Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 816D532C3DC
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354341AbhCDAIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:08:09 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12677 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355018AbhCCGRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 01:17:54 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Dr3cx6l7dzlRhs;
        Wed,  3 Mar 2021 14:14:57 +0800 (CST)
Received: from use12-sp2.huawei.com (10.67.189.174) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Wed, 3 Mar 2021 14:16:59 +0800
From:   Xiaoming Ni <nixiaoming@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <kiyin@tencent.com>,
        <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <sameo@linux.intel.com>, <linville@tuxdriver.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <mkl@pengutronix.de>,
        <stefan@datenfreihafen.org>, <matthieu.baerts@tessares.net>,
        <netdev@vger.kernel.org>
CC:     <nixiaoming@huawei.com>, <wangle6@huawei.com>,
        <xiaoqian9@huawei.com>
Subject: [PATCH 4/4] nfc: Avoid endless loops caused by repeated llcp_sock_connect()
Date:   Wed, 3 Mar 2021 14:16:54 +0800
Message-ID: <20210303061654.127666-5-nixiaoming@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303061654.127666-1-nixiaoming@huawei.com>
References: <20210303061654.127666-1-nixiaoming@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.189.174]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When sock_wait_state() returns -EINPROGRESS, "sk->sk_state" is
 LLCP_CONNECTING. In this case, llcp_sock_connect() is repeatedly invoked,
 nfc_llcp_sock_link() will add sk to local->connecting_sockets twice.
 sk->sk_node->next will point to itself, that will make an endless loop
 and hang-up the system.
To fix it, check whether sk->sk_state is LLCP_CONNECTING in
 llcp_sock_connect() to avoid repeated invoking.

fix CVE-2020-25673
Fixes: b4011239a08e ("NFC: llcp: Fix non blocking sockets connections")
Reported-by: "kiyin(尹亮)" <kiyin@tencent.com>
Link: https://www.openwall.com/lists/oss-security/2020/11/01/1
Cc: <stable@vger.kernel.org> #v3.11
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
---
 net/nfc/llcp_sock.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 59172614b249..a3b46f888803 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -673,6 +673,10 @@ static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
 		ret = -EISCONN;
 		goto error;
 	}
+	if (sk->sk_state == LLCP_CONNECTING) {
+		ret = -EINPROGRESS;
+		goto error;
+	}
 
 	dev = nfc_get_device(addr->dev_idx);
 	if (dev == NULL) {
-- 
2.27.0

