Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE3A57E496
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 18:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235573AbiGVQlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 12:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiGVQll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 12:41:41 -0400
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [IPv6:2a01:e0c:1:1599::12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0EC5FACB;
        Fri, 22 Jul 2022 09:41:40 -0700 (PDT)
Received: from [44.168.19.21] (unknown [86.242.59.24])
        (Authenticated sender: f6bvp@free.fr)
        by smtp3-g21.free.fr (Postfix) with ESMTPSA id 38A8E13F895;
        Fri, 22 Jul 2022 18:41:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
        s=smtp-20201208; t=1658508098;
        bh=rlcF3KgIs0FMFe9DKk3wBQxyYNlE9M2DFSh/Q2odekM=;
        h=Date:To:Cc:References:Subject:From:In-Reply-To:From;
        b=ahw2VbGbUP6QfXSmCLtzpCFUpFes8gs8rTT//nHE/flfU+k1ldDPxjM58lvu63KDq
         +erobcPtQctDBFvw9/Ao6V8WmQax6xi36BXfQ2NQOsuw3glZIkJnJPadpV1r8Ku04p
         asSWQI5ATDnAkkhaCCo3cNvUEHcw5rDYNnjDHizh2gjRLJLy/QDop5lOyGkZlXToup
         RrRsne8WIdxmcJQFgS0ABz0VLFTQ+wjJrnNAZuICDBdRcUtj1UtfwQo09fHNuMn96h
         FdxsgJgOtwQi9bsdKK1xKDdRAsnf/qWjmJjCxKeQdGGCiRpbKChP4Lp3M0KR7mxaH0
         IaoHdQ4uH15vw==
Message-ID: <9c033c36-c291-1927-079b-b4aee5f7ac08@free.fr>
Date:   Fri, 22 Jul 2022 18:41:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To:     kuba@kernel.org
Cc:     davem@davemloft.net, duoming@zju.edu.cn, edumazet@google.com,
        f6bvp@free.fr, linux-hams@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, ralf@linux-mips.org
References: <20220715154314.510ca2fb@kernel.org>
Subject: Re: [PATCH] net: rose: fix unregistered netdevice: waiting for rose0
 to become free
Content-Language: en-US
From:   Bernard f6bvp <f6bvp@free.fr>
Organization: Dimension Parabole
In-Reply-To: <20220715154314.510ca2fb@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here is the context.

This patch adds dev_put(dev) in order to allow removal of rose module
after use of AX25 and ROSE via rose0 device.

Otherwise when trying to remove rose module via rmmod rose an infinite
loop message was displayed on all consoles with xx being a random number.

unregistered_netdevice: waiting for rose0 to become free. Usage count = xx

unregistered_netdevice: waiting for rose0 to become free. Usage count = xx

...

With the patch it is ok to rmmod rose.

This bug appeared with kernel 4.10 and has been only partially repaired 
by adding two dev_put(dev).

Signed-off-by: Bernard Pidoux <f6bvp@free.fr>

---
  net/rose/af_rose.c | 2 ++
  1 file changed, 2 insertions(+)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index bf2d986a6bc3..4163171ce3a6 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -711,6 +711,8 @@ static int rose_bind(struct socket *sock, struct 
sockaddr *uaddr, int addr_len)
      rose_insert_socket(sk);

      sock_reset_flag(sk, SOCK_ZAPPED);
+
+    dev_put(dev);

      return 0;
  }
-- 
2.34.1

[master da21d19e920d] [PATCH] net: rose: fix unregistered netdevice: 
waiting for rose0 to become free
  Date: Mon Jul 18 16:23:54 2022 +0200
  1 file changed, 2 insertions(+)


