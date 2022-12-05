Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F84642F8C
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 19:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiLESBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 13:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbiLESB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 13:01:28 -0500
X-Greylist: delayed 121 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 05 Dec 2022 10:01:27 PST
Received: from mx6.didiglobal.com (mx6.didiglobal.com [111.202.70.123])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 49C011AF35
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 10:01:26 -0800 (PST)
Received: from mail.didiglobal.com (unknown [10.79.65.15])
        by mx6.didiglobal.com (Maildata Gateway V2.8) with ESMTPS id 356D2110411001;
        Tue,  6 Dec 2022 01:59:23 +0800 (CST)
Received: from zwp-5820-Tower (10.79.65.102) by
 ZJY02-ACTMBX-05.didichuxing.com (10.79.65.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 6 Dec 2022 01:59:22 +0800
Date:   Tue, 6 Dec 2022 01:59:16 +0800
X-MD-Sfrom: zhangweiping@didiglobal.com
X-MD-SrcIP: 10.79.65.15
From:   Weiping Zhang <zhangweiping@didiglobal.com>
To:     <edumazet@google.com>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <zwp10758@gmail.com>
Subject: [RFC PATCH] tcp: correct srtt and mdev_us calculation
Message-ID: <Y44xdN3zH4f+BZCD@zwp-5820-Tower>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [10.79.65.102]
X-ClientProxiedBy: ZJY03-PUBMBX-01.didichuxing.com (10.79.71.12) To
 ZJY02-ACTMBX-05.didichuxing.com (10.79.65.15)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From the comments we can see that, rtt = 7/8 rtt + 1/8 new,
but there is an mistake,

m -= (srtt >> 3);
srtt += m;

explain:
m -= (srtt >> 3); //use t stands for new m
t = m - srtt/8;

srtt = srtt + t
= srtt + m - srtt/8
= srtt 7/8 + m

Test code:

 #include<stdio.h>

 #define u32 unsigned int

static void test_old(u32 srtt, long mrtt_us)
{
	long m = mrtt_us;
	u32 old = srtt;

	m -= (srtt >> 3);
	srtt += m;

	printf("%s old_srtt: %u mrtt_us: %ld new_srtt: %u\n", __func__,  old, mrtt_us, srtt);
}

static void test_new(u32 srtt, long mrtt_us)
{
	long m = mrtt_us;
	u32 old = srtt;

	m = ((m - srtt) >> 3);
	srtt += m;

	printf("%s old_srtt: %u mrtt_us: %ld new_srtt: %u\n", __func__,  old, mrtt_us, srtt);
}

int main(int argc, char **argv)
{
	u32 srtt = 100;
	long mrtt_us = 90;

	test_old(srtt, mrtt_us);
	test_new(srtt, mrtt_us);

	return 0;
}

./a.out
test_old old_srtt: 100 mrtt_us: 90 new_srtt: 178
test_new old_srtt: 100 mrtt_us: 90 new_srtt: 98

Signed-off-by: Weiping Zhang <zhangweiping@didiglobal.com>
---
 net/ipv4/tcp_input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 0640453fce54..0242bb31e1ce 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -848,7 +848,7 @@ static void tcp_rtt_estimator(struct sock *sk, long mrtt_us)
 	 * that VJ failed to avoid. 8)
 	 */
 	if (srtt != 0) {
-		m -= (srtt >> 3);	/* m is now error in rtt est */
+		m = (m - srtt >> 3);	/* m is now error in rtt est */
 		srtt += m;		/* rtt = 7/8 rtt + 1/8 new */
 		if (m < 0) {
 			m = -m;		/* m is now abs(error) */
@@ -864,7 +864,7 @@ static void tcp_rtt_estimator(struct sock *sk, long mrtt_us)
 			if (m > 0)
 				m >>= 3;
 		} else {
-			m -= (tp->mdev_us >> 2);   /* similar update on mdev */
+			m = (m - tp->mdev_us >> 2);   /* similar update on mdev */
 		}
 		tp->mdev_us += m;		/* mdev = 3/4 mdev + 1/4 new */
 		if (tp->mdev_us > tp->mdev_max_us) {
-- 
2.34.1

