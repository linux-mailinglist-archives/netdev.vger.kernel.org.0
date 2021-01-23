Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44E2D3016CA
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 17:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbhAWQVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 11:21:08 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:24607 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbhAWQVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 11:21:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611418866; x=1642954866;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DN5eZjnAtCOTKv9CtTf6bYhkgWAbYsnIlHVD1aItLxU=;
  b=ZhS2x5Fhg5BAuG+r5Bwo2BD5BnY7vi+Tl5/0JicVUqJSkbNxpK15xLET
   CJzycCoZUQqfWdu1a99KEUgfRA4sSrmUl1BRRMP0G1WfGD9GEHgC1PYhf
   HaKWw7BS1ZwWtvnGXwlgljcMa337eHmYOzqJjqTl/SwfBGtoLaHKYOH4e
   Y6ZR6QhYiCyYBASCOkBXPZI3MlFjQ2XFiQdR/TAPhoSvPfPkC2QZ/kaKy
   OxHL0Y5qFfPSjdYZAS005Qk4Iq/fbhDddDcetuD4tDt5Al69q4bSVS/n8
   aKdDlaOePX0CzXOV6K7ZXXa9GC39W7TQLguiUiM8jmBrlXIFRH1u/KNnP
   w==;
IronPort-SDR: S9FsRNdB6VpSL9CyITAgYJscmf/93TSVW4UI6FFgclGg6xMlVZJB2NluurEl6aJO5WsoVatvUI
 2VAo42ejPGaQlOZcnw2iQ9CDQ0dU2de1AtJSlPA0MhCYCkGNt76waXsRjDrPXQB9lIwdFnAQyT
 YJLUqSH/IL29xbkHyhm+ZNV2It+qYjO/GLtF4ukVd2Cbzq6oH6quaXhF8Gg9gZCnviqEyfrqN4
 cmLAcQKw5Y5jcUG12qhRhliVOYmwBJQdxafQ0IT4Yh1aax1Q+uKEGTukS56DICb1FdyrtQvsHr
 1TU=
X-IronPort-AV: E=Sophos;i="5.79,369,1602572400"; 
   d="scan'208";a="101164367"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Jan 2021 09:19:49 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 23 Jan 2021 09:19:49 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Sat, 23 Jan 2021 09:19:46 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <jiri@resnulli.us>, <ivecera@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <rasmus.villemoes@prevas.dk>, <andrew@lunn.ch>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 0/4] bridge: mrp: Extend br_mrp_switchdev_*
Date:   Sat, 23 Jan 2021 17:18:08 +0100
Message-ID: <20210123161812.1043345-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series extends MRP switchdev to allow the SW to have a better
understanding if the HW can implment the MRP functionality or it needs to
help the HW to run it. There are 3 cases:
- when HW can't implement at all the functionality.
- when HW can implement a part of the functionality but needs the SW
  implement the rest. For example if it can't detect when it stops
  receiving MRP Test frames but it can copy the MRP frames to CPU to
  allow the SW to determin this.  Another example is generating the MRP
  Test frames. If HW can't do that then the SW is used as backup.
- when HW can implement completely the functionality.

So, initially the SW tries to offload the entire functionality in HW, if
that fails it tries offload parts of the functionality in HW and use the
SW as helper and if also this fails then MRP can't run on this HW.

Horatiu Vultur (4):
  switchdev: mrp: Extend ring_role_mrp and in_role_mrp
  bridge: mrp: Add 'enum br_mrp_hw_support'
  bridge: mrp: Extend br_mrp_switchdev to detect better the errors
  bridge: mrp: Update br_mrp to use new return values of
    br_mrp_switchdev

 include/net/switchdev.h       |   2 +
 net/bridge/br_mrp.c           |  43 +++++---
 net/bridge/br_mrp_switchdev.c | 189 +++++++++++++++++++++++++---------
 net/bridge/br_private_mrp.h   |  38 +++++--
 4 files changed, 195 insertions(+), 77 deletions(-)

-- 
2.27.0

