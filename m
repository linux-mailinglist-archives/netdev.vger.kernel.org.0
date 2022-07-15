Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271F9575ADE
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 07:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiGOFWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 01:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiGOFWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 01:22:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D27B796A2
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 22:22:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15E8D62264
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 05:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7BEC34115;
        Fri, 15 Jul 2022 05:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657862562;
        bh=5RYdngJzzvW+g6SZOr/we5IJ4zPXlQAlaDzZwGB0DEk=;
        h=From:To:Cc:Subject:Date:From;
        b=EQ9HF8weeZCAOQpLyazwVKtvjYErYVrcsiGgRZn2PR5x6cuWQTINy4/EPKXdwWn4O
         tJCHUT9sQGhfdQ1wUb6fq868UXNFTEYxtA7oj4lbKafGHXXI8gZGCKS4tSipcKsbYR
         Xo/likqVK+bXI3H+/dPdKoXkfWqjhf2WvVD+CXowKcWdWdj1ukzfrjQPQVWnn7C3t3
         1k2RJe0A5bWyQBkHL+ZdiPy8DWnCehEK5tRqEto0mmCJt8mCkA40jpdMJRQRRgcDw0
         WvZNyz50Ws28zdihi+A5FLjw/X+5YR/lgEYWrHthMkdP/sF2m1UvJRGBlfp+hJ09Gq
         1cnHD9EgvJ8ZQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 00/11] tls: rx: avoid skb_cow_data()
Date:   Thu, 14 Jul 2022 22:22:24 -0700
Message-Id: <20220715052235.1452170-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TLS calls skb_cow_data() on the skb it received from strparser
whenever it needs to hold onto the skb with the decrypted data.
(The alternative being decrypting directly to a user space buffer
in whic case the input skb doesn't get modified or used after.)
TLS needs the decrypted skb:
 - almost always with TLS 1.3 (unless the new NoPad is enabled);
 - when user space buffer is too small to fit the record;
 - when BPF sockmap is enabled.

Most of the time the skb we get out of strparser is a clone of
a 64kB data unit coalsced by GRO. To make things worse skb_cow_data()
tries to output a linear skb and allocates it with GFP_ATOMIC.
This occasionally fails even under moderate memory pressure.

This patch set rejigs the TLS Rx so that we don't expect decryption
in place. The decryption handlers return an skb which may or may not
be the skb from strparser. For TLS 1.3 this results in a 20-30%
performance improvement without NoPad enabled.

v2: rebase after 3d8c51b25a23 ("net/tls: Check for errors in tls_device_init")

Jakub Kicinski (11):
  tls: rx: allow only one reader at a time
  tls: rx: don't try to keep the skbs always on the list
  tls: rx: don't keep decrypted skbs on ctx->recv_pkt
  tls: rx: remove the message decrypted tracking
  tls: rx: factor out device darg update
  tls: rx: read the input skb from ctx->recv_pkt
  tls: rx: return the decrypted skb via darg
  tls: rx: async: adjust record geometry immediately
  tls: rx: async: hold onto the input skb
  tls: rx: async: don't put async zc on the list
  tls: rx: decrypt into a fresh skb

 include/net/strparser.h |   1 -
 include/net/tls.h       |   4 +
 net/tls/Makefile        |   2 +-
 net/tls/tls.h           |  20 +-
 net/tls/tls_device.c    |  25 ++-
 net/tls/tls_strp.c      |  17 ++
 net/tls/tls_sw.c        | 458 ++++++++++++++++++++++++----------------
 7 files changed, 333 insertions(+), 194 deletions(-)
 create mode 100644 net/tls/tls_strp.c

-- 
2.36.1

