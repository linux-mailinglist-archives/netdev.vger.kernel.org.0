Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8331527C11A
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 11:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgI2J2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 05:28:37 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41776 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727746AbgI2J2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 05:28:37 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08T9OYJ8010725;
        Tue, 29 Sep 2020 02:28:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=u4eoJftl1VM4X/M8bk9d61cersQCmUD2ckghLtciNck=;
 b=F9CIE4LXGN24cMJyixzoOzIOyz7XN+9f1Ul/HYSrPhESge4K/u8O6Mkb6oD3/dwgGpIV
 oq2t//WXOTO605nkenFN1dZH+WInYeTrG9b2aKxuHA47HcHfnXkFlKQkqdOTw7eep5EB
 p5NAvmYaU/bpqzjYy5UooWrMRzYEdn1N8/4T1tMI94yIIvsNL0xOKeikj2w90sVgTiGs
 GKYXYBYu/d99CoAsX0JvKuHjJ3D8+a4tilD+bfuNUU3fh5swqXZARpOky2MyAKSBVS1B
 7OGK44M2veA1qqeCkoW8VhTF4JL0iHJqCvxYHSSq14yICAQ2DbjUVqztXo31KRpKwoVj 7Q== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 33teemb7x5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 02:28:34 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 29 Sep
 2020 02:28:33 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 29 Sep 2020 02:28:33 -0700
Received: from yoga.marvell.com (unknown [10.95.131.226])
        by maili.marvell.com (Postfix) with ESMTP id 0B2CA3F703F;
        Tue, 29 Sep 2020 02:28:31 -0700 (PDT)
From:   Stanislaw Kardach <skardach@marvell.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>
CC:     <kda@semihalf.com>, Stanislaw Kardach <skardach@marvell.com>
Subject: [PATCH net-next 0/7] octeontx2-af: cleanup and extend parser config
Date:   Tue, 29 Sep 2020 11:28:13 +0200
Message-ID: <20200929092820.22487-1-skardach@marvell.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_01:2020-09-29,2020-09-29 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current KPU configuration data is spread over multiple files which makes
it hard to read. Clean this up by gathering all configuration data in a
single structure and also in a single file (npc_profile.h). This should
increase the readability of KPU handling code (since it always
references same structure), simplify updates to the CAM key extraction
code and allow abstracting out the configuration source.
Additionally extend and fix the parser config to support additional DSA
types, NAT-T-ESP and IPv6 fields.

Patch 1 ensures that CUSTOMx LTYPEs are not aliased with meaningful
LTYPEs where possible.

Patch 2 gathers all KPU profile related data into a single struct and
creates an adapter structure which provides an interface to the KPU
profile for the octeontx2-af driver.

Patches 3-4 add support for Extended DSA, eDSA and Forward DSA.

Patches 5-6 adds IPv6 fields to CAM key extraction and optimize the
parser performance for fragmented IPv6 packets.

Patch 7 refactors ESP handling in the parser to support NAT-T-ESP.

Abhijit Ayarekar (1):
  octeontx2-af: optimize parsing of IPv6 fragments

Hariprasad Kelam (1):
  octeontx2-af: add parser support for Forward DSA

Kiran Kumar K (1):
  octeontx2-af: add parser support for NAT-T-ESP

Satha Rao (1):
  octeontx2-af: fix Extended DSA and eDSA parsing

Stanislaw Kardach (2):
  octeontx2-af: fix LD CUSTOM LTYPE aliasing
  octeontx2-af: cleanup KPU config data

Vidhya Vidhyaraman (1):
  octeontx2-af: Add IPv6 fields to default MKEX

 .../net/ethernet/marvell/octeontx2/af/npc.h   |  43 +-
 .../marvell/octeontx2/af/npc_profile.h        | 473 +++++++++++++++---
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  17 +
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  36 +-
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   | 202 +++-----
 5 files changed, 557 insertions(+), 214 deletions(-)

-- 
2.20.1

