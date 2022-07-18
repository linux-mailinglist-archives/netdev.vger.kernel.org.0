Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9076B578B2E
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236313AbiGRTsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234128AbiGRTsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:48:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAEB3139D
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 12:48:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E52656173B
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 19:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3413DC341C0;
        Mon, 18 Jul 2022 19:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658173698;
        bh=KG03ClYU2ESub8drhzGIOem0WyCtJrweVqBV6uXZDCw=;
        h=From:To:Cc:Subject:Date:From;
        b=m7J5+omgmV+RxndSQpETsnHGRF1CS9kILSFc7MJBzREIShFSx8HJrzIyEAd8rtk5F
         wHSClENQpuI3bG3ySZ/WOrlq7xXt9DVivAhCNXFiWcy37bs4xbGLR0JeURHNwusVLk
         oH5M+60YuEGzKxRE0H5DUJwbH9Y6DFnTsEQ2ni6F1PHW77QNRthakwxp/UAun8jFuF
         pzACZ69TulZGZz9i9vCt0p5MA8rsGeLCz7MdRusqBlwUwmxJzEawz8lb86pW0kcXyg
         JA+yNbIUyxwdTyY7BIKGwZTjWn5hnXmEh7I8miRTQgbyTC9zCrv6TA+FC73gQHaN3k
         7cG8wMEP+0QQw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/7] tls: rx: decrypt from the TCP queue
Date:   Mon, 18 Jul 2022 12:48:04 -0700
Message-Id: <20220718194811.1728061-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
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
 net/ipv4/tcp.c       |  44 +++-
 net/tls/tls.h        |  29 ++-
 net/tls/tls_device.c |  19 +-
 net/tls/tls_main.c   |  20 +-
 net/tls/tls_strp.c   | 488 ++++++++++++++++++++++++++++++++++++++++++-
 net/tls/tls_sw.c     | 228 +++++++++++---------
 8 files changed, 725 insertions(+), 124 deletions(-)

-- 
2.36.1

