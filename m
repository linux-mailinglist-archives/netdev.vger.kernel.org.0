Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 776835ABEE3
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 14:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbiICMKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 08:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbiICMKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 08:10:36 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 176FF543FD
        for <netdev@vger.kernel.org>; Sat,  3 Sep 2022 05:10:35 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id g4so875498qvo.5
        for <netdev@vger.kernel.org>; Sat, 03 Sep 2022 05:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=PuIlkk70kMFtSejQUjCujFel4cYJBYTGLYxzo4V9o9M=;
        b=FxaPLTmjLJ1wTI5QZaTVTrfvQhlNa+IYtqdwGkNhr09vxjS+m9I8CwETl/OMyqJZiw
         IEY8kWImjHBtutlxAS6lerR1hTIwqz5oYLT/z2gS+NOic7c3FAvIYiFF74rGX1xWU1uN
         ttobkeFFeTFCPzT4G4AyYXC75COi4w6v/LZUiXBB8gyl9rum7tvJcIEoNUE+laUvzT5O
         kP6yGFV0Pyy8AaFYGw06Xr8GNoaY/N/VAImQop/dXfGGVd8hCs5suyjslTdxOnrBLJjs
         zZDQR0pLyFkKYRQ1VOwgnYt4ZRsRSH9T6B3679RioRYPfeuvniNZ5zsPqZXovGEyym2O
         7SEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=PuIlkk70kMFtSejQUjCujFel4cYJBYTGLYxzo4V9o9M=;
        b=5iEg6lK5uguvJ+oBgzgRGbwDbu3eBmdKrT0K0tvZnc3YH6BBELfLucW55cUmd73aSI
         e3nNIB6YnBOIj4G5Xy9iOSpBsWhuxsKceEfiFGybhn5vH2ApAPEYeKL+WZNNmXhBQ1hQ
         UFZcy03x3+ZlxWnqnKh8hxLHNQx2Krahj3pEDd40j19ARO66fwgjyuXDbUS/69BkZ4xD
         tJI8V9kDWkj2Uqs7W4e3rXJ2Xws44kh094uLXx410kgtbsmRa2zJLcBC7OA52TXxr9EC
         mnofNKWvAI4EPohSNaLetIQFMLAzsS2Hdph/QCON6amstqkDyke9nJ3pg+SxoLhKROvc
         Xfsg==
X-Gm-Message-State: ACgBeo0PUtLsJ2ywzcJJ8kgs3bKHNMtsT5CsNOY5qh5ToBKGL9+5saR0
        iJhX6W+IHOqb5bN7fzzBZjcbQVhd0T0deA==
X-Google-Smtp-Source: AA6agR4PCZPZbKQhSfr/4Qdc04F67xqL20fImqAGmXODoXByMG7+Jw2s2AJhdoeh5y9GHVvijhp46w==
X-Received: by 2002:a05:6214:c6f:b0:498:f9f7:4bd4 with SMTP id t15-20020a0562140c6f00b00498f9f74bd4mr30082814qvj.79.1662207034026;
        Sat, 03 Sep 2022 05:10:34 -0700 (PDT)
Received: from soy.nyc.corp.google.com ([2620:0:1003:317:fcb:8093:3ce2:e511])
        by smtp.gmail.com with ESMTPSA id u15-20020a05622a010f00b003435bb7fe9csm2904211qtw.78.2022.09.03.05.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Sep 2022 05:10:33 -0700 (PDT)
From:   Neal Cardwell <ncardwell.kernel@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Nagaraj Arankal <nagaraj.p.arankal@hpe.com>,
        Yuchung Cheng <ycheng@google.com>
Subject: [PATCH net] tcp: fix early ETIMEDOUT after spurious non-SACK RTO
Date:   Sat,  3 Sep 2022 08:10:23 -0400
Message-Id: <20220903121023.866900-1-ncardwell.kernel@gmail.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neal Cardwell <ncardwell@google.com>

Fix a bug reported and analyzed by Nagaraj Arankal, where the handling
of a spurious non-SACK RTO could cause a connection to fail to clear
retrans_stamp, causing a later RTO to very prematurely time out the
connection with ETIMEDOUT.

Here is the buggy scenario, expanding upon Nagaraj Arankal's excellent
report:

(*1) Send one data packet on a non-SACK connection

(*2) Because no ACK packet is received, the packet is retransmitted
     and we enter CA_Loss; but this retransmission is spurious.

