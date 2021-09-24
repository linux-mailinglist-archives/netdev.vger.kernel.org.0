Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7164416A0C
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 04:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243918AbhIXChf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 22:37:35 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:59721 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233314AbhIXChe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 22:37:34 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UpOL48y_1632450958;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0UpOL48y_1632450958)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 24 Sep 2021 10:35:59 +0800
Subject: [PATCH v2] net: prevent user from passing illegal stab size
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:TC subsystem" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <da8bd5e9-0476-d75b-4669-0a21637663b2@linux.alibaba.com>
Message-ID: <afa1a88b-e4c2-9ad9-939c-b2d1e71fca11@linux.alibaba.com>
Date:   Fri, 24 Sep 2021 10:35:58 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <da8bd5e9-0476-d75b-4669-0a21637663b2@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We observed below report when playing with netlink sock:

  UBSAN: shift-out-of-bounds in net/sched/sch_api.c:580:10
  shift exponent 249 is too large for 32-bit type
  CPU: 0 PID: 685 Comm: a.out Not tainted
  Call Trace:
   dump_stack_lvl+0x8d/0xcf
   ubsan_epilogue+0xa/0x4e
   __ubsan_handle_shift_out_of_bounds+0x161/0x182
   __qdisc_calculate_pkt_len+0xf0/0x190
   __dev_queue_xmit+0x2ed/0x15b0

it seems like kernel won't check the stab log value passing from
user, and will use the insane value later to calculate pkt_len.

This patch just add a check on the size/cell_log to avoid insane
calculation.

Reported-by: Abaci <abaci@linux.alibaba.com>
Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
---
 include/net/pkt_sched.h | 1 +
 net/sched/sch_api.c     | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 6d7b12c..bf79f3a 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -11,6 +11,7 @@
 #include <uapi/linux/pkt_sched.h>

 #define DEFAULT_TX_QUEUE_LEN	1000
+#define STAB_SIZE_LOG_MAX	30

 struct qdisc_walker {
 	int	stop;
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 5e90e9b..12f39a2 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -513,6 +513,12 @@ static struct qdisc_size_table *qdisc_get_stab(struct nlattr *opt,
 		return stab;
 	}

+	if (s->size_log > STAB_SIZE_LOG_MAX ||
+	    s->cell_log > STAB_SIZE_LOG_MAX) {
+		NL_SET_ERR_MSG(extack, "Invalid logarithmic size of size table");
+		return ERR_PTR(-EINVAL);
+	}
+
 	stab = kmalloc(sizeof(*stab) + tsize * sizeof(u16), GFP_KERNEL);
 	if (!stab)
 		return ERR_PTR(-ENOMEM);
-- 
1.8.3.1


