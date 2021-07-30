Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE5973DB80A
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 13:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238672AbhG3Ltf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 07:49:35 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:13198 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230157AbhG3Ltd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 07:49:33 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16UBksAB025864;
        Fri, 30 Jul 2021 04:49:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=WAEhPIZOmplGc+XtmWxurmrYl2K9o7NOBEVJAaaF6nA=;
 b=N1Meh1mQ2RScb9KcYf5EyVfU/YCtc55EO2++IVNlIF2kTz/MPyxdDXDjUy/OlEtDlxMj
 zLgUJNjhVItz50KPTAZyCPy6MlAP6HhD2hIngvJhZbVcDWMstnm+xGCFh1PYEIkwyOzM
 proV5BuuF3YN40KGs3bDmS2a0nHeWwYpTNc+AqzA+Y8bpSXrfOZ2nm3qZgiY/xZXbFbL
 rHRKh0QSGppjcheAEoE3yXVZOtTFV4Cys37ns8A5UltXZnPOyEztWBxJ5QbJiCUq8rJX
 dgq40jzkc5pmi73VK97JZnHAeiCa6UISTN+wXNeqcUsSKbYtT7qAfAsb3GJvGEBpVF0E FQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3a4866sv3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 30 Jul 2021 04:49:22 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 30 Jul
 2021 04:49:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 30 Jul 2021 04:49:20 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id 52FE63F7050;
        Fri, 30 Jul 2021 04:49:19 -0700 (PDT)
From:   Sunil Goutham <sgoutham@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Sunil Goutham <sgoutham@marvell.com>
Subject: [net-next PATCH 0/2] cn10k: DWRR MTU and weights configuration
Date:   Fri, 30 Jul 2021 17:19:12 +0530
Message-ID: <1627645754-18131-1-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: eOp0xa0AqCejQu7-xMUHqtOLt9KA-hfE
X-Proofpoint-ORIG-GUID: eOp0xa0AqCejQu7-xMUHqtOLt9KA-hfE
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-30_05:2021-07-30,2021-07-30 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On OcteonTx2 DWRR quantum is directly configured into each of
the transmit scheduler queues. And PF/VF drivers were free to
config any value upto 2^24.

On CN10K, HW is modified, the quantum configuration at scheduler
queues is in terms of weight. And SW needs to setup a base DWRR MTU
at NIX_AF_DWRR_RPM_MTU / NIX_AF_DWRR_SDP_MTU. HW will do
'DWRR MTU * weight' to get the quantum.

This patch series addresses this HW change on CN10K silicons,
both admin function and PF/VF drivers are modified.

Also added support to program DWRR MTU via devlink params.

Sunil Goutham (2):
  octeontx2-af: cn10k: DWRR MTU configuration
  octeontx2-pf: cn10k: Config DWRR weight based on MTU

 drivers/net/ethernet/marvell/octeontx2/af/common.h |   5 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |   4 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   3 +
 .../ethernet/marvell/octeontx2/af/rvu_devlink.c    | 110 ++++++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 103 ++++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |   2 +
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c |   3 +-
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h |  14 +++
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  23 +++--
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   1 +
 10 files changed, 253 insertions(+), 15 deletions(-)

-- 
2.7.4

