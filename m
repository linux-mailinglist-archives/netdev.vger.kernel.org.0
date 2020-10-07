Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECAC2863AD
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 18:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgJGQXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 12:23:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49448 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728015AbgJGQXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 12:23:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602087785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dFPCNmJV7BWn4h0wNGFY7upekYwi7D/UkVwSZQX+Iw4=;
        b=a5XNN3nph/PkA+43gk08EcWJUZRV29oBgOA3HzKQ5tLV0fU603CdHhTi7C3U801ppFhOhN
        5lW1glrJw95G4B+omSkTODX/fsuTtsT4W9z8aTZx95yAb8LeUI+Is3Czk64TjNhqRqD4AM
        t5ddCHmPIlEaRnTk63lO2NpDYwNr1V8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-nAP6kKJRPG2DDFEanhOstQ-1; Wed, 07 Oct 2020 12:23:01 -0400
X-MC-Unique: nAP6kKJRPG2DDFEanhOstQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7A358070E2;
        Wed,  7 Oct 2020 16:22:59 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF1A36EF43;
        Wed,  7 Oct 2020 16:22:56 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id A8AC430736C8B;
        Wed,  7 Oct 2020 18:22:55 +0200 (CEST)
Subject: [PATCH bpf-next V2 4/6] bpf: make it possible to identify BPF
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
Date:   Wed, 07 Oct 2020 18:22:55 +0200
Message-ID: <160208777560.798237.12584544697367464358.stgit@firesoul>
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

This change makes it possible to identify SKBs that have been redirected
by TC-BPF (cls_act). This is needed for a number of cases.

(1) For collaborating with driver ifb net_devices.
(2) For avoiding starting generic-XDP prog on TC ingress redirect.
(3) Next MTU check patches need ability to identify redirected SKBs.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/dev.c    |    2 ++
 net/sched/Kconfig |    1 +
 2 files changed, 3 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 9d55bf5d1a65..b433098896b2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3885,6 +3885,7 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 		return NULL;
 	case TC_ACT_REDIRECT:
 		/* No need to push/pop skb's mac_header here on egress! */
+		skb_set_redirected(skb, false);
 		skb_do_redirect(skb);
 		*ret = NET_XMIT_SUCCESS;
 		return NULL;
@@ -4974,6 +4975,7 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 		 * redirecting to another netdev
 		 */
 		__skb_push(skb, skb->mac_len);
+		skb_set_redirected(skb, true);
 		skb_do_redirect(skb);
 		return NULL;
 	case TC_ACT_CONSUMED:
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


