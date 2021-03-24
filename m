Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D850347CED
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 16:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236800AbhCXPpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 11:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236704AbhCXPpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 11:45:09 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD30EC0613DE
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 08:45:08 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id z1so28220959edb.8
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 08:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gUNHHN+a05PbMPS4FsZBMqlmcyf5xosnMltACvnqWr4=;
        b=CsnVviYdfYDdMW0izohFXEuTUdA2Gvq9qBO9bA23r+0JOx9sughwpzav6fnvZw78u0
         AILGXuGI275eA7QeZ0Mb0Yb1PZqvZz/PrZkYX15VM4IKHRPMp8T/HeZ8LKlodVpvyYJK
         8wuONzj/mqndZlzydBCtUavxIa7Gr+GSpdbRQM1iMyxeIennsuqOqB/tNK1q1gwdK98c
         GDFeB5+NgQ92cwjfqYKaQJ0hyieFnvhUfqRZiWMMWVOE7kJ/OIG0DfDISzSkrE1aaDAP
         gYs1cTijZgpxJ1/F2pdDJuxVe1bqAckkJLsSvdGJKsPoJHW88QLK3TKW6howV4GKuG0f
         hEcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gUNHHN+a05PbMPS4FsZBMqlmcyf5xosnMltACvnqWr4=;
        b=lolZImtQdqyUOGXyU87ApnV1AqIpOE16BiTkEzYeM7eupalV+lVEUNg29sU+Jj1x8j
         FsF8MrMIhYaUuQ8RgBvZcuV2Kw08YS8IXMwJxJheQTHF5D/MdnLBYUkGzL5l4wBsJlFz
         ueS4Q+BuedwYUV9OFGQdHlxMrYOxIU2Ji6R0TRqTqgg//eHNLDAGS87tvdr4ak6LAJDw
         +uHmDnuC9SLxdyMrywqkHTT0zM5vfrcPJUdXmC3mJBscajtj18mKYMoJn5UXtnIM9Ey/
         BugNf9JwuqRf/0vepW6PHIi82oNW5Ft0406NRFdI94B2hq5FI1lxgVJ3AyW8+1uDpUhs
         EeoQ==
X-Gm-Message-State: AOAM530fxeusEGsf+VWYf7QANtiKH4q+AQ/TZ+X1mPu/EJC9b+ghKbNC
        ev2L6GQhkwYLhTwe/ntQ7ow=
X-Google-Smtp-Source: ABdhPJy0SpVYwbrNepffdOAJ4iJ+2FQJalqPSYS4uTVpWSzhrwfp5V9i6Of3KzSmR80isMRNrNM7Zg==
X-Received: by 2002:a05:6402:2552:: with SMTP id l18mr4020811edb.71.1616600706699;
        Wed, 24 Mar 2021 08:45:06 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id w24sm1317542edt.44.2021.03.24.08.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 08:45:06 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 2/2] net: enetc: don't depend on system endianness in enetc_set_mac_ht_flt
Date:   Wed, 24 Mar 2021 17:44:55 +0200
Message-Id: <20210324154455.1899941-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210324154455.1899941-1-olteanv@gmail.com>
References: <20210324154455.1899941-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When enetc runs out of exact match entries for unicast address
filtering, it switches to an approach based on hash tables, where
multiple MAC addresses might end up in the same bucket.

However, the enetc_set_mac_ht_flt function currently depends on the
system endianness, because it interprets the 64-bit hash value as an
array of two u32 elements. Modify this to use lower_32_bits and
upper_32_bits.

Tested by forcing enetc to go into hash table mode by creating two
macvlan upper interfaces:

ip link add link eno0 address 00:01:02:03:00:00 eno0.0 type macvlan && ip link set eno0.0 up
ip link add link eno0 address 00:01:02:03:00:01 eno0.1 type macvlan && ip link set eno0.1 up

and verified that the same bit values are written to the registers
before and after:

enetc_sync_mac_filters: addr 00:00:80:00:40:10 exact match 0
enetc_sync_mac_filters: addr 00:00:00:00:80:00 exact match 0
enetc_set_mac_ht_flt: hash 0x80008000000000 UMHFR0 0x0 UMHFR1 0x800080

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 9c69ca516192..5e95afd61c87 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -129,16 +129,20 @@ static void enetc_clear_mac_ht_flt(struct enetc_si *si, int si_idx, int type)
 }
 
 static void enetc_set_mac_ht_flt(struct enetc_si *si, int si_idx, int type,
-				 u32 *hash)
+				 unsigned long hash)
 {
 	bool err = si->errata & ENETC_ERR_UCMCSWP;
 
 	if (type == UC) {
-		enetc_port_wr(&si->hw, ENETC_PSIUMHFR0(si_idx, err), *hash);
-		enetc_port_wr(&si->hw, ENETC_PSIUMHFR1(si_idx), *(hash + 1));
+		enetc_port_wr(&si->hw, ENETC_PSIUMHFR0(si_idx, err),
+			      lower_32_bits(hash));
+		enetc_port_wr(&si->hw, ENETC_PSIUMHFR1(si_idx),
+			      upper_32_bits(hash));
 	} else { /* MC */
-		enetc_port_wr(&si->hw, ENETC_PSIMMHFR0(si_idx, err), *hash);
-		enetc_port_wr(&si->hw, ENETC_PSIMMHFR1(si_idx), *(hash + 1));
+		enetc_port_wr(&si->hw, ENETC_PSIMMHFR0(si_idx, err),
+			      lower_32_bits(hash));
+		enetc_port_wr(&si->hw, ENETC_PSIMMHFR1(si_idx),
+			      upper_32_bits(hash));
 	}
 }
 
@@ -182,7 +186,7 @@ static void enetc_sync_mac_filters(struct enetc_pf *pf)
 		if (i == UC)
 			enetc_clear_mac_flt_entry(si, pos);
 
-		enetc_set_mac_ht_flt(si, 0, i, (u32 *)f->mac_hash_table);
+		enetc_set_mac_ht_flt(si, 0, i, *f->mac_hash_table);
 	}
 }
 
-- 
2.25.1

