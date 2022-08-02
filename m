Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0631587826
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 09:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236119AbiHBHqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 03:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236099AbiHBHqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 03:46:49 -0400
Received: from m12-13.163.com (m12-13.163.com [220.181.12.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5AFA12DA9F;
        Tue,  2 Aug 2022 00:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=RaLUe
        ySVHWocZ18U4++qfFwHHyNFRwc6CeYMbKjIV+o=; b=XXFisJdduEqEnk33vFr3s
        2q8QzdNjU0fSHSptJw/CeeCELlAikCgvltBS5feANzPfrU/jl4Lmz5CCUshJxJWd
        0NbImCV48ZHcG1RB8Op+nJcR278XdLj5JR9CdwOOgRQqeycn1NmWHcJSSMLKdD7R
        c3lHWq76eEntTJFZMSePh0=
Received: from localhost.localdomain (unknown [123.58.221.99])
        by smtp9 (Coremail) with SMTP id DcCowAAHE7gc0uhibtSZUg--.300S2;
        Tue, 02 Aug 2022 15:28:31 +0800 (CST)
From:   studentxswpy@163.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Xie Shaowen <studentxswpy@163.com>,
        Hacash Robot <hacashRobot@santino.com>
Subject: [PATCH] net: check the return value of ioremap() in mhz_mfc_config()
Date:   Tue,  2 Aug 2022 15:28:26 +0800
Message-Id: <20220802072826.3212612-1-studentxswpy@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DcCowAAHE7gc0uhibtSZUg--.300S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Xw4kWr18Cr13Wry5Gr4kZwb_yoWDtrcEkF
        WIvF13tr4jgr1Ykw1jqr4xG3yYkr98uF4kXasFqrWFk347ZF1UWw1kZrykGw1fu3y8GFWD
        G39IvFZay347GjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8LjjDUUUUU==
X-Originating-IP: [123.58.221.99]
X-CM-SenderInfo: xvwxvv5qw024ls16il2tof0z/xtbBEQBRJFaEJ6ATSgAAso
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie Shaowen <studentxswpy@163.com>

The function ioremap() in mhz_mfc_config() can fail, so
its return value should be checked.

Fixes: cdb138080b781 ("pcmcia: do not use win_req_t when calling pcmcia_request_window()")
Reported-by: Hacash Robot <hacashRobot@santino.com>
Signed-off-by: Xie Shaowen <studentxswpy@163.com>
---
 drivers/net/ethernet/smsc/smc91c92_cs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/smsc/smc91c92_cs.c b/drivers/net/ethernet/smsc/smc91c92_cs.c
index 37c822e27207..14333f5bdcdc 100644
--- a/drivers/net/ethernet/smsc/smc91c92_cs.c
+++ b/drivers/net/ethernet/smsc/smc91c92_cs.c
@@ -446,6 +446,8 @@ static int mhz_mfc_config(struct pcmcia_device *link)
 
     smc->base = ioremap(link->resource[2]->start,
 		    resource_size(link->resource[2]));
+    if (!smc->base)
+	    return -ENOMEM;
     offset = (smc->manfid == MANFID_MOTOROLA) ? link->config_base : 0;
     i = pcmcia_map_mem_page(link, link->resource[2], offset);
     if ((i == 0) &&
-- 
2.25.1

