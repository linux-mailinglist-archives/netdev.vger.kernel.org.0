Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2D7129D0D
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 19:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391113AbfEXRew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 13:34:52 -0400
Received: from mail-ua1-f68.google.com ([209.85.222.68]:37742 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391037AbfEXRet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 13:34:49 -0400
Received: by mail-ua1-f68.google.com with SMTP id t18so3897269uar.4
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 10:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ucJbXJjYkkExyU9fU6S6lml5tD9pH71yYmuUmVnLNSQ=;
        b=YeiMtu2MHxLgb7mO6nmqSCYgle3/hn6GVOVYsCWuCT0TPorUfPp476u6t2pqVGIM1s
         70EpQ8v1eFb0sK5Vb2mmxRecmxmI9Wp11acLPKc2URISh9ceJrXXeHGdOxLPQmfN+UUe
         c6dtv7MmFvEjUyayJbsFF/tgYj3W82vP8TqomZ2L0pDsMOZlbfy8NEursTGVE0FOF1Ew
         pU5mX3WOd00PvD8baxYTsEJ/3YsZVsFtImKDuEYhlRe5LR+KLNfqU8AshdKvY1BV3VXm
         gwh7WmTXA7laaYaPe37mriU/1Z5jhsMc77Iqg5mE1nBRAyBtH1s/KGu6yYxlYZRC2cfO
         f8bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ucJbXJjYkkExyU9fU6S6lml5tD9pH71yYmuUmVnLNSQ=;
        b=ZDLt2TlP3zsR9Ls0u44OuAbtxJNLk0kCTIDYpG4JbW14SbGGsAxfsHkRh8stEP7sxR
         VfycKY4r4NwHF9EBiEK/P9MWgUzocT2+UtCB4ZYZ1xz1ZJPzYjLVf/undIZ6dp1Uvi/F
         FePZy0/4gFAeJcq93Zzx1eicS9VoLfNDf0KE8+HS6Y7srbyOxsNnAFgPY1qf+n76Vzap
         tPe/dPTTMWWXXpq/emOxcYmIfWdHK/vacW36Jx9A3lpey6u60eJlgyfGofH8RTZYljNl
         1vlN3WSKCKLBFszgKZy1WTaViJJ8Gw4m6b/yOTfQcLOwZlLamrwbWyRloNAsZg2eFNBR
         xS8A==
X-Gm-Message-State: APjAAAXsbkVk8q3dvGQJTMXCLwKHBznsVr0FfAPHboP7hPElXtAsqHws
        n8kAK4w43M3CH90l62bTYnLLYIy8fNM=
X-Google-Smtp-Source: APXvYqzY3XunM2GwRWLoQwZvNoCyKW2oPg01Ti1pOQLIf1zVDlMOJqSeS7yT9ultMgoysna4p7e6IQ==
X-Received: by 2002:ab0:1d8e:: with SMTP id l14mr14046923uak.72.1558719288410;
        Fri, 24 May 2019 10:34:48 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n23sm2025647vsj.27.2019.05.24.10.34.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 10:34:47 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, john.fastabend@gmail.com, vakul.garg@nxp.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Beckett <david.beckett@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net 3/4] net/tls: fix no wakeup on partial reads
Date:   Fri, 24 May 2019 10:34:32 -0700
Message-Id: <20190524173433.9196-4-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190524173433.9196-1-jakub.kicinski@netronome.com>
References: <20190524173433.9196-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When tls_sw_recvmsg() partially copies a record it pops that
record from ctx->recv_pkt and places it on rx_list.

Next iteration of tls_sw_recvmsg() reads from rx_list via
process_rx_list() before it enters the decryption loop.
If there is no more records to be read tls_wait_data()
will put the process on the wait queue and got to sleep.
This is incorrect, because some data was already copied
in process_rx_list().

In case of RPC connections process may never get woken up,
because peer also simply blocks in read().

I think this may also fix a similar issue when BPF is at
play, because after __tcp_bpf_recvmsg() returns some data
we subtract it from len and use continue to restart the
loop, but len could have just reached 0, so again we'd
sleep unnecessarily. That's added by:
commit d3b18ad31f93 ("tls: add bpf support to sk_msg handling")

Fixes: 692d7b5d1f91 ("tls: Fix recvmsg() to be able to peek across multiple records")
Reported-by: David Beckett <david.beckett@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Tested-by: David Beckett <david.beckett@netronome.com>
---
 net/tls/tls_sw.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index fc13234db74a..960494f437ac 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1719,7 +1719,7 @@ int tls_sw_recvmsg(struct sock *sk,
 	len = len - copied;
 	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 
-	do {
+	while (len && (decrypted + copied < target || ctx->recv_pkt)) {
 		bool retain_skb = false;
 		bool zc = false;
 		int to_decrypt;
@@ -1850,11 +1850,7 @@ int tls_sw_recvmsg(struct sock *sk,
 		} else {
 			break;
 		}
-
-		/* If we have a new message from strparser, continue now. */
-		if (decrypted + copied >= target && !ctx->recv_pkt)
-			break;
-	} while (len);
+	}
 
 recv_end:
 	if (num_async) {
-- 
2.21.0

