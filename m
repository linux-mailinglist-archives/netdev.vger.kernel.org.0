Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56CBD5538C3
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 19:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353074AbiFURTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 13:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353198AbiFURTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 13:19:54 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49A424F37
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 10:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1655831993; x=1687367993;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GbQaryeWaOVjVdVAXDFTywVlWW39rLCYTGp0cBTejYA=;
  b=qS1SNRfpNXxIkkgT9y6PbxdkDNXDQcWGwtSl8lYCNYeD6emvp2++tjKN
   ncpKctT2Dp8r2s3VKNFUnSNqUMRnzkeDEMEao7mgoURDWatYCbVT0Gpni
   fW2e3kHD1bnwP7cxzcWi31cLFxrqxP4EU9aPAd3Wgx6NAfvB8iFxCmcgC
   Y=;
X-IronPort-AV: E=Sophos;i="5.92,209,1650931200"; 
   d="scan'208";a="100420177"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-a31e1d63.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 21 Jun 2022 17:19:32 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-a31e1d63.us-east-1.amazon.com (Postfix) with ESMTPS id 9D016A27F5;
        Tue, 21 Jun 2022 17:19:30 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Tue, 21 Jun 2022 17:19:29 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.161.29) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Tue, 21 Jun 2022 17:19:26 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Amit Shah <aams@amazon.com>, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 net-next 0/6] af_unix: Introduce per-netns socket hash table.
Date:   Tue, 21 Jun 2022 10:19:07 -0700
Message-ID: <20220621171913.73401-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.29]
X-ClientProxiedBy: EX13D12UWC002.ant.amazon.com (10.43.162.253) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series replaces unix_socket_table with a per-netns hash table and
reduces lock contention and time on iterating over the list.

Note the 3rd-6th patches can be a single patch, but for ease of review,
they are split into small changes without breakage.


Changes:
  v3:
    6th:
      * Remove unix_table_locks from comments.
      * Remove missed spin_unlock(&unix_table_locks) in
        unix_lookup_by_ino() (kernel test robot)

  v2: https://lore.kernel.org/netdev/20220620185151.65294-1-kuniyu@amazon.com/
    3rd:
      * Update changelog
      * Remove holes from per-netns hash table structure
      * Use kvmalloc_array() instead of kmalloc() (Eric Dumazet)
      * Remove unnecessary parts in af_unix_init() (Eric Dumazet)
      * Move `err_sysctl` label into ifdef block (kernel test robot)
      * Remove struct netns_unix from struct net if CONFIG_UNIX is disabled
    4th:
      * Use spin_lock_nested() (kernel test robot)

  v1: https://lore.kernel.org/netdev/20220616234714.4291-1-kuniyu@amazon.com/


Kuniyuki Iwashima (6):
  af_unix: Clean up some sock_net() uses.
  af_unix: Include the whole hash table size in UNIX_HASH_SIZE.
  af_unix: Define a per-netns hash table.
  af_unix: Acquire/Release per-netns hash table's locks.
  af_unix: Put a socket into a per-netns hash table.
  af_unix: Remove unix_table_locks.

 include/net/af_unix.h       |   5 +-
 include/net/net_namespace.h |   2 +
 include/net/netns/unix.h    |   6 +
 net/unix/af_unix.c          | 228 +++++++++++++++++++-----------------
 net/unix/diag.c             |  49 ++++----
 5 files changed, 152 insertions(+), 138 deletions(-)

-- 
2.30.2

