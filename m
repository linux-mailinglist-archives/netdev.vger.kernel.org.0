Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C99FF6F06D4
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 15:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243459AbjD0Npg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 09:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243389AbjD0Npe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 09:45:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE10E44BA
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 06:45:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A80B63841
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 13:45:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C60C433EF;
        Thu, 27 Apr 2023 13:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682603130;
        bh=4t5v2nKuLWbj9FzijDkR6wFptIkccGLMr14+DuDXvWQ=;
        h=From:To:Cc:Subject:Date:From;
        b=lDI0NNRVq9d1fMF3YXvdHSZWWaTK0NmC3QG0IHo2scCtW67hXfeCWu8nw6xtOeyoB
         /AUZvHj15NfacrY9heRiFVkcJ/vlkU+Cb0ff9J9rNCDXifPa1uexaKOihs1mliOgg/
         eKvwZHXTWHilW1UIddZikg7CXGYnZ6DrjZRx6ZEwhHRol9QsXp08qy4SMAfDNMTV9a
         ar2n+wMnXnJKdJM2f1kmf/TBaUO+N9kj++JVG0UMozUyFO7XR+2qbco1aL972HtFRH
         gZGXZDd+acihGgxcD8yqJ/OtHPFIQAPBZbSC6qrXUmUGvcYryA5TxdxjjdfV0Plf/p
         Hst082VPimWeg==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/4] net: tcp: make txhash use consistent for IPv4
Date:   Thu, 27 Apr 2023 15:45:23 +0200
Message-Id: <20230427134527.18127-1-atenart@kernel.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Series is divided in two parts. First two commits make the txhash (used
for the skb hash in TCP) to be consistent for all IPv4/TCP packets (IPv6
doesn't have the same issue). Last two commits improve doc/comment
hash-related parts.

One example is when using OvS with dp_hash, which uses skb->hash, to
select a path. We'd like packets from the same flow to be consistent, as
well as the hash being stable over time when using net.core.txrehash=0.
Same applies for kernel ECMP which also can use skb->hash.

IMHO the series makes sense in net-next, but we could argue (some)
commits be seen as fixes and I can resend if necessary.

Thanks!
Antoine

Antoine Tenart (4):
  net: tcp: make the txhash available in TIME_WAIT sockets for IPv4 too
  net: ipv4: use consistent txhash in TIME_WAIT and SYN_RECV
  Documentation: net: net.core.txrehash is not specific to listening
    sockets
  net: skbuff: fix l4_hash comment

 Documentation/admin-guide/sysctl/net.rst |  4 ++--
 include/linux/skbuff.h                   |  4 ++--
 include/net/ip.h                         |  2 +-
 net/ipv4/ip_output.c                     |  4 +++-
 net/ipv4/tcp_ipv4.c                      | 14 +++++++++-----
 net/ipv4/tcp_minisocks.c                 |  2 +-
 6 files changed, 18 insertions(+), 12 deletions(-)

-- 
2.40.0

