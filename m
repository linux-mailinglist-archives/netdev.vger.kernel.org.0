Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8B756B18F
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 06:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236703AbiGHEbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 00:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiGHEbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 00:31:35 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BD424BC1;
        Thu,  7 Jul 2022 21:31:34 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2681sgHt030409;
        Thu, 7 Jul 2022 21:31:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=3SiQWiCZJ+A8o/VaYrq5OlVmft7klm0U5xlzIHMU6yY=;
 b=YOyQ2hPP/Tp8Z9boS/ctKC8cLOkHhSA18WrFPoeBIGLLfDF+M0Cguk1cjFrguZ6TK97B
 U/vYQMtQzuHnTjuoacDUm8zDn5fi/W70UqSMZjBADhL16rzHlxonRsu0kKgAushmfH5s
 knxMTIMNqwLDilMTinct3wRmdjelU49l3Rp3QEOw0o2MnR/nPWVfBkCcYfUJrjnGBERD
 D/9FuYdlJQvFpCzF31p5P0xk9/t7SiqpyUgY7AJhmEvd9zBWQy10GqJ/5UCMmMwXZIxK
 QjHSazEc8/ZRjh5MSb9K+HmP5b2D5VxdlCv1EU8iM94hVb9yogxYBteF4F7koFi/FGdl /g== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3h6bay8ds7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 21:31:21 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 7 Jul
 2022 21:31:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 7 Jul 2022 21:31:20 -0700
Received: from IPBU-BLR-SERVER1.marvell.com (IPBU-BLR-SERVER1.marvell.com [10.28.8.41])
        by maili.marvell.com (Postfix) with ESMTP id 9CECE3F7083;
        Thu,  7 Jul 2022 21:31:17 -0700 (PDT)
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: [net-next PATCH v4 00/12] octeontx2: Exact Match Table.
Date:   Fri, 8 Jul 2022 10:00:48 +0530
Message-ID: <20220708043100.2971020-1-rkannoth@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 3uTABkD9ZeEzE_JJEKa0xVV39ux0b99-
X-Proofpoint-ORIG-GUID: 3uTABkD9ZeEzE_JJEKa0xVV39ux0b99-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-08_02,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Exact match table and Field hash support for CN10KB silicon

ChangeLog
---------
  1) V0 to V1
     a) Removed change IDs from all patches.

  2) V1 to V2
     a)Fixed all compile warnings and cleanly compiled all patches.

  3) V2 to V3
     a) Fixed patch series subject text.

  4) V3 to V4
     a) Fixed sparse errors.
     b) Fixed warnings by -Wsometimes-uninitialized option

Ratheesh Kannoth (11):

These patch series enables exact match table in CN10KB silicon. Legacy
silicon used NPC mcam to do packet fields/channel matching for NPC rules.
NPC mcam resources exahausted as customer use case increased.
Supporting many DMAC filter becomes a challenge, as RPM based filter
count is less. Exact match table has 4way 2K entry table and a 32 entry
fully associative cam table. Second table is to handle hash
table collision over flow in 4way 2K entry table. Enabling exact match
table results in KEX key to be appended with Hit/Miss status. This can be
used to match in NPC mcam for a more generic rule and drop those packets
than having DMAC drop rules for each DMAC entry in NPC mcam.

  octeontx2-af: Exact match support
  octeontx2-af: Exact match scan from kex profile
  octeontx2-af: devlink configuration support
  octeontx2-af: FLR handler for exact match table.
  octeontx2-af: Drop rules for NPC MCAM
  octeontx2-af: Debugsfs support for exact match.
  octeontx2: Modify mbox request and response structures
  octeontx2-af: Wrapper functions for mac addr add/del/update/reset
  octeontx2-af: Invoke exact match functions if supported
  octeontx2-pf: Add support for exact match table.
  octeontx2-af: Enable Exact match flag in kex profile

