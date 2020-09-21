Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCA2273153
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 19:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbgIUR5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 13:57:32 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:14898 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726436AbgIUR5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 13:57:31 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08LHtDRr030739;
        Mon, 21 Sep 2020 10:57:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=RMoMwP7DHwmIVrsImExpffsA3WKR7EZ1sRWbHTkqN2I=;
 b=WEMCZeGPsrdqw+zorXH8A+jhO2CgWo1l9uhOaa3brYz9qFMFPO/NBK7vyzLx4dN9qzAW
 BvRjqFkgbXtwP9hjLKufrFpaCK4zN7iJBcMGAAHpYjZvZEUo6aL90cgFcDDTOBeRIrfZ
 Ksw9ba+oAo1w3rvOO33pG52EfzmFcgnTfTAwQ5T448sQLuU1ako/z87EGSD7Av0FAXIt
 2056r4EsIVle03HV9a14PvnXN15idmxj5hsU+qWji9OUYSsm2OZxU6D2Bv4u8AoFHAS7
 kYx1EQl6JMxneL/M6zK3/D//oB4p/d5szCRzvm6Nhqk8QKWw48nZSuQBPZO+g/kl13OI 2Q== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 33nfbpq3tw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 10:57:29 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 21 Sep
 2020 10:57:28 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 21 Sep
 2020 10:57:27 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 21 Sep 2020 10:57:27 -0700
Received: from yoga.marvell.com (unknown [10.95.131.144])
        by maili.marvell.com (Postfix) with ESMTP id 91BE83F7043;
        Mon, 21 Sep 2020 10:57:25 -0700 (PDT)
From:   Stanislaw Kardach <skardach@marvell.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>
CC:     <kda@semihalf.com>, Stanislaw Kardach <skardach@marvell.com>
Subject: [PATCH net-next 0/3] octeontx2-af: add support for KPU profile customization
Date:   Mon, 21 Sep 2020 19:54:39 +0200
Message-ID: <20200921175442.16789-1-skardach@marvell.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-21_06:2020-09-21,2020-09-21 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marvell octeontx2 NPC device contains a configurable Kanguroo Parser Unit
(KPU) and CAM match key data extraction (MKEX). The octeontx2-af driver
configures them both to parse a list of standard protocol headers which
are used by netdev driver and other potential applications (i.e.
userspace through VFIO).
The problem arises when users have some custom protocol headers which
they'd like to use in CAM flow matching. If such protocols are publicly
known, they can be added to the built-in KPU configuration (called
"profile" - in npc_profile.h). If not, then there's more benefit in
keeping such changes local to the user.
For that case a mechanism which would allow users to produce a KPU
profile and load it along with octeontx2-af driver is needed. At the same
time such customization has to take care not to break the netdev driver
operation or other applications (that is be discoverable).

Therefore introduce a mechanism for a limited customization of the
built-in KPU profile via a firmware file (layout and contents described
by struct npc_kpu_profile_fwdata). It allows user modification of only a
limited number of top priority KPU entries, while others are configured
from the built-in KPU profile. Additionally by convention users should
only use NPC_LT_Lx_CUSTOMx LTYPE entries in their profiles to change the
meaning of built-in LTYPEs. This way the baseline protocol support is
always available and the impact of potential user errors is minimized.
As MKEX also needs to be modified to take into account any user
protocols, the KPU profile firmware binary contains also that. Netdev
driver and applications have a way to discover applied MKEX settings by
querying RVU AF device via NPC_GET_KEX_CFG MBOX message.
Finally some users might need to modify hardware packet data alignment
behavior and profile contains settings for that too.

First patch ensures that CUSTOMx LTYPEs are not aliased with meaningful
LTYPEs where possible.

Second patch gathers all KPU profile related data into a single struct
and creates an adapter structure which provides an interface to the KPU
profile for the octeontx2-af driver.

Third patch adds logic for loading the KPU profile through kernel
firmware APIs, filling in the customizable entries in the adapter
structure and programming the MKEX from KPU profile.

Changes from v1:
* Remove unnecessary __packed attributes. All structures in profile are
  naturally aligned and only struct npc_kpu_profile_fwdata is padded
  1B at the end, which is expected.
* Make npc_lt_defaults and npc_mkex_default const as they are read-only.
* Save custom KPU entries in separate struct npc_kpu_profile so that the
  default profile can remain read-only and there's no need to allocate
  and memcpy 25kB of default profile when customizations are present.
  The drawbacks are weaker profile abstraction and slightly more
  complicated programming steps.
  This is a result of:
  4a681bf3456f octeontx2-af: Constify npc_kpu_profile_{action,cam}
* Describe in last commit the reason for using a module parameter
  instead of an arbitrary firmware name.

Stanislaw Kardach (3):
  octeontx2-af: fix LD CUSTOM LTYPE aliasing
  octeontx2-af: prepare for custom KPU profiles
  octeontx2-af: add support for custom KPU entries

 .../net/ethernet/marvell/octeontx2/af/npc.h   |  76 +++-
 .../marvell/octeontx2/af/npc_profile.h        | 244 +++++++++++-
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   6 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  22 ++
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  36 +-
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   | 368 +++++++++++-------
 6 files changed, 587 insertions(+), 165 deletions(-)

-- 
2.20.1

