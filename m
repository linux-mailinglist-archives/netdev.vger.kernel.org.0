Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFD12F2B24
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 10:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392571AbhALJTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 04:19:46 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.170]:35325 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390629AbhALJTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 04:19:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1610443010;
        s=strato-dkim-0002; d=hartkopp.net;
        h=Message-Id:Date:Subject:Cc:To:From:From:Subject:Sender;
        bh=7pyP7lDPNTdyYupdnAeIGcGbSW38pPi0EFXIRuaqpWM=;
        b=M+z8MJxUPTlJOs1e3fOCXx8NZJLoWPR8oLynNpJ1HuNfvrCFcNwCCO3h+Nu5FoHn19
        rTxm5V//KPD6EwM3BnSeXjQY56kG1negx8b4K6j9ZesmgKfscGWKvjPHAPTbP3DcJ5SR
        /Mz15CkL2DVBhMVtGokY9JbDVF8qslMhFAD+kmfUFysrFjJDqcwYw0pUkDdP+DPZQ7JR
        F/U+8V4ffcE7E8f9Tzj+vuoJK71RSZKWAWGhupcWMCDB4IC0QnQupxbMMbwRyzGmdhwb
        chIyEtaKnL3xzVC61YUe83v906bbNoEGqSVZ6kifpzNqlxsC3Uu/U+16JGfI78Ca+DPk
        x4+w==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS0k+8CejudJywjsStM+A=="
X-RZG-CLASS-ID: mo00
Received: from silver.lan
        by smtp.strato.de (RZmta 47.12.1 SBL|AUTH)
        with ESMTPSA id k075acx0C9GnKUa
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 12 Jan 2021 10:16:49 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     mkl@pengutronix.de, kuba@kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+057884e2f453e8afebc8@syzkaller.appspotmail.com
Subject: [PATCH v2] can: isotp: fix isotp_getname() leak
Date:   Tue, 12 Jan 2021 10:16:43 +0100
Message-Id: <20210112091643.11789-1-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initialize the sockaddr_can structure to prevent a data leak to user space.

Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
Reported-by: syzbot+057884e2f453e8afebc8@syzkaller.appspotmail.com
Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
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

