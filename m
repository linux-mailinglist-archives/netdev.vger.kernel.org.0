Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 691E36B736C
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 11:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjCMKIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 06:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbjCMKIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 06:08:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA68428204;
        Mon, 13 Mar 2023 03:08:48 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32D8tmU0022461;
        Mon, 13 Mar 2023 10:08:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=kv7GwSq+UojBA2xKj44PdjW0grBqdHksq/nECgQz3zo=;
 b=n+Chz6h7JE9/ZEqPyybXonXA8f/bR6aWvIJE9n+mJDQGqhfaNkTv4JyQGWbbpDVv4SYL
 E16I+4Aq2uCf7jteUMT+A68HpIDCuCJbHqgbPe4Wxvwdj/2Zf48DBhbJZHwV5QhoMTmU
 DZ1N26G+GPtx0HDZsEaitJUlb7+pbfZyK4ePq6tomVkcwLf0pO0jy07vHoP786DinWOV
 aU23JxJGfNGlAS9SQ1kWO/CwQKKmTMCybst5KtdiZlLZDegAgOcYH/NIu6lI5J8ac3lG
 pFFQNxgCvPHAiMFIwwwd8yGFrd9kSCJ5baNWNK9+WCP2SDgH+yasoj6ROl8d8kWaEmOd 8g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p93et95w3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Mar 2023 10:08:45 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32D7PqHZ008423;
        Mon, 13 Mar 2023 10:08:44 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p93et95ux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Mar 2023 10:08:44 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32CIO4mQ017628;
        Mon, 13 Mar 2023 10:08:42 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3p8h96jf5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Mar 2023 10:08:42 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32DA8cqP30212558
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Mar 2023 10:08:38 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB6C5201DB;
        Mon, 13 Mar 2023 10:08:38 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD9E9201DD;
        Mon, 13 Mar 2023 10:08:34 +0000 (GMT)
Received: from MBP-von-Wenjia.fritz.box.com (unknown [9.163.87.100])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 13 Mar 2023 10:08:34 +0000 (GMT)
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
Subject: [PATCH net 0/2] net/smc: Fixes 2023-03-01
Date:   Mon, 13 Mar 2023 11:08:27 +0100
Message-Id: <20230313100829.13136-1-wenjia@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FNJLhsU4IBCWeh3asV8dAGAJo9G1PzHz
X-Proofpoint-ORIG-GUID: LJi-8tCT0KGSWbisyPbKolItouLu9p8d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-13_02,2023-03-10_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxscore=0 spamscore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=972 bulkscore=0 impostorscore=0
 clxscore=1015 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2303130082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 1st patch solves the problem that CLC message initialization was
not properly reversed in error handling path. And the 2nd one fixes
the possible deadlock triggered by cancel_delayed_work_sync().

Stefan Raspl (1):
  net/smc: Fix device de-init sequence

Wenjia Zhang (1):
  net/smc: fix deadlock triggered by cancel_delayed_work_syn()

 net/smc/af_smc.c   | 1 +
 net/smc/smc_core.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

-- 
2.37.2

