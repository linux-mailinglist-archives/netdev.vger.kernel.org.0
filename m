Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0094F4AEAD7
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 08:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbiBIHP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 02:15:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235078AbiBIHPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 02:15:24 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8D0C05CB81;
        Tue,  8 Feb 2022 23:15:27 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 219278S8004012;
        Tue, 8 Feb 2022 23:15:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=5NBzfbLthbGQBQEeu8E4JFnQ13Sb0ASpbjH7FFkk8CQ=;
 b=aLrT4q2sXBjYUO75sFql4v9XjTFfn68PtvS+QSMdGIt00xI3a0ahAXew7AZ9Y/UeHSo3
 saOp9c2Udk+7EFBBkm/Ks7OFE5/ce2zoeoc6FhGucj+i0H81/6tO1lb7UDuGw6se3Lvh
 d2nzBfUGxs/KeQhrv+AeoFvhdkkqJk9/ABXePZmSEfKMym3xehrZNRUKZoGpFUbtWTIT
 RJD5+xm7pYMwYj3uXiWGPu03ggZi2MSejmDIuyKcz5KV0XL8tNOFBQ3Xj3gtnson5tUv
 PUaRvqkxAgOtXcKgBalVw7jKP+nSrC/7kvAgi0fxgtAd8vUSWcfMAe8XwzbKJrPkl4U9 sw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3e44hth16b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 23:15:25 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Feb
 2022 23:15:23 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 8 Feb 2022 23:15:23 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id A72CA3F706B;
        Tue,  8 Feb 2022 23:15:20 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net-next PATCH V2 0/4] Priority flow control support for RVU netdev
Date:   Wed, 9 Feb 2022 12:45:15 +0530
Message-ID: <20220209071519.10403-1-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: bbYJExX89RzKHCU2qEporaW9Snalb7rA
X-Proofpoint-ORIG-GUID: bbYJExX89RzKHCU2qEporaW9Snalb7rA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-09_03,2022-02-07_02,2021-12-02_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In network congestion, instead of pausing all traffic on link
PFC allows user to selectively pause traffic according to its
class. This series of patches add support of PFC for RVU netdev
drivers.

Patch1 adds support to disable pause frames by default as
with PFC user can enable either PFC or 802.3 pause frames.
Patch2&3 adds resource management support for flow control
and configures necessary registers for PFC.
Patch4 adds dcb ops registration for netdev drivers.

V2 changes:
Fix compilation error by exporting required symbols 'otx2_config_pause_frm'

Hariprasad Kelam (3):
  octeontx2-af: Don't enable Pause frames by default
  octeontx2-af: Flow control resource management
  octeontx2-pf: PFC config support with DCBx

Sunil Kumar Kori (1):
  octeontx2-af: Priority flow control configuration support

 .../net/ethernet/marvell/octeontx2/af/cgx.c   | 247 +++++++++++++-----
 .../net/ethernet/marvell/octeontx2/af/cgx.h   |  13 +
 .../marvell/octeontx2/af/lmac_common.h        |  10 +
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  19 ++
 .../net/ethernet/marvell/octeontx2/af/rpm.c   | 223 ++++++++++++----
 .../net/ethernet/marvell/octeontx2/af/rpm.h   |  30 +++
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   3 +
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   | 117 ++++++++-
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  16 +-
 .../ethernet/marvell/octeontx2/nic/Makefile   |   3 +
 .../marvell/octeontx2/nic/otx2_common.c       |  18 +-
 .../marvell/octeontx2/nic/otx2_common.h       |  12 +
 .../marvell/octeontx2/nic/otx2_dcbnl.c        | 170 ++++++++++++
 .../marvell/octeontx2/nic/otx2_flows.c        |  50 +++-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  26 +-
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |  24 +-
 16 files changed, 836 insertions(+), 145 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c

--
2.17.1
