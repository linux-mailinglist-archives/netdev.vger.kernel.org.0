Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 863BD5B7371
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 17:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbiIMPJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 11:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233340AbiIMPHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 11:07:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D1DB75CEB;
        Tue, 13 Sep 2022 07:30:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32835614DD;
        Tue, 13 Sep 2022 14:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE8EC433C1;
        Tue, 13 Sep 2022 14:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079448;
        bh=eGNzvcJW9a3VCM96k2fbhRyyeCBUvL/2LzhxbbtcIik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DfVDiveMeYB4fMjSuEqyiiiy20pn9I5K28LZWrP/jI8b8V7uppwoZfFIDFvFDkrqA
         abMvRUN+A4+Sok39pL31Fm7Uqw6zUefDcguPBwLm4QGbkj7IZMi5D8bk+SfHc4nuWo
         CcylIWnD7bFy7JL3GWU3s4ImJ8bKUBTLZg9WiYgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        stable <stable@kernel.org>
Subject: [PATCH 4.19 04/79] net: mvpp2: debugfs: fix memory leak when using debugfs_lookup()
Date:   Tue, 13 Sep 2022 16:06:22 +0200
Message-Id: <20220913140349.063571382@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140348.835121645@linuxfoundation.org>
References: <20220913140348.835121645@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit fe2c9c61f668cde28dac2b188028c5299cedcc1e upstream.

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  Fix this up to be much
simpler logic and only create the root debugfs directory once when the
driver is first accessed.  That resolves the memory leak and makes
things more obvious as to what the intent is.

Cc: Marcin Wojtas <mw@semihalf.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Cc: stable <stable@kernel.org>
Fixes: 21da57a23125 ("net: mvpp2: add a debugfs interface for the Header Parser")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
@@ -667,10 +667,10 @@ void mvpp2_dbgfs_cleanup(struct mvpp2 *p
 
 void mvpp2_dbgfs_init(struct mvpp2 *priv, const char *name)
 {
-	struct dentry *mvpp2_dir, *mvpp2_root;
+	static struct dentry *mvpp2_root;
+	struct dentry *mvpp2_dir;
 	int ret, i;
 
-	mvpp2_root = debugfs_lookup(MVPP2_DRIVER_NAME, NULL);
 	if (!mvpp2_root) {
 		mvpp2_root = debugfs_create_dir(MVPP2_DRIVER_NAME, NULL);
 		if (IS_ERR(mvpp2_root))