Suman Ghosh (1):
  octeontx2-af: Support to hash reduce of actual field into MCAM key

 .../ethernet/marvell/octeontx2/af/Makefile    |    2 +-
 First patch in the series "octeontx2-af: Support to hash reduce of actual
 field into MCAM key" introduced new C file. Makefile is modified to
 compile the same.

 .../net/ethernet/marvell/octeontx2/af/mbox.h  |   41 +-
 Mbox request and response structures requires modification.
 RPM based DMAC filter can be modified at any location
 in the RPM filter table as entry's location has no relation to content.
 But for NPC exact match's 2K, 4way table is based on hash.
 This means that modification of an entry may fail if hash mismatches.
 In these cases, we need to delete existing entry and create a new entry
 in a different slot determined by hash value. This index has to
 be returned to caller.

 .../net/ethernet/marvell/octeontx2/af/npc.h   |   25 +
 New data types (enums and macros) for this feature.

 .../marvell/octeontx2/af/npc_profile.h        |    5 +-
 Kex profile changes to add exact match HIT bit in the Key.
 Inorder to accommodate this nibble, NPC_PARSE_NIBBLE_ERRCODE
 is deleted as it is not used.

 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   17 +
 Exact match HW capability flag is initialized to false.
 FLR handler changes to invoke rvu_npc_exact_reset()
 to free all exact match resources in case of interface reset.

 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   24 +-
 Exact match table info is defined in rvu_hwinfo structure.
  This table structure is heap allocated and maintains
 all information about available/free/allocated resources.

 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   |   41 +-
 As of today, RPM based DMAC filter is configured upon user command.
 Each of these mbox handler is trapped and checked for NPC exact match
 support. If support is enabled, invokes Exact match API instead of
 RPM dmac based calls.

 .../marvell/octeontx2/af/rvu_debugfs.c        |  179 ++
 Three debugfs entries would be created if Exact match table is supported.
  1. exact_entries : List out npc exact match entries
  2. exact_info : Info related exact match tables (mem and cam table)
  3. exact_drop_cnt: Drop packet counter for each NPC mcam drop rule.

 .../marvell/octeontx2/af/rvu_devlink.c        |   71 +-
 Devlink provides flexibility to user to switch to RPM based DMAC filters
 on CN10KB silicon. Please note that devlink command fails if user added
 DMAC filters prior to devlink command to disable exact match table.

 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |    7 +
 Promiscuous mode enable must disable this Exact match table based drop
 rule on NPC mcam. set rx mode routine calls enable/disable corresponding
 NPC exact drop rule when promiscuous mode is toggled.

 .../ethernet/marvell/octeontx2/af/rvu_npc.c   |   51 +-
 APIs to reserve NPC mcam entries. This is used to reserve and
 configure NPC drop rules.

 .../marvell/octeontx2/af/rvu_npc_fs.c         |  162 +-
 For each PF, there is a drop rule installed in NPC mcam.
 This installation is done during rvu probe itself.
 Drop rule has multicast and broadcast bits turned off.
 This means that broadcast and multicast packets will
 never get dropped irrespective of NPC exact match table.
 This rule action is drop if exact table match bit
 0 and channel is matched. This means if there is no hit
 is exact match table and channel match, packets will
 be dropped.

 .../marvell/octeontx2/af/rvu_npc_fs.h         |   17 +

 .../marvell/octeontx2/af/rvu_npc_hash.c       | 1958 +++++++++++++++++
 New file added. This file implements add/del/update to exact match table,
 probing of the feature and invokes function to install drop ruleis
 in NPC mcam.

 .../marvell/octeontx2/af/rvu_npc_hash.h       |  233 ++
 function declarations for rvu_npc_hash.c

 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   15 +
 Register access macros for NPC exact match.

 .../marvell/octeontx2/nic/otx2_common.h       |   10 +-
 Since NPC exact match table has more entries than RPM DMAC filter,
 size of bmap_to_dmacindex is increased from 8 to 32bit.
 Maximum number of dmac entries available also increased
 (increased the size of bitmap)

 .../marvell/octeontx2/nic/otx2_dmac_flt.c     |   46 +-
 .../marvell/octeontx2/nic/otx2_flows.c        |   40 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |    2 +-
 Above change in marvell/octeontx2/nic/otx2_common.h,
 require corresponding modification in these 3 C files.
 Please note that we need to modify/change existing entry index as
 mentioned in description of net/ethernet/marvell/octeontx2/af/mbox.h
 in this cover letter.

 20 files changed, 2879 insertions(+), 67 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h

--
2.25.1
