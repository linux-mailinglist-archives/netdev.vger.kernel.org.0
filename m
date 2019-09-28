Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9ABC127B
	for <lists+netdev@lfdr.de>; Sun, 29 Sep 2019 01:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbfI1Xhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 19:37:33 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53449 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728666AbfI1Xhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 19:37:32 -0400
Received: by mail-wm1-f65.google.com with SMTP id i16so9515590wmd.3
        for <netdev@vger.kernel.org>; Sat, 28 Sep 2019 16:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=pc1gn553XzgE7FsOxqol2Go/JfJXO1epqVbTb4JKeko=;
        b=JQ98L5DM8Vpuj/2Hgp8S4jNZ21mJtn8aF92uYKitzkdUsn2+gt+FqtZJzsO6WQopbI
         DREMHtG2NtxgWNf/xaXp4H16f5Xp18o/ohXwZsRWjfsm999LqcDb39MEJE6aHbU7netW
         gxgd7/89t7d23aimzxqW9WIcnR9sWwwhCcyx7dHpSe5K46EGfKZcoE1DCw6k5XKSmtYN
         1DQuLpxejxzYVT1WdHpCNXshIUE18VE7UqODLVCZhuJ1FdgIMBTQY7wBsFh1qo+XloQl
         LF4ZMc8qVOrdPShpfpzV3SRdwTIKdczkYXthdRjJ3kBx+nQhL1fKANMzvNRamyj0IazI
         LYZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pc1gn553XzgE7FsOxqol2Go/JfJXO1epqVbTb4JKeko=;
        b=HxQBzHsC49KBt0Cc+MIwoyaoVRcS3wWnRNLa3TcCJCfwf6HR3svdZBtd8+SJdnqcqe
         +kN1N6jp0zXB5CB+86ms1G1Q3paoQDAboshSXH+66AVpuF7L5S38poCXorE3f6UnI6zc
         tTne6L5KJSYMfk3ms6KganWALyfVNNjXFDnoiPKsUw/rNGmolWNz6DZUAvSENgaLmMHx
         Q2mxrlh5M6WwjOvz8/9Uy6VOxQod06ggXzXY0HsqmNQSARYZ0hlefYvQOIGbo6hXxmBK
         dqYAOdxE6n91HQBHHfOzBtO8f4Bvxrr+ItmAuZXlrIMR7Kq17CM5H50m5Z726vRC73Yr
         IXIg==
X-Gm-Message-State: APjAAAVTf7Gh1GKvYCgKe9rwhrWC4AWmTGdQ9DZj0h7jA5NBKWjbSkfL
        Qnt2HSLCPWLx1aO5kVqMX9Y=
X-Google-Smtp-Source: APXvYqxKW0wO5M1A46X7I+Z23HwHS5eyk97WSt6tXODZOvUyQtEhxo9jeBr1i8LqM56I4dlOYoZBAw==
X-Received: by 2002:a1c:3cc3:: with SMTP id j186mr11451827wma.119.1569713849861;
        Sat, 28 Sep 2019 16:37:29 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id z4sm5481970wrh.93.2019.09.28.16.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Sep 2019 16:37:29 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, vinicius.gomes@intel.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net] net: sched: taprio: Avoid division by zero on invalid link speed
Date:   Sun, 29 Sep 2019 02:37:22 +0300
Message-Id: <20190928233722.15054-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The check in taprio_set_picos_per_byte is currently not robust enough
and will trigger this division by zero, due to e.g. PHYLINK not setting
kset->base.speed when there is no PHY connected:

