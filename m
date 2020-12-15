Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E09D02DA9E0
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 10:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbgLOJOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 04:14:44 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40862 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727536AbgLOJOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 04:14:23 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BF948iN184556;
        Tue, 15 Dec 2020 04:13:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=TfUhrMamW9R81qMcKj99e69AFR+nMhxQPxemF7uclbo=;
 b=sPWqU73Y3+QZJQ2vTu4UOxFiTSCXrS2dIuRQeofay3wYTYdR0Kj/MRZnlSH9LqbJG3nE
 j6VG9BcLodFVV+XHbQtRpidZyDqjzF0cHj3fawevAxIVRZI4jSwxQCXYsgmAjqR2s2nJ
 Aq+YQO8rv2eec830O1/PnryX+L4IVEizj0AVVMIuH9wAYGKfRXFRYUoo/v8ynfPnp0qu
 juVH291LxYFkrPofX45DJz/S5r8XDewxryivDFtHJ6CHJwTUjQpeKpgKS5hgkwmMTxps
 LvvcjllLLQSQv8giDxTIo+5GhaDw/FS9cyRuvO+7jGU/aSyrsAJuVEkJz1BE14H0fJio rA== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35eseg1tt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Dec 2020 04:13:40 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BF9D0KA026408;
        Tue, 15 Dec 2020 09:13:38 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 35cng8chu7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Dec 2020 09:13:38 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BF9B5Ch29950410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Dec 2020 09:11:05 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7317452057;
        Tue, 15 Dec 2020 09:11:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 283515204F;
        Tue, 15 Dec 2020 09:11:05 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next 0/1] net/smc: fix access to parent of an ib device
Date:   Tue, 15 Dec 2020 10:10:57 +0100
Message-Id: <20201215091058.49354-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-15_04:2020-12-11,2020-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 adultscore=0 mlxscore=0 suspectscore=0 clxscore=1015
 phishscore=0 spamscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=861
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012150059
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please apply the following patch for smc to netdev's net-next tree.

The patch fixes an access to the parent of an ib device which might be NULL.

I am sending this fix to net-next because the fixed code is still in this
tree only.

Karsten Graul (1):
  net/smc: fix access to parent of an ib device

 net/smc/smc_ib.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

-- 
2.17.1

