Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9A72F24E4
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405329AbhALAZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390766AbhAKWsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 17:48:04 -0500
X-Greylist: delayed 1385 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 11 Jan 2021 14:47:23 PST
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0562C061786
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 14:47:23 -0800 (PST)
Received: from pps.filterd (m0122330.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10BMNfbI015016;
        Mon, 11 Jan 2021 22:24:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=jan2016.eng;
 bh=U6ScRs8gJ/mqbOrKcwH+l4+kJXmDfsU1g2ccT/Jl1xc=;
 b=llnXhZ0HyurOYS6s7ktdDk+gdcQuP8W8vXEsuZqQlPTpIOhoujLs4+WUoPHVejoKICsz
 2DdRbUlQmAC7XopgV8nSqxzfxQ4nY4ZgosksgXA5pZqc0TVPFMDMWosIoRIFl2zyECfc
 p1WcvOVQr0kW6zYb7d5TDbTYOd5QO+IA+MFEjrphhWR8UNbLFB9ysASgOPAr/FrylQFH
 OnoU56nSdIIAVQWjW0TnfnxuyJ/YH/2ScJRxzcWGeWHZOQZr/mBX9TA8TNpJ0KCMCqxq
 O3jcyE311OS8WfYUI31slwrtlEn586iefMgVcA5PzTC1Z1QYTWJEQ6ew41k2VzC7vb88 0Q== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 35y5ek0wea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 22:24:16 +0000
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.16.0.43/8.16.0.43) with SMTP id 10BMJoMq002704;
        Mon, 11 Jan 2021 17:24:15 -0500
Received: from email.msg.corp.akamai.com ([172.27.123.32])
        by prod-mail-ppoint1.akamai.com with ESMTP id 35y8q2vu4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 17:24:15 -0500
Received: from USMA1EX-CAS2.msg.corp.akamai.com (172.27.123.31) by
 usma1ex-dag3mb5.msg.corp.akamai.com (172.27.123.55) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Mon, 11 Jan 2021 17:24:14 -0500
Received: from bos-lhvedt.bos01.corp.akamai.com (172.28.223.201) by
 USMA1EX-CAS2.msg.corp.akamai.com (172.27.123.31) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Mon, 11 Jan 2021 17:24:14 -0500
Received: by bos-lhvedt.bos01.corp.akamai.com (Postfix, from userid 33863)
        id B18D316004F; Mon, 11 Jan 2021 17:24:14 -0500 (EST)
From:   Heath Caldwell <hcaldwel@akamai.com>
To:     <netdev@vger.kernel.org>
CC:     Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Josh Hunt <johunt@akamai.com>, Ji Li <jli@akamai.com>,
        Heath Caldwell <hcaldwel@akamai.com>
Subject: [PATCH net-next 3/4] tcp: consistently account for overhead in rcv_wscale calculation
Date:   Mon, 11 Jan 2021 17:24:10 -0500
Message-ID: <20210111222411.232916-4-hcaldwel@akamai.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210111222411.232916-1-hcaldwel@akamai.com>
References: <20210111222411.232916-1-hcaldwel@akamai.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_32:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101110124
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_32:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 impostorscore=0 mlxscore=0 suspectscore=0 mlxlogscore=973 bulkscore=0
 malwarescore=0 clxscore=1011 lowpriorityscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110125
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 184.51.33.18)
 smtp.mailfrom=hcaldwel@akamai.com smtp.helo=prod-mail-ppoint1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calculating the window scale to use for the advertised window for a
TCP connection, adjust the size values used to extend the maximum possible
window value so that overhead is properly accounted.  In other words:
convert the maximum value candidates from buffer size space into advertised
window space.

This adjustment keeps the scale of the maximum value consistent - that is,
keeps it in window space.

Without this adjustment, the window scale used could be larger than
necessary, reducing granularity for the advertised window.

Signed-off-by: Heath Caldwell <hcaldwel@akamai.com>
---
 net/ipv4/tcp_output.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index f322e798a351..1d2773cd02c8 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -240,8 +240,12 @@ void tcp_select_initial_window(const struct sock *sk, int __space, __u32 mss,
 	*rcv_wscale = 0;
 	if (wscale_ok) {
 		/* Set window scaling on max possible window */
-		space = max_t(u32, space, sock_net(sk)->ipv4.sysctl_tcp_rmem[2]);
-		space = max_t(u32, space, sysctl_rmem_max);
+		space = max_t(u32, space,
+		              tcp_win_from_space(
+		                      sk,
+		                      sock_net(sk)->ipv4.sysctl_tcp_rmem[2]));
+		space = max_t(u32, space,
+		              tcp_win_from_space(sk, sysctl_rmem_max));
 		space = min_t(u32, space, *window_clamp);
 		*rcv_wscale = clamp_t(int, ilog2(space) - 15,
 				      0, TCP_MAX_WSCALE);
-- 
2.28.0

