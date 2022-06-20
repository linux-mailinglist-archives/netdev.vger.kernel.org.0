Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4A955243D
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 20:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242513AbiFTSwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 14:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237201AbiFTSw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 14:52:29 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30FBF1144A
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 11:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1655751148; x=1687287148;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0NnFSP+9QCgZIDbEMIRId5OOvDYg2SGI2BcyBtGCZWc=;
  b=qOi8nvGqDcZKxeGKY9kJOmss+qxEXVhJ2lLgYZt3CoeL4WOpEA/FTuKf
   dHXCNbyANWbtrLYy5W0xdtQ/wgJvhalzXUb582Vbve1vhG/LZV0B2fDNw
   VZ6CUfL5EsvyKuUbz2WyAmCnHF049lnQA1D4b6ztrcwLyE7QTpLKkamwY
   o=;
X-IronPort-AV: E=Sophos;i="5.92,207,1650931200"; 
   d="scan'208";a="203576704"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-8be8ed69.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 20 Jun 2022 18:52:13 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-8be8ed69.us-east-1.amazon.com (Postfix) with ESMTPS id 570BAC07FE;
        Mon, 20 Jun 2022 18:52:11 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 20 Jun 2022 18:52:10 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.183) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 20 Jun 2022 18:52:07 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Amit Shah <aams@amazon.com>, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 net-next 0/6] af_unix: Introduce per-netns socket hash table.
Date:   Mon, 20 Jun 2022 11:51:45 -0700
Message-ID: <20220620185151.65294-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.183]
X-ClientProxiedBy: EX13D22UWB004.ant.amazon.com (10.43.161.165) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
  v2:
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
 net/unix/af_unix.c          | 216 +++++++++++++++++++-----------------
 net/unix/diag.c             |  46 ++++----
 5 files changed, 145 insertions(+), 130 deletions(-)

-- 
2.30.2

