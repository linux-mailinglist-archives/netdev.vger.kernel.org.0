Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C40D3FACF7
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 18:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235651AbhH2P7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 11:59:30 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net ([165.227.154.27]:58818
        "HELO zg8tmty1ljiyny4xntqumjca.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S235548AbhH2P73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 11:59:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id; bh=rgUZgbBBtTunyYwAzXQPQn5I+ZYWQlJxRslZk4bBoZ4=; b=q
        64EEFqLW+jM6DDmDr0CupQEoRgSnoYb4dgLsfRwUmmbJyOe16kEPfWHwRkt8PvPd
        97Wp12Gi5m9+Y/G6IRjqBpeBhyooIg3tsiMspYJiUKL9CECpAZ+OVwY4iYE9s//d
        aMv5rkVN3yBeCpSrLRVunNcjSs0dpXQYYWMwt+pIv8=
Received: from localhost.localdomain (unknown [223.104.213.4])
        by app2 (Coremail) with SMTP id XQUFCgBH_j+PrithQNdfAQ--.10733S3;
        Sun, 29 Aug 2021 23:58:07 +0800 (CST)
From:   Xiyu Yang <xiyuyang19@fudan.edu.cn>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Xiyu Yang <xiyuyang19@fudan.edu.cn>
Subject: [PATCH] net: sched: Fix qdisc_rate_table refcount leak when get tcf_block failed
Date:   Sun, 29 Aug 2021 23:58:01 +0800
Message-Id: <1630252681-71588-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: XQUFCgBH_j+PrithQNdfAQ--.10733S3
X-Coremail-Antispam: 1UD129KBjvdXoW7GF1UWw1Dtw1fGrW7Kw4rKrg_yoWfXFb_Gw
        n5WF1xZr10qr1UAwsrta95GryS9F1Ivws5ArWDKrWDX3yFyF98JFZYgry8XryfGF42k3s8
        Jr9Ig3s8Aw4I9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbsAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
        0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
        1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
        rcIFxwCY02Avz4vE14v_XrWl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr
        1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE
        14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7
        IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvE
        x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnU
        UI43ZEXa7VUjf-BJUUUUU==
X-CM-SenderInfo: irzsiiysuqikmy6i3vldqovvfxof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The reference counting issue happens in one exception handling path of
cbq_change_class(). When failing to get tcf_block, the function forgets
to decrease the refcount of "rtab" increased by qdisc_put_rtab(),
causing a refcount leak.

Fix this issue by jumping to "failure" label when get tcf_block failed.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
---
 net/sched/sch_cbq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index b79a7e27bb31..38a3a8394bbd 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -1614,7 +1614,7 @@ cbq_change_class(struct Qdisc *sch, u32 classid, u32 parentid, struct nlattr **t
 	err = tcf_block_get(&cl->block, &cl->filter_list, sch, extack);
 	if (err) {
 		kfree(cl);
-		return err;
+		goto failure;
 	}
 
 	if (tca[TCA_RATE]) {
-- 
2.7.4

