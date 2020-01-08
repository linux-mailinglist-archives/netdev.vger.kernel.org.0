Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77048134EB7
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbgAHVQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 16:16:43 -0500
Received: from mail-il1-f181.google.com ([209.85.166.181]:37119 "EHLO
        mail-il1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726836AbgAHVQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 16:16:43 -0500
Received: by mail-il1-f181.google.com with SMTP id t8so3909251iln.4;
        Wed, 08 Jan 2020 13:16:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=yXmxsUzDxx3UVsdYKuZEr+cwB6nejckACPxlNU4PCDI=;
        b=gEBJ6yFTCLzNUV+2DjSCesjosoyDVuqIxuLlyiVdjNgjtVWSX0jzyLBoD4cRMfbu9A
         pYabl6YXqgONs0OKZ8FAXog8hbJfUKofqm3w2YOkyffeX9+IC86uoPyUjspYzhBPupWB
         Enc4pZ2d4mOynBelKWbnRoZ5/maTpfCHp/BnyQo3akYOBTr02wvhLhUpvtN7LzzoZmMv
         fhkvb1c6FxOhHyzM2oxnonGijqLfGqvxL3LTBQuLXJWCVmc3bEYcMscGmPX8ZajMQaDL
         liL/YRJMPr2bvAIQgZLVj61TLCFuAd4qdTKC0+W0lsuUzo1GB3S/pd/36h+sdBohuirq
         hY8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=yXmxsUzDxx3UVsdYKuZEr+cwB6nejckACPxlNU4PCDI=;
        b=lg397/DYWLW0eRrLcPxKTplN5Wz6TBw01CJAS1J14MkI9Ya026dAdrRiz1e6n0uRSi
         v4kKCPfYQteaqHTp56Vvf4RtpTlv1geMocF43IUeXcREvIuLO9up1GPYf7DtAU1fg0P/
         wi9ljWXDhIslGrCmOSEGi8u5gnCVvxaUPyg9YZdsB5R6Pbn8gYUwUR1wM8hYjb1WoGED
         TAoun/UfJybXdmhWtJkPrUaVj+ZZEd0l7Iv3na+dlNSEDo6LSCJC+nb8XPXPHuEnL5Lt
         J1V+bWk3nwfSIeGTpJRJzGBRMyGQJMd5yukKp66GsjDfuuf3nJZiDEI7KulWxypBJYAn
         pErQ==
X-Gm-Message-State: APjAAAVth7CCSx7qBz8pie23fajEpMfSFTCubm6KSzDJ8bMcTCk7sYx5
        dHGxMY+kG7cqNt0kzhOoT4jHTlBs
X-Google-Smtp-Source: APXvYqzpurPMotm6OEYRJQfLw4fcefi+5q6PwNDWbC4NIpgURuLX+9VLaBRqKmKJgc/bP26CO6lc4A==
X-Received: by 2002:a92:5b49:: with SMTP id p70mr5501604ilb.209.1578518202313;
        Wed, 08 Jan 2020 13:16:42 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id x2sm1309186ila.74.2020.01.08.13.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 13:16:41 -0800 (PST)
Subject: [bpf PATCH 9/9] bpf: sockmap/tls,
 fix pop data with SK_DROP return code
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, john.fastabend@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Date:   Wed, 08 Jan 2020 21:16:29 +0000
Message-ID: <157851818932.1732.14521897338802839226.stgit@ubuntu3-kvm2>
In-Reply-To: <157851776348.1732.12600714815781177085.stgit@ubuntu3-kvm2>
References: <157851776348.1732.12600714815781177085.stgit@ubuntu3-kvm2>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When user returns SK_DROP we need to reset the number of copied bytes
to indicate to the user the bytes were dropped and not sent. If we
don't reset the copied arg sendmsg will return as if those bytes were
copied giving the user a positive return value.

This works as expected today except in the case where the user also
pops bytes. In the pop case the sg.size is reduced but we don't correctly
account for this when copied bytes is reset. The popped bytes are not
accounted for and we return a small positive value potentially confusing
the user.

The reason this happens is due to a typo where we do the wrong comparison
when accounting for pop bytes. In this fix notice the if/else is not
needed and that we have a similar problem if we push data except its not
visible to the user because if delta is larger the sg.size we return a
negative value so it appears as an error regardless.

Fixes: 7246d8ed4dcce ("bpf: helper to pop data from messages")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/ipv4/tcp_bpf.c |    5 +----
 net/tls/tls_sw.c   |    5 +----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index e38705165ac9..587d55611814 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -315,10 +315,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 		 */
 		delta = msg->sg.size;
 		psock->eval = sk_psock_msg_verdict(sk, psock, msg);
-		if (msg->sg.size < delta)
-			delta -= msg->sg.size;
-		else
-			delta = 0;
+		delta -= msg->sg.size;
 	}
 
 	if (msg->cork_bytes &&
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 0326e916ab01..d9a757c0ba0c 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -812,10 +812,7 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 	if (psock->eval == __SK_NONE) {
 		delta = msg->sg.size;
 		psock->eval = sk_psock_msg_verdict(sk, psock, msg);
-		if (delta < msg->sg.size)
-			delta -= msg->sg.size;
-		else
-			delta = 0;
+		delta -= msg->sg.size;
 	}
 	if (msg->cork_bytes && msg->cork_bytes > msg->sg.size &&
 	    !enospc && !full_record) {

