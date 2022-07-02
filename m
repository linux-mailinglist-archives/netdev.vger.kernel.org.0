Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77411563D96
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 03:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiGBBpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 21:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiGBBpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 21:45:22 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697422FFE9
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 18:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1656726321; x=1688262321;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=znFWaaCW4vmNVyJp5CRa6OTSqo8AHCc1bE/vQxrXp8g=;
  b=NhF2+wZeVZ9HxUxxYCfMerFqllJmeauMivBk+sC6nMiEf8L/mfJJAUlo
   dhVcNO7Gm+JU1Pwreu+PKG6qFIFXIqsMcnA9HBLy1Awwl/fo4rHnZGYu4
   4jaygClUlGuSgjF1pg+Kl91Cy8/JeVksriJcZfTtKEnayhM3qHhCYF/R+
   U=;
X-IronPort-AV: E=Sophos;i="5.92,238,1650931200"; 
   d="scan'208";a="234243347"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-2d7489a4.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 02 Jul 2022 01:45:05 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-2d7489a4.us-east-1.amazon.com (Postfix) with ESMTPS id D3838828C0;
        Sat,  2 Jul 2022 01:45:01 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Sat, 2 Jul 2022 01:45:00 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.135) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Sat, 2 Jul 2022 01:44:58 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Sachin Sant <sachinp@linux.ibm.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        "Kuniyuki Iwashima" <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 net-next 0/2] af_unix: Fix regression by the per-netns hash table series.
Date:   Fri, 1 Jul 2022 18:44:45 -0700
Message-ID: <20220702014447.93746-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.135]
X-ClientProxiedBy: EX13D13UWA003.ant.amazon.com (10.43.160.181) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The series 6dd4142fb5a9 ("Merge branch 'af_unix-per-netns-socket-hash'")
replaced a global hash table with per-netns tables, which caused regression
reported in the links below. [0][1]

When a pathname socket is visible, any socket, even in different netns,
has to be able to connect to it.  The series puts all sockets into each
namespace's hash table, making it impossible to look up a visible socket
in different netns.

On the other hand, while dumping sockets, they are filtered by netns.  To
keep such code simple, let's add a new global hash table only for pathname
sockets and link them with sk_bind_node.  Then we can keep all sockets in
each per-netns table and look up pathname sockets via the global table.

[0]: https://lore.kernel.org/netdev/B2AA3091-796D-475E-9A11-0021996E1C00@linux.ibm.com/
[1]: https://lore.kernel.org/netdev/5fb8d86f-b633-7552-8ba9-41e42f07c02a@gmail.com/


Kuniyuki Iwashima (2):
  af_unix: Put a named socket in the global hash table.
  selftests: net: af_unix: Test connect() with different netns.

 net/unix/af_unix.c                            |  47 ++++--
 tools/testing/selftests/net/.gitignore        |   1 +
 tools/testing/selftests/net/af_unix/Makefile  |   3 +-
 .../selftests/net/af_unix/unix_connect.c      | 149 ++++++++++++++++++
 4 files changed, 189 insertions(+), 11 deletions(-)
 create mode 100644 tools/testing/selftests/net/af_unix/unix_connect.c

-- 
2.30.2

