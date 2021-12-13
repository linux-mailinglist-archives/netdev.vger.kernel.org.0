Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56BFC4731DA
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 17:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240892AbhLMQ3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 11:29:37 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:35838 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240853AbhLMQ3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 11:29:34 -0500
Date:   Mon, 13 Dec 2021 17:29:31 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639412973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=khNiWXrbl57NC0XP5QkX2h9rtI4+lVZeQMf0zctQIj4=;
        b=bppupGI/5hIazabGEX6mGawvwh9FyinhmZlw9lE9wP/YqVSlN5GUVp1xHzyLLFT6dpBcmO
        j5cLTYUIh8dydvywnb+hU8QXaocGjVCi6vVISir3YIeEg/x9vuFJPR5eUKVYSV8JkWqMKa
        Hp3/hmyi6bwbC+gC8KsQ1kXrN1MsmR0rhekpNgjwlPrUQKpoubAofsSUKsaAl37Y0nMXNh
        0G2uUlLV29OzvKHdeAMqIhQyPUW5EDTUHw9KpwazLOqlqOMZ8BAqHDPee7jYQ8OvxkEMST
        PtOJUToSD+sKzZuDFrM01I5V+CPHETtcRJ6H1wpR9XZ71Wn4rJisVl9DLQ7QWQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639412973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=khNiWXrbl57NC0XP5QkX2h9rtI4+lVZeQMf0zctQIj4=;
        b=Adf0LzG1uoYhaqZ2J+ZsDll0LlZPHQgrJRawf/R0ZPPsv6wz95fgj73uCP9SR5SzLIc3Pr
        RAT3gfsJ7uQecKDQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH net-next] net: dev: Change the order of the arguments for the
 contended condition.
Message-ID: <Ybd06waO3S5y1Q6h@linutronix.de>
References: <YbN1OL0I1ja4Fwkb@linutronix.de>
 <20211210203256.09eec931@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YbckZ8VxICTThXOn@linutronix.de>
 <20211213081556.1a575a28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211213081556.1a575a28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the order of arguments and make qdisc_is_running() appear first.
This is more readable for the general case.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8438553c06b8e..6d73a55ddf5f9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3841,7 +3841,7 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 	 * sent after the qdisc owner is scheduled again. To prevent this
 	 * scenario the task always serialize on the lock.
 	 */
-	contended = IS_ENABLED(CONFIG_PREEMPT_RT) || qdisc_is_running(q);
+	contended = qdisc_is_running(q) || IS_ENABLED(CONFIG_PREEMPT_RT);
 	if (unlikely(contended))
 		spin_lock(&q->busylock);
 
-- 
2.34.1

