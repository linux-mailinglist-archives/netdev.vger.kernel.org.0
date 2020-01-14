Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A09FA13A946
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 13:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgANM3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 07:29:37 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:38002 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbgANM3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 07:29:36 -0500
Received: from localhost.localdomain (cyclone.blr.asicdesigners.com [10.193.186.206])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 00ECTEfh031366;
        Tue, 14 Jan 2020 04:29:29 -0800
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH 2/3] crypto/chtls: Fixed listen fail when max stid range reached
Date:   Tue, 14 Jan 2020 17:58:48 +0530
Message-Id: <20200114122849.133085-3-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114122849.133085-1-vinay.yadav@chelsio.com>
References: <20200114122849.133085-1-vinay.yadav@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not return error when max stid reached, to Fallback to nic mode.

Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 drivers/crypto/chelsio/chtls/chtls_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_main.c b/drivers/crypto/chelsio/chtls/chtls_main.c
index a148f5c6621b..a038de90b2ea 100644
--- a/drivers/crypto/chelsio/chtls/chtls_main.c
+++ b/drivers/crypto/chelsio/chtls/chtls_main.c
@@ -84,7 +84,6 @@ static int listen_backlog_rcv(struct sock *sk, struct sk_buff *skb)
 static int chtls_start_listen(struct chtls_dev *cdev, struct sock *sk)
 {
 	struct chtls_listen *clisten;
-	int err;
 
 	if (sk->sk_protocol != IPPROTO_TCP)
 		return -EPROTONOSUPPORT;
@@ -100,10 +99,10 @@ static int chtls_start_listen(struct chtls_dev *cdev, struct sock *sk)
 	clisten->cdev = cdev;
 	clisten->sk = sk;
 	mutex_lock(&notify_mutex);
-	err = raw_notifier_call_chain(&listen_notify_list,
+	raw_notifier_call_chain(&listen_notify_list,
 				      CHTLS_LISTEN_START, clisten);
 	mutex_unlock(&notify_mutex);
-	return err;
+	return 0;
 }
 
 static void chtls_stop_listen(struct chtls_dev *cdev, struct sock *sk)
-- 
2.24.1

