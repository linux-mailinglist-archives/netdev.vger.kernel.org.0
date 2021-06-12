Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF07B3A4F56
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 16:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbhFLOlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 10:41:20 -0400
Received: from mail-io1-f42.google.com ([209.85.166.42]:41671 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbhFLOlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 10:41:02 -0400
Received: by mail-io1-f42.google.com with SMTP id p66so32861446iod.8
        for <netdev@vger.kernel.org>; Sat, 12 Jun 2021 07:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LC9SvpQ/Uxhg0GO1cMqQXuwzbE3v2RjkJ7G/fhbU/Z8=;
        b=HRrIfU2NNwbt/T1Aemqlv+f2Xej+RwSv/MeoPgIqoPaMIOBE6iL1XEcTKsDfMgWeVu
         5h2/usTr/2oL62fd6HaJuz/YeVB5PyQCW1CKGl4fkp6ODbjURk3nJam6Xf6FElB1LBr5
         Ce3sSaKo6mzxz/deimuGU/UzsCcARcEz/RLCSb6m2n8pT/d1fbVDjD2eXEIJ8wtO8FGA
         UxLi9yKXxgUheSvoba3EZ5DZXgiYfK7hvGT0gJp4lBx9CG3umMi2/sRfNqrKBljM/hpr
         lfa9ljIggY8SzHCCGt4LuP0M0NzpvWlywmVHZg38qmTqawy+1NXscfkp7C+LkKh4HOo7
         kDuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LC9SvpQ/Uxhg0GO1cMqQXuwzbE3v2RjkJ7G/fhbU/Z8=;
        b=LlOEuyhEcwhYpgS8M8MYiw1+LeLkIwImDgOe4duPmWEBBRyg3ZSLmiRoSEZblbd2Md
         12/5pXFDgdsE27UUNI39P1qMJwIAmUYnlU+KmYTMHNGHhk8V1L4mIWxyxsh41H8CyPiP
         g+/PXx5QQBzXZovHSyFTXABfvLZR+u8rYDi4rcEv8TfnvI2rNCNURfuHahLthm2IEH8O
         RwiDChw7NbMekO83YIqJnCgMCdO8WTqSftvZ9/LO6gebXFJV3g0gXy0XVXC37oVldaxT
         DFOdY2pPr00/ZctGOq8DdG3az9gqvmnFH4x6B/iE2DnlWVuUiMBtlDjl7jLT9HGh/Vw2
         W7Cg==
X-Gm-Message-State: AOAM532+Hd+8IGPXhLECrQFF7MMjH2T024JCk4QmVeqI016aPXFMWuGr
        1WCOsoQugtJCLsOnc30tBKXRlA==
X-Google-Smtp-Source: ABdhPJzw9KYRciou0IdBEOqS/8G1/fotTFk7/EiGDzNUuYyZWTbSdIF5Y4Ttix5h3abVDCFn9RDe1Q==
X-Received: by 2002:a5d:9916:: with SMTP id x22mr7217178iol.160.1623508666642;
        Sat, 12 Jun 2021 07:37:46 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id k4sm5126559ior.55.2021.06.12.07.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Jun 2021 07:37:46 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 8/8] net: qualcomm: rmnet: IPv6 payload length is simple
Date:   Sat, 12 Jun 2021 09:37:36 -0500
Message-Id: <20210612143736.3498712-9-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210612143736.3498712-1-elder@linaro.org>
References: <20210612143736.3498712-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't support any extension headers for IPv6 packets.  Extension
headers therefore contribute 0 bytes to the payload length.  As a
result we can just use the IPv6 payload length as the length used to
compute the pseudo header checksum for both UDP and TCP messages.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index ed4737d0043d6..a6ce22f60a00c 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -114,7 +114,6 @@ rmnet_map_ipv6_dl_csum_trailer(struct sk_buff *skb,
 	__sum16 *csum_field, pseudo_csum;
 	__sum16 ip6_payload_csum;
 	__be16 ip_header_csum;
-	u32 length;
 
 	/* Checksum offload is only supported for UDP and TCP protocols;
 	 * the packet cannot include any IPv6 extension headers
@@ -134,11 +133,9 @@ rmnet_map_ipv6_dl_csum_trailer(struct sk_buff *skb,
 	ip_header_csum = (__force __be16)ip_fast_csum(ip6h, sizeof(*ip6h) / 4);
 	ip6_payload_csum = csum16_sub(csum_trailer->csum_value, ip_header_csum);
 
-	length = (ip6h->nexthdr == IPPROTO_UDP) ?
-		 ntohs(((struct udphdr *)txporthdr)->len) :
-		 ntohs(ip6h->payload_len);
 	pseudo_csum = csum_ipv6_magic(&ip6h->saddr, &ip6h->daddr,
-				      length, ip6h->nexthdr, 0);
+				      ntohs(ip6h->payload_len),
+				      ip6h->nexthdr, 0);
 
 	/* It's sufficient to compare the IP payload checksum with the
 	 * negated pseudo checksum to determine whether the packet
-- 
2.27.0

