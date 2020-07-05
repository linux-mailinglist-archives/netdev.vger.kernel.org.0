Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7797215024
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 00:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728233AbgGEWWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 18:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbgGEWWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 18:22:36 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB7AC061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 15:22:36 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id f16so5766184pjt.0
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 15:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=HECj+HnT/OQgpvYdvNjaeiGd1wL1vPorxDl9OT4vwUs=;
        b=h/1LLSDkpami7/iUOE18CmDknTn5IOmtKIywpXbje80fBTxJUZRfix+qNBhfDC4PW1
         WzIhGUeYg+9CeyI1yFfJJ1GUGOvT78lbyKuWfpw4eCgr3kROwoVBW39PxyA49sPjUAuP
         gWs8kzv8kWhc9aEyuBqPJRnxIAO0oGF8Ng/TY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HECj+HnT/OQgpvYdvNjaeiGd1wL1vPorxDl9OT4vwUs=;
        b=b1mp/r6jZGDM1d/UYDXs653729RMv2Ayx1AQDq42aW5+Vy0u0ygoZIPZUuVT86XJyq
         4XHcvKvmqxv6bnhKNjCMfE0+BFQdkNbVsELnD61DFZmbcbjX4TyLmBkEfTkGDCUTykVJ
         FygpVI9TQbpWokqRt+V3v0/8X8knNlzQtXlyugfCye2+/QdSRQM65hUrX7Y44yZKeFcY
         0Ry5gkV0vI+MJgzLZBMWxNXpjoco9Lu9hN+VhbovKmTCY6xHiiO7qiDqR33IfNMLi9BT
         ABe9R2b/7aVdldXE4jrdK2rrrrvcdR4JVxtx/C4+TzQImm2gBBD7MTTwGuiI8RRd8gpC
         OX0g==
X-Gm-Message-State: AOAM530Q7glMaTobhMirlXxSAs5HenhwzrdijiGh9ArHx3rhh6/fulAX
        VuLutQPkjVkJ2Lu5qqkq+XR+Xw==
X-Google-Smtp-Source: ABdhPJy1+edFQMvWFrbfAg5GOgAHU1YPAZO5S0Ho7lVvKr2IPoR8KSoiZGqx8uMQpFyEHYGbnRz30w==
X-Received: by 2002:a17:90b:1b0a:: with SMTP id nu10mr47498933pjb.182.1593987756095;
        Sun, 05 Jul 2020 15:22:36 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i184sm16843251pfc.73.2020.07.05.15.22.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 Jul 2020 15:22:35 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v3 0/8] bnxt_en: Driver update for net-next.
Date:   Sun,  5 Jul 2020 18:22:04 -0400
Message-Id: <1593987732-1336-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset implements ethtool -X to setup user-defined RSS indirection
table.  The new infrastructure also allows the proper logical ring index
to be used to populate the RSS indirection when queried by ethtool -x.
Prior to these patches, we were incorrectly populating the output of
ethtool -x with internal ring IDs which would make no sense to the user.

The last 2 patches add some cleanups to the VLAN acceleration logic
and check the firmware capabilities before allowing VLAN acceleration
offloads.

v3: Use ALIGN() in patch 5.
    Add warning messages in patch 6.

v2: Some RSS indirection table changes requested by Jakub Kicinski.

Edwin Peer (2):
  bnxt_en: clean up VLAN feature bit handling
  bnxt_en: allow firmware to disable VLAN offloads

Michael Chan (6):
  bnxt_en: Set up the chip specific RSS table size.
  bnxt_en: Add logical RSS indirection table structure.
  bnxt_en: Add helper function to return the number of RSS contexts.
  bnxt_en: Fill HW RSS table from the RSS logical indirection table.
  bnxt_en: Return correct RSS indirection table entries to ethtool -x.
  bnxt_en: Implement ethtool -X to set indirection table.

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 227 ++++++++++++++++------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  20 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  50 ++++-
 3 files changed, 229 insertions(+), 68 deletions(-)

-- 
1.8.3.1

