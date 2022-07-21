Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C239057C414
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 08:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbiGUGEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 02:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbiGUGEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 02:04:43 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D142A1D319;
        Wed, 20 Jul 2022 23:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1658383482; x=1689919482;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=jUcky1r04rEkx9UQ23fy1TR33/eOScjGID6m91yFoHg=;
  b=EuBBfack/N2OmqnHJov8Smkj1VUR6Deu7KAZgVlcjiNoFt5v5abpvNAW
   0e3DBaRaxAwBa+iKQ3EHBXRR+6B+z6RTUrLzHeeajGZYCiFpZAVhkOhvV
   P9gP4AMx7U6BP3w19hh1VHbtbMUinFKNxKy1RF8CE8KoHP+X3sHxB5zg3
   g=;
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 20 Jul 2022 23:04:42 -0700
X-QCInternal: smtphost
Received: from unknown (HELO nasanex01a.na.qualcomm.com) ([10.52.223.231])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 23:04:42 -0700
Received: from zijuhu-gv.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 20 Jul 2022 23:04:39 -0700
From:   Zijun Hu <quic_zijuhu@quicinc.com>
To:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <luiz.von.dentz@intel.com>, <swyterzone@gmail.com>,
        <quic_zijuhu@quicinc.com>
CC:     <linux-kernel@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 0/4] Bluetooth: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING
Date:   Thu, 21 Jul 2022 14:04:29 +0800
Message-ID: <1658383473-32188-1-git-send-email-quic_zijuhu@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series remove bluetooth HCI_QUIRK_BROKEN_ERR_DATA_REPORTING
the quirk was introduced by 'commit cde1a8a99287 ("Bluetooth: btusb: Fix
and detect most of the Chinese Bluetooth controllers")' to mark HCI
commands HCI_Read|Write_Default_Erroneous_Data_Reporting broken within BT
device driver, but the reason why these two HCI commands are broken is
that feature "Erroneous Data Reporting" is not enabled by firmware, so BT
core driver can addtionally check feature bit "Erroneous Data Reporting"
instead of the quirk to decide if these two HCI commands work fine.

BLUETOOTH CORE SPECIFICATION Version 5.3 | Vol 2, Part C | page 587
This feature indicates whether the device is able to support the
Packet_Status_Flag and the HCI commands HCI_Write_Default_-
Erroneous_Data_Reporting and HCI_Read_Default_Erroneous_-
Data_Reporting.

Only QCA and fake CSR btusb device driver set the quirk currently since
the feature "Erroneous Data Reporting" are not enabled by their firmware
so we also remove the quirk from their device driver.

Changes since v1:
- split changes to solve build error between patches
- optimize commit messages

Zijun Hu (4):
  Bluetooth: hci_sync: Check LMP feature bit instead of quirk
  Bluetooth: btusb: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING for QCA
  Bluetooth: btusb: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING for fake
    CSR
  Bluetooth: hci_sync: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING

 drivers/bluetooth/btusb.c   |  2 --
 include/net/bluetooth/hci.h | 12 +-----------
 net/bluetooth/hci_sync.c    |  7 ++-----
 3 files changed, 3 insertions(+), 18 deletions(-)

-- 
2.7.4
