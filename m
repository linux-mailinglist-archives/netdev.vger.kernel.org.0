Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 391AD47ECD3
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 08:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241462AbhLXHrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 02:47:18 -0500
Received: from smtp25.cstnet.cn ([159.226.251.25]:49262 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234111AbhLXHrQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Dec 2021 02:47:16 -0500
Received: from localhost.localdomain (unknown [124.16.138.126])
        by APP-05 (Coremail) with SMTP id zQCowADHz3_nesVh5yjNBA--.10329S2;
        Fri, 24 Dec 2021 15:46:47 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH] net/tipc: Check null mem pointer
Date:   Fri, 24 Dec 2021 15:46:46 +0800
Message-Id: <20211224074646.1588903-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: zQCowADHz3_nesVh5yjNBA--.10329S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Xw4kZF17XF4rKw18Wr18uFg_yoWDCFXE9r
        WSqF15W348Gwn5uFWjv3yv9F93twsrW3W8W3sayFWjka4kGrykWrWDWrn3JrWSkF43Wwn8
        Ga98tF15Xr17ujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbckFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_GF4l
        42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJV
        WUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAK
        I48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r
        4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF
        0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUffHUUUUUU=
X-Originating-IP: [124.16.138.126]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the possible alloc failure of the kmemdup(), it may return null
pointer.
Therefore, the returned pointer should be checked to guarantee the
success of the init.

Fixes: fc1b6d6de220 ("tipc: introduce TIPC encryption & authentication")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 net/tipc/crypto.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index c9391d38de85..19015e08e750 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -596,7 +596,14 @@ static int tipc_aead_init(struct tipc_aead **aead, struct tipc_aead_key *ukey,
 	tmp->mode = mode;
 	tmp->cloned = NULL;
 	tmp->authsize = TIPC_AES_GCM_TAG_SIZE;
+
 	tmp->key = kmemdup(ukey, tipc_aead_key_size(ukey), GFP_KERNEL);
+	if (!tmp->key) {
+		free_percpu(tmp->tfm_entry);
+		kfree_sensitive(tmp);
+		return -ENOMEM;
+	}
+
 	memcpy(&tmp->salt, ukey->key + keylen, TIPC_AES_GCM_SALT_SIZE);
 	atomic_set(&tmp->users, 0);
 	atomic64_set(&tmp->seqno, 0);
-- 
2.25.1

