Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA2C2789BD
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 15:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbgIYNiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 09:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728199AbgIYNiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 09:38:16 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E49AC0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 06:38:16 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id t4so1651484qvr.21
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 06:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=VKFy9NipztlVM5FZv5eOUlqWAx0IyNbosavXJT4Xbec=;
        b=Tx0jFyXrd98OQfFj3FTn3WKpM7a/7stCsTx8YY3dUVlQC0E6W/jsRud9ULTwmUIe8s
         GnDhkFi9b9dC2UBZi0heoPIEw4tJU9htz0SCvoV6TsH9Xa5w6Y7UjiVdWXWvmw86jfXH
         fbJ7kM/I4a5/OZLLyPUtOaf5y0UkZolSnuG++1ci9y3/L+GRtc3MVcqFGs+00+wnhw6X
         QZCjEkvZoW/U4w+FhplJjAheaPSvqllCchXFAglnNWwbQep1fXVz9HbxTITMGI9ZBEsx
         z8TCW8INlN69myDgn8jiRKUJOJOrRMy4H+26D15r5uRoZZBtpInza90ilWXUDnvItBbq
         J/cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VKFy9NipztlVM5FZv5eOUlqWAx0IyNbosavXJT4Xbec=;
        b=XveAIffZH0ZJtqPd/LMQqgNTEmSA9UZ+h2pnhVONIDkf8KwbComifJA36nt56wOsxd
         KSRrUi7fEzMsQi2rABGE6JpF3fOdCvueXsMTfda4gt98IYnFWyna9Ibz00JXYI9pnvG6
         80HIys1OzrFtpRXUEshnUCMJL6Qy/MhmPJJq1LvyZIup9+JCmSlH2vWgXt0+M2Vug9qk
         Vnq+otXuWGjUdjEtqyNS7HVyRHdHzTrWqa1ksFmOyWz9qbo5W1mlQkigBvv1Fy3Sd2Po
         gEDdfYPJLYpPNpblrIG6XoTv0hoOW67bA48CWNwCrwH7yyOL0MD2ZP2yijcYKQnjqg+m
         M1nQ==
X-Gm-Message-State: AOAM530+Jdi6mBa5CFcw/sa5tFvyMzyY5qaZZVq0G4nNetnRKy/UJ5Zq
        Kia8ib/IbCCT68iydheTH06M1w1wTV5tvA==
X-Google-Smtp-Source: ABdhPJxigR7ug5Ii0Pq+KacqAMiZBMM4t28bpheDXNeV9Gs/5f1k6cFcDvodWldhj5U6i99iTwbdIowrQHhPNQ==
Sender: "edumazet via sendgmr" <edumazet@edumazet1.svl.corp.google.com>
X-Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
 (user=edumazet job=sendgmr) by 2002:ad4:5565:: with SMTP id
 w5mr4351508qvy.24.1601041094131; Fri, 25 Sep 2020 06:38:14 -0700 (PDT)
Date:   Fri, 25 Sep 2020 06:38:07 -0700
In-Reply-To: <20200925133808.1242950-1-edumazet@google.com>
Message-Id: <20200925133808.1242950-2-edumazet@google.com>
Mime-Version: 1.0
References: <20200925133808.1242950-1-edumazet@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH net 1/2] bonding: set dev->needed_headroom in bond_setup_by_slave()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot managed to crash a host by creating a bond
with a GRE device.

For non Ethernet device, bonding calls bond_setup_by_slave()
instead of ether_setup(), and unfortunately dev->needed_headroom
was not copied from the new added member.

[  171.243095] skbuff: skb_under_panic: text:ffffffffa184b9ea len:116 put:20 head:ffff883f84012dc0 data:ffff883f84012dbc tail:0x70 end:0xd00 dev:bond0
[  171.243111] ------------[ cut here ]------------
[  171.243112] kernel BUG at net/core/skbuff.c:112!
[  171.243117] invalid opcode: 0000 [#1] SMP KASAN PTI
[  171.243469] gsmi: Log Shutdown Reason 0x03
[  171.243505] Call Trace:
[  171.243506]  <IRQ>
[  171.243512]  [<ffffffffa171be59>] skb_push+0x49/0x50
[  171.243516]  [<ffffffffa184b9ea>] ipgre_header+0x2a/0xf0
[  171.243520]  [<ffffffffa17452d7>] neigh_connected_output+0xb7/0x100
[  171.243524]  [<ffffffffa186f1d3>] ip6_finish_output2+0x383/0x490
[  171.243528]  [<ffffffffa186ede2>] __ip6_finish_output+0xa2/0x110
[  171.243531]  [<ffffffffa186acbc>] ip6_finish_output+0x2c/0xa0
[  171.243534]  [<ffffffffa186abe9>] ip6_output+0x69/0x110
[  171.243537]  [<ffffffffa186ac90>] ? ip6_output+0x110/0x110
[  171.243541]  [<ffffffffa189d952>] mld_sendpack+0x1b2/0x2d0
[  171.243544]  [<ffffffffa189d290>] ? mld_send_report+0xf0/0xf0
[  171.243548]  [<ffffffffa189c797>] mld_ifc_timer_expire+0x2d7/0x3b0
[  171.243551]  [<ffffffffa189c4c0>] ? mld_gq_timer_expire+0x50/0x50
[  171.243556]  [<ffffffffa0fea270>] call_timer_fn+0x30/0x130
[  171.243559]  [<ffffffffa0fea17c>] expire_timers+0x4c/0x110
[  171.243563]  [<ffffffffa0fea0e3>] __run_timers+0x213/0x260
[  171.243566]  [<ffffffffa0fecb7d>] ? ktime_get+0x3d/0xa0
[  171.243570]  [<ffffffffa0ff9c4e>] ? clockevents_program_event+0x7e/0xe0
[  171.243574]  [<ffffffffa0f7e5d5>] ? sched_clock_cpu+0x15/0x190
[  171.243577]  [<ffffffffa0fe973d>] run_timer_softirq+0x1d/0x40
[  171.243581]  [<ffffffffa1c00152>] __do_softirq+0x152/0x2f0
[  171.243585]  [<ffffffffa0f44e1f>] irq_exit+0x9f/0xb0
[  171.243588]  [<ffffffffa1a02e1d>] smp_apic_timer_interrupt+0xfd/0x1a0
[  171.243591]  [<ffffffffa1a01ea6>] apic_timer_interrupt+0x86/0x90

Fixes: f5184d267c1a ("net: Allow netdevices to specify needed head/tailroom")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 drivers/net/bonding/bond_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 42ef25ec0af5b089365c5a0b0378c40c22db1afe..14740d3053b8ad2b0b0fcbe6666a44bca384bb7d 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1315,6 +1315,7 @@ static void bond_setup_by_slave(struct net_device *bond_dev,
 
 	bond_dev->type		    = slave_dev->type;
 	bond_dev->hard_header_len   = slave_dev->hard_header_len;
+	bond_dev->needed_headroom   = slave_dev->needed_headroom;
 	bond_dev->addr_len	    = slave_dev->addr_len;
 
 	memcpy(bond_dev->broadcast, slave_dev->broadcast,
-- 
2.28.0.681.g6f77f65b4e-goog

