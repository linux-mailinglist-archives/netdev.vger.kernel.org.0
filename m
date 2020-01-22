Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC8F145A9B
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 18:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbgAVRHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 12:07:40 -0500
Received: from mail-il1-f201.google.com ([209.85.166.201]:37408 "EHLO
        mail-il1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbgAVRHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 12:07:40 -0500
Received: by mail-il1-f201.google.com with SMTP id l13so230104ilj.4
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 09:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=LFLg8/P4IRzI0qdPR1ZCMadMW7D7KH198L7HUQvQNPE=;
        b=Z3xS/Bm/cMQ2xTGx4bZGBXk7aTY06Nle5NCfqhLqDH2dIa26jWsLfKVX7QtwOrlFvz
         XlbsFSkfyOMwrKWlO0/kWdu112ltrVtpGDP7ufcCxWclkkw83m0JkXzDPNjrrMUSJ1mH
         /BR+qn3cwLYGsVi/hgxQLCYAgi6bh430ofWc5LYce5hWCnrSRooX+TwLCsZ+eYHfspGE
         y0QHAj49PZZwMoXZ8jbzSOdSN2cecYPhH4bfo0pUhxPSMvM8p+IMfrcQV/UC4c4fFBan
         RQX6LLUupnbWwRD9J8Sk6j1Qdy5kq6R/+TrYJTWR0mJ2FtrnyY5U8JVZNQVCCyuKjyEc
         zbJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=LFLg8/P4IRzI0qdPR1ZCMadMW7D7KH198L7HUQvQNPE=;
        b=TGwVVTyM54ChuZp70feTtoiQ+CkYfWcvRPQZifp5+hOX5L5Ieood/UhKBWf3Kmeg7H
         WLAVC83WTXItJCEMbc+06s8nOkXQVYewl4ZPXZK1HsFm/VgmvotpicV0agGjYmwOmEoP
         5ftQid2n3GFQyvOhwnY14QewNNmqkJ7g3EerhZyfVSU6AlDSKmQtLnC0Tjtv5lcTr2cx
         Us8SgfuhVyiHYqPy6j34acao9Nobf+vX74du0VWHXZdiDoB97QRvh13JVudUjZqX5N45
         0Emb8J661qPA9wKdM2z+9qWjQM2EwakGXk2JZtDcf0xeaaQzU5tUbnsXSDuvBYllFiWe
         MazQ==
X-Gm-Message-State: APjAAAVTEUnBFk3DJS+gguRSOpQBiTQhZkCs0zTI83bwTe6mjXek0MK+
        tU4MJA7VRAFzwVEeOcxz1eN4vHngosNkgQ==
X-Google-Smtp-Source: APXvYqzBSKvBnVme8v484RwSko756BoayKU6A3l3fCoy7MA2BB3Eef2UoSmuCpPSPpP3vTTT7M1TqQ3DIIoLew==
X-Received: by 2002:a63:b50a:: with SMTP id y10mr12185365pge.104.1579712858533;
 Wed, 22 Jan 2020 09:07:38 -0800 (PST)
Date:   Wed, 22 Jan 2020 09:07:35 -0800
Message-Id: <20200122170735.4126-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH net] tun: add mutex_unlock() call and napi.skb clearing in tun_get_user()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If both IFF_NAPI_FRAGS mode and XDP are enabled, and the XDP program
consumes the skb, we need to clear the napi.skb (or risk
a use-after-free) and release the mutex (or risk a deadlock)

WARNING: lock held when returning to user space!
5.5.0-rc6-syzkaller #0 Not tainted
------------------------------------------------
syz-executor.0/455 is leaving the kernel with locks still held!
1 lock held by syz-executor.0/455:
 #0: ffff888098f6e748 (&tfile->napi_mutex){+.+.}, at: tun_get_user+0x1604/0x3fc0 drivers/net/tun.c:1835

Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Petar Penkov <ppenkov@google.com>
Cc: Willem de Bruijn <willemb@google.com>
---
 drivers/net/tun.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 683d371e6e82063bec7ade102a3b40aa38b1b6af..35e884a8242d95a4e866ad740a234face2fa0ac0 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1936,6 +1936,10 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 			if (ret != XDP_PASS) {
 				rcu_read_unlock();
 				local_bh_enable();
+				if (frags) {
+					tfile->napi.skb = NULL;
+					mutex_unlock(&tfile->napi_mutex);
+				}
 				return total_len;
 			}
 		}
-- 
2.25.0.341.g760bfbb309-goog

