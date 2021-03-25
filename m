Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F160B3487A3
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 04:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbhCYDvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 23:51:37 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:14868 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhCYDv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 23:51:28 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F5WLs2Lt0z9sjR;
        Thu, 25 Mar 2021 11:49:25 +0800 (CST)
Received: from use12-sp2.huawei.com (10.67.189.174) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Thu, 25 Mar 2021 11:51:17 +0800
From:   Xiaoming Ni <nixiaoming@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <kiyin@tencent.com>,
        <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <sameo@linux.intel.com>, <linville@tuxdriver.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <mkl@pengutronix.de>,
        <stefan@datenfreihafen.org>, <matthieu.baerts@tessares.net>,
        <netdev@vger.kernel.org>
CC:     <nixiaoming@huawei.com>, <wangle6@huawei.com>,
        <xiaoqian9@huawei.com>
Subject: [PATCH resend 4/4] nfc: Avoid endless loops caused by repeated llcp_sock_connect()
Date:   Thu, 25 Mar 2021 11:51:13 +0800
Message-ID: <20210325035113.49323-5-nixiaoming@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210325035113.49323-1-nixiaoming@huawei.com>
References: <YFnwiFmgejk/TKOX@kroah.com>
 <20210325035113.49323-1-nixiaoming@huawei.com>
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

