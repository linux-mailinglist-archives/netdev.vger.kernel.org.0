Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 749AF54EE02
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 01:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378765AbiFPXsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 19:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348137AbiFPXsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 19:48:09 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB011252A2
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 16:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1655423288; x=1686959288;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1rs1DYCAH388F9PSuBId/ePqF8Ni8rWJ1JCMTh8BKjM=;
  b=R771cJu5+6KfumdQVs/MlUHrS9mYPlRy0/2XrV/qHuSJjPYpd3l10zRe
   ugsBJTqb78w1mnHexMeDRURmOJemMitJl6C/D8Euv8Fl9U1AKsW77zs4y
   9e5GUtDnxF+qzsaKuTPKG3nqRn4dpRVO1DoJr/LguaGcvlWCe/oaM3yN5
   g=;
X-IronPort-AV: E=Sophos;i="5.92,306,1650931200"; 
   d="scan'208";a="98685392"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-54a073b7.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 16 Jun 2022 23:47:52 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-54a073b7.us-east-1.amazon.com (Postfix) with ESMTPS id 48941A08EF;
        Thu, 16 Jun 2022 23:47:49 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Thu, 16 Jun 2022 23:47:49 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.26) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Thu, 16 Jun 2022 23:47:47 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Amit Shah <aams@amazon.com>, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 0/6] af_unix: Introduce per-netns socket hash table.
Date:   Thu, 16 Jun 2022 16:47:08 -0700
Message-ID: <20220616234714.4291-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.26]
X-ClientProxiedBy: EX13d09UWC004.ant.amazon.com (10.43.162.114) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series replaces unix_socket_table with a per-netns hash table and
reduce lock contention.

Note the 3rd-6th patches can be a single patch, but for ease of review,
they are split into small changes without breakage.


Kuniyuki Iwashima (6):
  af_unix: Clean up some sock_net() uses.
  af_unix: Include the whole hash table size in UNIX_HASH_SIZE.
  af_unix: Define a per-netns hash table.
  af_unix: Acquire/Release per-netns hash table's locks.
  af_unix: Put a socket into a per-netns hash table.
  af_unix: Remove unix_table_locks.

 include/net/af_unix.h    |  10 +-
 include/net/netns/unix.h |   2 +
 net/unix/af_unix.c       | 213 +++++++++++++++++++++------------------
 net/unix/diag.c          |  47 ++++-----
 4 files changed, 143 insertions(+), 129 deletions(-)

-- 
2.30.2

