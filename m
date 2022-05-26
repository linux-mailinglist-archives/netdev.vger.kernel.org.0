Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C281B53496C
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 05:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243945AbiEZDqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 23:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbiEZDqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 23:46:00 -0400
X-Greylist: delayed 914 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 25 May 2022 20:45:58 PDT
Received: from mail-m973.mail.163.com (mail-m973.mail.163.com [123.126.97.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 785C735DD7;
        Wed, 25 May 2022 20:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=CjTO1
        zV1XxDBvRyik+WBGvUIZFFmgjo+eyQguphswZA=; b=fwlLaKzWVMM5dd12lo4e8
        A/aAWpMLYTUCF86JRTQhpTcpd0yzeVoDKDXqncr1tSbACKnZ+WU0HdwscDV36A8B
        TXTHxCPw/Vh1ZT/RL7zhK6u0NmS544WTPCH9K67cGz44dNfcseaB6MZY+P/lr6UV
        860oL8uw3R41TWTeWuwnPA=
Received: from localhost.localdomain (unknown [123.112.69.106])
        by smtp3 (Coremail) with SMTP id G9xpCgA3f6s89I5iG2uqEg--.14753S4;
        Thu, 26 May 2022 11:30:14 +0800 (CST)
From:   Jianglei Nie <niejianglei2021@163.com>
To:     pizza@shaftnet.org, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jianglei Nie <niejianglei2021@163.com>
Subject: [PATCH] cw1200: Fix memory leak in cw1200_set_key()
Date:   Thu, 26 May 2022 11:30:03 +0800
Message-Id: <20220526033003.473943-1-niejianglei2021@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: G9xpCgA3f6s89I5iG2uqEg--.14753S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jr18Aw1rCF4DKFW7Cr4fuFg_yoW3KFX_GF
        1Yqa18Grs7Jr12kryrAr4furWSv3WYgF4fuay2qayayanrurWDXr15XFWxJryUK3y8ZF4f
        Gw4kWa1rAw1jqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xREsjjJUUUUU==
X-Originating-IP: [123.112.69.106]
X-CM-SenderInfo: xqlhyxxdqjzvrlsqjii6rwjhhfrp/1tbiWwcNjGI0Up-XlwABsH
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When wsm_key.index > WSM_KEY_MAX_INDEX, cw1200_set_key() returns without
calling cw1200_free_key() like other wrong paths, which may lead to a
potential memory leak.

We can fix it by calling cw1200_free_key() when some error occurs.

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
---
 drivers/net/wireless/st/cw1200/sta.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/st/cw1200/sta.c b/drivers/net/wireless/st/cw1200/sta.c
index 236022d4ae2a..c0097577978d 100644
--- a/drivers/net/wireless/st/cw1200/sta.c
+++ b/drivers/net/wireless/st/cw1200/sta.c
@@ -823,6 +823,7 @@ int cw1200_set_key(struct ieee80211_hw *dev, enum set_key_cmd cmd,
 		};
 
 		if (wsm_key.index > WSM_KEY_MAX_INDEX) {
+			cw1200_free_key(priv, idx);
 			ret = -EINVAL;
 			goto finally;
 		}
-- 
2.25.1

