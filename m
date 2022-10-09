Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B60B5F92EE
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233585AbiJIWzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233627AbiJIWwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:52:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D70C548EBE;
        Sun,  9 Oct 2022 15:28:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A268260DBB;
        Sun,  9 Oct 2022 22:24:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B64C433B5;
        Sun,  9 Oct 2022 22:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354260;
        bh=maJ8fNNyCcC99rqyWAvsYKYOT4uvsH7Am3h5FOC+4NU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pAQ4YlrKyVpRsvzhre8HvpITg1PKAknMnVuTle+0Abu0NA5s0CLAFzzbRHi/2/2Zm
         iWvSNeB8+3HODu66g12+x/jk7iTDUWgRzmDM1C3ANwPdeMwOJkn50UieYzWo9rnXzN
         FHHogZrqIfsZU5XQ0UmK+1HCT8BXLZ8Uu8eezTNm4tb3Nt0UcQmLTCs+zD5wOhQENt
         +DIdU506dWMwY+skKxIkURWiZVcAGKZRfzvhdjbXcJRTBH4B4Ovm3BBqeLF2QyfGCO
         9YW/RHfyeaa6L2Uffrb2ZiFVVpI1ObCqWD7GTeyyLBrIkrBnYAZwD8j5c5r3gxUNlt
         2c3KmNfihwKlg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sungwoo Kim <iam@sung-woo.kim>,
        Sasha Levin <sashal@kernel.org>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 27/29] Bluetooth: L2CAP: Fix user-after-free
Date:   Sun,  9 Oct 2022 18:23:02 -0400
Message-Id: <20221009222304.1218873-27-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009222304.1218873-1-sashal@kernel.org>
References: <20221009222304.1218873-1-sashal@kernel.org>
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
index 442432f89be1..2d28b4e49b7a 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4066,6 +4066,12 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
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
@@ -4095,6 +4101,7 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
 	}
 
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 unlock:
 	mutex_unlock(&conn->chan_lock);
-- 
2.35.1

