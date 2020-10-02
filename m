Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB72281C57
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 21:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725793AbgJBTxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 15:53:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29767 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725283AbgJBTxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 15:53:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601668394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=3K0Pxu+gC6syY9syny9BArfDKK8IA+0REr3HjAGSJuA=;
        b=Oq8ICsWcerI75eV64EB8fDxTzIg/sdyfKmDOVcbruPJPHgDB04y30yEJ84bktozxPsYvMl
        G1KTXkKJSa1z4RK2RPwA+MIwEyku4tpnYx0NkdPuqJ98cRaAibi8AIYX6EhMgZ/ncfGElS
        Ctwvzw9DHAhGgm5wCDLPofGqKtWAcMs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-0KknLvu1MFe6HjzobF88zg-1; Fri, 02 Oct 2020 15:53:12 -0400
X-MC-Unique: 0KknLvu1MFe6HjzobF88zg-1
Received: by mail-wm1-f70.google.com with SMTP id b20so910473wmj.1
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 12:53:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=3K0Pxu+gC6syY9syny9BArfDKK8IA+0REr3HjAGSJuA=;
        b=pE8rCHoniDOuFOdeDQf9CRX1/KAtdHS9EAbAQR6GtH2pz8hMTR6mmgW9rYeKHaVLqD
         mNiEHyn+y6BcH5fA/UCZAcq/7wDv6BGkwqMm902dAlX6L39wK43xQWANHOS0Mr9d/Afu
         pUb3SjTElli2Q2qc2k6h+ZgX9WWkvMB+k58MJZrFnmUsMZu+twESdhFeQq9qudt+H3yM
         XB4k2dj7trdt4y1UHl6PCABrxgQGPudE21r2YtgNvl7ucS0fXsogYP8kOXySgfVbk63W
         c2zeDsGzn4Ns2HwQdutkMkR2BKPkWCEAHeA6+Zmtjx6lHOaoNjnDGEa3kCrr1X2fpHyU
         d0yw==
X-Gm-Message-State: AOAM531bt4FebyO1hj+OCULwQllruPCIHQxCPAPKdqVmjYvLj67vluHE
        vMU0EyPWNCiiSmSsOacfoAsJDdZmJ5CelcGETB19I/yllwIUz1KO9mTc2S22TFd0UEgigIV+08p
        Yttz3sedaHVYhuTTr
X-Received: by 2002:a05:600c:20c:: with SMTP id 12mr4687312wmi.40.1601668391302;
        Fri, 02 Oct 2020 12:53:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyU7xq/zIJOBm5rQfh4PzTyUVQTnUO/LhIQ5x/O7xVdLxit6qX51ayaTDuDje3fg5ZvZSrjPQ==
X-Received: by 2002:a05:600c:20c:: with SMTP id 12mr4687299wmi.40.1601668391090;
        Fri, 02 Oct 2020 12:53:11 -0700 (PDT)
Received: from pc-2.home (2a01cb058d4f8400c9f0d639f7c74c26.ipv6.abo.wanadoo.fr. [2a01:cb05:8d4f:8400:c9f0:d639:f7c7:4c26])
        by smtp.gmail.com with ESMTPSA id z67sm2907107wme.41.2020.10.02.12.53.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 12:53:10 -0700 (PDT)
Date:   Fri, 2 Oct 2020 21:53:08 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Martin Varghese <martin.varghese@nokia.com>,
        Davide Caratti <dcaratti@redhat.com>
Subject: [PATCH net] net/core: check length before updating Ethertype in
 skb_mpls_{push,pop}
Message-ID: <71ec98d51cc4aab7615061336fb1498ad16cda30.1601667845.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Openvswitch allows to drop a packet's Ethernet header, therefore
skb_mpls_push() and skb_mpls_pop() might be called with ethernet=true
and mac_len=0. In that case the pointer passed to skb_mod_eth_type()
doesn't point to an Ethernet header and the new Ethertype is written at
unexpected locations.

Fix this by verifying that mac_len is big enough to contain an Ethernet
header.

Fixes: fa4e0f8855fc ("net/sched: fix corrupted L2 header with MPLS 'push' and 'pop' actions")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
Notes:
  - Found by code inspection.
  - Using commit fa4e0f8855fc for the Fixes tag because mac_len is
    needed for the test. The problem probably exists since openvswitch
    can pop the Ethernet header though.

 net/core/skbuff.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 6faf73d6a0f7..2b48cb0cc684 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5622,7 +5622,7 @@ int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto,
 	lse->label_stack_entry = mpls_lse;
 	skb_postpush_rcsum(skb, lse, MPLS_HLEN);
 
-	if (ethernet)
+	if (ethernet && mac_len >= ETH_HLEN)
 		skb_mod_eth_type(skb, eth_hdr(skb), mpls_proto);
 	skb->protocol = mpls_proto;
 
@@ -5662,7 +5662,7 @@ int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len,
 	skb_reset_mac_header(skb);
 	skb_set_network_header(skb, mac_len);
 
-	if (ethernet) {
+	if (ethernet && mac_len >= ETH_HLEN) {
 		struct ethhdr *hdr;
 
 		/* use mpls_hdr() to get ethertype to account for VLANs. */
-- 
2.21.3

