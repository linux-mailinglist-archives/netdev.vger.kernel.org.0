Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B58560B3E5
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 19:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiJXRUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 13:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbiJXRUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 13:20:04 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C36760FE
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 08:54:52 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 0210121A5B;
        Mon, 24 Oct 2022 15:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1666625336; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc;
        bh=MBq7iXIrmBOBfgn5SORrhloUoXEUXDJebRjMAcJ5RRQ=;
        b=1YwHoiAcUuMR7yc/ycK19BExtFe8vIECE+kVifuXaDam64xODLst1gCJossBlA6No8Y2ne
        9KGTl4glc83dLh9gUaJrhHsBITEojCbMGMAoQ73rhA7cgJHNX+nXxePMoiG+eorRbRnLoE
        iRIixkye4XeLoPwrHPUHcjk+6QUy3h8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1666625336;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc;
        bh=MBq7iXIrmBOBfgn5SORrhloUoXEUXDJebRjMAcJ5RRQ=;
        b=bCpyan8uo1pmedKcF4Gi4JY+pitqWxJj2TqmpsZFMjGsBZDbrnCqsOz4xJXTvAr7pzeNTu
        fho4tBGoHcOu0CAQ==
Received: from lion.mk-sys.cz (unknown [10.163.44.94])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id EDD3A2C141;
        Mon, 24 Oct 2022 15:28:55 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id D0D6E604C3; Mon, 24 Oct 2022 17:28:55 +0200 (CEST)
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool] add 10baseT1L mode to link mode tables
To:     netdev@vger.kernel.org
Cc:     Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Alexandru Tachici <alexandru.tachici@analog.com>
Message-Id: <20221024152855.D0D6E604C3@lion.mk-sys.cz>
Date:   Mon, 24 Oct 2022 17:28:55 +0200 (CEST)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add recently added 10baseT1L/Full link mode to man page and ioctl and
fallback code paths.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 ethtool.8.in       | 1 +
 ethtool.c          | 3 +++
 netlink/settings.c | 1 +
 3 files changed, 5 insertions(+)

diff --git a/ethtool.8.in b/ethtool.8.in
index 1c0e2346f3a1..dee39ddb434a 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -776,6 +776,7 @@ nokeep;
 lB	l	lB.
 0x001	10baseT Half
 0x002	10baseT Full
+0x100000000000000000000000	10baseT1L Full
 0x004	100baseT Half
 0x008	100baseT Full
 0x80000000000000000	100baseT1 Full
diff --git a/ethtool.c b/ethtool.c
index 7b400da32c6f..5d4930252c9b 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -475,6 +475,7 @@ static void init_global_link_mode_masks(void)
 		ETHTOOL_LINK_MODE_400000baseCR4_Full_BIT,
 		ETHTOOL_LINK_MODE_100baseFX_Half_BIT,
 		ETHTOOL_LINK_MODE_100baseFX_Full_BIT,
+		ETHTOOL_LINK_MODE_10baseT1L_Full_BIT,
 	};
 	static const enum ethtool_link_mode_bit_indices
 		additional_advertised_flags_bits[] = {
@@ -715,6 +716,8 @@ static void dump_link_caps(const char *prefix, const char *an_prefix,
 		  "100baseFX/Half" },
 		{ 1, ETHTOOL_LINK_MODE_100baseFX_Full_BIT,
 		  "100baseFX/Full" },
+		{ 0, ETHTOOL_LINK_MODE_10baseT1L_Full_BIT,
+		  "10baseT1L/Full" },
 	};
 	int indent;
 	int did1, new_line_pend;
diff --git a/netlink/settings.c b/netlink/settings.c
index dda4ac9bcf35..ea86e365383b 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -164,6 +164,7 @@ static const struct link_mode_info link_modes[] = {
 	[ETHTOOL_LINK_MODE_400000baseCR4_Full_BIT]	= __REAL(400000),
 	[ETHTOOL_LINK_MODE_100baseFX_Half_BIT]		= __HALF_DUPLEX(100),
 	[ETHTOOL_LINK_MODE_100baseFX_Full_BIT]		= __REAL(100),
+	[ETHTOOL_LINK_MODE_10baseT1L_Full_BIT]		= __REAL(10),
 };
 const unsigned int link_modes_count = ARRAY_SIZE(link_modes);
 
-- 
2.38.0

