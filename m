Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC8F4AFACC
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 19:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbiBISkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 13:40:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240066AbiBISjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 13:39:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF1BC03E94A;
        Wed,  9 Feb 2022 10:39:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A8E060C81;
        Wed,  9 Feb 2022 18:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0736CC340E9;
        Wed,  9 Feb 2022 18:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644431951;
        bh=AmJ88brCUlZqtikAlLHcWYvv3MfLZ/dBUHwKlvKvL8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qj9I/vq+STJTvEXCBRN4FawlvKjqgQASlfpH8C8+M3lt7Ys7HzdhHgi/a6Pl5Lqp0
         zrXqa0c+7Cmod/YDkl6Sgd9qX2Pm5AzytAdil8y0XaJg6vizx+DxteQ8TSdD1B/yHd
         4YVeVg8ZRldTxkE+puTl6xMxBr5NsOr6GybVWE9ZtUdjlMQvsIZlaFXMclfskWegJM
         kKAXBThTVqLnc17YZJ7P0ESJKV9xKRgv85FUEXW5LLVEWFdt85E9wDV0ZUcNomS+It
         bIIgjY4OST4jvqDZpFRgMNlDF585iFrZAXz4uBClcrIvuXI/3PyB2yOgRLsP9SZPCO
         x16I1U5r1UnzQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Duoming Zhou <duoming@zju.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, jreuter@yaina.de,
        kuba@kernel.org, linux-hams@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 15/36] ax25: improve the incomplete fix to avoid UAF and NPD bugs
Date:   Wed,  9 Feb 2022 13:37:38 -0500
Message-Id: <20220209183759.47134-15-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209183759.47134-1-sashal@kernel.org>
References: <20220209183759.47134-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 4e0f718daf97d47cf7dec122da1be970f145c809 ]

The previous commit 1ade48d0c27d ("ax25: NPD bug when detaching
AX25 device") introduce lock_sock() into ax25_kill_by_device to
prevent NPD bug. But the concurrency NPD or UAF bug will occur,
when lock_sock() or release_sock() dereferences the ax25_cb->sock.

The NULL pointer dereference bug can be shown as below:

ax25_kill_by_device()        | ax25_release()
                             |   ax25_destroy_socket()
                             |     ax25_cb_del()
  ...                        |     ...
                             |     ax25->sk=NULL;
  lock_sock(s->sk); //(1)    |
  s->ax25_dev = NULL;        |     ...
  release_sock(s->sk); //(2) |
  ...                        |

The root cause is that the sock is set to null before dereference
site (1) or (2). Therefore, this patch extracts the ax25_cb->sock
in advance, and uses ax25_list_lock to protect it, which can synchronize
with ax25_cb_del() and ensure the value of sock is not null before
dereference sites.

The concurrency UAF bug can be shown as below:

ax25_kill_by_device()        | ax25_release()
                             |   ax25_destroy_socket()
  ...                        |   ...
                             |   sock_put(sk); //FREE
  lock_sock(s->sk); //(1)    |
  s->ax25_dev = NULL;        |   ...
  release_sock(s->sk); //(2) |
  ...                        |

The root cause is that the sock is released before dereference
site (1) or (2). Therefore, this patch uses sock_hold() to increase
the refcount of sock and uses ax25_list_lock to protect it, which
can synchronize with ax25_cb_del() in ax25_destroy_socket() and
ensure the sock wil not be released before dereference sites.

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/af_ax25.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 7473e0cc6d469..ea3431ac46a14 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -77,6 +77,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 {
 	ax25_dev *ax25_dev;
 	ax25_cb *s;
+	struct sock *sk;
 
 	if ((ax25_dev = ax25_dev_ax25dev(dev)) == NULL)
 		return;
@@ -85,13 +86,15 @@ static void ax25_kill_by_device(struct net_device *dev)
 again:
 	ax25_for_each(s, &ax25_list) {
 		if (s->ax25_dev == ax25_dev) {
+			sk = s->sk;
+			sock_hold(sk);
 			spin_unlock_bh(&ax25_list_lock);
-			lock_sock(s->sk);
+			lock_sock(sk);
 			s->ax25_dev = NULL;
-			release_sock(s->sk);
+			release_sock(sk);
 			ax25_disconnect(s, ENETUNREACH);
 			spin_lock_bh(&ax25_list_lock);
-
+			sock_put(sk);
 			/* The entry could have been deleted from the
 			 * list meanwhile and thus the next pointer is
 			 * no longer valid.  Play it safe and restart
-- 
2.34.1

