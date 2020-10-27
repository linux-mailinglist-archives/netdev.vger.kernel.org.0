Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B997629BBD3
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 17:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1809650AbgJ0Q2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 12:28:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49678 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1809657AbgJ0Q1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 12:27:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603816040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bwTmwSFw/9HYws/MwgFi/u7T+cq4aSThDW49ZrCo2Mg=;
        b=JjfyMlydIY4gAxHYXFsYleoruxH6e7TWUGoJTzL7IHyfpsdk/ZkzNS76PqBhWbseN93YOR
        vPEIl8PZkPdKPr64Io67rnzDs+uh05E969kyeOMYPsg+rYVA79ULGzUUx3zmUTz2M07PVs
        VidULJSqZx6rzkykssW6vG0Yqm7B8sA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-IwpBzh88PpC3WP2keEaQ4w-1; Tue, 27 Oct 2020 12:27:16 -0400
X-MC-Unique: IwpBzh88PpC3WP2keEaQ4w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4954361277;
        Tue, 27 Oct 2020 16:27:14 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AE85E5D9E8;
        Tue, 27 Oct 2020 16:27:11 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 93AB130736C93;
        Tue, 27 Oct 2020 17:27:10 +0100 (CET)
Subject: [PATCH bpf-next V4 5/5] bpf: make it possible to identify BPF
 redirected SKBs
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com
Date:   Tue, 27 Oct 2020 17:27:10 +0100
Message-ID: <160381603052.1435097.17996668799662432883.stgit@firesoul>
In-Reply-To: <160381592923.1435097.2008820753108719855.stgit@firesoul>
References: <160381592923.1435097.2008820753108719855.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change makes it possible to identify SKBs that have been redirected
by TC-BPF (cls_act). This is needed for a number of cases.

(1) For collaborating with driver ifb net_devices.
(2) For avoiding starting generic-XDP prog on TC ingress redirect.

It is most important to fix XDP case(2), because this can break userspace
when a driver gets support for native-XDP. Imagine userspace loads XDP
prog on eth0, which fallback to generic-XDP, and it process TC-redirected
packets. When kernel is updated with native-XDP support for eth0, then the
program no-longer see the TC-redirected packets. Therefore it is important
to keep the order intact; that XDP runs before TC-BPF.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/dev.c    |    2 ++
 net/sched/Kconfig |    1 +
 2 files changed, 3 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 445ccf92c149..930c165a607e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3870,6 +3870,7 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 		return NULL;
 	case TC_ACT_REDIRECT:
 		/* No need to push/pop skb's mac_header here on egress! */
+		skb_set_redirected(skb, false);
 		skb_do_redirect(skb);
 		*ret = NET_XMIT_SUCCESS;
 		return NULL;
@@ -4959,6 +4960,7 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 		 * redirecting to another netdev
 		 */
 		__skb_push(skb, skb->mac_len);
+		skb_set_redirected(skb, true);
 		if (skb_do_redirect(skb) == -EAGAIN) {
 			__skb_pull(skb, skb->mac_len);
 			*another = true;
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index a3b37d88800e..a1bbaa8fd054 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -384,6 +384,7 @@ config NET_SCH_INGRESS
 	depends on NET_CLS_ACT
 	select NET_INGRESS
 	select NET_EGRESS
+	select NET_REDIRECT
 	help
 	  Say Y here if you want to use classifiers for incoming and/or outgoing
 	  packets. This qdisc doesn't do anything else besides running classifiers,


