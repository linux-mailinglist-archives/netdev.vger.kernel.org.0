Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5A92C8DB5
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 20:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729665AbgK3TJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 14:09:34 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63468 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726026AbgK3TJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 14:09:33 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AUJ4avh089405;
        Mon, 30 Nov 2020 14:08:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=92Q1vgbqp4ZQLKIS0fVsyjyRxXEJa4Fh4HAukYPHP58=;
 b=jG08u+uFaBYkQoUoMJn7VIRWfuX6XphxtxRPp9BujNnx9Fx2CfwdNXxBwZh4+Ut0J7Rt
 TH6OXWV5xvJ2225ndlUlxd5O6KksVSeWLXDa4J8ylJHDySIEjMc47adrnJlwQJqXstj0
 VnxyI9AgPN2zT/ZxYi1R7DVsA0x/3DjT+dhEqhVl2hYMabjgzfUlIXdK0mYuQZwpvc3w
 LGWrgAnu9aeatrgHuYnAI1qHyGYoumUXshQ8GF8QJJdRNRB2v0yZOzm5DsqK4bJAB9b0
 agqGHyn3bAw02dgP8gosu1b0LKhO5eMeRQDNUbFPnmpaj5U1DmtLQhuSmz7DJFJCv4Pj GA== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3555crahj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 14:08:47 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AUJ10qU002319;
        Mon, 30 Nov 2020 19:08:45 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01wdc.us.ibm.com with ESMTP id 353e68tgh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 19:08:45 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AUJ7UZC37814722
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 19:07:30 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A96D2805C;
        Mon, 30 Nov 2020 19:07:30 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1B462806A;
        Mon, 30 Nov 2020 19:07:28 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.4.131])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 30 Nov 2020 19:07:28 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     mpe@ellerman.id.au
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        cforno12@linux.ibm.com, ljp@linux.vnet.ibm.com,
        ricklind@linux.ibm.com, dnbanerg@us.ibm.com,
        drt@linux.vnet.ibm.com, brking@linux.vnet.ibm.com,
        sukadev@linux.vnet.ibm.com, tlfalcon@linux.ibm.com
Subject: [PATCH net v2 0/2] ibmvnic: Bug fixes for queue descriptor processing
Date:   Mon, 30 Nov 2020 13:07:22 -0600
Message-Id: <1606763244-28111-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_08:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 adultscore=0 phishscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 suspectscore=1 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300122
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series resolves a few issues in the ibmvnic driver's
RX buffer and TX completion processing. The first patch
includes memory barriers to synchronize queue descriptor
reads. The second patch fixes a memory leak that could
occur if the device returns a TX completion with an error
code in the descriptor, in which case the respective socket
buffer and other relevant data structures may not be freed
or updated properly.

v2: Provide more detailed comments explaining specifically what
    reads are being ordered, suggested by Michael Ellerman

Thomas Falcon (2):
  ibmvnic: Ensure that SCRQ entry reads are correctly ordered
  ibmvnic: Fix TX completion error handling

 drivers/net/ethernet/ibm/ibmvnic.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

-- 
1.8.3.1

