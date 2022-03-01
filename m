Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 453314C98DD
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 00:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237087AbiCAXLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 18:11:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236771AbiCAXLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 18:11:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516CF41FB6;
        Tue,  1 Mar 2022 15:10:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E17696100E;
        Tue,  1 Mar 2022 23:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82515C340EE;
        Tue,  1 Mar 2022 23:10:47 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="HpHK4YAl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1646176245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=v51/pr6zj5GBafoJMMF4V6c2A3sYVSTfTzxiFGcCg0Q=;
        b=HpHK4YAl0y1ezJHIPHufjYfgr1iesMaH3pNHA86oKW4CndMtAIqTUlFKxExm/ajIXjh7A6
        8x7W57lq1btZOi4kGSwiKVun0yIf9zuZcIbWE+/9a4mB+RQDenfDx8T86OErpQzhnUtZpX
        1OIAIeDwRvVYZGAdOHN26yKCU9ovhUI=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8cc3121e (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 1 Mar 2022 23:10:45 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, Alexander Graf <graf@amazon.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 0/3] random: wire up in-kernel virtual machine fork notifications
Date:   Wed,  2 Mar 2022 00:10:35 +0100
Message-Id: <20220301231038.530897-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As discussed, here is the notifier for learning when a virtual machine
forks, as well as a first use case for it, which is unsurprisingly
WireGuard, since I happen to know that case rather well.

The first patch is a small cleanup discovered when working on the second
patch, which is adding the actual notifier. The third case then
trivially adds it to WireGuard.

Jason A. Donenfeld (3):
  random: replace custom notifier chain with standard one
  random: provide notifier for VM fork
  wireguard: device: clear keys on VM fork

 drivers/char/random.c          | 82 ++++++++++++++--------------------
 drivers/net/wireguard/device.c | 27 +++++------
 include/linux/random.h         | 16 +++----
 lib/random32.c                 | 12 ++---
 lib/vsprintf.c                 | 10 +++--
 5 files changed, 69 insertions(+), 78 deletions(-)

-- 
2.35.1

