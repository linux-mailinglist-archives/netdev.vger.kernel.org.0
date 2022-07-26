Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150135814E0
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 16:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbiGZONT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 10:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiGZONQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 10:13:16 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755FC6543
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 07:13:14 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26Q8pans019149;
        Tue, 26 Jul 2022 07:13:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=JE8Ik0IuHTiT9DucAY/CoDi+w7QkpSUFUH2SDtJkOLM=;
 b=OigzIvEXu0RtZikHRtaqO0MOkUQZ/WLNIMKYXnWeVslozKWDAGUAXJeVhxKQaiLmUP76
 t48zVSsdhzWtYkjSxDF0V9f3TDslYASGPffrVkl73kj+4I6Klr1HgoLQ7ianZx7zH/8Q
 zYmV/77f7Qo0iXBBP5U9jcyw/7kYnJe43CBL741yuP3VIORIbhc7fyZb0MqSsf8ozaNC
 Eg+iFsS2M8cdZUpNtqTtZMTa6DBSI1cECEG8v3vhS7Z5lMXNx8gGJmvkioTKn3FyhqRe
 pRvnxTWumkgOLQK4OIyefFT34HriWuxNZXOJJH/78ABvQWDzkVySWtxj5Zr+Hyve1i5v Pw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3hgggnabdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 07:13:01 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Jul
 2022 07:12:59 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 26 Jul 2022 07:12:59 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 29EE76267D8;
        Tue, 26 Jul 2022 07:11:23 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>
CC:     Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net v2 PATCH 0/5] Octeontx2 AF driver fixes for NPC
Date:   Tue, 26 Jul 2022 19:41:17 +0530
Message-ID: <1658844682-12913-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: Zeeyv7Dqal0MqNcn-dfLWi0IpwqLB8IW
X-Proofpoint-ORIG-GUID: Zeeyv7Dqal0MqNcn-dfLWi0IpwqLB8IW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_04,2022-07-26_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset includes AF driver fixes wrt packet parser NPC.
Following are the changes:

Patch 1: The parser nibble configuration must be same for
TX and RX interfaces and if not fix up is applied. This fixup was
applied only for default profile currently and it has been fixed
to apply for all profiles.
Patch 2: Firmware image may not be present all times in the kernel image
and default profile is used mostly hence suppress the warning.
Patch 3: Custom profiles may not extract DMAC into the match key
always. Hence fix the driver to allow profiles without DMAC extraction.
Patch 4: This patch fixes a corner case where NIXLF is detached but
without freeing its mcam entries which results in resource leak.
Patch 5: SMAC is overlapped with DMAC mistakenly while installing
rules based on SMAC. This patch fixes that.

v2 changes:
Added the space which was missing between commit hash
and ("octeontx2-af for patch 4.

Thanks,
Sundeep

Harman Kalra (1):
  octeontx2-af: suppress external profile loading warning

Stanislaw Kardach (1):
  octeontx2-af: Apply tx nibble fixup always

Subbaraya Sundeep (2):
  octeontx2-af: Fix mcam entry resource leak
  octeontx2-af: Fix key checking for source mac

Suman Ghosh (1):
  octeontx2-af: Allow mkex profiles without dmac.

 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |  1 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  6 ++
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  6 ++
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 15 +++-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 85 +++++++++++++++++-----
 5 files changed, 90 insertions(+), 23 deletions(-)

-- 
2.7.4

