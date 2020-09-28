Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3EA27A520
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 03:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgI1BNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 21:13:33 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45634 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726406AbgI1BNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 21:13:33 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08S10Pci068257
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 21:13:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=JwmzTrvazjjcIBZX5xtcvdvoiL/61MtuwUpk/xhR7aY=;
 b=TW4sdV1qPN9bYT+02fZOwgSI0dcEuFmw96RdzZnms+ILR8Zjc6nFBaELKulB1ZaMCYf/
 TEU/aueut2a41NKZxPJSY6BgnMtJwAa/O2izsxYDRKqRBEdOFqjUJggHbpgYxOuXVeN+
 0tmF8A5LneBNiU3x5H8w+nP1eUv7jcRfQmGyOAMTzEQizMHbq+VOKR9jYbuftpd/jYvJ
 /IjURdUGBpesDZ5d1/jof1rcuOib/uMuJ472SEyf0pdYhv0BDr2M9H2ekInun6hX/K1I
 YAqBN0oQsmO/POIw5xFdiJLp/DdRSFpRYAW48tPwbJ4Gkgud0R8MJxyJv8oJk+AVHgQG 1w== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33u5ahrt7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 21:13:32 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08S16nK8030984
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 01:13:31 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01wdc.us.ibm.com with ESMTP id 33sw98pjyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 01:13:31 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08S1DV7t43450718
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 01:13:31 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 176CCAC062;
        Mon, 28 Sep 2020 01:13:31 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B045AAC05E;
        Mon, 28 Sep 2020 01:13:30 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.151.55])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 28 Sep 2020 01:13:30 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com,
        Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net-next 0/5] ibmvnic: refactor some send/handle functions
Date:   Sun, 27 Sep 2020 20:13:25 -0500
Message-Id: <20200928011330.79774-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-27_18:2020-09-24,2020-09-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 clxscore=1015 mlxscore=0 impostorscore=0 spamscore=0 mlxlogscore=619
 lowpriorityscore=0 malwarescore=0 suspectscore=1 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009280000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series rename and factor some send crq request functions.
The new naming aligns better with handle* functions such that it make
the code easier to read and search by new contributors.

Lijun Pan (5):
  ibmvnic: rename send_cap_queries to send_query_cap
  ibmvnic: rename ibmvnic_send_req_caps to send_request_cap
  ibmvnic: rename send_map_query to send_query_map
  ibmvnic: create send_query_ip_offload
  ibmvnic: create send_control_ip_offload

 drivers/net/ethernet/ibm/ibmvnic.c | 222 ++++++++++++++++-------------
 1 file changed, 119 insertions(+), 103 deletions(-)

-- 
2.23.0

