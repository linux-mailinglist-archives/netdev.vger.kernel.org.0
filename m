Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2357B5EEBF8
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 04:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbiI2Ci7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 22:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234776AbiI2Cia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 22:38:30 -0400
Received: from mail-m975.mail.163.com (mail-m975.mail.163.com [123.126.97.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7DB6F126B50;
        Wed, 28 Sep 2022 19:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=bjNhm
        CM4v+jDZRiUHBiePOPQW64zNvuCPbudERf+mCY=; b=ZxYQ+RPVx+r/egn+gEGJ8
        /rFFVokJ0YRyDc3HyTSqv6xlsIw398QIL+/J/bQEtipbr1BKkbuc7BCfbuWYoclG
        ZlzU2jh0E5gMXD2qajvJgr5VRJzQPRoBp9tUIR75vjesQrQJgwPJ1pKyl9Cr1Nsz
        yQmAQCmY00AwdG/Ff8yef0=
Received: from localhost.localdomain (unknown [36.112.3.106])
        by smtp5 (Coremail) with SMTP id HdxpCgDH4wMCBTVjmtG1gA--.20705S4;
        Thu, 29 Sep 2022 10:38:02 +0800 (CST)
From:   Jianglei Nie <niejianglei2021@163.com>
To:     aelior@marvell.com, skalluru@marvell.com, manishc@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jianglei Nie <niejianglei2021@163.com>
Subject: [PATCH] bnx2x: fix potential memory leak in bnx2x_tpa_stop()
Date:   Thu, 29 Sep 2022 10:37:52 +0800
Message-Id: <20220929023752.5914-1-niejianglei2021@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HdxpCgDH4wMCBTVjmtG1gA--.20705S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrKF13CF1rWw17Gry3WF1rZwb_yoWkuFgEgw
        n8Zw17Jr4DG392kw4jkr45X34ayryqqrn3uFyagrZagryDGr1UG3Wv9Fn3Xw1UWr4UJFn3
        Gryaqa4Yvwn3KjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRMsqXDUUUUU==
X-Originating-IP: [36.112.3.106]
X-CM-SenderInfo: xqlhyxxdqjzvrlsqjii6rwjhhfrp/1tbiQw2LjFc7bj7gIQAAs0
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bnx2x_tpa_stop() allocates a memory chunk from new_data with
bnx2x_frag_alloc(). The new_data should be freed when gets some error.
But when "pad + len > fp->rx_buf_size" is true, bnx2x_tpa_stop() returns
without releasing the new_data, which will lead to a memory leak.

We should free the new_data with bnx2x_frag_free() when "pad + len >
fp->rx_buf_size" is true.

Fixes: 07b0f00 ("bnx2x: fix possible panic under memory stress")
Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 712b5595bc39..24bfc65e28e1 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -789,6 +789,7 @@ static void bnx2x_tpa_stop(struct bnx2x *bp, struct bnx2x_fastpath *fp,
 			BNX2X_ERR("skb_put is about to fail...  pad %d  len %d  rx_buf_size %d\n",
 				  pad, len, fp->rx_buf_size);
 			bnx2x_panic();
+			bnx2x_frag_free(fp, new_data);
 			return;
 		}
 #endif
-- 
2.25.1

