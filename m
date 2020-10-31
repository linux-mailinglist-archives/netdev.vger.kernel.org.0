Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040292A11DA
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 01:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725857AbgJaAHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 20:07:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49853 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725536AbgJaAHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 20:07:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604102851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=LNDl/57jBQQD6MdYyzssY8Zz71TuydVtJhQDSAMU6ZU=;
        b=C6i2O5R19NGLvtdqgPvNhFiLNW38S5R8qKmeE8Qyuro8IBhI1wk7NOTeV73TLAmKelO67f
        oDJZ7CLKY6Q8k07W96OamS2cI/lVVDek03Dm1Cm4BqvpmYVhuxUJggkuh1FHcbsJlybswH
        evVkt9KO/+7+BqCkqi2gdpH4PnOEjPA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-ZE1QBeVsOsO_7DGNaYsviw-1; Fri, 30 Oct 2020 20:07:30 -0400
X-MC-Unique: ZE1QBeVsOsO_7DGNaYsviw-1
Received: by mail-wr1-f70.google.com with SMTP id t14so3374544wrs.2
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 17:07:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=LNDl/57jBQQD6MdYyzssY8Zz71TuydVtJhQDSAMU6ZU=;
        b=JlfAQAfmpHZVAv+U052/dIjhHyoT9+B5PiRvyak6apeQFP9JlRsaCx5li/YLWQvBNd
         krz7o77J3XZ3/DoFTHImdJm+9YAsz4aXAbscaDLEijk/9QOvoxhhDsCnDMXhlpP433Qz
         IEzqQ9Be4YP7pg3wQaLqb+TqySBRE2/ozoVMGhJFFcpMSSyv4+5utBfZooBqlCxRcA0U
         oEj4Vh7B+HTITFt7F+w15yAftgEtvNb8kRNYZb4GfzAIRrqgVKnIlyBNsehQSJDUYOdV
         5paTt4nHrg2rDrQT7z/LVO6S7EvjxKnDN3Cogm/jzE2D2HsaGs3lVH2GROhgwMJHjzF6
         RWwA==
X-Gm-Message-State: AOAM531K1g60uVcS1t0SevFykpxr1sboIFSsQiFGNDqyxF62RBLl270r
        2L8nXbe2tU3tBtJFUA+ZzYpt37L1wjAXSqu3bVnhNjjprheEawm0ECMNl/f7OL0qiWwFHBx50ip
        UyaFpr1Wcm7ugTLBw
X-Received: by 2002:adf:f381:: with SMTP id m1mr6827156wro.347.1604102848752;
        Fri, 30 Oct 2020 17:07:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyGNh4p4CG3nigzcR04igxsAiJx6q6sNkTHLWtkg4NjYhfZpaviLLXA7SfhTg9QnYp8e534VQ==
X-Received: by 2002:adf:f381:: with SMTP id m1mr6827129wro.347.1604102848533;
        Fri, 30 Oct 2020 17:07:28 -0700 (PDT)
Received: from pc-2.home (2a01cb058d4f8400c9f0d639f7c74c26.ipv6.abo.wanadoo.fr. [2a01:cb05:8d4f:8400:c9f0:d639:f7c7:4c26])
        by smtp.gmail.com with ESMTPSA id y2sm12381770wrh.0.2020.10.30.17.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 17:07:27 -0700 (PDT)
Date:   Sat, 31 Oct 2020 01:07:25 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Martin Varghese <martin.varghese@nokia.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        David Ahern <dsa@cumulusnetworks.com>
Subject: [PATCH net-next] mpls: drop skb's dst in mpls_forward()
Message-ID: <f8c2784c13faa54469a2aac339470b1049ca6b63.1604102750.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 394de110a733 ("net: Added pointer check for
dst->ops->neigh_lookup in dst_neigh_lookup_skb") added a test in
dst_neigh_lookup_skb() to avoid a NULL pointer dereference. The root
cause was the MPLS forwarding code, which doesn't call skb_dst_drop()
on incoming packets. That is, if the packet is received from a
collect_md device, it has a metadata_dst attached to it that doesn't
implement any dst_ops function.

To align the MPLS behaviour with IPv4 and IPv6, let's drop the dst in
mpls_forward(). This way, dst_neigh_lookup_skb() doesn't need to test
->neigh_lookup any more. Let's keep a WARN condition though, to
document the precondition and to ease detection of such problems in the
future.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 include/net/dst.h  | 12 +++++-------
 net/mpls/af_mpls.c |  2 ++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index 8ea8812b0b41..10f0a8399867 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -400,14 +400,12 @@ static inline struct neighbour *dst_neigh_lookup(const struct dst_entry *dst, co
 static inline struct neighbour *dst_neigh_lookup_skb(const struct dst_entry *dst,
 						     struct sk_buff *skb)
 {
-	struct neighbour *n = NULL;
+	struct neighbour *n;
 
-	/* The packets from tunnel devices (eg bareudp) may have only
-	 * metadata in the dst pointer of skb. Hence a pointer check of
-	 * neigh_lookup is needed.
-	 */
-	if (dst->ops->neigh_lookup)
-		n = dst->ops->neigh_lookup(dst, skb, NULL);
+	if (WARN_ON_ONCE(!dst->ops->neigh_lookup))
+		return NULL;
+
+	n = dst->ops->neigh_lookup(dst, skb, NULL);
 
 	return IS_ERR(n) ? NULL : n;
 }
diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index f2868a8a50c3..47bab701555f 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -377,6 +377,8 @@ static int mpls_forward(struct sk_buff *skb, struct net_device *dev,
 	if (!pskb_may_pull(skb, sizeof(*hdr)))
 		goto err;
 
+	skb_dst_drop(skb);
+
 	/* Read and decode the label */
 	hdr = mpls_hdr(skb);
 	dec = mpls_entry_decode(hdr);
-- 
2.21.3

