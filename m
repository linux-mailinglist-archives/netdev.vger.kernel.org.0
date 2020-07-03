Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849312134CF
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 09:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgGCHUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 03:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbgGCHUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 03:20:04 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3F7C08C5C1
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 00:20:04 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z13so31550666wrw.5
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 00:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=TBgVbwc+ZUlfC7VZ87ZP+1DZxsG1nyG6UHR8iEMt3Po=;
        b=K+ZLZJ042+iwVEqqwUjNXEN2VEHFQgVV5rEqishMxuNrXPgN0yIXSeSzKZNJYYNLuB
         EGUaaoortVYihTfFJrtIjagxCrCDabQmTBa5LEyVLUNEzEthltHWymJV7bKYb7ahXPRY
         wPSWMgXvKltfcce9ltnr/mOeOIBcnDOoRsFs0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TBgVbwc+ZUlfC7VZ87ZP+1DZxsG1nyG6UHR8iEMt3Po=;
        b=C5DBgLxflDTO90nKRa/jzoC2vZfnCcSx8/d7N0fcTN6WiVlK9VHXLpehNumOtrMmnW
         T35wXVR/ZaQgwQlE/ra5vA5q6Vu3RsEzBfScjodKPLhUSxBdTqj5Pvb9ApC3fPKceswy
         7TrElc0UtPA+OLPqm9wXrkoRbj3ImWs/PZ4ed/2IIiDXVWBDGtRSY8xDK1h/VPieORjd
         vzNgy+JuzZaXq78JWf5XrTTATjKfy0c2/Jwgwy0aQ+NnszF/GGH78JCZzB+mukMTDcxe
         QAa3A66RZlZxiRwXCWznZkOS6vp72tnx8Ogvz407kxq2qXhoXTv9NbsTuuwLgTxSd94e
         1Rxw==
X-Gm-Message-State: AOAM531dVkTPwlffednB8UVaUj1BDH7a5M/ETI6ww+NQfZEdsywF4E2G
        by420qDdaQ0oN0cfSwZpGY57TrNPjes=
X-Google-Smtp-Source: ABdhPJzJsnhJj5tv0+SYp6K3qurMFzR27iv8DNS3LilOKI4KBCmsMYT1NkTynAqiA++GoV1CkRrzlg==
X-Received: by 2002:adf:f885:: with SMTP id u5mr34641024wrp.402.1593760800605;
        Fri, 03 Jul 2020 00:20:00 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a22sm12529564wmj.9.2020.07.03.00.19.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jul 2020 00:20:00 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v2 0/8] bnxt_en: Driver update for net-next.
Date:   Fri,  3 Jul 2020 03:19:39 -0400
Message-Id: <1593760787-31695-1-git-send-email-michael.chan@broadcom.com>
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

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 221 +++++++++++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  20 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  52 ++++-
 3 files changed, 225 insertions(+), 68 deletions(-)

-- 
1.8.3.1

