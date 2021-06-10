Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9423A3008
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 18:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhFJQDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 12:03:38 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:40919 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbhFJQDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 12:03:37 -0400
Received: by mail-pl1-f176.google.com with SMTP id e7so1259971plj.7
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 09:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i8BnrdHNC+jHmUkPNkkwz2zS4N6PZxzAljYW8S2uYfE=;
        b=L/BRHxtT3t6YdMnHJDOE7bk1g1F7pZYXPGN8Lqp2MEz9EcVDL7QMRkNjQFzFXBtF57
         ZeXzXzMiRoDjKXi05Gai5dt3wIsVRzotWB0IH3c0Mh5zxJDIsWhbPXrjDTH185u1jGeH
         d2RgQ5QvxZ9aqXkmqUnEXjKeOiC4hMArGpvdk2JOCguWsltwKBrb7cXr/P0W97Mc+0Cb
         bemrZMFP7xTSmSS/UpzqmlbyvLgLqn9e7DknJNxO7vct+00cjgqXd+mbvhk9F3gqKZEi
         FcvHMP3ysdnclruQh028999QrWle3KPr/kR1QTJlCnIe3FjgiUcYC4C19cODQQfuUWLY
         QRLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i8BnrdHNC+jHmUkPNkkwz2zS4N6PZxzAljYW8S2uYfE=;
        b=exrZFBwXnYirA+IryUpZW8fhJQ7VZS4KK+zSVLBoSc/E/O0EtBgGjH/q5Nb9pTIRFX
         bWjIk+ViY4y/y5cl6BDvVX7I7/TMmj2Dh5XRwbJjETbz06YF1vpHGXiFfelm2ALIZ+Gu
         LN9wUkg8rfJkDlUxPqQJ/FISJnM2mGWuFCosMJ0FiJdf5zW92B6WFpTzCmiJgHq5VT4u
         OKXgYxrM4P+ckkMIa/Zkw7db3qNwbNhGfZjxdkfzcQ+QZArngRHUC7Zgi9h0GnVuX32R
         0sUHs76nXORdtQUyvSPA1wAcQarvCB7UBj7oCQZe5ISPUdBIBux9Iz/7gZ6jPXonKMRv
         Qjuw==
X-Gm-Message-State: AOAM53213dgmObgeRe8HRSH+qxVt6CPXtPzOHa9a2qsRoAaOxF20ckNX
        N2F/kxn6JuGr9gfpwV+fF/8=
X-Google-Smtp-Source: ABdhPJwO59RuLtjGLpFTgQd4dV8UDGpSyxgaEOMNyrIRL6t5ny40+Sc1mv8elafUKVjaR95uuH8/uQ==
X-Received: by 2002:a17:902:e8d8:b029:117:8e2c:1ed5 with SMTP id v24-20020a170902e8d8b02901178e2c1ed5mr1681132plg.39.1623340825705;
        Thu, 10 Jun 2021 09:00:25 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c6f4:90b5:5614:38a0])
        by smtp.gmail.com with ESMTPSA id t24sm8050538pji.56.2021.06.10.09.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 09:00:16 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net] net/packet: annotate data race in packet_sendmsg()
Date:   Thu, 10 Jun 2021 09:00:12 -0700
Message-Id: <20210610160012.1452531-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

There is a known race in packet_sendmsg(), addressed
in commit 32d3182cd2cd ("net/packet: fix race in tpacket_snd()")

Now we have data_race(), we can use it to avoid a future KCSAN warning,
as syzbot loves stressing af_packet sockets :)

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/packet/af_packet.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index ae906eb4b269e858434828a383491e8d4c33c422..74e6e45a8e8435a556ce813c410a1f4146dd05b6 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3034,10 +3034,13 @@ static int packet_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	struct sock *sk = sock->sk;
 	struct packet_sock *po = pkt_sk(sk);
 
-	if (po->tx_ring.pg_vec)
+	/* Reading tx_ring.pg_vec without holding pg_vec_lock is racy.
+	 * tpacket_snd() will redo the check safely.
+	 */
+	if (data_race(po->tx_ring.pg_vec))
 		return tpacket_snd(po, msg);
-	else
-		return packet_snd(sock, msg, len);
+
+	return packet_snd(sock, msg, len);
 }
 
 /*
-- 
2.32.0.rc1.229.g3e70b5a671-goog

