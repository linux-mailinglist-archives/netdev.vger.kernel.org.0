Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1DC54228B7
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 15:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235963AbhJENyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 09:54:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235480AbhJENxF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 09:53:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC62E61989;
        Tue,  5 Oct 2021 13:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441870;
        bh=OTrccWwKPffRiq3S6lIt8TgRqj+9/RN0ax0h0LgFrls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oNKZ6yxRKPie7Fg07LuPpcALLxRuWgOw/vB2Vk1LIZ+u7r6cOw2JO8rItrzEaCYV2
         qp4+y8BhqLblvcTHBNZ1KEenNN8lh1TNxIMlP3Rqhjzr2eb2KaEnm5mWYomhSNgX2X
         Kh4ZB3h78dE6P+45obM8QRiGBtCdKKd07F/vUtmeUL7RvxrBiZAYCt1jmGWh7eonw0
         B/SMzjn2vHSn6vWfzDmTnw47nToECxtgUn/ZZjz6W+7cbJtU4eF2M4y9MZ7hzzIyvO
         koGfkWgDyeF0+ZEmptSTNA4MldcZi72yZj3icMhSZgHRNYH7A//hUQY6b3CDYAqkj/
         yB1DlwdZVPHNw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?=E7=8E=8B=E8=B4=87?= <yun.wang@linux.alibaba.com>,
        Abaci <abaci@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 25/40] net: prevent user from passing illegal stab size
Date:   Tue,  5 Oct 2021 09:50:04 -0400
Message-Id: <20211005135020.214291-25-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: 王贇 <yun.wang@linux.alibaba.com>

[ Upstream commit b193e15ac69d56f35e1d8e2b5d16cbd47764d053 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/pkt_sched.h | 1 +
 net/sched/sch_api.c     | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 6d7b12cba015..bf79f3a890af 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -11,6 +11,7 @@
 #include <uapi/linux/pkt_sched.h>
 
 #define DEFAULT_TX_QUEUE_LEN	1000
+#define STAB_SIZE_LOG_MAX	30
 
 struct qdisc_walker {
 	int	stop;
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index f87d07736a14..148edd0e71e3 100644
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
2.33.0

