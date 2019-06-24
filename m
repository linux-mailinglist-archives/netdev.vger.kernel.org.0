Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A566505E9
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 11:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbfFXJiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 05:38:24 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:40697 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfFXJiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 05:38:24 -0400
Received: by mail-pl1-f201.google.com with SMTP id 91so7058755pla.7
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 02:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=2ryvTXJUr6E1POqVcJ5n+r4c9ZhGMz73tT6VUcTuFrQ=;
        b=CdMURYMdeWxpusj13Xt9S24MaVgKY7cgMgjt3xO3eaKRu2SIi4CP3g1qStg6B9WF4w
         T4INniFURIFUxtsLzlbPkCrXXr3IhIpvDUhXMo+Cn3v5yxfUzoil/6UGRsXEfefaU/Qo
         SHYxH53fO9uz6LaKqNe9bIiVYDV7094ZMsIBjtEGeJF8jGKGB/yl7OqcX3MP4gjXyQtf
         uaE2qfzxKeYCWq+YyeCY8qrRLfqwT3jB0ukT5c0tJ7bqn2r7zfCWgNz9XGRpg1LhSZDC
         wnqRWXnWkB8w0ylcEEL/VKOMIHBIHVH7WsZhXMVxwxm73nqhfcBfOC1NsEjXjT9nR5Ld
         KFeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=2ryvTXJUr6E1POqVcJ5n+r4c9ZhGMz73tT6VUcTuFrQ=;
        b=cBUFQ9ub7dnq+qQOz3g/We1ZCo/VHcupwBGmLJS9MDjKyabRkDNBWL1f86uCv9Maet
         PYlTSVP07ArfDPrkDEsdO/byax39fSSk044PsYf2E0FGFo5hNgwFU5d8KVrnpZeWvhtZ
         1u90rb1lwinRsItkV5OdKDklNO2PUOSdOMdkib8pH3DpzRO36+aeomxgumAZ9ri3cVtD
         A2ovcFfwwoI+/wnPBmiWQsBP6b3euGzBemBA3Hi4CrDoNlPaHnxZFsrzxoMcemohlr+O
         eaWLlhY110FXhuQa/H92WtFZdtHHoLmrgZniZAvjp5FMAWio5pmjLSKTt96iDQ7aEDvP
         /fZQ==
X-Gm-Message-State: APjAAAUOMddOvoN3FjHVbROeTgslseqXd76npPwS4ARLLR3U4/rmBOly
        uv6tcQJqEQnw7LpYw7114kbVNTk4u5YPjA==
X-Google-Smtp-Source: APXvYqwVZ2Xs94VeFGjX0hPvrOe12vMf3iFziNHz2RyK5SbA0kqSPO8RvsNMvUYejS7diBIlK515oSgziq6/XA==
X-Received: by 2002:a63:6dc5:: with SMTP id i188mr18529204pgc.188.1561369103299;
 Mon, 24 Jun 2019 02:38:23 -0700 (PDT)
Date:   Mon, 24 Jun 2019 02:38:20 -0700
Message-Id: <20190624093820.48023-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH net] net/packet: fix memory leak in packet_set_ring()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Sowmini Varadhan <sowmini.varadhan@oracle.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot found we can leak memory in packet_set_ring(), if user application
provides buggy parameters.

Fixes: 7f953ab2ba46 ("af_packet: TX_RING support for TPACKET_V3")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/packet/af_packet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index a29d66da7394bb48c4012b29ff2ad3d256cf7bff..0b4cf94f0233f86c196e767dc0179c38330ecca7 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4314,7 +4314,7 @@ static int packet_set_ring(struct sock *sk, union tpacket_req_u *req_u,
 				    req3->tp_sizeof_priv ||
 				    req3->tp_feature_req_word) {
 					err = -EINVAL;
-					goto out;
+					goto out_free_pg_vec;
 				}
 			}
 			break;
@@ -4378,6 +4378,7 @@ static int packet_set_ring(struct sock *sk, union tpacket_req_u *req_u,
 			prb_shutdown_retire_blk_timer(po, rb_queue);
 	}
 
+out_free_pg_vec:
 	if (pg_vec)
 		free_pg_vec(pg_vec, order, req->tp_block_nr);
 out:
-- 
2.22.0.410.gd8fdbe21b5-goog

