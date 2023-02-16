Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 101F1699233
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 11:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjBPKuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 05:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjBPKuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 05:50:25 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C2B22029;
        Thu, 16 Feb 2023 02:50:00 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G8Fsdv029192;
        Thu, 16 Feb 2023 10:49:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=I5oeXiLLxeB9Q7/euCAHFLJJkPxTOkk5q/Htp3r3aF4=;
 b=CzCPYhMbOz/Z3dhYLZHEYkfU0e0E23+3BGzNercjc/oLA9LQ/3N5onkGQtP5unrOxOIz
 +7cHQF+w0I1LhNhA0epA+7jcSDSvF2HajqPWi5cuWSXk4dGka3qBTy0aUQhPMdF1+O7S
 ZbGMCFvazAbgyl+WTb6M0UtYuXC1Y5gIOSmD9gGopmyG0lIuh4or65y7s5FPI61L00hv
 iJoawwtfUrZo8BwATNDxTUU5ELky8gAnRzQwEPJeNqomZmAwLA3j5C1eaUO5PBMnrvrl
 D+PoGMRwBj5ioeKrnnNHYlEuWQeGkiNihQfrMDm32SabK8V9iasPrKx7GwIbLS4bMMEn 3Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np2wa2ufe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 10:49:46 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31GAn0Hi032425;
        Thu, 16 Feb 2023 10:49:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f8f0rs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 10:49:45 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31GAnjcb025701;
        Thu, 16 Feb 2023 10:49:45 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3np1f8f0rf-1;
        Thu, 16 Feb 2023 10:49:45 +0000
From:   Alok Tiwari <alok.a.tiwari@oracle.com>
To:     netdev@vger.kernel.org
Cc:     alok.a.tiwari@oracle.com, darren.kenny@oracle.com,
        linux-kernel@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        simon.horman@corigine.com, keescook@chromium.org
Subject: [PATCH] net: sched: sch: null pointer dereference in htb_offload_move_qdisc()
Date:   Thu, 16 Feb 2023 02:49:40 -0800
Message-Id: <20230216104939.3553390-1-alok.a.tiwari@oracle.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_07,2023-02-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302160091
X-Proofpoint-GUID: Q7QcYSJlSWv01Pr-sPBFvqylga6ZZ4ot
X-Proofpoint-ORIG-GUID: Q7QcYSJlSWv01Pr-sPBFvqylga6ZZ4ot
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A possible case of null pointer dereference detected by static analyzer
htb_destroy_class_offload() is calling htb_find() which can return NULL value
for invalid class id, moved_cl=htb_find(classid, sch);
in that case it should not pass 'moved_cl' to htb_offload_move_qdisc()
if 'moved_cl' is NULL pointer return -EINVAL.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
---
 net/sched/sch_htb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 92f2975b6a82..5a96d9ea3221 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1601,6 +1601,8 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
 		u32 classid = TC_H_MAJ(sch->handle) |
 			      TC_H_MIN(offload_opt.classid);
 		struct htb_class *moved_cl = htb_find(classid, sch);
+		if (WARN_ON_ONCE(!moved_cl))
+			return -EINVAL;
 
 		htb_offload_move_qdisc(sch, moved_cl, cl, destroying);
 	}
-- 
2.39.1

