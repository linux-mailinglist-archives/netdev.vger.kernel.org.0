Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504591E927A
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 18:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729168AbgE3QLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 12:11:15 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:17600 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728927AbgE3QLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 12:11:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1590855074; x=1622391074;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LsWUZ3Vo3pgKdES5u3EIGHNrOLkQ2RbU+615OKxy1SI=;
  b=lhM9/r2Evgd8QeUnu16sOAsS2KEk5frSnSP9GchJBwYMyF/It+8K/d96
   zXBTvvpbgIwnFW5Pzz4V0Ny4fUn6Oc69h68SW8Kct1mae9+lbFnR18TVk
   OoHH2Kb8eKlOFYQ7hrc1q1jm9nQWt+12XQYF7q/h63SmO1NlyjDJ3eDmy
   nglCuoYO1Q/eRc/0Y7Rrh7lqugkdVUIJflWLtvnhzSanezVRP/Mn3BhWg
   485bGnrA2LkUHxd03XrIUpjNvvET45XPwJ8zaffmkb6ccI/1bVfLbkKQy
   iHhZAbmAJKyGPvyvuDVaZA7l9hoBkJlgqPngVQ3GSm5CBFSAeK8+GMhTT
   Q==;
IronPort-SDR: OqdrAnuviwCfZhiovI71506kcNq/dYqCBphoRNrogKqCaaACKhPD8eT+lm/RbeIi3TEyfP3ZbI
 e04xCbsgD7g4fYflzOWfgZbZnVifc/GBjVPcYeyt29BOTqOCTS844m39pnhaPsN1iTN1G52PYr
 Z7lnK3dJ3HlyqEme3xwL3XgcA28/QpQazrqnfXK8Jr6xg663ldDu7ccJF5j/qQoQKDujoTm2oZ
 r3H2aMcnb79bM5oUfyAIEcnIxSsuRdtWIyiJM3tz7zkWTbAaPoPj5cnPKzCwd4i3EHDUpFoTN3
 KmY=
X-IronPort-AV: E=Sophos;i="5.73,452,1583218800"; 
   d="scan'208";a="14047729"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 May 2020 09:11:14 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 30 May 2020 09:11:17 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Sat, 30 May 2020 09:11:11 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <jiri@resnulli.us>, <ivecera@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 0/3] bridge: mrp: Add support for MRA role
Date:   Sat, 30 May 2020 18:09:45 +0000
Message-ID: <20200530180948.1194569-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series extends the MRP with the MRA role.
A node that has the MRA role can behave as a MRM or as a MRC. In case there are
multiple nodes in the topology that has the MRA role then only one node can
behave as MRM and all the others need to be have as MRC. The node that has the
higher priority(lower value) will behave as MRM.
A node that has the MRA role and behaves as MRC, it just needs to forward the
MRP_Test frames between the ring ports but also it needs to detect in case it
stops receiving MRP_Test frames. In that case it would try to behave as MRM.

v2:
 - add new patch that fixes sparse warnings
 - fix parsing of prio attribute

Horatiu Vultur (3):
  bridge: mrp: Update MRP frame type
  bridge: mrp: Set the priority of MRP instance
  bridge: mrp: Add support for role MRA

 include/net/switchdev.h         |   2 +
 include/uapi/linux/if_bridge.h  |   4 +
 include/uapi/linux/mrp_bridge.h |  60 ++++++++++++---
 net/bridge/br_mrp.c             | 128 +++++++++++++++++++++++++++-----
 net/bridge/br_mrp_netlink.c     |  11 +++
 net/bridge/br_mrp_switchdev.c   |   5 +-
 net/bridge/br_private_mrp.h     |   5 +-
 7 files changed, 182 insertions(+), 33 deletions(-)

-- 
2.26.2

