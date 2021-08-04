Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF9B3E00F4
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 14:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238021AbhHDMPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 08:15:44 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:46956
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236350AbhHDMPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 08:15:44 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 7DFA63F0FF;
        Wed,  4 Aug 2021 12:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628079330;
        bh=Vupsdv0RPAeK1I9qqidHNj9oHtZHv80qP1aQFhD3ryw=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=wExr9J9Km7F5akPcRZABV8xo1GbwAdFdvbo6hG088WyXhyxey2bnGSFNZMCL4iZts
         5H13NcAt4YEgR4OlTlxaCfYaxkRChQwvsKKj1POEQvbEalEM9xhQ1eveK6y3HztMw9
         6iLUI8H8YWjSIUJZS9HU6uDlMSL3RzSHXtRtO/zSPfK/zMMtWEjL6Wxp3RAIfP2yf8
         pHrWnAoxr3V7yA5RmXtfybfJA3fbPJwZMzYcCv+1YfzqSwfCnuGH0+ZdQb6DgFiq2h
         JW3hnKMgGLCDyFnZT+pmmnD3zS9TlgzqXPWN5ZHq67eju8euxVConPy7+TcI3kcMVM
         pomKHDbA4c3WA==
From:   Colin King <colin.king@canonical.com>
To:     Jeremy Kerr <jk@codeconstruct.com.au>,
        Matt Johnston <matt@codeconstruct.com.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] mctp: remove duplicated assignment of pointer hdr
Date:   Wed,  4 Aug 2021 13:15:30 +0100
Message-Id: <20210804121530.110521-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The pointer hdr is being initialized and also re-assigned with the
same value from the call to function mctp_hdr. Static analysis reports
that the initializated value is unused. The second assignment is
duplicated and can be removed.

Addresses-Coverity: ("Unused value").
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/mctp/af_mctp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index 84f722d31fd7..a9526ac29dff 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -170,7 +170,6 @@ static int mctp_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		/* TODO: expand mctp_skb_cb for header fields? */
 		struct mctp_hdr *hdr = mctp_hdr(skb);
 
-		hdr = mctp_hdr(skb);
 		addr = msg->msg_name;
 		addr->smctp_family = AF_MCTP;
 		addr->smctp_network = cb->net;
-- 
2.31.1

