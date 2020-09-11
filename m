Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20E426643C
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 18:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgIKQdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 12:33:46 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:29688 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725919AbgIKPQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:16:40 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08BDJrcr027182;
        Fri, 11 Sep 2020 06:21:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=S7PDn2ea4pG+6EcmnvXKnsOulhplG0V4vUvi4N+ws0I=;
 b=SzMocMvksGf8Mfxp82KM2tBsMdfKK0fiJXUZ1ZOCCLEzL3KWhZLt1qWT993TFXg2vWWw
 N3K4nGDDQ3CXazbWMb0U+/mOHsaQMfMGmFiZ+dWQ2qcepnenZgTiIBNr6g+3R+DvDaaW
 l2eD2MwYoNCFBtUHnjHEcBEYA5YgLlKYYRBiZ8d3px7anDzBr9cl8Y7Spw00nK0ork9s
 4n2oQrQ4ds/7axu5xylXqeIt6pInyk8WLLWwWER8Xsi2Fa4QIrxR8RcYfds6e1S/lroU
 lW2uuHh7Rou/ARNgSeyVBbsABpIh3uaq9u1QFUzMdJJ6Y4RQLE1HBacXv2jbIHab0APG /Q== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 33ff7mdjwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 11 Sep 2020 06:21:35 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Sep
 2020 06:21:34 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Sep
 2020 06:21:33 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 11 Sep 2020 06:21:33 -0700
Received: from yoga.marvell.com (unknown [10.95.131.64])
        by maili.marvell.com (Postfix) with ESMTP id 6FF4E3F703F;
        Fri, 11 Sep 2020 06:21:31 -0700 (PDT)
From:   <skardach@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>
CC:     Stanislaw Kardach <skardach@marvell.com>
Subject: [PATCH net-next 0/3] octeontx2-af: add support for KPU profile customization
Date:   Fri, 11 Sep 2020 15:21:21 +0200
Message-ID: <20200911132124.7420-1-skardach@marvell.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-11_04:2020-09-10,2020-09-11 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stanislaw Kardach <skardach@marvell.com>

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

Stanislaw Kardach (3):
  octeontx2-af: fix LD CUSTOM LTYPE aliasing
  octeontx2-af: prepare for custom KPU profiles
  octeontx2-af: add support for custom KPU entries

 .../net/ethernet/marvell/octeontx2/af/npc.h   |  80 +++-
 .../marvell/octeontx2/af/npc_profile.h        | 244 ++++++++++++-
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   6 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  22 ++
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  36 +-
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   | 341 ++++++++++--------
 6 files changed, 564 insertions(+), 165 deletions(-)

-- 
2.20.1

