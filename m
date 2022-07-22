Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3B157EA6F
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 01:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236451AbiGVXup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 19:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbiGVXuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 19:50:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8107BA277
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 16:50:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44B156227A
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 23:50:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B393C341C6;
        Fri, 22 Jul 2022 23:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658533842;
        bh=MgtA5xH4bpDmlIXTeEcTiVQnYQtGp6PkJ+sVz+gtyho=;
        h=From:To:Cc:Subject:Date:From;
        b=k6eoE9ocV5v+bW/RvSGl+R0o55wHY3xTKKOE4yLSYoaJ6ECBanpq+p1uQ0df4C2E5
         NtvmJPVxeXt3grQW8sc1auNm0Gj0lSmBvJXF922kJ9tj2hPgeQ2UAOTwohixfdxsZE
         pWdjI9hhSYVkvyK+tlqbWMRkIXzwUK5Es4752wSOZ0EDB13YQAiaCbWNIPjKgtoiXt
         /3xN2pakXa3EBluiDOB+ID5PPXqrOAD9xyHeGttuWSIA6SuWkoMyp7IZnOuHeUTgfw
         3StJam/mCQjvdvIq2H4yy9xDKJAf9skRsu3ufE5F5RlisRl7VXYXmwYvQAMDAtMyuQ
         1kGS4n0LRJEbw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 0/7] tls: rx: decrypt from the TCP queue
Date:   Fri, 22 Jul 2022 16:50:26 -0700
Message-Id: <20220722235033.2594446-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This is the final part of my TLS Rx rework. It switches from
strparser to decrypting data from skbs queued in TCP. We don't
need the full strparser for TLS, its needs are very basic.
This set gives us a small but measurable (6%) performance
improvement (continuous stream).

v2: drop the __exit marking for the unroll path
v3: drop tcp_recv_skb() in patch 5

Jakub Kicinski (7):
  tls: rx: wrap recv_pkt accesses in helpers
  tls: rx: factor SW handling out of tls_rx_one_record()
  tls: rx: don't free the output in case of zero-copy
  tls: rx: device: keep the zero copy status with offload
  tcp: allow tls to decrypt directly from the tcp rcv queue
  tls: rx: device: add input CoW helper
  tls: rx: do not use the standard strparser

 include/net/tcp.h    |   2 +
 include/net/tls.h    |  19 +-
 net/ipv4/tcp.c       |  42 +++-
 net/tls/tls.h        |  29 ++-
 net/tls/tls_device.c |  19 +-
 net/tls/tls_main.c   |  20 +-
 net/tls/tls_strp.c   | 488 ++++++++++++++++++++++++++++++++++++++++++-
 net/tls/tls_sw.c     | 228 +++++++++++---------
 8 files changed, 723 insertions(+), 124 deletions(-)

-- 
2.37.1

