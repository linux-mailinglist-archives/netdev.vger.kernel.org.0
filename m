Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75807605338
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 00:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbiJSWf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 18:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiJSWf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 18:35:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7991316D572
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 15:35:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13523619E5
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 22:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D57C433C1;
        Wed, 19 Oct 2022 22:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666218956;
        bh=hxklS8mhtSUoHgr1g+XPTWztEe+wG1+4BPByaA6V5XM=;
        h=From:To:Cc:Subject:Date:From;
        b=WQYT9Jyrk2kDKeTNJOabOyrhNJRA+UqMC6I8U8zKu4Nlvp7KvIV+lrT3gqONgZwVb
         2ZpOkDH0sck0g+sDqhBvcs094Iqaa4nly4+zJzBjGMnLAWfVrvO5NFduZPDREpZH59
         yDIMVkTsacx8LCyIHdBBS5S2/njuQwzEIzE1FHNaYTEzWxes0RjiFoTjuOF8HyjSAj
         HZ38fnNChILwpM6187JkFJcHBgLe6Sg8R0CBOnvy2DncKg5uj+d5iTWrb1dWnWk8Fi
         YTbemW29MfMtmcA5os/R3U9RGqznQYBAkHXsCI1lOtRwuxgHbOT/DZt3dl2c+YTULw
         fJMT9QqkkuHcg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+81c4b4bbba6eea2cfcae@syzkaller.appspotmail.com,
        andrew@lunn.ch, linux@rempel-privat.de, bagasdotme@gmail.com,
        lkp@intel.com
Subject: [PATCH net] ethtool: pse-pd: fix null-deref on genl_info in dump
Date:   Wed, 19 Oct 2022 15:35:51 -0700
Message-Id: <20221019223551.1171204-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ethnl_default_dump_one() passes NULL as info.

It's correct not to set extack during dump, as we should just
silently skip interfaces which can't provide the information.

Reported-by: syzbot+81c4b4bbba6eea2cfcae@syzkaller.appspotmail.com
Fixes: 18ff0bcda6d1 ("ethtool: add interface to interact with Ethernet Power Equipment")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: andrew@lunn.ch
CC: linux@rempel-privat.de
CC: bagasdotme@gmail.com
CC: lkp@intel.com
---
 net/ethtool/pse-pd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/pse-pd.c b/net/ethtool/pse-pd.c
index 5a471e115b66..e8683e485dc9 100644
--- a/net/ethtool/pse-pd.c
+++ b/net/ethtool/pse-pd.c
@@ -64,7 +64,7 @@ static int pse_prepare_data(const struct ethnl_req_info *req_base,
 	if (ret < 0)
 		return ret;
 
-	ret = pse_get_pse_attributes(dev, info->extack, data);
+	ret = pse_get_pse_attributes(dev, info ? info->extack : NULL, data);
 
 	ethnl_ops_complete(dev);
 
-- 
2.37.3

