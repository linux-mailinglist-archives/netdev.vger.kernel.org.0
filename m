Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7ABD61377
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 04:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfGGCH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 22:07:29 -0400
Received: from nwk-aaemail-lapp03.apple.com ([17.151.62.68]:60556 "EHLO
        nwk-aaemail-lapp03.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726869AbfGGCH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 22:07:29 -0400
X-Greylist: delayed 10444 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Jul 2019 22:07:28 EDT
Received: from pps.filterd (nwk-aaemail-lapp03.apple.com [127.0.0.1])
        by nwk-aaemail-lapp03.apple.com (8.16.0.27/8.16.0.27) with SMTP id x66NC7sd035713;
        Sat, 6 Jul 2019 16:13:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=sender : from : to :
 cc : subject : date : message-id : mime-version :
 content-transfer-encoding; s=20180706;
 bh=v+wS1MxN+8a13DGa6BHYG2Qedm+dLXoTWaM3ftIvFFQ=;
 b=YRMH2gjoBKJ1VvYFhDekd2Wv2MPbF+1e+A3P8FBdNHJh0RPraSS83OSosH/9/IY97Hsi
 nqX/SzaCv/7CqCEE7HJEMycmgvTmmBopBH/v8esC60amKMStZBblxiAfJlxQ7lOAqcyg
 IcHH3vgtzHKWNJHI69imHxIYqVlcI0zE72wAurCAC9fPTEJlsVDvOS8H5Ap8mEwS73WF
 ZU2jvqmtLOqRFHhdmvilAPQZu51/s+O/QHgU4FgR0KtKjfO5LU38fCHxHBxm1GohCA28
 Jw/W6/YG/llMpuyxXVeZF+WL6OJ3WjSNnlHZGLEGco2A6ENQ16a/8KZHbLQTwiwhhh9b RA== 
Received: from ma1-mtap-s03.corp.apple.com (ma1-mtap-s03.corp.apple.com [17.40.76.7])
        by nwk-aaemail-lapp03.apple.com with ESMTP id 2tjr63yg1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Sat, 06 Jul 2019 16:13:20 -0700
Received: from nwk-mmpp-sz12.apple.com
 (nwk-mmpp-sz12.apple.com [17.128.115.204]) by ma1-mtap-s03.corp.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPS id <0PU80074JTU7G440@ma1-mtap-s03.corp.apple.com>; Sat,
 06 Jul 2019 16:13:19 -0700 (PDT)
Received: from process_milters-daemon.nwk-mmpp-sz12.apple.com by
 nwk-mmpp-sz12.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) id <0PU800I00TIQKU00@nwk-mmpp-sz12.apple.com>; Sat,
 06 Jul 2019 16:13:19 -0700 (PDT)
X-Va-A: 
X-Va-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-Va-E-CD: 000aff906eecd1f9f6f9d54780f56300
X-Va-R-CD: 2de81153b9b67bcda99f349476cbc8e0
X-Va-CD: 0
X-Va-ID: a0c3e1dc-2a61-4df1-a8b7-0da114829b10
X-V-A:  
X-V-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-V-E-CD: 000aff906eecd1f9f6f9d54780f56300
X-V-R-CD: 2de81153b9b67bcda99f349476cbc8e0
X-V-CD: 0
X-V-ID: 52152e72-430e-4f9c-9c29-48606c50f15e
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,,
 definitions=2019-07-06_07:,, signatures=0
Received: from localhost ([17.234.28.206]) by nwk-mmpp-sz12.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPSA id <0PU800ADZTU6JG90@nwk-mmpp-sz12.apple.com>; Sat,
 06 Jul 2019 16:13:19 -0700 (PDT)
From:   Christoph Paasch <cpaasch@apple.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net] tcp: Reset bytes_acked and bytes_received when
 disconnecting
Date:   Sat, 06 Jul 2019 16:13:07 -0700
Message-id: <20190706231307.98483-1-cpaasch@apple.com>
X-Mailer: git-send-email 2.21.0
MIME-version: 1.0
Content-transfer-encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-06_07:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If an app is playing tricks to reuse a socket via tcp_disconnect(),
bytes_acked/received needs to be reset to 0. Otherwise tcp_info will
report the sum of the current and the old connection..

Cc: Eric Dumazet <edumazet@google.com>
Fixes: 0df48c26d841 ("tcp: add tcpi_bytes_acked to tcp_info")
Fixes: bdd1f9edacb5 ("tcp: add tcpi_bytes_received to tcp_info")
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
---
 net/ipv4/tcp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 7dc9ab84bb69..2eebd092c3c1 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2614,6 +2614,8 @@ int tcp_disconnect(struct sock *sk, int flags)
 	tcp_saved_syn_free(tp);
 	tp->compressed_ack = 0;
 	tp->bytes_sent = 0;
+	tp->bytes_acked = 0;
+	tp->bytes_received = 0;
 	tp->bytes_retrans = 0;
 	tp->duplicate_sack[0].start_seq = 0;
 	tp->duplicate_sack[0].end_seq = 0;
-- 
2.21.0

