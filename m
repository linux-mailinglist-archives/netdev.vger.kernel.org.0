Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62227405797
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355448AbhIINiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 09:38:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354429AbhIIM47 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:56:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B13EE6325F;
        Thu,  9 Sep 2021 11:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188710;
        bh=+j+ku3WMfVme/OizryAaBaf/ukhHdSZTlb15h09RTME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QlqAdOeOLmt487Oq9NI2HyeYFZwzxHmKIx6wbaTxPWAEOVLEj6rKkfY+FIh5piPVx
         RnVlrx5DzCG1KkZgISkemb3t3Qs1Ntde7JGqahuD4VbBXIiCKrJp8VGxPvsMuy+pRC
         gVBIPw12CHiX84JDEnPpEf9qAa3IN5dtnbI6WOCtlftysUqjn0zsgZuEI4889fLqb2
         1FdmvkvLbTYYjYyIHlvgYtoCWgB7j4EkY4CuKNEnXGR6iW5dm4TH+VnV+hHifuNdUj
         C4ud55e3qQ3wwx6wFNw3VXeRYcY9PYPM72tzXCfjM2i051iU39KoXGkStODlT49lNe
         b5DBBsyIdUQfw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luke Hsiao <lukehsiao@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 51/74] tcp: enable data-less, empty-cookie SYN with TFO_SERVER_COOKIE_NOT_REQD
Date:   Thu,  9 Sep 2021 07:57:03 -0400
Message-Id: <20210909115726.149004-51-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115726.149004-1-sashal@kernel.org>
References: <20210909115726.149004-1-sashal@kernel.org>
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
index 2ab371f55525..119d2c2f3b04 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -342,8 +342,7 @@ struct sock *tcp_try_fastopen(struct sock *sk, struct sk_buff *skb,
 		return NULL;
 	}
 
-	if (syn_data &&
-	    tcp_fastopen_no_cookie(sk, dst, TFO_SERVER_COOKIE_NOT_REQD))
+	if (tcp_fastopen_no_cookie(sk, dst, TFO_SERVER_COOKIE_NOT_REQD))
 		goto fastopen;
 
 	if (foc->len >= 0 &&  /* Client presents or requests a cookie */
-- 
2.30.2

