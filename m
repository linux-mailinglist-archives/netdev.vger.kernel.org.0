Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98CAD6AC768
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 17:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbjCFQNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 11:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbjCFQNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 11:13:02 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9639359E5B
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 08:09:20 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3269A2JN026225;
        Mon, 6 Mar 2023 08:07:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=MkMaK5JNRlRIJnoZBtjnaGhZJE9UOy4EUGGkLsVNbc0=;
 b=jeX2ud2u1z6lfjxPl6V+fqXDLgmUj11Xvh07r64EyGJlMMJkwDApuDKYw4wm7iyK7VFX
 iR1ewbKcMQsDY1fu8r+OFBVt5QEwywUw8hzkrc84FCPwaU72sOJabt0GDgEua/sRuL8s
 VjTFbmTb6t0FcdsMxa9VK6vl+Ejph70XeorZPBk/5UXsl1oUrA5g5ietsXQVUSvBXoIZ
 7pvptx77Y3dFJbrRg0wKtPPhT2lAwVmR0eMSkd7a6ywPJQuW3xqHs2R/Os5cYOHXX09k
 S1jukY51NEtYoWoXOZR5r4tGIJeqA1NdaAAna6PZcZEVN+vIi/3EDIb/SxhgNkiGWlFO LQ== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3p44d4aqgj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 06 Mar 2023 08:07:48 -0800
Received: from devvm1736.cln0.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server id
 15.1.2507.17; Mon, 6 Mar 2023 08:07:45 -0800
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "Eric Dumazet" <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>
CC:     Vadim Fedorenko <vadfed@meta.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        <netdev@vger.kernel.org>
Subject: [PATCH net-next] net-timestamp: extend SOF_TIMESTAMPING_OPT_ID to HW timestamps
Date:   Mon, 6 Mar 2023 08:07:38 -0800
Message-ID: <20230306160738.4116342-1-vadfed@meta.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c085:108::4]
X-Proofpoint-GUID: eEmplpGVegA-WTRxu_0GKrChttlcROAr
X-Proofpoint-ORIG-GUID: eEmplpGVegA-WTRxu_0GKrChttlcROAr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_09,2023-03-06_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the feature was added it was enabled for SW timestamps only but
with current hardware the same out-of-order timestamps can be seen.
Let's expand the area for the feature to all types of timestamps.

Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
---
 net/ipv4/ip_output.c  | 2 +-
 net/ipv6/ip6_output.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 4e4e308c3230..e7bef36ce26f 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -990,7 +990,7 @@ static int __ip_append_data(struct sock *sk,
 	mtu = cork->gso_size ? IP_MAX_MTU : cork->fragsize;
 	paged = !!cork->gso_size;
 
-	if (cork->tx_flags & SKBTX_ANY_SW_TSTAMP &&
+	if (cork->tx_flags & SKBTX_ANY_TSTAMP &&
 	    sk->sk_tsflags & SOF_TIMESTAMPING_OPT_ID)
 		tskey = atomic_inc_return(&sk->sk_tskey) - 1;
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index c314fdde0097..4ce3f9d3bc8a 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1500,7 +1500,7 @@ static int __ip6_append_data(struct sock *sk,
 	mtu = cork->gso_size ? IP6_MAX_MTU : cork->fragsize;
 	orig_mtu = mtu;
 
-	if (cork->tx_flags & SKBTX_ANY_SW_TSTAMP &&
+	if (cork->tx_flags & SKBTX_ANY_TSTAMP &&
 	    sk->sk_tsflags & SOF_TIMESTAMPING_OPT_ID)
 		tskey = atomic_inc_return(&sk->sk_tskey) - 1;
 
-- 
2.30.2

