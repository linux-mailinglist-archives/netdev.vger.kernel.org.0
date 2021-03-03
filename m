Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E2A32C3DA
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354331AbhCDAIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:08:07 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12675 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355016AbhCCGRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 01:17:54 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Dr3cx5QKHzlRYR;
        Wed,  3 Mar 2021 14:14:57 +0800 (CST)
Received: from use12-sp2.huawei.com (10.67.189.174) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Wed, 3 Mar 2021 14:16:58 +0800
From:   Xiaoming Ni <nixiaoming@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <kiyin@tencent.com>,
        <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <sameo@linux.intel.com>, <linville@tuxdriver.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <mkl@pengutronix.de>,
        <stefan@datenfreihafen.org>, <matthieu.baerts@tessares.net>,
        <netdev@vger.kernel.org>
CC:     <nixiaoming@huawei.com>, <wangle6@huawei.com>,
        <xiaoqian9@huawei.com>
Subject: [PATCH 3/4] nfc: fix memory leak in llcp_sock_connect()
Date:   Wed, 3 Mar 2021 14:16:53 +0800
Message-ID: <20210303061654.127666-4-nixiaoming@huawei.com>
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

In llcp_sock_connect(), use kmemdup to allocate memory for
 "llcp_sock->service_name". The memory is not released in the sock_unlink
label of the subsequent failure branch.
As a result, memory leakage occurs.

fix CVE-2020-25672

Fixes: d646960f7986 ("NFC: Initial LLCP support")
Reported-by: "kiyin(尹亮)" <kiyin@tencent.com>
Link: https://www.openwall.com/lists/oss-security/2020/11/01/1
Cc: <stable@vger.kernel.org> #v3.3
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
---
 net/nfc/llcp_sock.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 9e2799ee1595..59172614b249 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -746,6 +746,8 @@ static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
 
 sock_unlink:
 	nfc_llcp_sock_unlink(&local->connecting_sockets, sk);
+	kfree(llcp_sock->service_name);
+	llcp_sock->service_name = NULL;
 
 sock_llcp_release:
 	nfc_llcp_put_ssap(local, llcp_sock->ssap);
-- 
2.27.0