[   27.109992] Division by zero in kernel.
[   27.113842] CPU: 1 PID: 198 Comm: tc Not tainted 5.3.0-rc5-01246-gc4006b8c2637-dirty #212
[   27.121974] Hardware name: Freescale LS1021A
[   27.126234] [<c03132e0>] (unwind_backtrace) from [<c030d8b8>] (show_stack+0x10/0x14)
[   27.133938] [<c030d8b8>] (show_stack) from [<c10b21b0>] (dump_stack+0xb0/0xc4)
[   27.141124] [<c10b21b0>] (dump_stack) from [<c10af97c>] (Ldiv0_64+0x8/0x18)
[   27.148052] [<c10af97c>] (Ldiv0_64) from [<c0700260>] (div64_u64+0xcc/0xf0)
[   27.154978] [<c0700260>] (div64_u64) from [<c07002d0>] (div64_s64+0x4c/0x68)
[   27.161993] [<c07002d0>] (div64_s64) from [<c0f3d890>] (taprio_set_picos_per_byte+0xe8/0xf4)
[   27.170388] [<c0f3d890>] (taprio_set_picos_per_byte) from [<c0f3f614>] (taprio_change+0x668/0xcec)
[   27.179302] [<c0f3f614>] (taprio_change) from [<c0f2bc24>] (qdisc_create+0x1fc/0x4f4)
[   27.187091] [<c0f2bc24>] (qdisc_create) from [<c0f2c0c8>] (tc_modify_qdisc+0x1ac/0x6f8)
[   27.195055] [<c0f2c0c8>] (tc_modify_qdisc) from [<c0ee9604>] (rtnetlink_rcv_msg+0x268/0x2dc)
[   27.203449] [<c0ee9604>] (rtnetlink_rcv_msg) from [<c0f4fef0>] (netlink_rcv_skb+0xe0/0x114)
[   27.211756] [<c0f4fef0>] (netlink_rcv_skb) from [<c0f4f6cc>] (netlink_unicast+0x1b4/0x22c)
[   27.219977] [<c0f4f6cc>] (netlink_unicast) from [<c0f4fa84>] (netlink_sendmsg+0x284/0x340)
[   27.228198] [<c0f4fa84>] (netlink_sendmsg) from [<c0eae5fc>] (sock_sendmsg+0x14/0x24)
[   27.235988] [<c0eae5fc>] (sock_sendmsg) from [<c0eaedf8>] (___sys_sendmsg+0x214/0x228)
[   27.243863] [<c0eaedf8>] (___sys_sendmsg) from [<c0eb015c>] (__sys_sendmsg+0x50/0x8c)
[   27.251652] [<c0eb015c>] (__sys_sendmsg) from [<c0301000>] (ret_fast_syscall+0x0/0x54)
[   27.259524] Exception stack(0xe8045fa8 to 0xe8045ff0)
[   27.264546] 5fa0:                   b6f608c8 000000f8 00000003 bed7e2f0 00000000 00000000
[   27.272681] 5fc0: b6f608c8 000000f8 004ce54c 00000128 5d3ce8c7 00000000 00000026 00505c9c
[   27.280812] 5fe0: 00000070 bed7e298 004ddd64 b6dd1e64

Russell King points out that the ethtool API says zero is a valid return
value of __ethtool_get_link_ksettings:

   * If it is enabled then they are read-only; if the link
   * is up they represent the negotiated link mode; if the link is down,
   * the speed is 0, %SPEED_UNKNOWN or the highest enabled speed and
   * @duplex is %DUPLEX_UNKNOWN or the best enabled duplex mode.

  So, it seems that taprio is not following the API... I'd suggest either
  fixing taprio, or getting agreement to change the ethtool API.

The chosen path was to fix taprio.

Fixes: 7b9eba7ba0c1 ("net/sched: taprio: fix picos_per_byte miscalculation")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
This has a mechanical merge conflict with "[PATCH v2 net] net: sched:
taprio: Fix potential integer overflow in taprio_set_picos_per_byte"
unless that patch is applied first.

 net/sched/sch_taprio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 2aab46ada94f..68b543f85a96 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1044,7 +1044,7 @@ static void taprio_set_picos_per_byte(struct net_device *dev,
 	if (err < 0)
 		goto skip;
 
-	if (ecmd.base.speed != SPEED_UNKNOWN)
+	if (ecmd.base.speed && ecmd.base.speed != SPEED_UNKNOWN)
 		speed = ecmd.base.speed;
 
 skip:
-- 
2.17.1

