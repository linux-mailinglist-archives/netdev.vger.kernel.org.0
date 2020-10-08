Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EABE62875BA
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 16:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730518AbgJHOJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 10:09:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41028 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730494AbgJHOJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 10:09:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602166170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c8MAr+gO5Pb8hieZ2zNwB6Q2C986gSFsUXCfz+LTfMo=;
        b=H4v6jdFrSVvRo7WkifRk32lIk+Hj1QlFznhU91RV+2VgYwN7mRqAxq641D9k+WhWy7QPlh
        PqTpcMikUwPfryNhIRIb+Gr97iipfAdsOVlfwLM5/uusrfaxIeJDHpXL+Q5CUVlKJHB+w1
        YnOuC17q+3Ua/hv/BKBcbsP9wKt79Cg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-2wUimDCZPtmFkDnHPv9tEQ-1; Thu, 08 Oct 2020 10:09:28 -0400
X-MC-Unique: 2wUimDCZPtmFkDnHPv9tEQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6A8080401A;
        Thu,  8 Oct 2020 14:09:26 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D81465D9E8;
        Thu,  8 Oct 2020 14:09:23 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id CE60230736C8B;
        Thu,  8 Oct 2020 16:09:22 +0200 (CEST)
Subject: [PATCH bpf-next V3 5/6] bpf: drop MTU check when doing TC-BPF
 redirect to ingress
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com
Date:   Thu, 08 Oct 2020 16:09:22 +0200
Message-ID: <160216616276.882446.17894852306425732310.stgit@firesoul>
In-Reply-To: <160216609656.882446.16642490462568561112.stgit@firesoul>
References: <160216609656.882446.16642490462568561112.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The use-case for dropping the MTU check when TC-BPF does redirect to
ingress, is described by Eyal Birger in email[0]. The summary is the
ability to increase packet size (e.g. with IPv6 headers for NAT64) and
ingress redirect packet and let normal netstack fragment packet as needed.

[0] https://lore.kernel.org/netdev/CAHsH6Gug-hsLGHQ6N0wtixdOa85LDZ3HNRHVd0opR=19Qo4W4Q@mail.gmail.com/

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/linux/netdevice.h |    5 +++--
 net/core/dev.c            |    2 +-
 net/core/filter.c         |   12 ++++++++++--
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 28cfa53daf72..58fb7b4869ba 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3866,10 +3866,11 @@ bool is_skb_forwardable(const struct net_device *dev,
 			const struct sk_buff *skb);
 
 static __always_inline int ____dev_forward_skb(struct net_device *dev,
-					       struct sk_buff *skb)
+					       struct sk_buff *skb,
+					       const bool mtu_check)
 {
 	if (skb_orphan_frags(skb, GFP_ATOMIC) ||
-	    unlikely(!is_skb_forwardable(dev, skb))) {
+	    (mtu_check && unlikely(!is_skb_forwardable(dev, skb)))) {
 		atomic_long_inc(&dev->rx_dropped);
 		kfree_skb(skb);
 		return NET_RX_DROP;
diff --git a/net/core/dev.c b/net/core/dev.c
index b433098896b2..96b455f15872 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2209,7 +2209,7 @@ EXPORT_SYMBOL_GPL(is_skb_forwardable);
 
 int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb)
 {
-	int ret = ____dev_forward_skb(dev, skb);
+	int ret = ____dev_forward_skb(dev, skb, true);
 
 	if (likely(!ret)) {
 		skb->protocol = eth_type_trans(skb, dev);
diff --git a/net/core/filter.c b/net/core/filter.c
index 5986156e700e..a8e24092e4f5 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2083,13 +2083,21 @@ static const struct bpf_func_proto bpf_csum_level_proto = {
 
 static inline int __bpf_rx_skb(struct net_device *dev, struct sk_buff *skb)
 {
-	return dev_forward_skb(dev, skb);
+	int ret = ____dev_forward_skb(dev, skb, false);
+
+	if (likely(!ret)) {
+		skb->protocol = eth_type_trans(skb, dev);
+		skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
+		ret = netif_rx(skb);
+	}
+
+	return ret;
 }
 
 static inline int __bpf_rx_skb_no_mac(struct net_device *dev,
 				      struct sk_buff *skb)
 {
-	int ret = ____dev_forward_skb(dev, skb);
+	int ret = ____dev_forward_skb(dev, skb, false);
 
 	if (likely(!ret)) {
 		skb->dev = dev;


