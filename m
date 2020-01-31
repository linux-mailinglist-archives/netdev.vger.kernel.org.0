Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1183C14F235
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 19:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgAaScq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 13:32:46 -0500
Received: from mail-pf1-f201.google.com ([209.85.210.201]:55418 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbgAaScp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 13:32:45 -0500
Received: by mail-pf1-f201.google.com with SMTP id 63so4460943pfw.22
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 10:32:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=J1QFr62Ow7U+Z8XwZP3S0a+dNZnNVzSk1ch4WzaK1jU=;
        b=FGfm4Va62VUwBcSpP9sPtPXt64qBuq4YUnlQkreh/ck0MnaWLxUmQF17Si5Ko7wsdf
         Gv7I5JpaKW+GTjIfhswzMygEva1tVsXh4AtxF+oM/e8narvU3tEv8149LtaqQXeSYAf1
         ksnIhj5JpwZS9MU95XV8b0Y6og1y6MpB3vXFSx1j5n1Tm4GYpgVr6GCNN07y+K4WI2xT
         hh4teimg0TEEirFw2HQ8yinkxwmaxOELBQycbvgHxfOuFcUillKjcsvOciFD+YIVr25q
         8VOm/pvQRS3Om9fWvx5iGdoWGZL5XreNAW1yOvm4nkMQVZZ4D26UCtD0lmB/n4ePAFeF
         xVPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=J1QFr62Ow7U+Z8XwZP3S0a+dNZnNVzSk1ch4WzaK1jU=;
        b=OG60ty5hrSMcCFEMlRU/YHdS770VIcGkUDkOFbZSFnMP9MEfAazNn4ZoTkL1pdODn7
         mafbvGXkF7Lr/Jx4jLN4YrvA4Fyjt5PdTdo14L/yGF6J61i81fDuIOjt8CJTHu6CM8+O
         ekKBww/1HX7p1BlphTUeYy/i2e9a9xi58/uaxBQO1mGa+mDYeyxkXJgqqS+Jc9sYqd2W
         LbZTExxbQsC8mK254oT8BrUKqvIQRv5nnq9UhOju/da3dhEsQCyEwF8ScJJWfai8tkna
         zvRfNymD/zLanNWI+IXGkX0clDP5ARn21k9/ummcsow4BqXmKud+RBVmfG4ZvvaTAd6u
         iFfQ==
X-Gm-Message-State: APjAAAVRKnGyFmeOtLY9Tq9RCGCz24oZL5qAailXGFYIExN3fgveLxvg
        me+OWrT3rK7XEHUGQZdAoDsPu/jpqmpzlg==
X-Google-Smtp-Source: APXvYqyYyjDad34/VA51fHiZQzYw2J9Yu+zjroePMoadmArI8dNHmsvcTOZeg+gH9qi+lrkOHAh0RVsD4ibk4A==
X-Received: by 2002:a63:4b48:: with SMTP id k8mr11683788pgl.362.1580495565001;
 Fri, 31 Jan 2020 10:32:45 -0800 (PST)
Date:   Fri, 31 Jan 2020 10:32:41 -0800
Message-Id: <20200131183241.140636-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH net] tcp: clear tp->data_segs{in|out} in tcp_disconnect()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tp->data_segs_in and tp->data_segs_out need to be cleared
in tcp_disconnect().

tcp_disconnect() is rarely used, but it is worth fixing it.

Fixes: a44d6eacdaf5 ("tcp: Add RFC4898 tcpEStatsPerfDataSegsOut/In")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
---
 net/ipv4/tcp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index a8ffdfb61f422228d4af1de600b756c9d3894ef5..3b601823f69a93dd20f9a4876945a87cd2196dc9 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2643,6 +2643,8 @@ int tcp_disconnect(struct sock *sk, int flags)
 	tp->bytes_acked = 0;
 	tp->bytes_received = 0;
 	tp->bytes_retrans = 0;
+	tp->data_segs_in = 0;
+	tp->data_segs_out = 0;
 	tp->duplicate_sack[0].start_seq = 0;
 	tp->duplicate_sack[0].end_seq = 0;
 	tp->dsack_dups = 0;
-- 
2.25.0.341.g760bfbb309-goog

