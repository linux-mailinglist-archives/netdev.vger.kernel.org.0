Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4B89F20E9
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 22:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfKFVlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 16:41:22 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34104 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbfKFVlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 16:41:21 -0500
Received: by mail-pg1-f193.google.com with SMTP id e4so18091801pgs.1
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 13:41:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=aL6gnC5HpuQh3/KHoadGe2OLXEz+jdXbIu1EwmcEd9s=;
        b=jpfgLjvFbMTpxj8vTyz5fOO2Us9RuUNv5+2dFtWEYxz03JU0ZXrYxVYtVYVJKmEoTa
         VSvpIC4GqaO7eqBpu2ETKjtx7uJaTlQ5NoIFxCds11HLcV1cHwmKGFGZKw0IczDsB05L
         64P/1xFr4cyF1ynkjEZVyA9o3NIcjsGWHq7/ng0dbn+wiSI95oc5OVfRXEoG39hQEnxZ
         YVHD2uSWMmlA4QBiEbF2r+qtqCCcs5AuRxeQiYQYM8uzuobYvThjCrAYo866VzepmO08
         nX6H+ya+UYuaRn5ZOVHO41MfBslPmOmKI6oT0DFynOpfITCJkoABTkBuQZMa1VSnhefU
         8Nqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aL6gnC5HpuQh3/KHoadGe2OLXEz+jdXbIu1EwmcEd9s=;
        b=IluBaT3yMU7qQW8bPn+pmMkYTQOEOQwCPlEPAYtpQT+kuyb+5CUWIsumTpIiYhUIXU
         BBUCg0WA+T8R5ZWas0ErIKXK8Wg6wfC2pshPP1FMNk7Ak5NQhwSfAd/yWq4V4cgx9cqr
         1MMMJSk5SyQ2pICB8zPwPf2d+sIeylMOSKCHxqogqycFuiXUbPJaM85xnhcF9DxjzeDE
         2yMAmVQ2vMWBBf1VVo8/pb4MZeZNpe8NpmkBTKIovbdcgbLwgfByRUD6AHmZ9Gy6WrFA
         fUahbiq72NdTCKR1JJAqkP5B/aQZu2RqCmYYD7DSbZ8GKOgEWYoAfqIAVnaC6AjUh/Xm
         N3Sw==
X-Gm-Message-State: APjAAAXNWkbu7QlaVqcXnVe/duTtduTW5wWonaSMyN2wSXL4a84edrGb
        AOCoARwgbUD2hzYul5vsfNsNJaFD80Y=
X-Google-Smtp-Source: APXvYqwdSZ/xTsOX/rBd/gmVzDqgnK9dAzMsdU9+UY0gGtGqPVa47m1CoKj86YXJYU4zmYUF9lLysA==
X-Received: by 2002:a65:4189:: with SMTP id a9mr23087pgq.380.1573076480835;
        Wed, 06 Nov 2019 13:41:20 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id l21sm3694707pjt.28.2019.11.06.13.41.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Nov 2019 13:41:20 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next] net: disable preempt for processed counter
Date:   Wed,  6 Nov 2019 13:41:06 -0800
Message-Id: <20191106214106.41237-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a kernel is built with CONFIG_PREEMPT and CONFIG_DEBUG_PREEMPT,
and a network driver is processing inbound data, we see

 BUG: using __this_cpu_add() in preemptible [00000000] code: nmd/4170
 caller is __this_cpu_preempt_check+0x18/0x20
 CPU: 1 PID: 4170 Comm: nmd Tainted: G           O    4.14.18 #1
 Hardware name: (xxxxx)
 Call trace:
 [<ffff0000080895d0>] dump_backtrace+0x0/0x2a0
 [<ffff000008089894>] show_stack+0x24/0x30
 [<ffff0000085ed64c>] dump_stack+0xac/0xf0
 [<ffff0000083bd538>] check_preemption_disabled+0xf8/0x100
 [<ffff0000083bd588>] __this_cpu_preempt_check+0x18/0x20
 [<ffff000008510f64>] __netif_receive_skb_core+0xa4/0xa10
 [<ffff000008514258>] __netif_receive_skb+0x28/0x80
 [<ffff0000085183b0>] netif_receive_skb_internal+0x30/0x120

We found that this gets hit inside of check_preemption_disabled(),
which is called by __netif_receive_skb_core() wanting to do a safe
per-cpu statistic increment with __this_cpu_inc(softnet_data.processed).
In order to be a safe increment, preemption needs to be disabled, but
in this case there are no calls to preempt_disable()/preempt_enable().
Note that a few lines later preempt_disable/preempt_enable() are used
around the call into do_xdp_generic().

This patch adds the preempt_disable()/preempt_enable() around
the call to __this_cpu_inc() as has been done in a few other
cases in the kernel.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 net/core/dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index bb15800c8cb5..ffda48def391 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4976,7 +4976,9 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 another_round:
 	skb->skb_iif = skb->dev->ifindex;
 
+	preempt_disable();
 	__this_cpu_inc(softnet_data.processed);
+	preempt_enable();
 
 	if (static_branch_unlikely(&generic_xdp_needed_key)) {
 		int ret2;
-- 
2.17.1

