Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8C7558F82
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 06:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiFXEM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 00:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbiFXEM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 00:12:57 -0400
Received: from mail-m974.mail.163.com (mail-m974.mail.163.com [123.126.97.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B877668089;
        Thu, 23 Jun 2022 21:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=E5epV
        JPg/t9YUTy8EYdJ5qpvHm/ag92IRP9C9ezExQ8=; b=Eb/ySWxb4Bs7FHrHGaqRK
        9ppG6dY+Lv+E02icvWdeAVVfLpMCGn6h0DqMR7r+lwOkGPmk6/F5e+LLzomKwZxj
        or94OTFszkqwJRers8wF/4eOXz/bW/eCZelH231VX8XeobUVBNKNlb5tDlD6su61
        Og3fKi/CkJdiR2hvp8AVhQ=
Received: from localhost.localdomain (unknown [123.112.69.106])
        by smtp4 (Coremail) with SMTP id HNxpCgDn7uejObViIy4HLA--.29322S4;
        Fri, 24 Jun 2022 12:12:28 +0800 (CST)
From:   Jianglei Nie <niejianglei2021@163.com>
To:     aelior@marvell.com, skalluru@marvell.com, manishc@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jianglei Nie <niejianglei2021@163.com>
Subject: [PATCH] bnx2x: fix memory leak in bnx2x_tpa_stop()
Date:   Fri, 24 Jun 2022 12:12:17 +0800
Message-Id: <20220624041217.1805512-1-niejianglei2021@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HNxpCgDn7uejObViIy4HLA--.29322S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7GFy7ZF4rtF1kWryxWFWrAFb_yoWkGwcEgw
        n8Zr13Jr4DG39Fy34jkr4aq343tF90qrn3uFyagrZagr1DJr1UG3Wv9Fn5Xw17Wr48JFnx
        Gryaqa4YvwnxKjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRiYLvtUUUUU==
X-Originating-IP: [123.112.69.106]
X-CM-SenderInfo: xqlhyxxdqjzvrlsqjii6rwjhhfrp/1tbiFQwqjF5mLalVGwAAsN
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
bnx2x_frag_alloc(). The new_data should be freed when some errors occur.
But when "pad + len > fp->rx_buf_size" is true, bnx2x_tpa_stop() returns
without releasing the new_data, which leads to a memory leak.

We should free the new_data with bnx2x_frag_free() when "pad + len >
fp->rx_buf_size" is true.

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 5729a5ab059d..4cbd3ba5acb9 100644
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

