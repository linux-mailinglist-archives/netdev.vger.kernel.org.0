Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C89F57F3F6
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 10:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiGXIVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 04:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiGXIVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 04:21:31 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F4F11D
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 01:21:29 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26O30I99005354;
        Sun, 24 Jul 2022 01:21:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=2TFJgmTkleY7AjAo1uHI56a/LAegCORvD/pzLokBRXc=;
 b=Z/0fZH0fd+fsRu1/PKMb1x/EviHW2brDq8s6DhtumrORwrGBzklZiCZx4G05Etl1AiLl
 XtThzJcmzvb86KDOfvTou1yVr8PHBXxg5oZzrqF6L1321vfsuAsFQqGh+8SMZzYGjw15
 B+EQBh3/ohrLyPWSBelRXZboV5CDfMMtvxwQd9EEL69PPI/tERNgGiBBlAIUZCUBTwQe
 JZU4R3AUHOxP6IS7TMSl64DzR0z70qKSYnq81PJ0wPG69CbSWC+7FeIdf/MSEOmHGWrG
 2Jn13eMF2/cdFHj+uVF2ZEPA07ZbGMaWg4ULtm8cVej1l/4szg5Rpa9WHYI4cDBjvu2e sQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3hgebq2cgn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 24 Jul 2022 01:21:21 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 24 Jul
 2022 01:21:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 24 Jul 2022 01:21:20 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 590EB3F70CF;
        Sun, 24 Jul 2022 01:21:18 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>
CC:     Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net PATCH 0/2] Octeontx2 minor tc fixes
Date:   Sun, 24 Jul 2022 13:51:12 +0530
Message-ID: <1658650874-16459-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: fCoUaMS1XKXvP_rS5Xsy0LPZy43_KLWy
X-Proofpoint-ORIG-GUID: fCoUaMS1XKXvP_rS5Xsy0LPZy43_KLWy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-23_02,2022-07-21_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set fixes two problems found in tc code 
wrt to ratelimiting and when installing UDP/TCP filters.

Patch 1: CN10K has different register format compared to
CN9xx hence fixes that.
Patch 2: Check flow mask also before installing a src/dst
port filter, otherwise installing for one port installs for other one too. 

Thanks,
Sundeep


Subbaraya Sundeep (1):
  octeontx2-pf: Fix UDP/TCP src and dst port tc filters

Sunil Goutham (1):
  octeontx2-pf: cn10k: Fix egress ratelimit configuration

 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   | 106 ++++++++++++++-------
 1 file changed, 73 insertions(+), 33 deletions(-)

-- 
2.7.4

