Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFCD1804FB
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 18:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgCJRiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 13:38:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62956 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726683AbgCJRiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 13:38:12 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02AHZ6Sv190584
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 13:38:11 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yp8ycfpxa-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 13:38:11 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 10 Mar 2020 17:38:09 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 10 Mar 2020 17:38:05 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02AHc4P931523170
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Mar 2020 17:38:04 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28AEFAE051;
        Tue, 10 Mar 2020 17:38:04 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DAA9EAE055;
        Tue, 10 Mar 2020 17:38:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 10 Mar 2020 17:38:03 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 0/3] s390/qeth: fixes 2020-03-10
Date:   Tue, 10 Mar 2020 18:38:00 +0100
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 20031017-0020-0000-0000-000003B26814
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031017-0021-0000-0000-0000220AB504
Message-Id: <20200310173803.91602-1-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-10_12:2020-03-10,2020-03-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 priorityscore=1501 clxscore=1015 spamscore=0 mlxlogscore=843
 impostorscore=0 lowpriorityscore=0 suspectscore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003100106
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

please apply the following patch series for qeth to netdev's net tree.

This fixes three minor issues:
1) a setup parameter gets cleared unnecessarily when the HW config
   changes,
2) insufficient error handling when initially filling the RX ring, and
3) a rarely used worker that needs to be cancelled during tear down.

Thanks,
Julian

Julian Wiedmann (3):
  s390/qeth: don't reset default_out_queue
  s390/qeth: handle error when backing RX buffer
  s390/qeth: cancel RX reclaim work earlier

 drivers/s390/net/qeth_core_main.c | 15 +++++++++------
 drivers/s390/net/qeth_l2_main.c   |  1 +
 drivers/s390/net/qeth_l3_main.c   |  1 +
 3 files changed, 11 insertions(+), 6 deletions(-)

-- 
2.17.1

