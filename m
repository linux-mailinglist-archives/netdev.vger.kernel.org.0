Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E7D3E2DF4
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 17:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244849AbhHFPwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 11:52:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58520 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244834AbhHFPwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 11:52:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628265133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=VMLtWJU4f89hGGxYfujjU5RIJ1FjILqbg00bDIS72Dk=;
        b=gvi0U8C4l1TkrQ6c6Niq/OmazsH/vRQCLlIlLfwqkn4TcorGrbqgF9A7yo460ecRbeC+2U
        215SN8oMNBRj4Z/SOA6UGuXZ3DJp+6j4rzkta9ypBwR0RPb/n9yLGyaDLFP6IczZwltGBJ
        HQr/gBj4HEf7mpoTJ0G5/YpTy01Dgac=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-5Lpbhb6SP0mYjsheibatoA-1; Fri, 06 Aug 2021 11:52:10 -0400
X-MC-Unique: 5Lpbhb6SP0mYjsheibatoA-1
Received: by mail-wm1-f70.google.com with SMTP id f6-20020a05600c1546b029025af999e04dso2143205wmg.7
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 08:52:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=VMLtWJU4f89hGGxYfujjU5RIJ1FjILqbg00bDIS72Dk=;
        b=o+tlhAyIgxOwQdkXS0fZGt/Xs0jDh0UUfJ6a6fU9WxlfvWsCJI310kNqrW/XcscyWP
         UAD/bxHTJ3NP7D4HB8F+PV+iMdBoW/iG46pkY8bM9rsA4RwoyIalCmQj4duJTMoPigmm
         Ujv1gTAlJMlTcIxBinyUt0gqhHZ2GZPMRVxhBXd7UyVq8hDFsV7GiKuxIuDv143axZ/w
         8rm7snwQJqXDTV4hCa0S5kvoZHfJXz7skrOctUawLB8dkrPjlsL/XL1pN3VS18eOfYon
         M4UrpHU8p61GN2yC/bVRFcvSpS+C6SfCtO7B2tK1hiPb62T+RNgYUjQNknQyDjbMIFUM
         3FHA==
X-Gm-Message-State: AOAM530C9/ktJLgjbneFtT+WwGHHbvtU9tIdSvZVjFrVFV2KTWrYLWJK
        AxXs2eZlCncweQ3Eu3vwO5HkEcJaW8fJf9z3P2su3WzbvYQTxiMXXoWgByUHXNbo+b/I0Cjj7ew
        9rLLKPB0eJt1J4RVN
X-Received: by 2002:a1c:a187:: with SMTP id k129mr4026982wme.17.1628265129162;
        Fri, 06 Aug 2021 08:52:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWLvoD9SjHDjOUyi6ez5vMHanOKtosvbQL8/gtlBN/+wlUjGSYY1/molKN+cubibvhx1Co+A==
X-Received: by 2002:a1c:a187:: with SMTP id k129mr4026970wme.17.1628265129007;
        Fri, 06 Aug 2021 08:52:09 -0700 (PDT)
Received: from pc-32.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id t17sm9686329wru.94.2021.08.06.08.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 08:52:08 -0700 (PDT)
Date:   Fri, 6 Aug 2021 17:52:06 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Martin Varghese <martin.varghese@nokia.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net] bareudp: Fix invalid read beyond skb's linear data
Message-ID: <7741c46545c6ef02e70c80a9b32814b22d9616b3.1628264975.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Data beyond the UDP header might not be part of the skb's linear data.
Use skb_copy_bits() instead of direct access to skb->data+X, so that
we read the correct bytes even on a fragmented skb.

Fixes: 4b5f67232d95 ("net: Special handling for IP & MPLS.")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 drivers/net/bareudp.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index a7ee0af1af90..54e321a695ce 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -71,12 +71,18 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 		family = AF_INET6;
 
 	if (bareudp->ethertype == htons(ETH_P_IP)) {
-		struct iphdr *iphdr;
+		__u8 ipversion;
 
-		iphdr = (struct iphdr *)(skb->data + BAREUDP_BASE_HLEN);
-		if (iphdr->version == 4) {
-			proto = bareudp->ethertype;
-		} else if (bareudp->multi_proto_mode && (iphdr->version == 6)) {
+		if (skb_copy_bits(skb, BAREUDP_BASE_HLEN, &ipversion,
+				  sizeof(ipversion))) {
+			bareudp->dev->stats.rx_dropped++;
+			goto drop;
+		}
+		ipversion >>= 4;
+
+		if (ipversion == 4) {
+			proto = htons(ETH_P_IP);
+		} else if (ipversion == 6 && bareudp->multi_proto_mode) {
 			proto = htons(ETH_P_IPV6);
 		} else {
 			bareudp->dev->stats.rx_dropped++;
-- 
2.21.3

