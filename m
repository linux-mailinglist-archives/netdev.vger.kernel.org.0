Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16594415A95
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 11:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240095AbhIWJJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 05:09:48 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:36872 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239985AbhIWJJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 05:09:47 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UpJU6BM_1632388093;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0UpJU6BM_1632388093)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 23 Sep 2021 17:08:14 +0800
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:TC subsystem" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Subject: [PATCH] net: prevent user from passing illegal stab size
Message-ID: <da8bd5e9-0476-d75b-4669-0a21637663b2@linux.alibaba.com>
Date:   Thu, 23 Sep 2021 17:08:13 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
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

it seems like kernel won't check the stab size_log passing from
user, and will use the insane value later to calculate pkt_len.

This patch just add a check on the size_log to avoid insane
calculation.

Reported-by: Abaci <abaci@linux.alibaba.com>
Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
---
 include/uapi/linux/pkt_sched.h | 1 +
 net/sched/sch_api.c            | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index ec88590..fa194a0 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -98,6 +98,7 @@ struct tc_ratespec {
 };

 #define TC_RTAB_SIZE	1024
+#define TC_LOG_MAX	30

 struct tc_sizespec {
 	unsigned char	cell_log;
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 5e90e9b..1b6b8f8 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -513,6 +513,9 @@ static struct qdisc_size_table *qdisc_get_stab(struct nlattr *opt,
 		return stab;
 	}

+	if (s->size_log > TC_LOG_MAX)
+		return ERR_PTR(-EINVAL);
+
 	stab = kmalloc(sizeof(*stab) + tsize * sizeof(u16), GFP_KERNEL);
 	if (!stab)
 		return ERR_PTR(-ENOMEM);
-- 
1.8.3.1

