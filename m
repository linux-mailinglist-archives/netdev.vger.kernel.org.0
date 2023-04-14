Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC2686E2556
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 16:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjDNOKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 10:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjDNOJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 10:09:28 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2155FA24D
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 07:08:59 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id e7so7564768wrc.12
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 07:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1681481312; x=1684073312;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ogznRyoPP+056OwMwbae8knri/N8tWTWU74IRb36bJ0=;
        b=sHfPEz0/Z8hOsH0W31okcmmWVW7Jz8Y7MBvd91H6QX/yi0LPkhBmL+QziymNrCD0Dt
         mmq7WRi0bd8OGuFzfPgUfuxbLGAeVbXCIJsR2ZuBbjY2qIAVYDd/sk/9LQImUGfNbqTk
         QxantsEkC1yRH8lL3RGX4H44kjQTt43PfaXxA5mo0kageEjTFRjT8q1r+thXNImrWBT/
         FL4HhDcjzi26OsnYpP3u4fTndD1BqrwDCg5yFMXwoy1xFTKlcjjiiU8TirGN+HzWm3Cq
         FA552QzpLqx+qdOrqkI1Oxhl8tesZX1b0LrifRo3q6RFhs5HBOFtaS/UX9k60yPvJVnb
         23zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681481312; x=1684073312;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ogznRyoPP+056OwMwbae8knri/N8tWTWU74IRb36bJ0=;
        b=g+VUGYDXz50yfhC+phrmwzbOY8A6shjMsXRJ/DaTfsNB89bZA9Paxp7iH4AajBkiNV
         0hTQqhkNdlmxqkuf4h3/SmN5F/ClOxksQ/cFzfW4DINu485nu+un8GG0fguMX13F2p0u
         UXksc3nfz+3JtYoTvPopiIUdp4BN6SCZ+kIObdfwWNPacQlI1WJ/qCwzKutPTII/qCYS
         Sn2YquIZ/hz8FwzVKq8V4wd6rTWinOEBRU1I+X60MgrDyF2KMCYpM+YebaKTGz45Yyuv
         s7u6jkQyMCDTK1MQQAxF0knPRLB+m0nPRJDst1tMUFKOhzbgfompGavESFR6D3yOsFCO
         4rmw==
X-Gm-Message-State: AAQBX9ebWZntBgBHPn6zZvuNO674+rumukUH8sAgDyARYRAJbdIonZnq
        02BuFhj+4B4rd55zPmouLr4A33xkPtiucVhDUgApgw==
X-Google-Smtp-Source: AKy350bkxr1N61hkZ+AtoNNV6ZcA5K2MOGNy5oi6o/OWZ0VZPTarzZXBKBMc6Pbq01/9cpp6BJTYIQ==
X-Received: by 2002:adf:e48a:0:b0:2ef:4c83:b78e with SMTP id i10-20020adfe48a000000b002ef4c83b78emr7119539wrm.4.1681481312552;
        Fri, 14 Apr 2023 07:08:32 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id o5-20020a5d58c5000000b002f47ae62fe0sm3648185wrf.115.2023.04.14.07.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 07:08:32 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Fri, 14 Apr 2023 16:08:04 +0200
Subject: [PATCH net-next 5/5] mptcp: fastclose msk when cleaning unaccepted
 sockets
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230414-upstream-net-next-20230414-mptcp-refactor-first-subflow-init-v1-5-04d177057eb9@tessares.net>
References: <20230414-upstream-net-next-20230414-mptcp-refactor-first-subflow-init-v1-0-04d177057eb9@tessares.net>
In-Reply-To: <20230414-upstream-net-next-20230414-mptcp-refactor-first-subflow-init-v1-0-04d177057eb9@tessares.net>
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1319;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=94Du3tPB/bRAi77YjNm1E+sPGspDF2pImjBzRfpMGgM=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkOV5ZnxzUZCmm4W6LKU/y/OGltXEBtKUntbAZd
 abPqNuiHgSJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZDleWQAKCRD2t4JPQmmg
 czK4EADZTlZwhMw4sDQxk2HQKSNWPPTDQDBWBEvEiAkSXa3HW4mCAEz4MCW+znvv05+henG8DmV
 AdtFcbeuVrgZiWzPShQUkR/No1m8On2aoEHYPf52GbRXqzBktNWiYE1idnDqOUcYVDz1urBLM51
 /YqcPuSmHszvVNWpG2ZHBZ3nMLwHxVtxFuJA4N1tX4Y+aLijYnJqkpnfolwMM0NjJHJUuIrTntA
 9Zc/qb4+qu1mtdvW++RBSz7GRqoypv4bGaDLJ0u/nzwLk7YcAbntRyeXioCO1MSKQh9MqKwZ9t+
 L0xSkLFbl5f3owh1qCfaSEmCM60i9hZ2BsX7KeXCnOO/O68um2AkTz5BgJlO5O1Pr9vOXNpX4B/
 lEYBLj2SzSrb4M+PKY16/TWlFVxS+0tsw3ddWthsmQgFArcHZwjIVcCt8GVGVxYJRftKy+RgAg0
 n2Dt0XgSdSXNs4TTIFLl5y4ATXPyuJxSJm7uUspkjHTgwKS9Sf9vOuhjFGtVv3fdAcxSqDYuiuW
 pgc3zBfMqoB4IFfAnugo90UpjP8jVCYLvyJ4Y5BoeZG5ryWYpc5DN2kjnpD+NR/JD42SEgbciZW
 oaRda3KsOXarak9Cq8Muz/YginE+PES5quDFIJiYBsrP2GlUtQdh1N6wwo/pBpJGhZWzOBRWmBx
 eYzbMat2s5xk2Ow==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

When cleaning up unaccepted mptcp socket still laying inside
the listener queue at listener close time, such sockets will
go through a regular close, waiting for a timeout before
shutting down the subflows.

There is no need to keep the kernel resources in use for
such a possibly long time: short-circuit to fast-close.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/protocol.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index a676ac1bb9f1..1926b81a9538 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2953,10 +2953,13 @@ bool __mptcp_close(struct sock *sk, long timeout)
 		goto cleanup;
 	}
 
-	if (mptcp_check_readable(msk)) {
-		/* the msk has read data, do the MPTCP equivalent of TCP reset */
+	if (mptcp_check_readable(msk) || timeout < 0) {
+		/* If the msk has read data, or the caller explicitly ask it,
+		 * do the MPTCP equivalent of TCP reset, aka MPTCP fastclose
+		 */
 		inet_sk_state_store(sk, TCP_CLOSE);
 		mptcp_do_fastclose(sk);
+		timeout = 0;
 	} else if (mptcp_close_state(sk)) {
 		__mptcp_wr_shutdown(sk);
 	}

-- 
2.39.2

