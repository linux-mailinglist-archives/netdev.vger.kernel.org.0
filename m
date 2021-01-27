Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1D6306573
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 21:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbhA0UzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 15:55:18 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:29881 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233543AbhA0UzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 15:55:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611780915; x=1643316915;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vm0CrJTo/kb0nUxUNkkuwbyYmWL4gU6mgVkXg9ndpHg=;
  b=RHuqJYokQEM+LXnKsJpQLdOKpb2j8w5tBRnjzx6TS0nZYwWCrei+syOP
   /TioV3HvtsoE2KGfJ6xW0wdK9/W7oSlsqy1rmWAOVggxyyezHEwpv52k1
   gcFbbFYrkEHKq+suSbG1M60oYN3eBv0N9p21bFIFHtdavN8raaQYjaLwL
   M7t4mG7qg35wKQ64ccSE0aKozC4xlhyRqfF0NmKxGPk6btJhmiPZ7LQco
   S2G/7Ju69qadNj0FrGdpM1VlwDbCP+sZnGEjW9X9jIRQvv5Bi42Fvb4xi
   M5nf9CH66qg4xNJ+klMaTj9PEyNq61qGkcjJJxB4FSqnDjFmEs9/Y1sgZ
   g==;
IronPort-SDR: IAvxKCBZPGmeA9e4rmrEgkpHvQKhvZb551K2uBe0KlwcyAhAiDb5iESmPTLml9Ls61ar5yhlJ9
 varKrus5ZCJwiCpGhzcA4FcKACvibHzrGY8rSGoc7qh6ZGZ75EiF2cKdT1SFM7wdxFAklkXhQ1
 EgGOmzX0giDiVKVoAJ8KIPyqNLvQKjQrXr51fsP36wC1VBJfIVvMExoRs7SAq0oMrNh0Oc9Je+
 +e0paNW5biU83XNAkmyHBJ/WDvgCL5cQqWa2PFamf8K5PVp+pSleYLCcmCYH0UxbwVhCyzBdu/
 Hs8=
X-IronPort-AV: E=Sophos;i="5.79,380,1602572400"; 
   d="scan'208";a="101667246"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2021 13:53:59 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 27 Jan 2021 13:53:59 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 27 Jan 2021 13:53:57 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <jiri@resnulli.us>, <ivecera@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <rasmus.villemoes@prevas.dk>, <andrew@lunn.ch>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 0/4] bridge: mrp: Extend br_mrp_switchdev_*
Date:   Wed, 27 Jan 2021 21:52:37 +0100
Message-ID: <20210127205241.2864728-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series extends MRP switchdev to allow the SW to have a better
understanding if the HW can implement the MRP functionality or it needs
to help the HW to run it. There are 3 cases:
- when HW can't implement at all the functionality.
- when HW can implement a part of the functionality but needs the SW
  implement the rest. For example if it can't detect when it stops
  receiving MRP Test frames but it can copy the MRP frames to CPU to
  allow the SW to determine this.  Another example is generating the MRP
  Test frames. If HW can't do that then the SW is used as backup.
- when HW can implement completely the functionality.

So, initially the SW tries to offload the entire functionality in HW, if
that fails it tries offload parts of the functionality in HW and use the
SW as helper and if also this fails then MRP can't run on this HW.

v2:
 - fix typos in comments and in commit messages
 - remove some of the comments
 - move repeated code in helper function
 - fix issue when deleting a node when sw_backup was true

Horatiu Vultur (4):
  switchdev: mrp: Extend ring_role_mrp and in_role_mrp
  bridge: mrp: Add 'enum br_mrp_hw_support'
  bridge: mrp: Extend br_mrp_switchdev to detect better the errors
  bridge: mrp: Update br_mrp to use new return values of
    br_mrp_switchdev

 include/net/switchdev.h       |   2 +
 net/bridge/br_mrp.c           |  43 +++++----
 net/bridge/br_mrp_switchdev.c | 171 +++++++++++++++++++++-------------
 net/bridge/br_private_mrp.h   |  38 ++++++--
 4 files changed, 161 insertions(+), 93 deletions(-)

-- 
2.27.0

