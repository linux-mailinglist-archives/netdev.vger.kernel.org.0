Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F31F35F9347
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233822AbiJIW7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234200AbiJIW5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:57:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8F64BA49;
        Sun,  9 Oct 2022 15:30:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFF0960DDC;
        Sun,  9 Oct 2022 22:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33F5C433D7;
        Sun,  9 Oct 2022 22:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354427;
        bh=0vXha/ZnD8UqFgF3bT4H9GPLaJFT/OwUwdOCaflmLtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C20oyuE5UH4OxbSkRMJyNmw4rPU+xeZ9L+hXpgxpp5R5xiXBdrrZwXXFQsSwzrtTM
         EcHD0SJloX0i+95Midy8bCJWDtmTK5S+Us+YLYVUDJJEXOBSUJQctlam6i6x6bBDx6
         jCQWNN4qE3QZgUWPCdCABfUSsah6noA0NyPEg4IE5jY9xYIZdnH/7RQn6QxzG72Y/i
         Qj+VeH1Fwf6ZCd3I/AoBtaD8CrrmUSbW9M4130Zh7bOHzB4G2nEti/EULakL/CITXN
         vo0KlHRTQmKjL9roeBHUbna86uPU8WhjGahe5FiYvxU4SHitL6PgRzvgdQAiw7hL09
         5cpaHKSPEOVMg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sungwoo Kim <iam@sung-woo.kim>,
        Sasha Levin <sashal@kernel.org>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 22/23] Bluetooth: L2CAP: Fix user-after-free
Date:   Sun,  9 Oct 2022 18:25:52 -0400
Message-Id: <20221009222557.1219968-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009222557.1219968-1-sashal@kernel.org>
References: <20221009222557.1219968-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 35fcbc4243aad7e7d020b7c1dfb14bb888b20a4f ]

This uses l2cap_chan_hold_unless_zero() after calling
__l2cap_get_chan_blah() to prevent the following trace:

Bluetooth: l2cap_core.c:static void l2cap_chan_destroy(struct kref
*kref)
Bluetooth: chan 0000000023c4974d
Bluetooth: parent 00000000ae861c08
==================================================================
BUG: KASAN: use-after-free in __mutex_waiter_is_first
kernel/locking/mutex.c:191 [inline]
BUG: KASAN: use-after-free in __mutex_lock_common
kernel/locking/mutex.c:671 [inline]
BUG: KASAN: use-after-free in __mutex_lock+0x278/0x400
kernel/locking/mutex.c:729
Read of size 8 at addr ffff888006a49b08 by task kworker/u3:2/389

Link: https://lore.kernel.org/lkml/20220622082716.478486-1-lee.jones@linaro.org
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 75a76353525c..652c0723051b 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4049,6 +4049,12 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
 		}
 	}
 
+	chan = l2cap_chan_hold_unless_zero(chan);
+	if (!chan) {
+		err = -EBADSLT;
+		goto unlock;
+	}
+
 	err = 0;
 
 	l2cap_chan_lock(chan);
@@ -4078,6 +4084,7 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
 	}
 
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 unlock:
 	mutex_unlock(&conn->chan_lock);
-- 
2.35.1