(*3) The ACK for the original data is received. The transmitted packet
     is acknowledged.  The TCP timestamp is before the retrans_stamp,
     so tcp_may_undo() returns true, and tcp_try_undo_loss() returns
     true without changing state to Open (because tcp_is_sack() is
     false), and tcp_process_loss() returns without calling
     tcp_try_undo_recovery().  Normally after undoing a CA_Loss
     episode, tcp_fastretrans_alert() would see that the connection
     has returned to CA_Open and fall through and call
     tcp_try_to_open(), which would set retrans_stamp to 0.  However,
     for non-SACK connections we hold the connection in CA_Loss, so do
     not fall through to call tcp_try_to_open() and do not set
     retrans_stamp to 0. So retrans_stamp is (erroneously) still
     non-zero.

     At this point the first "retransmission event" has passed and
     been recovered from. Any future retransmission is a completely
     new "event". However, retrans_stamp is erroneously still
     set. (And we are still in CA_Loss, which is correct.)

(*4) After 16 minutes (to correspond with tcp_retries2=15), a new data
     packet is sent. Note: No data is transmitted between (*3) and
     (*4) and we disabled keep alives.

     The socket's timeout SHOULD be calculated from this point in
     time, but instead it's calculated from the prior "event" 16
     minutes ago (step (*2)).

(*5) Because no ACK packet is received, the packet is retransmitted.

(*6) At the time of the 2nd retransmission, the socket returns
     ETIMEDOUT, prematurely, because retrans_stamp is (erroneously)
     too far in the past (set at the time of (*2)).

This commit fixes this bug by ensuring that we reuse in
tcp_try_undo_loss() the same careful logic for non-SACK connections
that we have in tcp_try_undo_recovery(). To avoid duplicating logic,
we factor out that logic into a new
tcp_is_non_sack_preventing_reopen() helper and call that helper from
both undo functions.

Fixes: da34ac7626b5 ("tcp: only undo on partial ACKs in CA_Loss")
Reported-by: Nagaraj Arankal <nagaraj.p.arankal@hpe.com>
Link: https://lore.kernel.org/all/SJ0PR84MB1847BE6C24D274C46A1B9B0EB27A9@SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM/
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
---
 net/ipv4/tcp_input.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index b85a9f755da41..bc2ea12221f95 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2513,6 +2513,21 @@ static inline bool tcp_may_undo(const struct tcp_sock *tp)
 	return tp->undo_marker && (!tp->undo_retrans || tcp_packet_delayed(tp));
 }
 
+static bool tcp_is_non_sack_preventing_reopen(struct sock *sk)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+
+	if (tp->snd_una == tp->high_seq && tcp_is_reno(tp)) {
+		/* Hold old state until something *above* high_seq
+		 * is ACKed. For Reno it is MUST to prevent false
+		 * fast retransmits (RFC2582). SACK TCP is safe. */
+		if (!tcp_any_retrans_done(sk))
+			tp->retrans_stamp = 0;
+		return true;
+	}
+	return false;
+}
+
 /* People celebrate: "We love our President!" */
 static bool tcp_try_undo_recovery(struct sock *sk)
 {
@@ -2535,14 +2550,8 @@ static bool tcp_try_undo_recovery(struct sock *sk)
 	} else if (tp->rack.reo_wnd_persist) {
 		tp->rack.reo_wnd_persist--;
 	}
-	if (tp->snd_una == tp->high_seq && tcp_is_reno(tp)) {
-		/* Hold old state until something *above* high_seq
-		 * is ACKed. For Reno it is MUST to prevent false
-		 * fast retransmits (RFC2582). SACK TCP is safe. */
-		if (!tcp_any_retrans_done(sk))
-			tp->retrans_stamp = 0;
+	if (tcp_is_non_sack_preventing_reopen(sk))
 		return true;
-	}
 	tcp_set_ca_state(sk, TCP_CA_Open);
 	tp->is_sack_reneg = 0;
 	return false;
@@ -2578,6 +2587,8 @@ static bool tcp_try_undo_loss(struct sock *sk, bool frto_undo)
 			NET_INC_STATS(sock_net(sk),
 					LINUX_MIB_TCPSPURIOUSRTOS);
 		inet_csk(sk)->icsk_retransmits = 0;
+		if (tcp_is_non_sack_preventing_reopen(sk))
+			return true;
 		if (frto_undo || tcp_is_sack(tp)) {
 			tcp_set_ca_state(sk, TCP_CA_Open);
 			tp->is_sack_reneg = 0;
-- 
2.37.2.789.g6183377224-goog

