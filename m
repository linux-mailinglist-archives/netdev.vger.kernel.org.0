Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 047C251C06C
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379029AbiEENWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235022AbiEENV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:21:57 -0400
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.129.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A9D3E2D1F5
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 06:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651756697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bSE7VVBnWsfXxxTEbF0LrnB6UoyHMPPc7LdLn8ugniU=;
        b=VvD8kw0dqxdUh5h2n2uIDI7jEyzka4PdiczqbOCEY+aFHbJJhnZVpom3dTkGXEUG3Cvja+
        n0N8plJ7CRukRJP5hNZErE5wu7W1uqUMuWhEsUn9JDJ1vYPd3zZeMHr5fWgesL9c/1W+3x
        WpmOcxhnDOSERhaetqchjkhNwg3idXo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-139-JhhDd-uOM3eVMiD_xGdGGw-1; Thu, 05 May 2022 09:18:14 -0400
X-MC-Unique: JhhDd-uOM3eVMiD_xGdGGw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 527CD1C05AF3;
        Thu,  5 May 2022 13:18:14 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1589B463EC0;
        Thu,  5 May 2022 13:18:14 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id 04BE41C00FC; Thu,  5 May 2022 15:18:12 +0200 (CEST)
From:   Artem Savkov <asavkov@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Anna-Maria Behnsen <anna-maria@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Artem Savkov <asavkov@redhat.com>
Subject: [PATCH v5 1/2] timer: add a function to adjust timeouts to be upper bound
Date:   Thu,  5 May 2022 15:18:10 +0200
Message-Id: <20220505131811.3744503-2-asavkov@redhat.com>
In-Reply-To: <20220505131811.3744503-1-asavkov@redhat.com>
References: <87zgkwjtq2.ffs@tglx>
 <20220505131811.3744503-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current timer wheel implementation is optimized for performance and
energy usage but lacks in precision. This, normally, is not a problem as
most timers that use timer wheel are used for timeouts and thus rarely
expire, instead they often get canceled or modified before expiration.
Even when they don't, expiring a bit late is not an issue for timeout
timers.

TCP keepalive timer is a special case, it's aim is to prevent timeouts,
so triggering earlier rather than later is desired behavior. In a
reported case the user had a 3600s keepalive timer for preventing firewall
disconnects (on a 3650s interval). They observed keepalive timers coming
in up to four minutes late, causing unexpected disconnects.

Add a new upper_bound_timeout() function that takes a relative timeout
and adjusts it based on timer wheel granularity so that supplied value
effectively becomes an upper bound for the timer.

This was previously discussed here:
https://lore.kernel.org/all/20210302001054.4qgrvnkltvkgikzr@treble/T/#u

Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Artem Savkov <asavkov@redhat.com>
---
 include/linux/timer.h |  1 +
 kernel/time/timer.c   | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index fda13c9d1256..b209d31d543f 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -168,6 +168,7 @@ static inline int timer_pending(const struct timer_list * timer)
 	return !hlist_unhashed_lockless(&timer->entry);
 }
 
+extern unsigned long upper_bound_timeout(unsigned long timeout);
 extern void add_timer_on(struct timer_list *timer, int cpu);
 extern int del_timer(struct timer_list * timer);
 extern int mod_timer(struct timer_list *timer, unsigned long expires);
diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index 9dd2a39cb3b0..b087a481d06f 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -545,6 +545,20 @@ static int calc_wheel_index(unsigned long expires, unsigned long clk,
 	return idx;
 }
 
+/**
+ * upper_bound_timeout - return adjusted timeout
+ * @timeout: timeout value in jiffies
+ *
+ * This function return supplied timeout adjusted to timer wheel granularity
+ * effectively making supplied value an upper bound at which the timer will
+ * expire.
+ */
+unsigned long upper_bound_timeout(unsigned long timeout)
+{
+	return timeout - (timeout >> LVL_CLK_SHIFT);
+}
+EXPORT_SYMBOL(upper_bound_timeout);
+
 static void
 trigger_dyntick_cpu(struct timer_base *base, struct timer_list *timer)
 {
-- 
2.34.1

