Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2276E405465
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356037AbhIIM6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:58:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353172AbhIIMtG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:49:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC672611C1;
        Thu,  9 Sep 2021 11:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188600;
        bh=VulqvxBtUQTNH3d86yDvRtC5+CUk148V7vQLKRn6wXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RkwfQ1p7eP37UIioJpW3sewG3Mo3g0kA1g1ZJF47CBrskldzUcovlgVDH3KRnVFTq
         mDNoGxo5kONQxa4lMRvjdlRKnzFot8N8Z5FuclBRiyfykEcPRa2eqLItZ5d4Q+nTcJ
         LMpu75DcVjapxhRc2eYzngvztQ5yOgdBDa207uQTlJsoc4MbK6ZygTfOREQmOPTJOG
         j3qoxHSX1RfnRbbzzc0/IR1p6KqjvL9O93cOVWvixYLsEiIWA6voL2DWj2AYs8B/SS
         AqbjLOdkoKGyZp1F62AP9shzD5SM4q3glMBAUWMqvt1UFrtWE60Ilbijrt8xBSlsAX
         zJU9e9LUyfBRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luke Hsiao <lukehsiao@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 073/109] tcp: enable data-less, empty-cookie SYN with TFO_SERVER_COOKIE_NOT_REQD
Date:   Thu,  9 Sep 2021 07:54:30 -0400
Message-Id: <20210909115507.147917-73-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115507.147917-1-sashal@kernel.org>
References: <20210909115507.147917-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luke Hsiao <lukehsiao@google.com>

[ Upstream commit e3faa49bcecdfcc80e94dd75709d6acb1a5d89f6 ]

Since the original TFO server code was implemented in commit
168a8f58059a22feb9e9a2dcc1b8053dbbbc12ef ("tcp: TCP Fast Open Server -
main code path") the TFO server code has supported the sysctl bit flag
TFO_SERVER_COOKIE_NOT_REQD. Currently, when the TFO_SERVER_ENABLE and
TFO_SERVER_COOKIE_NOT_REQD sysctl bit flags are set, a server connection
will accept a SYN with N bytes of data (N > 0) that has no TFO cookie,
create a new fast open connection, process the incoming data in the SYN,
and make the connection ready for accepting. After accepting, the
connection is ready for read()/recvmsg() to read the N bytes of data in
the SYN, ready for write()/sendmsg() calls and data transmissions to
transmit data.

This commit changes an edge case in this feature by changing this
behavior to apply to (N >= 0) bytes of data in the SYN rather than only
(N > 0) bytes of data in the SYN. Now, a server will accept a data-less
SYN without a TFO cookie if TFO_SERVER_COOKIE_NOT_REQD is set.

Caveat! While this enables a new kind of TFO (data-less empty-cookie
SYN), some firewall rules setup may not work if they assume such packets
are not legit TFOs and will filter them.

Signed-off-by: Luke Hsiao <lukehsiao@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20210816205105.2533289-1-luke.w.hsiao@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_fastopen.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 8af4fefe371f..a5ec77a5ad6f 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -379,8 +379,7 @@ struct sock *tcp_try_fastopen(struct sock *sk, struct sk_buff *skb,
 		return NULL;
 	}
 
-	if (syn_data &&
-	    tcp_fastopen_no_cookie(sk, dst, TFO_SERVER_COOKIE_NOT_REQD))
+	if (tcp_fastopen_no_cookie(sk, dst, TFO_SERVER_COOKIE_NOT_REQD))
 		goto fastopen;
 
 	if (foc->len == 0) {
-- 
2.30.2

