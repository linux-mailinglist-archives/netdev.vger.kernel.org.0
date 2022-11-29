Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1F763B955
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 06:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235345AbiK2FOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 00:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233673AbiK2FOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 00:14:31 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A537419BF;
        Mon, 28 Nov 2022 21:14:30 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ASNXEwQ020462;
        Mon, 28 Nov 2022 21:14:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=IoPRbkY/MlPR1tnHdwbhaAfp4JsczIk/OwmFzWgEIc8=;
 b=HjTawK3hPx24crttcHU+GUspX9NxPIbQMQKz8B3uAkXFvBpMrfirQQMgNHg62ExnHg19
 SBXoBm8ImKXcT03gQNgAoSLLXBqSuQLXZexPDohEoSEhta4uueedgJcrrx8DjO14mvxO
 wDSsco22P1bffDTjpVmjT4lddUVolNEZzt1+3yyDO3zfqKEprZq3JRfOah4x+oXoPnWh
 FX0UjsAw5FIbt971ppJDRp5vahiHZ9dc7DpgwZ8K0ChEBrrMA75lpGzH1cAdys4NJ4H2
 ylUDsprnMTslhsg2eSs8YBo/6jwAblFhCCod1qgZ+hN1gaRof+j4uonl7T3k5u7DITdk gw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3m3k6w9qw8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 21:14:16 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 28 Nov
 2022 21:14:14 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 28 Nov 2022 21:14:14 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 079553F7086;
        Mon, 28 Nov 2022 21:14:10 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>
Subject: [net-next PATCH V2 0/4] CN10KB MAC block support
Date:   Tue, 29 Nov 2022 10:44:05 +0530
Message-ID: <20221129051409.20034-1-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: mGrNWFAlgNSRbIZot3I0FBLbEX3z2fnP
X-Proofpoint-ORIG-GUID: mGrNWFAlgNSRbIZot3I0FBLbEX3z2fnP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_04,2022-11-28_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OcteonTx2's next gen platform the CN10KB has RPM_USX MAC which has a
different serdes when compared to RPM MAC. Though the underlying
HW is different, the CSR interface has been designed largely inline
with RPM MAC, with few exceptions though. So we are using the same
CGX driver for RPM_USX MAC as well and will have a different set of APIs
for RPM_USX where ever necessary.

The RPM and RPM_USX blocks support a different number of LMACS.
RPM_USX support 8 LMACS per MAC block whereas legacy RPM supports only 4
LMACS per MAC. with this RPM_USX support double the number of DMAC filters
and fifo size.

This patchset adds initial support for CN10KB's RPM_USX  MAC i.e
registering the driver and defining MAC operations (mac_ops). With these
changes PF and VF netdev packet path will work and PF and VF netdev drivers
are able to configure MAC features like pause frames,PFC and loopback etc.

Also implements FEC stats for CN10K Mac block RPM and CN10KB Mac block
RPM_USX and extends ethtool support for PF and VF drivers by defining
get_fec_stats API to display FEC stats.

Hariprasad Kelam (3):
  octeontx2-af: cn10kb: Add RPM_USX MAC support
  octeontx2-pf: ethtool: Implement get_fec_stats
  octeontx2-af: Add FEC stats for RPM/RPM_USX block

Rakesh Babu Saladi (1):
  octeontx2-af: Support variable number of lmacs

 .../net/ethernet/marvell/octeontx2/af/cgx.c   |  78 ++++--
 .../net/ethernet/marvell/octeontx2/af/cgx.h   |   9 +-
 .../marvell/octeontx2/af/lmac_common.h        |  15 +-
 .../net/ethernet/marvell/octeontx2/af/rpm.c   | 262 ++++++++++++++++--
 .../net/ethernet/marvell/octeontx2/af/rpm.h   |  36 ++-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  12 +-
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   |  49 +++-
 .../marvell/octeontx2/af/rvu_debugfs.c        |   2 +-
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  10 +-
 .../marvell/octeontx2/af/rvu_npc_hash.c       |   4 +-
 .../marvell/octeontx2/nic/otx2_ethtool.c      |  75 ++---
 11 files changed, 435 insertions(+), 117 deletions(-)

--
2.17.1
