Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A61F34CED6
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 13:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232743AbhC2LZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 07:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbhC2LYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 07:24:51 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9548CC061574;
        Mon, 29 Mar 2021 04:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id:MIME-Version:Content-Transfer-Encoding; bh=qxbP5+Kk9h
        wkXbfb+CGZvxYCqM6EZhUj+fs9Awbi1jE=; b=DzdtN7Zo4pRvyQz9R3psxX4ID9
        1LJvAQyZk0ZC7OgcaTGYj3YI8unBCsR+jKCoSrs4PxL1uU12/d9m1AcS/YshW/wc
        tGUw72i6K9wq4RVchudFotPjlmxpAGnz2p6cwQ6ft9L3zSzM3VXRN6RFNITH6rIE
        olI7NoGF6Y1JIhe7U=
Received: from ubuntu.localdomain (unknown [202.38.69.14])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygAnLkL1uGFg_SFnAA--.609S4;
        Mon, 29 Mar 2021 19:24:38 +0800 (CST)
From:   Lv Yunlong <lyl2019@mail.ustc.edu.cn>
To:     amitkarwar@gmail.com, ganapathi.bhat@nxp.com,
        huxinming820@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Subject: [PATCH] wireless/marvell/mwifiex: Fix a double free in mwifiex_send_tdls_action_frame
Date:   Mon, 29 Mar 2021 04:24:35 -0700
Message-Id: <20210329112435.7960-1-lyl2019@mail.ustc.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LkAmygAnLkL1uGFg_SFnAA--.609S4
X-Coremail-Antispam: 1UD129KBjvJXoWrKw4kZryfGrWxur47AF1fWFg_yoW8Jr13pw
        sxC3s3urW8Ar1UCr1DCFWkGFWFgasxK34akrsrAw15WrZ3G34ftF12ga40kr15Xrs5Zr17
        ZF4jqF15AFs3CrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUB014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
        0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
        1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
        rcIFxwACI402YVCY1x02628vn2kIc2xKxwCY02Avz4vE14v_Gw4l42xK82IYc2Ij64vIr4
        1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
        67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
        8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAv
        wI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
        0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfU5UDJDUUUU
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In mwifiex_send_tdls_action_frame, it calls mwifiex_construct_tdls_action_frame
(..,skb). The skb will be freed in mwifiex_construct_tdls_action_frame() when
it is failed. But when mwifiex_construct_tdls_action_frame() returns error,
the skb will be freed in the second time by dev_kfree_skb_any(skb).

My patch removes the redundant dev_kfree_skb_any(skb) when
mwifiex_construct_tdls_action_frame() failed.

Fixes: b23bce2965680 ("mwifiex: add tdls_mgmt handler support")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
---
 drivers/net/wireless/marvell/mwifiex/tdls.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/tdls.c b/drivers/net/wireless/marvell/mwifiex/tdls.c
index 97bb87c3676b..8d4d0a9cf6ac 100644
--- a/drivers/net/wireless/marvell/mwifiex/tdls.c
+++ b/drivers/net/wireless/marvell/mwifiex/tdls.c
@@ -856,7 +856,6 @@ int mwifiex_send_tdls_action_frame(struct mwifiex_private *priv, const u8 *peer,
 	if (mwifiex_construct_tdls_action_frame(priv, peer, action_code,
 						dialog_token, status_code,
 						skb)) {
-		dev_kfree_skb_any(skb);
 		return -EINVAL;
 	}
 
-- 
2.25.1


