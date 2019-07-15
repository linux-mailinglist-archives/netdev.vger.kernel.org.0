Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6082568FD7
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389458AbfGOORO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:17:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388581AbfGOORI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:17:08 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7449A21530;
        Mon, 15 Jul 2019 14:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200227;
        bh=nw0bhWN22ol0B/YQQyU6ci3+WNhpdXGVRICZGPGzAKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CASsNHHTMjTZglGQ0UhfXEBNY5/ZHkTkemcc1LKQ8l758cKAKJQucq+BVyOaTa9hj
         17nGD22Yf3BeVvJVRS9UUNxnUuPneY0aWdd+q7Bs7QHk7VXSRo4+YIzLkUwAgsjpzU
         NKZkTH5CaFB7JtTNBRPU0X4wjaPh4d8NStNoTytc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Taehee Yoo <ap420073@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 212/219] gtp: add missing gtp_encap_disable_sock() in gtp_encap_enable()
Date:   Mon, 15 Jul 2019 10:03:33 -0400
Message-Id: <20190715140341.6443-212-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit e30155fd23c9c141cbe7d99b786e10a83a328837 ]

If an invalid role is sent from user space, gtp_encap_enable() will fail.
Then, it should call gtp_encap_disable_sock() but current code doesn't.
It makes memory leak.

Fixes: 91ed81f9abc7 ("gtp: support SGSN-side tunnels")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/gtp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 7a145172d503..83488f2bf7a0 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -847,8 +847,13 @@ static int gtp_encap_enable(struct gtp_dev *gtp, struct nlattr *data[])
 
 	if (data[IFLA_GTP_ROLE]) {
 		role = nla_get_u32(data[IFLA_GTP_ROLE]);
-		if (role > GTP_ROLE_SGSN)
+		if (role > GTP_ROLE_SGSN) {
+			if (sk0)
+				gtp_encap_disable_sock(sk0);
+			if (sk1u)
+				gtp_encap_disable_sock(sk1u);
 			return -EINVAL;
+		}
 	}
 
 	gtp->sk0 = sk0;
-- 
2.20.1

