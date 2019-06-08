Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AACD539A07
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 03:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730012AbfFHB0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 21:26:39 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:53415 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728456AbfFHB0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 21:26:38 -0400
Received: by mail-pl1-f201.google.com with SMTP id b24so2395334plz.20
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 18:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=zEPHlWmFc6fbMnKHEikPN5MKyQBSoqZ4hBXU7IefInw=;
        b=CEq0z4iCgCcJ4OTZ7Rkx9EmPRXt6S6lF10206p8Hy6/cqovM8pv/SnGhcYth0zRDfq
         ROJzem/dqaiKr5FdVYjAjWh5Zwl+VEL7RgSbIgcFHac/NmAydJcxA+MqbIO2mub8JFMq
         0gofWUsgcWVBQMK7R7KhyIVTyVZo6knqX5YVIT1E89Wp1VSCSYt5WZZSVjOzeDgE/B8Y
         j3xn7YX50Q+xAqnQU7IuuV5EpDWGuT4M5oQbABwpNLAOxsi0ky2uu49LPYbMrzu/H2I5
         5sMIcXiT9gSgTlsAfQ17+huZjojtvUAAfrFMurBQI9jRTUN7IwYAdOudaJwf+owj9sfq
         KUtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=zEPHlWmFc6fbMnKHEikPN5MKyQBSoqZ4hBXU7IefInw=;
        b=k84CZgh7in25vh7wnFjmY14tOjxu9BR4CxnJ79oBwhDjhWcJ3yt+FSy8XwHQY/5oMp
         x11oo/cvq6SB7vZosFsKotyluy0fbLe+gw3URAe2WEj3wDtypFPbJQVPdyzFGruq/mLB
         tt5/4GC4t+YsGL8pNZjeenFBpyTqwvgr93R0Cgs8X4oA8NHrS6f5ogHMpVzpKr7RxNCW
         12Lhdf8jL12nzxxzTqN1+n0uq4I05hVInOrE3IirgS3V0U8r4TfcjSgWD1NBE5ciM4jK
         4gK5ctKS+NkWAVBgYtn4ouYzV6fNFS3p4wM5UoE22t28xsjifaVDsJ+aaHvBfYBNR6XZ
         drtA==
X-Gm-Message-State: APjAAAUomTWXd0XflzzjZv5mCoqGB7shpTXGoQZIe3hAY8ZEKc59Er5d
        ihWejIOu++UzYGs2h3625bktwOYFGS8=
X-Google-Smtp-Source: APXvYqydfDKCcZQoka69ctTOVPQV/GSJO7SfqQFlUA5sdv5v3PPgLdkKIXp/vi/FWRlfOYAed9TqrHV1dDM=
X-Received: by 2002:a63:10d:: with SMTP id 13mr5473102pgb.176.1559957197660;
 Fri, 07 Jun 2019 18:26:37 -0700 (PDT)
Date:   Fri,  7 Jun 2019 18:26:33 -0700
Message-Id: <20190608012633.107118-1-ycheng@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
Subject: [PATCH net] tcp: fix undo spurious SYNACK in passive Fast Open
From:   Yuchung Cheng <ycheng@google.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ncardwell@google.com, edumazet@google.com,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 794200d66273 ("tcp: undo cwnd on Fast Open spurious SYNACK
retransmit") may cause tcp_fastretrans_alert() to warn about pending
retransmission in Open state. This is triggered when the Fast Open
server both sends data and has spurious SYNACK retransmission during
the handshake, and the data packets were lost or reordered.

The root cause is a bit complicated:

(1) Upon receiving SYN-data: a full socket is created with
    snd_una = ISN + 1 by tcp_create_openreq_child()

(2) On SYNACK timeout the server/sender enters CA_Loss state.

(3) Upon receiving the final ACK to complete the handshake, sender
    does not mark FLAG_SND_UNA_ADVANCED since (1)

    Sender then calls tcp_process_loss since state is CA_loss by (2)

(4) tcp_process_loss() does not invoke undo operations but instead
    mark REXMIT_LOST to force retransmission

(5) tcp_rcv_synrecv_state_fastopen() calls tcp_try_undo_loss(). It
    changes state to CA_Open but has positive tp->retrans_out

(6) Next ACK triggers the WARN_ON in tcp_fastretrans_alert()

The step that goes wrong is (4) where the undo operation should
have been invoked because the ACK successfully acknowledged the
SYN sequence. This fixes that by specifically checking undo
when the SYN-ACK sequence is acknowledged. Then after
tcp_process_loss() the state would be further adjusted based
in tcp_fastretrans_alert() to avoid triggering the warning in (6).

Fixes: 794200d66273 ("tcp: undo cwnd on Fast Open spurious SYNACK retransmit")

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
---
 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 08a477e74cf3..38dfc308c0fb 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2648,7 +2648,7 @@ static void tcp_process_loss(struct sock *sk, int flag, int num_dupack,
 	struct tcp_sock *tp = tcp_sk(sk);
 	bool recovered = !before(tp->snd_una, tp->high_seq);
 
-	if ((flag & FLAG_SND_UNA_ADVANCED) &&
+	if ((flag & FLAG_SND_UNA_ADVANCED || tp->fastopen_rsk) &&
 	    tcp_try_undo_loss(sk, false))
 		return;
 
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

