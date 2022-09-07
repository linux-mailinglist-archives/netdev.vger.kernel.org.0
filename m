Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44D225AFCDF
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 08:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiIGGwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 02:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiIGGwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 02:52:22 -0400
Received: from mail-m974.mail.163.com (mail-m974.mail.163.com [123.126.97.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5C4401CFCB;
        Tue,  6 Sep 2022 23:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=X3lrt
        93nIs2ExWkz5BJeKbh2vPXhTHhjwRs/Ic1JO0k=; b=SKbogZSKr8kZld7SmnyOV
        oKJzDXprGRh2c+RW5yQc8iQvfU7kSsKVwlU1ItF7qa2peuQku3BHkMDA/HH13ixB
        3fkr03lB3Mf5yXgXo2QPwxsGP8u0hrzOnYXhll/c7YiURIEwkhg5vzdRZ5TslLnv
        mIJCM+Bnv663esXF7kOH84=
Received: from localhost.localdomain (unknown [36.112.3.164])
        by smtp4 (Coremail) with SMTP id HNxpCgCnxs54PxhjRjvoaw--.21843S4;
        Wed, 07 Sep 2022 14:51:45 +0800 (CST)
From:   Jianglei Nie <niejianglei2021@163.com>
To:     aelior@marvell.com, skalluru@marvell.com, manishc@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jianglei Nie <niejianglei2021@163.com>
Subject: [PATCH] bnx2x: fix potential memory leak in bnx2x_tpa_stop()
Date:   Wed,  7 Sep 2022 14:51:28 +0800
Message-Id: <20220907065128.55190-1-niejianglei2021@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HNxpCgCnxs54PxhjRjvoaw--.21843S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrKF13CF1rWw17Gry3WF1rZwb_yoWkXrbEgw
        n8Zw17Jr4DG392k3yjkr4aq34ayFyqqrn3uFyagrZagryDGr1UG3Wv9Fn3Xw17Wr4UJFnx
        Gryaqa4YvwnxKjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRM8nYUUUUUU==
X-Originating-IP: [36.112.3.164]
X-CM-SenderInfo: xqlhyxxdqjzvrlsqjii6rwjhhfrp/xtbB0QF1jFzICmnm4QAAsZ
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

