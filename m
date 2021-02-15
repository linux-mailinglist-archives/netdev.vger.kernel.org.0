Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150F631BA6F
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 14:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbhBONfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 08:35:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbhBONcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 08:32:50 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C098C061574
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 05:32:10 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id y18so7953420edw.13
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 05:32:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1hx3xk4VFTALiO508KUbgQL+iRxF7aIDgEoNLRB8PVY=;
        b=OMzmqAXfhWvsKMAeqZZN6bH/LwihH8yfcMUfysc6VVGj/bk8hywzIx2XlUR8u5HIam
         6ixhvSYmHwNAUIriUR4VxPSeRyw7h2bWY9fBhIfTlPVv+CNDS9v9R60lEo+1iFu+7yjA
         e8Wj0zUEjr76Xm0OXwDGocz1XagSqXLMZIJgo7YmazGcd3w1MHFahRKbPkhQD5vaM7qE
         P7imjGT6xUg4DpMgZY08t7A49inf02yAAb3vpTYI6zSfcBxwHs4WKpylZ5vNoOJ+Mfy0
         oJ9pZhUSS2ZXneqFQaQzM2PQo+++IkBXknN5ru4fNDDMOijoCLCZqJgofiz1m5zdZbph
         O0fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1hx3xk4VFTALiO508KUbgQL+iRxF7aIDgEoNLRB8PVY=;
        b=plnN+9m/RVRScntdxPVQpn3cNBJV+59zit7oPezfFPX90DFB1+hJyyg9hVhosyiUW3
         lk9pRIK9YLespp0D2N2zzLr3YLjlRo6yMeoFqRJDiDfOz4V3qWXugx3gyG0P8WKOBkfp
         enPokaWhRGsqMFVeThsdw2b4hI5Fmp7hDOIumuOExfXBFdMFRWKPwQbHprC+qQKEJ2B5
         tZ32mHe53QEjbnDmpeYkx5SP16ao50qBRPN75Q0S7p3OUI38U3RJRm/G8Z0VJRlaV1Hx
         CFZxWEXzzMXpdnoNURgvy6GB0SksZ9FZq9SX2R/t99rZ7MxskFk6WyGexFWre1nbHNoG
         JtSA==
X-Gm-Message-State: AOAM5315id2MA2yFtpDCNcNsxRKhP0UGILpz9NJzIOWnH5hwYuF+QsWg
        6VqSfYIoWNTNKyKw6Lj63KM=
X-Google-Smtp-Source: ABdhPJxPZHMwMCzIygOcju8I2f35xdPPiqEqfygALwABNwRbamU8dEmY4z9DHWsx2LQf+SkkPk1CQA==
X-Received: by 2002:a05:6402:34c3:: with SMTP id w3mr15952274edc.3.1613395928946;
        Mon, 15 Feb 2021 05:32:08 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id q1sm7764484ejt.65.2021.02.15.05.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 05:32:08 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        UNGLinuxDriver@microchip.com,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH net-next] net: mscc: ocelot: avoid type promotion when calling ocelot_ifh_set_dest
Date:   Mon, 15 Feb 2021 15:31:43 +0200
Message-Id: <20210215133143.2425016-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Smatch is confused by the fact that a 32-bit BIT(port) macro is passed
as argument to the ocelot_ifh_set_dest function and warns:

ocelot_xmit() warn: should '(((1))) << (dp->index)' be a 64 bit type?
seville_xmit() warn: should '(((1))) << (dp->index)' be a 64 bit type?

The destination port mask is copied into a 12-bit field of the packet,
starting at bit offset 67 and ending at 56.

So this DSA tagging protocol supports at most 12 bits, which is clearly
less than 32. Attempting to send to a port number > 12 will cause the
packing() call to truncate way before there will be 32-bit truncation
due to type promotion of the BIT(port) argument towards u64.

Therefore, smatch's fears that BIT(port) will do the wrong thing and
cause unexpected truncation for "port" values >= 32 are unfounded.
Nonetheless, let's silence the warning by explicitly passing an u64
value to ocelot_ifh_set_dest, such that the compiler does not need to do
a questionable type promotion.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 2 +-
 net/dsa/tag_ocelot.c               | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 8d97c731e953..5d13087c85d6 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -803,7 +803,7 @@ void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 			 QS_INJ_CTRL_SOF, QS_INJ_CTRL, grp);
 
 	ocelot_ifh_set_bypass(ifh, 1);
-	ocelot_ifh_set_dest(ifh, BIT(port));
+	ocelot_ifh_set_dest(ifh, BIT_ULL(port));
 	ocelot_ifh_set_tag_type(ifh, IFH_TAG_TYPE_C);
 	ocelot_ifh_set_vid(ifh, skb_vlan_tag_get(skb));
 	ocelot_ifh_set_rew_op(ifh, rew_op);
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index a7dd61c8e005..f9df9cac81c5 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -56,7 +56,7 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 	void *injection;
 
 	ocelot_xmit_common(skb, netdev, cpu_to_be32(0x8880000a), &injection);
-	ocelot_ifh_set_dest(injection, BIT(dp->index));
+	ocelot_ifh_set_dest(injection, BIT_ULL(dp->index));
 
 	return skb;
 }
@@ -68,7 +68,7 @@ static struct sk_buff *seville_xmit(struct sk_buff *skb,
 	void *injection;
 
 	ocelot_xmit_common(skb, netdev, cpu_to_be32(0x88800005), &injection);
-	seville_ifh_set_dest(injection, BIT(dp->index));
+	seville_ifh_set_dest(injection, BIT_ULL(dp->index));
 
 	return skb;
 }
-- 
2.25.1

