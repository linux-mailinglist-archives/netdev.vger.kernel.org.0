Return-Path: <netdev+bounces-443-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF86E6F76CD
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 22:17:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51FB4280EB2
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:17:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64B1419528;
	Thu,  4 May 2023 19:51:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71C019522
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273D2C4339B;
	Thu,  4 May 2023 19:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229889;
	bh=xqnVCedNH7mQsCdY9m1JgAgwtMxQ5a73EXkT4swv6VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJhx0oaRi2u7Q+uffOrFnvnnW218dKI5nW4RbRUeVTbKM5fgTdt/N7cWvmyiIheWi
	 O8ndS/hWWMk6j1KpEcQO5Q9lxnqwDfzXj8a1uy22Ojn7ZdLK0ZInF0agpXXpMvpNFH
	 1Lay6xo5T4AyCXMzyNQEoqeFYREBTptdOWBYZ8mMUtcxJrVXnQOrV8NBfPR7Er+REX
	 8/zlGoKhtqbgHhkgUIykFS5S9wFDcXjK0n2asYpN/rsPSE347IuFxQG1/r0RrA49jI
	 ApdKtIwOaG89BabdaPh9oSFszqBjtGACGVBBvoqHcJ7YNd4IlMuFhQmd0xtmhmr1gS
	 mq6g7j3xO+ChA==
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
Subject: [PATCH AUTOSEL 5.4 18/18] Bluetooth: L2CAP: fix "bad unlock balance" in l2cap_disconnect_rsp
Date: Thu,  4 May 2023 15:50:40 -0400
Message-Id: <20230504195042.3808716-18-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504195042.3808716-1-sashal@kernel.org>
References: <20230504195042.3808716-1-sashal@kernel.org>
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
index 3c559a177761b..5f53e75d83024 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4410,7 +4410,6 @@ static inline int l2cap_disconnect_rsp(struct l2cap_conn *conn,
 
 	chan = l2cap_get_chan_by_scid(conn, scid);
 	if (!chan) {
-		mutex_unlock(&conn->chan_lock);
 		return 0;
 	}
 
-- 
2.39.2


