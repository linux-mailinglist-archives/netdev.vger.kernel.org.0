Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4EE34EB7CF
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 03:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241643AbiC3Bd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 21:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239352AbiC3Bd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 21:33:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A6D16F04C
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 18:31:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAE3961224
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 01:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B68C2BBE4;
        Wed, 30 Mar 2022 01:31:40 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="CFkzlIHI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1648603899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ip7RKpXdXMxYq/xnuCslnJ3lkQyAEz1My/0YHkdNkwI=;
        b=CFkzlIHIv3eGRSnxjHe8UM8E3eRWtvESNioEZjHuVBiR8jrMfNu+LF1IsLLIjHksrW2wlt
        kZ6F7AvCBtyx2tNfzGFx1CP9s86FcWL5njB2xfVftoLR4BQbEtppN3xwZee0GUpqXSYJry
        UlaKlynQ1Aih8MU/H5hUm8lJ8NbGPJg=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5a8eac94 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 30 Mar 2022 01:31:38 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 0/4] wireguard patches for 5.18-rc1
Date:   Tue, 29 Mar 2022 21:31:23 -0400
Message-Id: <20220330013127.426620-1-Jason@zx2c4.com>
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

Hi Dave/Jakub,

Here's a small set of fixes for the next net push:

1) Pipacs reported a CFI violation in a cleanup routine, which he
   triggered using grsec's RAP. I haven't seen reports of this yet from
   the Android/CFI world yet, but it's only a matter of time there.

2) A small rng cleanup to the self test harness to make it initialize
   faster on 5.18.

3) Wang reported and fixed a skb leak for CONFIG_IPV6=n.

4) After Wang's fix for the direct leak, I investigated how that code
   path even could be hit, and found that the netlink layer still
   handles IPv6 endpoints, when it probably shouldn't.

The relevant commits have stable@ and fixes tags.

Thanks,
Jason


Jason A. Donenfeld (3):
  wireguard: queueing: use CFI-safe ptr_ring cleanup function
  wireguard: selftests: simplify RNG seeding
  wireguard: socket: ignore v6 endpoints when ipv6 is disabled

Wang Hai (1):
  wireguard: socket: free skb in send6 when ipv6 is disabled

 drivers/net/wireguard/queueing.c              |  3 ++-
 drivers/net/wireguard/socket.c                |  5 ++--
 tools/testing/selftests/wireguard/qemu/init.c | 26 +++++--------------
 3 files changed, 12 insertions(+), 22 deletions(-)

-- 
2.35.1

