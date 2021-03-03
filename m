Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7359432C3DE
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354374AbhCDAIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:08:23 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12679 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355017AbhCCGR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 01:17:56 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Dr3cx6FBLzlRh7;
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
Subject: [PATCH 2/4] nfc: fix refcount leak in llcp_sock_connect()
Date:   Wed, 3 Mar 2021 14:16:52 +0800
Message-ID: <20210303061654.127666-3-nixiaoming@huawei.com>
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

nfc_llcp_local_get() is invoked in llcp_sock_connect(),
but nfc_llcp_local_put() is not invoked in subsequent failure branches.
As a result, refcount leakage occurs.
To fix it, add calling nfc_llcp_local_put().

fix CVE-2020-25671
Fixes: c7aa12252f51 ("NFC: Take a reference on the LLCP local pointer when
creating a socket")
Reported-by: "kiyin(尹亮)" <kiyin@tencent.com>
Link: https://www.openwall.com/lists/oss-security/2020/11/01/1
Cc: <stable@vger.kernel.org> #v3.6
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
---
 net/nfc/llcp_sock.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 68832ee4b9f8..9e2799ee1595 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -704,6 +704,7 @@ static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
 	llcp_sock->local = nfc_llcp_local_get(local);
 	llcp_sock->ssap = nfc_llcp_get_local_ssap(local);
 	if (llcp_sock->ssap == LLCP_SAP_MAX) {
+		nfc_llcp_local_put(llcp_sock->local);
 		ret = -ENOMEM;
 		goto put_dev;
 	}
@@ -748,6 +749,7 @@ static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
 
 sock_llcp_release:
 	nfc_llcp_put_ssap(local, llcp_sock->ssap);
+	nfc_llcp_local_put(llcp_sock->local);
 
 put_dev:
 	nfc_put_device(dev);
-- 
2.27.0

