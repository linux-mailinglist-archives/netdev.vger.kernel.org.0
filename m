Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 368D7E0E74
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 01:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388126AbfJVXLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 19:11:16 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38028 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728076AbfJVXLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 19:11:16 -0400
Received: by mail-pg1-f195.google.com with SMTP id w3so10883759pgt.5
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 16:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HqYClyx4AWhlD7zebpm8wQ+3M2kiFr4SH53W39ZQQmQ=;
        b=ZL4C6hDztk1gj/qkRQT9QZxgSk1aKpst2mHHcumYKojWJqHh6zLfjTZ5LXzzwK6KYV
         STvUAc0ZUCJrnfZj6prtcAZZaW/obp34l4M1lJRyQYiWWBHGDgCmNuzsM2SVU7zVO0D5
         kTyfmf2Xwsk+j9b1XU5/UnwT2RI1YDOd/Uc8JbL5rBbgWX01wMprsBw1p3dLF1IWhTR8
         bATR/PoWtogrcfQplEUeo+5NSXJ7eGdoK6ch5nDOphbPded/pRszkEMxh5NK04S8MPco
         KOBk8XsWlWwXq3fMZHUwp+7HfGMmasA8j1hJ5mTs2eujCdpn6jGB78lE37bLUO6KJKfK
         U58Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HqYClyx4AWhlD7zebpm8wQ+3M2kiFr4SH53W39ZQQmQ=;
        b=rC2BN67xCAqmcsksWUYP0TWW6N2wcV6PnvwVZDFDzNlNtYXX3qQQIiUt9RDZa/HTZI
         XysmQo9NmY4uQae0XSSD3dNl3DoZai03mIKdu1c7NALiIZ+qjoB85L+c9MKaAn8QCUpv
         BwMnFfx07ORKqf03JR/EA1x8MmWF6aUtLc9JNskfmcRTXW/ZG5sxAusde9euu5TYETUo
         TQZHI21xOMe6i25e+r82dL3I+G8Trkt+CQ+E+WccL9J4kgkTZf8YrbZbdGMxVRy0nVnc
         wvwMcyCnvCenD9NtaG/ciEH1uZebn7cn4783VS/ynxNsPp71fv79NrEwvXkKNKwPhvEk
         WnzQ==
X-Gm-Message-State: APjAAAVJZghD6n6Y12/kfRhCn0TZ24Yv+gn3R1ky+FL9gsi/buXnKyMp
        F2Ygt4d33QKCcX696tDKfnkOpUZm
X-Google-Smtp-Source: APXvYqxxzjkvGW+tlWJgvfF7RA9EL3a3xYTgywzVqZ9GAaILi5UNnTkVcWaqzxD5u0v8xW0PhhPcyg==
X-Received: by 2002:a17:90b:d90:: with SMTP id bg16mr7704318pjb.143.1571785875312;
        Tue, 22 Oct 2019 16:11:15 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id j24sm20619284pff.71.2019.10.22.16.11.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 16:11:14 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     ycheng@google.com, ncardwell@google.com, edumazet@google.com,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [Patch net-next 1/3] tcp: get rid of ICSK_TIME_EARLY_RETRANS
Date:   Tue, 22 Oct 2019 16:10:49 -0700
Message-Id: <20191022231051.30770-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191022231051.30770-1-xiyou.wangcong@gmail.com>
References: <20191022231051.30770-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit bec41a11dd3d ("tcp: remove early retransmit")
ICSK_TIME_EARLY_RETRANS is no longer effective, so we can remove
its definition too.

Cc: Yuchung Cheng <ycheng@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 include/net/inet_connection_sock.h | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 895546058a20..e46958460739 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -142,9 +142,8 @@ struct inet_connection_sock {
 #define ICSK_TIME_RETRANS	1	/* Retransmit timer */
 #define ICSK_TIME_DACK		2	/* Delayed ack timer */
 #define ICSK_TIME_PROBE0	3	/* Zero window probe timer */
-#define ICSK_TIME_EARLY_RETRANS 4	/* Early retransmit timer */
-#define ICSK_TIME_LOSS_PROBE	5	/* Tail loss probe timer */
-#define ICSK_TIME_REO_TIMEOUT	6	/* Reordering timer */
+#define ICSK_TIME_LOSS_PROBE	4	/* Tail loss probe timer */
+#define ICSK_TIME_REO_TIMEOUT	5	/* Reordering timer */
 
 static inline struct inet_connection_sock *inet_csk(const struct sock *sk)
 {
@@ -227,8 +226,7 @@ static inline void inet_csk_reset_xmit_timer(struct sock *sk, const int what,
 	}
 
 	if (what == ICSK_TIME_RETRANS || what == ICSK_TIME_PROBE0 ||
-	    what == ICSK_TIME_EARLY_RETRANS || what == ICSK_TIME_LOSS_PROBE ||
-	    what == ICSK_TIME_REO_TIMEOUT) {
+	    what == ICSK_TIME_LOSS_PROBE || what == ICSK_TIME_REO_TIMEOUT) {
 		icsk->icsk_pending = what;
 		icsk->icsk_timeout = jiffies + when;
 		sk_reset_timer(sk, &icsk->icsk_retransmit_timer, icsk->icsk_timeout);
-- 
2.21.0

