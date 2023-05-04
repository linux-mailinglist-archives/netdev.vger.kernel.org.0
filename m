Return-Path: <netdev+bounces-449-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E1BC36F76D9
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 22:19:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D076280EA6
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:19:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1A0319BC0;
	Thu,  4 May 2023 19:52:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE18111B0
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:52:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59895C433D2;
	Thu,  4 May 2023 19:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229924;
	bh=NfjV9ehDFlQJJubqBbkTn1BaQmZxQIud71NXKf6dpWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qu2JthMVseTpP2AaeWvasDyPW+gWj2FMFuREiDR983odab7jQWQkeS/1m58bE64eM
	 JyQ7iz/xUh6v7+jZxTeGjwukOnrSgex9UTF7stT2D6cOHdgmk1ag5q1OoDekylNu0h
	 oPG9FRWclvciAFe+uBAWwzd6LJGFgeCY0sNKODUj2Ykbej5S34NHhrhGgwzr+HjhqN
	 JDgGwn3xhdXmzakvNb5QVlzabGD49zAN61ccPcXacR76FQK1WvTe5lFzi/uflQ/IEj
	 +EAe6SC7ITiGLOEb8ug/rcCJW+hXV1SSWzYD2pvzh1NUbmlRGl4ExwEAbGJ+PaPqS/
	 GgH4DVSZW2meA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Min Li <lm0963hack@gmail.com>,
	syzbot+9519d6b5b79cf7787cf3@syzkaller.appspotmail.com,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	johan.hedberg@gmail.com,
	luiz.dentz@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 13/13] Bluetooth: L2CAP: fix "bad unlock balance" in l2cap_disconnect_rsp
Date: Thu,  4 May 2023 15:51:30 -0400
Message-Id: <20230504195132.3808946-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504195132.3808946-1-sashal@kernel.org>
References: <20230504195132.3808946-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Min Li <lm0963hack@gmail.com>

[ Upstream commit 25e97f7b1866e6b8503be349eeea44bb52d661ce ]

conn->chan_lock isn't acquired before l2cap_get_chan_by_scid,
if l2cap_get_chan_by_scid returns NULL, then 'bad unlock balance'
is triggered.

Reported-by: syzbot+9519d6b5b79cf7787cf3@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/000000000000894f5f05f95e9f4d@google.com/
Signed-off-by: Min Li <lm0963hack@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 1a68aad5737e1..94d40a20ab958 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4392,7 +4392,6 @@ static inline int l2cap_disconnect_rsp(struct l2cap_conn *conn,
 
 	chan = l2cap_get_chan_by_scid(conn, scid);
 	if (!chan) {
-		mutex_unlock(&conn->chan_lock);
 		return 0;
 	}
 
-- 
2.39.2


