Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0186B7375
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 11:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjCMKK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 06:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjCMKKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 06:10:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB81859425;
        Mon, 13 Mar 2023 03:10:53 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32D8cBWt007431;
        Mon, 13 Mar 2023 10:10:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=yIpyKidNzUrsMfRRiAsb3QCwAL7DNwZMIsufom65Xq0=;
 b=PZQ+Q1ekO1/Pbt42WSKxwHaX6maTVS6cl7yYqaYggfQJQJ6LgZEH0KEhHMjoKVPejkjn
 yIYFtHTFtoKd7qozFh4hrN2HO3Pm2RYhnNlvvt7H31QB3eo9m21En6ypeppaAMcajsjY
 uYnLi78Q/Yc9UNkpqF27t9YURS/4GeOqRtWHYVhBNCHlCxRBWhEasioOvF5Pk+1D3T4Y
 spoS2zPajz0Qt4ftsVaiDjod0JPEw3uI3/mVXYYDmHbJtMv7/n36ELjkym+ALADFtZGe
 xM3TvlN/z3H7pcUmmPLgj6FAN1fXSMT/ddzCrOjxBtXdtbxphL4w/qRWpbwUTHRxxZ7n hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p93t1h4sr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Mar 2023 10:10:49 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32D8FePE029492;
        Mon, 13 Mar 2023 10:10:49 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p93t1h4rw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Mar 2023 10:10:48 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32D3BDjk028730;
        Mon, 13 Mar 2023 10:10:46 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3p8h96k5js-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Mar 2023 10:10:44 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32DAAf4p2490964
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Mar 2023 10:10:41 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 358EE2022D;
        Mon, 13 Mar 2023 10:10:41 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46B8620229;
        Mon, 13 Mar 2023 10:10:37 +0000 (GMT)
Received: from MBP-von-Wenjia.fritz.box.com (unknown [9.163.87.100])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 13 Mar 2023 10:10:36 +0000 (GMT)
From:   Wenjia Zhang <wenjia@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jan Karcher <jaka@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>
Subject: [PATCH net-next 0/2] smc: Updates 2023-03-01
Date:   Mon, 13 Mar 2023 11:10:30 +0100
Message-Id: <20230313101032.13180-1-wenjia@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7lhaiegyHoRflJyjCbX2ng4tw4J8zNN_
X-Proofpoint-ORIG-GUID: -YiyoWtLFyna92yqBPmldULb5I92u8Vh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-13_02,2023-03-10_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 bulkscore=0 clxscore=1015 mlxscore=0 phishscore=0
 spamscore=0 suspectscore=0 mlxlogscore=641 impostorscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303130082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 1st patch is to make implements later do not need to adhere to a
specific SEID format. The 2nd patch does some cleanup.

Stefan Raspl (2):
  net/smc: Introduce explicit check for v2 support
  net/ism: Remove extra include

 drivers/s390/net/ism_drv.c | 8 +++++++-
 include/net/smc.h          | 1 +
 net/smc/smc_ism.c          | 2 +-
 3 files changed, 9 insertions(+), 2 deletions(-)

-- 
2.37.2

