Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72259534CE9
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 12:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345017AbiEZKDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 06:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiEZKDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 06:03:11 -0400
Received: from mail-m973.mail.163.com (mail-m973.mail.163.com [123.126.97.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5587BAF337;
        Thu, 26 May 2022 03:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=SIdeg
        1ju9DDQN5SyCoUMa81G3s2La6ZRZRDFK36w+Gs=; b=IT45QKTSbSotUcsxZObUz
        X/x0mnRaCmfMUDbvpTmu30DDcXk+RYMzFjgtF4l8haYS0UnziqbLhXroCc6DIIAG
        BcooIfejMSHpSQ2E6pdNkjqKvJcZg7PehLp5WqqZBSX1/hgHSZKGolkFQ0wPuV8R
        ukHMk7ZJ+pr7Is3O3/cr10=
Received: from localhost.localdomain (unknown [123.112.69.106])
        by smtp3 (Coremail) with SMTP id G9xpCgAXuJk2UI9iK0jaEg--.27316S4;
        Thu, 26 May 2022 18:02:43 +0800 (CST)
From:   Jianglei Nie <niejianglei2021@163.com>
To:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jianglei Nie <niejianglei2021@163.com>
Subject: [PATCH] ath11k: mhi: fix potential memory leak in ath11k_mhi_register()
Date:   Thu, 26 May 2022 18:02:27 +0800
Message-Id: <20220526100227.483609-1-niejianglei2021@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: G9xpCgAXuJk2UI9iK0jaEg--.27316S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7Wr48KryDZrWkKrW8uw1rZwb_yoWkZrg_CF
        ZYgF17ZrW2kw1rJrWjkr4UZFyS9ay7X3Z5Wa10qFyxJa95Z3yDuryDZFy5JasrKr4jvr13
        CrnrAFyjy3sI9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xREF4i5UUUUU==
X-Originating-IP: [123.112.69.106]
X-CM-SenderInfo: xqlhyxxdqjzvrlsqjii6rwjhhfrp/1tbiPhcNjFxBsWDfhwABs9
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mhi_alloc_controller() allocates a memory space for mhi_ctrl. When some
errors occur, mhi_ctrl should be freed by mhi_free_controller(). But
when ath11k_mhi_read_addr_from_dt() fails, the function returns without
calling mhi_free_controller(), which will lead to a memory leak.

We can fix it by calling mhi_free_controller() when
ath11k_mhi_read_addr_from_dt() fails.

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
---
 drivers/net/wireless/ath/ath11k/mhi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
index fc3524e83e52..3318c7c2b32b 100644
--- a/drivers/net/wireless/ath/ath11k/mhi.c
+++ b/drivers/net/wireless/ath/ath11k/mhi.c
@@ -376,8 +376,10 @@ int ath11k_mhi_register(struct ath11k_pci *ab_pci)
 
 	if (test_bit(ATH11K_FLAG_FIXED_MEM_RGN, &ab->dev_flags)) {
 		ret = ath11k_mhi_read_addr_from_dt(mhi_ctrl);
-		if (ret < 0)
+		if (ret < 0) {
+			mhi_free_controller(mhi_ctrl);
 			return ret;
+		}
 	} else {
 		mhi_ctrl->iova_start = 0;
 		mhi_ctrl->iova_stop = 0xFFFFFFFF;
-- 
2.25.1

