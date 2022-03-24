Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26DAA4E5D4F
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 03:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347843AbiCXCqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 22:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347840AbiCXCqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 22:46:06 -0400
X-Greylist: delayed 314 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 23 Mar 2022 19:44:33 PDT
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 458705D5D5;
        Wed, 23 Mar 2022 19:44:32 -0700 (PDT)
Received: from localhost.localdomain (unknown [222.205.7.202])
        by mail-app4 (Coremail) with SMTP id cS_KCgD3eRDJ2TtieeI_AA--.6621S4;
        Thu, 24 Mar 2022 10:39:05 +0800 (CST)
From:   Lin Ma <linma@zju.edu.cn>
To:     jk@codeconstruct.com.au, matt@codeconstruct.com.au,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>
Subject: [PATCH v0] mctp: fix netdev reference bug
Date:   Thu, 24 Mar 2022 10:39:04 +0800
Message-Id: <20220324023904.7173-1-linma@zju.edu.cn>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cS_KCgD3eRDJ2TtieeI_AA--.6621S4
X-Coremail-Antispam: 1UD129KBjvdXoWrtFWxuw1xurW5JrW5JFWkWFg_yoW3tFX_W3
        9xCryDWrs8Gr18ua1jkanaqr1rtw1avr18Gr4SgFs8J3yUZ3Wqqr18AF9xWryfC3y5Xa4U
        AF1qvry3A3WI9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbxxFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AK
        wVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20x
        vE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4UJVW0owA2z4x0Y4vEx4A2
        jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52
        x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWU
        GwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI4
        8JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_Gr1l42xK82IYc2Ij64vIr41l
        42xK82IY6x8ErcxFaVAv8VW8uw4UJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
        8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
        ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
        0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
        Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUO_
        MaUUUUU
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In extended addressing mode, function mctp_local_output() fetch netdev
through dev_get_by_index_rcu, which won't increase netdev's reference
counter. Hence, the reference may underflow when mctp_local_output calls
dev_put(), results in possible use after free.

This patch adds dev_hold() to fix the reference bug.

Fixes: 99ce45d5e7db ("mctp: Implement extended addressing")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
---
 net/mctp/route.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index e52cef750500..a9e5d6c40c65 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -817,6 +817,7 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 			return rc;
 		}
 
+		dev_hold(dev);
 		rt->dev = __mctp_dev_get(dev);
 		rcu_read_unlock();
 
-- 
2.35.1

