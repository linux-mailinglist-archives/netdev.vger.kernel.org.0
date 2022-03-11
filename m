Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 488484D657A
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 16:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349482AbiCKP7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 10:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350196AbiCKP6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 10:58:10 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631541D0852
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 07:56:53 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id g8so3746121qke.2
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 07:56:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x64architecture.com; s=x64;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8KVXm8VtbL8Q60zyQIZJY/zDt/+VyX8po8RQqT8kDSE=;
        b=pfGuBGT5PXPkvhoS2sjtR5MsYjCVS/jgnQ/lcxtmTCvbcPwlspg0p1f/sqje0KAqF9
         KlBAp9xfpG+E4BOaEp/mwp/NcK3Lt/V0NMGqdwSQKEq0n9T5T80XA8MpJsaPO8sbXPge
         O3oIXpxDN3ENrliCDY2E1a+B3RcABMyQnk39UMsnXCGCk2HLAUKytgQ8yQx48TxnEKZ/
         INTlGRAFSoW14Mag0wI/NGKbWRokzsi6pKmTVW6xEZBGer1dVC0bTsp8DPg3/u2tg7of
         ldkMm5RG8Ams1KJ1GMqXJX4ujsJXGzhZ0ZqWpMgolSris3iqzbPBnyLX0ZgKU0pOVJui
         blQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8KVXm8VtbL8Q60zyQIZJY/zDt/+VyX8po8RQqT8kDSE=;
        b=MQQeMo2oO7NBuIW7bv4Z0S5XJekZ5U8vqTeOjek0rguQC+uX0e3R4u29w4WXtHHpTs
         /+Llg2e1N266wzC2n1wL4MZ6aawX2IYEo3294X9HWkQY46/FBdH5OeAcoZTiqy2JXsQK
         49iqWvOlWVgsxNIijwFIHlB52aDl0Ux8YYFsOtJLeDHtHcJ0BoDvD8AVGunO4TSgcnPb
         M7YjNIdR9Lgu6eNyRX+UphL0Ge+KXYfBHZ9gWDLIRBn/1gb/E/ZZLJ6hH4+FrFBBgH2+
         LBE9Os/GyroXXLM7FWcpl972V9c/GN8YP79Nz54k5OVeudr/psmLqlVKgVucl6u5Xex7
         qMVg==
X-Gm-Message-State: AOAM533NbeLmD53d27+Q6r9QLdEQn9PCnTa+zF3i3FUCN1KsafQ3Rvaf
        U7XG5p6GIcgTjhqBjf8s/4YMut3vwiKzh1ZR
X-Google-Smtp-Source: ABdhPJzhQyimglGDZ6oM9EAJDsirIF2ve2Prjl5Gw+ubniN3YDehlyo8iP0Ab6nqoP1AwzTvZI/0vg==
X-Received: by 2002:a05:620a:a8f:b0:67b:31ce:6473 with SMTP id v15-20020a05620a0a8f00b0067b31ce6473mr6798140qkg.728.1647014211345;
        Fri, 11 Mar 2022 07:56:51 -0800 (PST)
Received: from kcancemi-arch.Engineering.com ([167.206.126.218])
        by smtp.gmail.com with ESMTPSA id f11-20020a05620a20cb00b0067d2a3ae475sm3952445qka.16.2022.03.11.07.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 07:56:50 -0800 (PST)
From:   Kurt Cancemi <kurt@x64architecture.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, linux@armlinux.org.uk,
        Kurt Cancemi <kurt@x64architecture.com>
Subject: [PATCH] net: phy: marvell: Fix invalid comparison in marvell_{suspend,resume}()
Date:   Fri, 11 Mar 2022 10:55:42 -0500
Message-Id: <20220311155542.1191854-1-kurt@x64architecture.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This bug resulted in not resuming and suspending both the fiber and copper
modes. Only the current mode would be suspended.

Signed-off-by: Kurt Cancemi <kurt@x64architecture.com>
---
 drivers/net/phy/marvell.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 2429db614b59..80b888a88127 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1687,7 +1687,7 @@ static int marvell_suspend(struct phy_device *phydev)
 	int err;
 
 	/* Suspend the fiber mode first */
-	if (!linkmode_test_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
 			       phydev->supported)) {
 		err = marvell_set_page(phydev, MII_MARVELL_FIBER_PAGE);
 		if (err < 0)
@@ -1722,7 +1722,7 @@ static int marvell_resume(struct phy_device *phydev)
 	int err;
 
 	/* Resume the fiber mode first */
-	if (!linkmode_test_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
 			       phydev->supported)) {
 		err = marvell_set_page(phydev, MII_MARVELL_FIBER_PAGE);
 		if (err < 0)
-- 
2.35.1

