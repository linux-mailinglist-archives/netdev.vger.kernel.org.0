Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8425E865E
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 01:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbiIWXrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 19:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbiIWXrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 19:47:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F79124746
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 16:47:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D20CB80B9B
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 23:47:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A222C433C1;
        Fri, 23 Sep 2022 23:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663976864;
        bh=TJQkrbWdnc+22PlObL9lKONmsxS044CUiTNKPnuvEgw=;
        h=From:To:Cc:Subject:Date:From;
        b=YUNh2ZaIsl7W45tQ9lRKU1mI+GIFbvbWX9fT1ylaUFVQBJVLVw4m0LpjmDERhk2yB
         wV7oGv99czEIBOnWzC9NYKgUNfovCMlJ/0in8PcS9aPQLTGM2CJLkDtT5cWGT6zVWE
         p31ucL2S9oXTepTeuDJ/5DrTUV2BhkzFO31Wpo0qxZecNLIALFxWNVHaMEaHi+PtY9
         /mAVRiCjALqNO+BVrQbQnyP23+nNj0tij12xZId6I1ANMX13SFgIVpenbA8M26Mc1N
         UCsefbMFLJfWX8Lm0/uX+VLJXzjhjup8pu/Wf7alBHW2YKGXIikkpubxS/OSvckRTZ
         JUPeHMP8vYElg==
From:   Sasha Levin <sashal@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, stable@kernel.org
Subject: [PATCH] Revert "net: mvpp2: debugfs: fix memory leak when using debugfs_lookup()"
Date:   Fri, 23 Sep 2022 19:47:36 -0400
Message-Id: <20220923234736.657413-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit fe2c9c61f668cde28dac2b188028c5299cedcc1e.

On Tue, Sep 13, 2022 at 05:48:58PM +0100, Russell King (Oracle) wrote:
>What happens if this is built as a module, and the module is loaded,
>binds (and creates the directory), then is removed, and then re-
>inserted?  Nothing removes the old directory, so doesn't
>debugfs_create_dir() fail, resulting in subsequent failure to add
>any subsequent debugfs entries?
>
>I don't think this patch should be backported to stable trees until
>this point is addressed.

Revert until a proper fix is available as the original behavior was
better.

Cc: Marcin Wojtas <mw@semihalf.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: netdev@vger.kernel.org
Cc: stable@kernel.org
Reported-by: Russell King <linux@armlinux.org.uk>
Fixes: fe2c9c61f668 ("net: mvpp2: debugfs: fix memory leak when using debugfs_lookup()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
index 0eec05d905eb..4a3baa7e0142 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
@@ -700,10 +700,10 @@ void mvpp2_dbgfs_cleanup(struct mvpp2 *priv)
 
 void mvpp2_dbgfs_init(struct mvpp2 *priv, const char *name)
 {
-	static struct dentry *mvpp2_root;
-	struct dentry *mvpp2_dir;
+	struct dentry *mvpp2_dir, *mvpp2_root;
 	int ret, i;
 
+	mvpp2_root = debugfs_lookup(MVPP2_DRIVER_NAME, NULL);
 	if (!mvpp2_root)
 		mvpp2_root = debugfs_create_dir(MVPP2_DRIVER_NAME, NULL);
 
-- 
2.35.1

