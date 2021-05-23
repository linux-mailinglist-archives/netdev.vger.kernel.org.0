Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77D338DBBE
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 17:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbhEWQAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 12:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbhEWQAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 12:00:15 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A645BC061574;
        Sun, 23 May 2021 08:58:47 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id f8so18976011qth.6;
        Sun, 23 May 2021 08:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DRIzGMm1llvtiop65Q5Xv1q5ORI+sSk6YJftRyqqFv8=;
        b=aeqilIN9R5UM9SvHX02AjsWuR5zTkegVQjw7ZlKgItSVQ2SC9L0bMLL3QLYAkcNXQm
         1lVbLkBcJe3tBUUvcSv1rzF34fr9GVs+JuuwaFk1XQ5YHxFwwey1agcR3TuarKmpVPvj
         pVAcrYvJrz5xKAKaSyW4I6YtweljtJ9sWLB7m1FcEu5ozywManVdn8FLye1SVS3dsFLA
         QFNjIiBamjR1uJ1gDobsGQxDi/efO7C6thdif51vKdz8txWzo/n51rZxmMstdryQskv4
         +S3etFOlciXfC1Cbg++BKxhxqcpCDMmDGdCjZcwnWlW+qzDyvHfySLT5kGWTmBPqUhdE
         p84A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DRIzGMm1llvtiop65Q5Xv1q5ORI+sSk6YJftRyqqFv8=;
        b=MxWA2+qH2RhfmGhK7NLm3+mWdmKf5DMMHN/akci5GUpts5CF2lYElmDGFjXoPVR12c
         xYdjLsqrZVN8ENqmMWdzkAKbB8sWr2rXqwgDQoFFpNP+4OIUkftpP9is8K78g7vdWSR4
         xTJaqMZCyRBeennCiFYeDS2KYiTGiRuPD07WbYfrKI0MOYVxCm2wL2gsHqEzLIjtJV3E
         EiMvZP2SnhBnyZMT7A3rLPReVnXUHhxtKWV+5WlK4ztxnBPkeWoWzSfuLyVXn9K4+Vdb
         ESa+g2FvSamHGedffp9sESPh1OvapLpghIDeb4IR1sFUdLAcFuoo5p2txTwHzt/QZG1g
         6yKA==
X-Gm-Message-State: AOAM532UM7oIX9TqRk61ut2DoyFu3UF4AjqWU6j/zIJNKoiSKGlIgfEJ
        Aq/9HPL8RO0doNvMV6R6B7X7BohEPUPD2g==
X-Google-Smtp-Source: ABdhPJwzH/O+GlwCXh714AY2EnfeJf11r6A4I0aAZu2ccBmivjG3Dp0DuCGC4BPLzsV+nCh+viUxyQ==
X-Received: by 2002:ac8:68d:: with SMTP id f13mr21936681qth.300.1621785526432;
        Sun, 23 May 2021 08:58:46 -0700 (PDT)
Received: from localhost.localdomain (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id s123sm9125602qkf.1.2021.05.23.08.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 08:58:45 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: r6040: Allow restarting auto-negotiation
Date:   Sun, 23 May 2021 08:58:42 -0700
Message-Id: <20210523155843.11395-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use phy_ethtool_nway_reset() since the driver makes use of the PHY
library.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/rdc/r6040.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/rdc/r6040.c b/drivers/net/ethernet/rdc/r6040.c
index 80fee3a9b603..dd9286f520b6 100644
--- a/drivers/net/ethernet/rdc/r6040.c
+++ b/drivers/net/ethernet/rdc/r6040.c
@@ -972,6 +972,7 @@ static const struct ethtool_ops netdev_ethtool_ops = {
 	.get_ts_info		= ethtool_op_get_ts_info,
 	.get_link_ksettings     = phy_ethtool_get_link_ksettings,
 	.set_link_ksettings     = phy_ethtool_set_link_ksettings,
+	.nway_reset		= phy_ethtool_nway_reset,
 	.get_regs_len		= r6040_get_regs_len,
 	.get_regs		= r6040_get_regs,
 };
-- 
2.25.1

