Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803DD2EFF4E
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 13:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbhAIMCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 07:02:40 -0500
Received: from spam.zju.edu.cn ([61.164.42.155]:13930 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726001AbhAIMCk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 07:02:40 -0500
Received: from localhost.localdomain (unknown [10.192.85.18])
        by mail-app4 (Coremail) with SMTP id cS_KCgDnyR4Rm_lfDiw3AA--.54507S4;
        Sat, 09 Jan 2021 20:01:24 +0800 (CST)
From:   Dinghao Liu <dinghao.liu@zju.edu.cn>
To:     dinghao.liu@zju.edu.cn, kjlu@umn.edu
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] netfilter: Fix memleak in nf_nat_init
Date:   Sat,  9 Jan 2021 20:01:21 +0800
Message-Id: <20210109120121.15938-1-dinghao.liu@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cS_KCgDnyR4Rm_lfDiw3AA--.54507S4
X-Coremail-Antispam: 1UD129KBjvdXoWrtw4UZr47CFyrGr4fKFykKrg_yoW3WFc_tr
        y0qryIqFn5Gr17Ww4Y9FsrXr18ua4xZF1fX34xXFW8A3s5X3W0kFZ3ur95Aa47Ww4SkryU
        CrWDKF1Iv3sF9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbVkFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AK
        wVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20x
        vE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E
        87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
        8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
        Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
        xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IY
        c2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VW8uw4UJr1UMxC20s026xCaFVCjc4AY6r1j6r
        4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
        67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
        x0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAI
        cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
        nxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgoABlZdtR6GKAAEsE
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When register_pernet_subsys() fails, nf_nat_bysource
should be freed just like when nf_ct_extend_register()
fails.

Fixes: 1cd472bf036ca ("netfilter: nf_nat: add nat hook register functions to nf_nat")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
---
 net/netfilter/nf_nat_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index ea923f8cf9c4..b7c3c902290f 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1174,6 +1174,7 @@ static int __init nf_nat_init(void)
 	ret = register_pernet_subsys(&nat_net_ops);
 	if (ret < 0) {
 		nf_ct_extend_unregister(&nat_extend);
+		kvfree(nf_nat_bysource);
 		return ret;
 	}
 
-- 
2.17.1

