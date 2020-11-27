Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2AB02C6B4F
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 19:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732507AbgK0SHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 13:07:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46219 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731555AbgK0SHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 13:07:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606500418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+KjiaZnt5TvPhVwqun5U0/5VXraitAEOcDnJu1jwtF8=;
        b=PJ4Xub0Ou74y7fO/+K+vpqfTgygE+eqvcb+uwhTtCdjK80xCuxHJmrPMI6Rv7pziBnhAwG
        RQhVDwNHFVvs1Gz+8/hKHR+6fHFtBxMpKvixI+oXnyJ39VC98DxHlSn+4ASjVPGQI+evjS
        hNsVFcnGwLTAglgWyarDcUkYazGqIRU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-yv7znlGCP4CPFKnIBG03dA-1; Fri, 27 Nov 2020 13:06:54 -0500
X-MC-Unique: yv7znlGCP4CPFKnIBG03dA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4FD72100C604;
        Fri, 27 Nov 2020 18:06:52 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0CCAB1001281;
        Fri, 27 Nov 2020 18:06:49 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 116C932138453;
        Fri, 27 Nov 2020 19:06:48 +0100 (CET)
Subject: [PATCH bpf-next V8 6/8] bpf: make it possible to identify BPF
 redirected SKBs
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
Date:   Fri, 27 Nov 2020 19:06:48 +0100
Message-ID: <160650040800.2890576.9811290366501747109.stgit@firesoul>
In-Reply-To: <160650034591.2890576.1092952641487480652.stgit@firesoul>
References: <160650034591.2890576.1092952641487480652.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
index 6ceb6412ee97..26b40f8005ae 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3872,6 +3872,7 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 		return NULL;
 	case TC_ACT_REDIRECT:
 		/* No need to push/pop skb's mac_header here on egress! */
+		skb_set_redirected(skb, false);
 		skb_do_redirect(skb);
 		*ret = NET_XMIT_SUCCESS;
 		return NULL;
@@ -4963,6 +4964,7 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
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


