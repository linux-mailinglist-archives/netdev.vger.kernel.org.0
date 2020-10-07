Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17702863AF
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 18:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbgJGQXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 12:23:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36804 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728015AbgJGQXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 12:23:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602087788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=slv34YzMOjRKcThCr0qZMAMqWuUetWu/HzyWsLS+KEs=;
        b=iYp5i7Jb1m7dccQKXUrZY7JXIDDZkWzxgOkezlKALz9FZVgK8OJqs5iN+MGD629QNYmMFL
        Moujvr02knmzkksaDaMCGov4D3Jr108IGeOcwjP/huUbVDC27qJJ5XYaoyvRAaOGoynhto
        68Y32VV1CZ+jnaWwgM9Y1FiArP2A7rU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-jAryO5TQN3Wpx_KOcJ9TNg-1; Wed, 07 Oct 2020 12:23:04 -0400
X-MC-Unique: jAryO5TQN3Wpx_KOcJ9TNg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 360B18070EE;
        Wed,  7 Oct 2020 16:23:02 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B74166EF45;
        Wed,  7 Oct 2020 16:23:01 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id BEBB330736C8B;
        Wed,  7 Oct 2020 18:23:00 +0200 (CEST)
Subject: [PATCH bpf-next V2 5/6] bpf: Add MTU check for TC-BPF packets after
 egress hook
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com
Date:   Wed, 07 Oct 2020 18:23:00 +0200
Message-ID: <160208778070.798237.16265441131909465819.stgit@firesoul>
In-Reply-To: <160208770557.798237.11181325462593441941.stgit@firesoul>
References: <160208770557.798237.11181325462593441941.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MTU should only apply to transmitted packets.

When TC-ingress redirect packet to egress on another netdev, then the
normal netstack MTU checks are skipped (and driver level will not catch
any MTU violation, checked ixgbe).

This patch choose not to add MTU check in the egress code path of
skb_do_redirect() prior to calling dev_queue_xmit(), because it is still
possible to run another BPF egress program that will shrink/consume
headers, which will make packet comply with netdev MTU. This use-case
might already be in production use (if ingress MTU is larger than egress).

Instead do the MTU check after sch_handle_egress() step, for the cases
that require this.

The cases need a bit explaining. Ingress to egress redirected packets
could be detected via skb->tc_at_ingress bit, but it is not reliable,
because sch_handle_egress() could steal the packet and redirect this
(again) to another egress netdev, which will then have the
skb->tc_at_ingress cleared. There is also the case of TC-egress prog
increase packet size and then redirect it egress. Thus, it is more
reliable to do the MTU check for any redirected packet (both ingress and
egress), which is available via skb_is_redirected() in earlier patch.
Also handle case where egress BPF-prog increased size.

One advantage of this approach is that it ingress-to-egress BPF-prog can
send information via packet data. With the MTU checks removed in the
helpers, and also not done in skb_do_redirect() call, this allows for an
ingress BPF-prog to communicate with an egress BPF-prog via packet data,
as long as egress BPF-prog remove this prior to transmitting packet.

Troubleshooting: MTU violations are recorded in TX dropped counter, and
kprobe on dev_queue_xmit() have retval -EMSGSIZE.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/dev.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index b433098896b2..19406013f93e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3870,6 +3870,7 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 	switch (tcf_classify(skb, miniq->filter_list, &cl_res, false)) {
 	case TC_ACT_OK:
 	case TC_ACT_RECLASSIFY:
+		*ret = NET_XMIT_SUCCESS;
 		skb->tc_index = TC_H_MIN(cl_res.classid);
 		break;
 	case TC_ACT_SHOT:
@@ -4064,9 +4065,12 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 {
 	struct net_device *dev = skb->dev;
 	struct netdev_queue *txq;
+#ifdef CONFIG_NET_CLS_ACT
+	bool mtu_check = false;
+#endif
+	bool again = false;
 	struct Qdisc *q;
 	int rc = -ENOMEM;
-	bool again = false;
 
 	skb_reset_mac_header(skb);
 
@@ -4082,14 +4086,28 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 
 	qdisc_pkt_len_init(skb);
 #ifdef CONFIG_NET_CLS_ACT
+	mtu_check = skb_is_redirected(skb);
 	skb->tc_at_ingress = 0;
 # ifdef CONFIG_NET_EGRESS
 	if (static_branch_unlikely(&egress_needed_key)) {
+		unsigned int len_orig = skb->len;
+
 		skb = sch_handle_egress(skb, &rc, dev);
 		if (!skb)
 			goto out;
+		/* BPF-prog ran and could have changed packet size beyond MTU */
+		if (rc == NET_XMIT_SUCCESS && skb->len > len_orig)
+			mtu_check = true;
 	}
 # endif
+	/* MTU-check only happens on "last" net_device in a redirect sequence
+	 * (e.g. above sch_handle_egress can steal SKB and skb_do_redirect it
+	 * either ingress or egress to another device).
+	 */
+	if (mtu_check && !is_skb_forwardable(dev, skb)) {
+		rc = -EMSGSIZE;
+		goto drop;
+	}
 #endif
 	/* If device/qdisc don't need skb->dst, release it right now while
 	 * its hot in this cpu cache.
@@ -4157,7 +4175,9 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 
 	rc = -ENETDOWN;
 	rcu_read_unlock_bh();
-
+#ifdef CONFIG_NET_CLS_ACT
+drop:
+#endif
 	atomic_long_inc(&dev->tx_dropped);
 	kfree_skb_list(skb);
 	return rc;


