Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E0E2F2ACE
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 10:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389634AbhALJJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 04:09:14 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.162]:11224 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388941AbhALJJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 04:09:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1610442318;
        s=strato-dkim-0002; d=hartkopp.net;
        h=Message-Id:Date:Subject:Cc:To:From:From:Subject:Sender;
        bh=Y2hdyqEH9W0jOqo8WF9Mxe0UWTLLyiqI7gZPa3+rneA=;
        b=k4nMtEGE5qTCJNho5lQM1eA9eiKRmGNVD6piAeQY1Rtnwp79EHa2AE4pid5BZ0mes2
        aDI1RLUy4wQtKu7MhGIqq5yEdDjIp7esrag3WwvKHTGy11bZP2zxcyOrQhS0xDfdVzOU
        QCrV0KNMRzZtqwuYkg4GQXN9penVOw4mChvldHDSH45+4Q/opzbEZPiCDI/W9mFWDanC
        SDFbec37l29ABb/CfQ0NEil/y3vwHgRFqI0WTIImpQbWpYY8se/7nalUxrO2K3hFrYwY
        bPe4bdJNeA0BuDpdfvA3JBex9NLuE+tEgvicbVoH2q4GCT+By+9dSzEaxyKcuEzcCJL7
        IXJQ==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS0k+8CejudJywjsStM+A=="
X-RZG-CLASS-ID: mo00
Received: from silver.lan
        by smtp.strato.de (RZmta 47.12.1 SBL|AUTH)
        with ESMTPSA id k075acx0C95HKR6
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 12 Jan 2021 10:05:17 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     mkl@pengutronix.de, kuba@kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+057884e2f453e8afebc8@syzkaller.appspotmail.com
Subject: [PATCH] can: isotp: fix isotp_getname() leak
Date:   Tue, 12 Jan 2021 10:04:57 +0100
Message-Id: <20210112090457.11262-1-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initialize the sockaddr_can structure to prevent a data leak to user space.

Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
Reported-by: syzbot+057884e2f453e8afebc8@syzkaller.appspotmail.com
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 net/can/isotp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 7839c3b9e5be..3ef7f78e553b 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1153,10 +1153,11 @@ static int isotp_getname(struct socket *sock, struct sockaddr *uaddr, int peer)
 	struct isotp_sock *so = isotp_sk(sk);
 
 	if (peer)
 		return -EOPNOTSUPP;
 
+	memset(addr, 0, sizeof(*addr));
 	addr->can_family = AF_CAN;
 	addr->can_ifindex = so->ifindex;
 	addr->can_addr.tp.rx_id = so->rxid;
 	addr->can_addr.tp.tx_id = so->txid;
 
-- 
2.29.2

