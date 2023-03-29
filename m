Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D533E6CD1E3
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 08:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjC2GBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 02:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjC2GBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 02:01:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475852724;
        Tue, 28 Mar 2023 23:01:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90AC1B8200E;
        Wed, 29 Mar 2023 06:01:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0573EC433EF;
        Wed, 29 Mar 2023 06:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680069690;
        bh=nH1AD2Nxv0C7fSJPzMtMRUHvGGWbSJLE7LmRam5bdIQ=;
        h=From:To:Cc:Subject:Date:From;
        b=iTbg7YpIrA7puEa3JYLcRU2MrQrhmR06N/eZXBvZeoV/7j1xUmC0ubDQjDn6xumN7
         XTdjNUPGGNtaS5JQ74UsZgc0rQ3O2kdG+7NMBW3ylJlNwYSnzCaknZXYwDFpdyz8iC
         5Q1TerCgNwLURWriRCZqn2UwdPXdbUJxsKPY9oWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org
Subject: [PATCH] mISDN: remove unneeded mISDN_class_release()
Date:   Wed, 29 Mar 2023 08:01:27 +0200
Message-Id: <20230329060127.2688492-1-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1247; i=gregkh@linuxfoundation.org; h=from:subject; bh=nH1AD2Nxv0C7fSJPzMtMRUHvGGWbSJLE7LmRam5bdIQ=; b=owGbwMvMwCRo6H6F97bub03G02pJDCnKV8wESv0636b3TYjZurDl6NRTmWbc7ufSpr2Pdjv9c fUZp4lhHbEsDIJMDLJiiixftvEc3V9xSNHL0PY0zBxWJpAhDFycAjARcX+G+Uk3a10ZhMyzvzsn c0f1n+PMVZzBzrBgKuex35Xbdaznv0m9efd19UQupqP3AA==
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mISDN_class_release() is not needed at all, as the class structure
is static, and it does not actually do anything either, so it is safe to
remove as struct class does not require a release callback.

Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Note: I would like to take this through the driver-core tree as I have
later struct class cleanups that depend on this change being made to the
tree if that's ok with the maintainer of this file.

 drivers/isdn/mISDN/core.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/isdn/mISDN/core.c b/drivers/isdn/mISDN/core.c
index f5989c9907ee..ab8513a7acd5 100644
--- a/drivers/isdn/mISDN/core.c
+++ b/drivers/isdn/mISDN/core.c
@@ -152,17 +152,11 @@ static int mISDN_uevent(const struct device *dev, struct kobj_uevent_env *env)
 	return 0;
 }
 
-static void mISDN_class_release(struct class *cls)
-{
-	/* do nothing, it's static */
-}
-
 static struct class mISDN_class = {
 	.name = "mISDN",
 	.dev_uevent = mISDN_uevent,
 	.dev_groups = mISDN_groups,
 	.dev_release = mISDN_dev_release,
-	.class_release = mISDN_class_release,
 };
 
 static int
-- 
2.40.0

