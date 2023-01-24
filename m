Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0D1678F1A
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 04:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbjAXDwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 22:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbjAXDwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 22:52:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E2139CC3
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 19:52:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94488B80EFA
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 03:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B25C433D2;
        Tue, 24 Jan 2023 03:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674532353;
        bh=Gfy1dIk+OU5nMtqRKXR6zPKEBTEXZZKQvtzpnj30Pqo=;
        h=From:To:Cc:Subject:Date:From;
        b=FTjSSieFczJyeh9dDXlgYDJAfg2HES9qEyAaNKlP2Aw3M1Ydt9fPPpkv4Jlyy9wVH
         3CqMips9BB9+0QRVQt0yHKKCTlKJUELuq8th7wgqCirYCzl0Lev5H7EdpuxuEjD1Fl
         GYuh+iPbaIQ62IxGkN/ovfJuU3uHMr2pJZk3bGM5UPLnkML42isxNECSAdbrnagyAy
         07tKkxSp7wTTc5WYhPjztf2UTHeyHNxh0LFrp+ea3Wm7G/gbSSC1Y5Hut+S5beUnXB
         qfXhkEH5PUvs64kfby9Fg11xX2gzxGPPSLcCvdt5pX7DK8Xg+L9pLlZy/1SAryneCZ
         6vAKjNU7vWfgw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] devlink: remove a dubious assumption in fmsg dumping
Date:   Mon, 23 Jan 2023 19:52:31 -0800
Message-Id: <20230124035231.787381-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Build bot detects that err may be returned uninitialized in
devlink_fmsg_prepare_skb(). This is not really true because
all fmsgs users should create at least one outer nest, and
therefore fmsg can't be completely empty.

That said the assumption is not trivial to confirm, so let's
follow the bots advice, anyway.

This code does not seem to have changed since its inception in
commit 1db64e8733f6 ("devlink: Add devlink formatted message (fmsg) API")

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/leftover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 8eab95cae917..74621287f4e5 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -7116,8 +7116,8 @@ devlink_fmsg_prepare_skb(struct devlink_fmsg *fmsg, struct sk_buff *skb,
 {
 	struct devlink_fmsg_item *item;
 	struct nlattr *fmsg_nlattr;
+	int err = 0;
 	int i = 0;
-	int err;
 
 	fmsg_nlattr = nla_nest_start_noflag(skb, DEVLINK_ATTR_FMSG);
 	if (!fmsg_nlattr)
-- 
2.39.1

