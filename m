Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA7756978F
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 03:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234837AbiGGBfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 21:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234626AbiGGBfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 21:35:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C332F2ED5B
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 18:35:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 738A2B81F68
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 01:35:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C505EC3411C;
        Thu,  7 Jul 2022 01:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657157716;
        bh=vOpjO+IxqYBRAbh6527veTv71fSqUQa9CL23WUySXXw=;
        h=From:To:Cc:Subject:Date:From;
        b=cHA8WTVvBS2ad0gQwXHwTL/GY8Bb7MCwOsR9OvU8kHmZ8A+JeZLQW8zIji0RaXTGF
         zgv81Wt+V+tyR4SsiHt3tuKahArAn6GWobiJpmwhK4MxNG0nOYrdjwmWbfC9RCLnfA
         M1exC8YP89MFCR5/k5XkSTfxEQTRkwQbukqs1xtm9D44jVFQccOV8Dyos+733/0868
         NFWKwDtiTTgadX4bvsJoTM4lL63TgtyQUrDasAyNkiHmHhMRSFor6EcpsrJ8d5Bw2F
         8+Ytj5yhX1P1hoPq4zWnRQCLcix+7Zl2ana9Axk96h2cv9B6md7xBdVyNqdrKbGPBt
         0JzXnvh5ZhiKw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/6] tls: pad strparser, internal header, decrypt_ctx etc.
Date:   Wed,  6 Jul 2022 18:35:04 -0700
Message-Id: <20220707013510.1372695-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A grab bag of non-functional refactoring to make the series
which will let us decrypt into a fresh skb smaller.

Patches in this series are not strictly required to get the
decryption into a fresh skb going, they are more in the "things
which had been annoying me for a while" category.

Jakub Kicinski (6):
  strparser: pad sk_skb_cb to avoid straddling cachelines
  tls: rx: always allocate max possible aad size for decrypt
  tls: rx: wrap decrypt params in a struct
  tls: rx: coalesce exit paths in tls_decrypt_sg()
  tls: create an internal header
  tls: rx: make tls_wait_data() return an recvmsg retcode

 include/net/strparser.h       |  12 +-
 include/net/tls.h             | 279 +-------------------------------
 net/strparser/strparser.c     |   3 +
 net/tls/tls.h                 | 291 ++++++++++++++++++++++++++++++++++
 net/tls/tls_device.c          |   3 +-
 net/tls/tls_device_fallback.c |   2 +
 net/tls/tls_main.c            |  23 ++-
 net/tls/tls_proc.c            |   2 +
 net/tls/tls_sw.c              | 162 ++++++++++---------
 net/tls/tls_toe.c             |   2 +
 10 files changed, 419 insertions(+), 360 deletions(-)
 create mode 100644 net/tls/tls.h

-- 
2.36.1

