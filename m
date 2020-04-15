Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE781A9710
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 10:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894795AbgDOIkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 04:40:39 -0400
Received: from mail.fudan.edu.cn ([202.120.224.10]:34153 "EHLO fudan.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2894777AbgDOIka (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 04:40:30 -0400
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Apr 2020 04:40:27 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id; bh=+7ymPy9X5j+FaNt3AHq7PMuOVkMbwkiPlxtK3UBUMTw=; b=u
        04oYSc7tk0cfjSIke3bOGW3JxrcDlCqpiux8KCJ5Eboeh9sb7NcnebuvYit1DemF
        ZFeXCu6gKj5PyIWUkJQW0L0DbS/gqAOOd2ENh1tftYBQSoZLlM8pVEQOqJBNl/6h
        lCs9vthKbMCat/c5wYs68Dx5B05jCyeR3dZAzm5MqA=
Received: from localhost.localdomain (unknown [120.229.255.108])
        by app1 (Coremail) with SMTP id XAUFCgAHzSxyyJZejoVFAA--.36467S3;
        Wed, 15 Apr 2020 16:40:19 +0800 (CST)
From:   Xiyu Yang <xiyuyang19@fudan.edu.cn>
To:     Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc:     yuanxzhang@fudan.edu.cn, kjlu@umn.edu,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: [PATCH] tipc: Fix potential tipc_aead refcnt leak in tipc_crypto_rcv
Date:   Wed, 15 Apr 2020 16:39:56 +0800
Message-Id: <1586939996-69937-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: XAUFCgAHzSxyyJZejoVFAA--.36467S3
X-Coremail-Antispam: 1UD129KBjvJXoWrurW7XF1rAryUWw1rZr1rXrb_yoW8Jr1xp3
        yUC39rArn5Gr4DKan5GF93K348Gry7urZxWFZ8uF15XFsFqw1IyrySqrWj9ry5uFWUArWq
        vrZYvw1Y9F45uFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9K14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26rxl
        6s0DM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAG
        YxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkIecxEwVAFwVW8ZwCF04k20xvY0x0EwIxGrw
        CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
        14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
        IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAv
        wI8IcIk0rVW8JVW3JwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14
        v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUePfQDUUUU
X-CM-SenderInfo: irzsiiysuqikmy6i3vldqovvfxof0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tipc_crypto_rcv() invokes tipc_aead_get(), which returns a reference of
the tipc_aead object to "aead" with increased refcnt.

When tipc_crypto_rcv() returns, the original local reference of "aead"
becomes invalid, so the refcount should be decreased to keep refcount
balanced.

The issue happens in one error path of tipc_crypto_rcv(). When TIPC
message decryption status is EINPROGRESS or EBUSY, the function forgets
to decrease the refcnt increased by tipc_aead_get() and causes a refcnt
leak.

Fix this issue by calling tipc_aead_put() on the error path when TIPC
message decryption status is EINPROGRESS or EBUSY.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
 net/tipc/crypto.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index c8c47fc72653..8c47ded2edb6 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -1712,6 +1712,7 @@ int tipc_crypto_rcv(struct net *net, struct tipc_crypto *rx,
 	case -EBUSY:
 		this_cpu_inc(stats->stat[STAT_ASYNC]);
 		*skb = NULL;
+		tipc_aead_put(aead);
 		return rc;
 	default:
 		this_cpu_inc(stats->stat[STAT_NOK]);
-- 
2.7.4

