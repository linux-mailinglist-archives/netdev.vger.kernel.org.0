Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023322F24EF
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405354AbhALAZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390909AbhAKXCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 18:02:55 -0500
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2552C061794
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 15:02:14 -0800 (PST)
Received: from pps.filterd (m0122333.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10BMNTdv010317;
        Mon, 11 Jan 2021 22:24:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=jan2016.eng;
 bh=F5LlgCMjwczZgbU7qrlxzsFYIQpXEDTyXXIv0cxtPfU=;
 b=g29LUTCxq8Hkr3OWb41SBO9//XaBMb2kU0xJJX1ghlvcX0E1T6kN9RgQE5RyyDByQGwB
 PS9ewGSeGIH2atw+57G7qDgum9IGcGLGyY9HV1HglywiveYjxdHbq+z7icxhtyAjia+4
 9Oc61gfcRMx86N6igmrUxFV87pG08y36HqM9eRgnYwKe80mlZh/FJLBzPsWt+pYFmb01
 4+xkmBQvPcDScF8/ZY2hWtTX/Ld5lv123o6cGT0Mvex2wQHLawFYpKzEknoE6lqwxhhT
 eB/6gl+umBFj3asLIv5vLh36RXyj7Tv3/FJtO0lXUdVZIwEImPB+Rd2Y88DsnNWuUOsR WQ== 
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 35y5m4t82k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 22:24:16 +0000
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
        by prod-mail-ppoint5.akamai.com (8.16.0.43/8.16.0.43) with SMTP id 10BMJeKm013411;
        Mon, 11 Jan 2021 14:24:15 -0800
Received: from email.msg.corp.akamai.com ([172.27.123.53])
        by prod-mail-ppoint5.akamai.com with ESMTP id 35ybbe4hpn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 14:24:15 -0800
Received: from USMA1EX-CAS2.msg.corp.akamai.com (172.27.123.31) by
 usma1ex-dag3mb4.msg.corp.akamai.com (172.27.123.56) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Mon, 11 Jan 2021 17:24:14 -0500
Received: from bos-lhvedt.bos01.corp.akamai.com (172.28.223.201) by
 USMA1EX-CAS2.msg.corp.akamai.com (172.27.123.31) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Mon, 11 Jan 2021 17:24:14 -0500
Received: by bos-lhvedt.bos01.corp.akamai.com (Postfix, from userid 33863)
        id AA6DF15F503; Mon, 11 Jan 2021 17:24:14 -0500 (EST)
From:   Heath Caldwell <hcaldwel@akamai.com>
To:     <netdev@vger.kernel.org>
CC:     Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Josh Hunt <johunt@akamai.com>, Ji Li <jli@akamai.com>,
        Heath Caldwell <hcaldwel@akamai.com>
Subject: [PATCH net-next 0/4] Fix receive window restriction
Date:   Mon, 11 Jan 2021 17:24:07 -0500
Message-ID: <20210111222411.232916-1-hcaldwel@akamai.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_32:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=664 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101110124
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_32:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 clxscore=1015
 phishscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=612 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101110125
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 184.51.33.60)
 smtp.mailfrom=hcaldwel@akamai.com smtp.helo=prod-mail-ppoint5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series addresses bugs in the calculations for receive buffer
restriction and the TCP window scale value and removes a limit on the
initially advertised receive window for TCP connections.

These changes make the receive buffer size and window scale calculations
more consistent and facilitate research and use cases which could benefit
from more direct and consistent control over the receive buffer and TCP
receive window.

Heath Caldwell (4):
  net: account for overhead when restricting SO_RCVBUF
  net: tcp: consistently account for overhead for SO_RCVBUF for TCP
  tcp: consistently account for overhead in rcv_wscale calculation
  tcp: remove limit on initial receive window

 include/net/tcp.h     | 17 +++++++++
 net/core/sock.c       | 89 ++++++++++++++++++++++++++++++++-----------
 net/ipv4/tcp_output.c | 10 +++--
 3 files changed, 90 insertions(+), 26 deletions(-)


base-commit: 73b7a6047971aa6ce4a70fc4901964d14f077171
-- 
2.28.0

