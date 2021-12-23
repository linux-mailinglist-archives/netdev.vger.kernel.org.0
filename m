Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F077247DDDB
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 03:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346039AbhLWCvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 21:51:02 -0500
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net ([165.227.154.27]:48458
        "HELO zg8tmty1ljiyny4xntqumjca.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S238419AbhLWCvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 21:51:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id:MIME-Version:Content-Transfer-Encoding; bh=63p8I4rdEf
        +g9H7ROy0pCMr473Tk1W9pYC57QWiVMTI=; b=Yt5dPsvDcDlhD94sSYJJxJ6Xn1
        iTSCQ6m+KL2bR3NpEm/2WJoAGlh2tWh9t8RLejivNCj1fgsKUz8CyJLo23HLcYZi
        NrvPRxgwAD4sPgpkmVyzYPfs6S26Qso/PQq9sZ2NwnRNNn2eWf33fUKmvWUuNM28
        aY4fCj8MmPRTMRViA=
Received: from localhost.localdomain (unknown [10.102.225.147])
        by app1 (Coremail) with SMTP id XAUFCgDnx6Tj48Nh9igTAA--.1148S4;
        Thu, 23 Dec 2021 10:50:18 +0800 (CST)
From:   Xin Xiong <xiongx18@fudan.edu.cn>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     yuanxzhang@fudan.edu.cn, Xin Xiong <xiongx18@fudan.edu.cn>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: [PATCH] netfilter: ipt_CLUSTERIP: fix refcount leak in clusterip_tg_check()
Date:   Thu, 23 Dec 2021 10:48:12 +0800
Message-Id: <20211223024811.4519-1-xiongx18@fudan.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: XAUFCgDnx6Tj48Nh9igTAA--.1148S4
X-Coremail-Antispam: 1UD129KBjvJXoW7tryktFW5Kry5tFy5Wr1ftFb_yoW8GrW5pr
        43K343JFyDGF1rXFWkt3Z7Wa45Cr9xJr4xC3yUZa95Gwn8ArWrAanIkrnxZF18CrZ5Jrn8
        JFyFka1Y9rs8AFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9C14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26rxl
        6s0DM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAG
        YxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkIecxEwVCm-wCF04k20xvY0x0EwIxGrwCFx2
        IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v2
        6r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67
        AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IY
        s7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI
        0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUPGYJUUUUU=
X-CM-SenderInfo: arytiiqsuqiimz6i3vldqovvfxof0/1tbiAg8EEFKp2hMppAAAsm
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The issue takes place in one error path of clusterip_tg_check(). When
memcmp() returns nonzero, the function simply returns the error code,
forgetting to decrease the reference count of a clusterip_config
object, which is bumped earlier by clusterip_config_find_get(). This
may incur reference count leak.

Fix this issue by decrementing the refcount of the object in specific
error path.

Signed-off-by: Xin Xiong <xiongx18@fudan.edu.cn>
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 8fd1aba8a..b518f20c9 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -520,8 +520,11 @@ static int clusterip_tg_check(const struct xt_tgchk_param *par)
 			if (IS_ERR(config))
 				return PTR_ERR(config);
 		}
-	} else if (memcmp(&config->clustermac, &cipinfo->clustermac, ETH_ALEN))
+	} else if (memcmp(&config->clustermac, &cipinfo->clustermac, ETH_ALEN)) {
+		clusterip_config_entry_put(config);
+		clusterip_config_put(config);
 		return -EINVAL;
+	}
 
 	ret = nf_ct_netns_get(par->net, par->family);
 	if (ret < 0) {
-- 
2.25.1

