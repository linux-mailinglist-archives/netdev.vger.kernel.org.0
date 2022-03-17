Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA034DBD5D
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 04:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237383AbiCQDKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 23:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiCQDKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 23:10:04 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C1521242
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 20:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1647486518; x=1679022518;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vUBNLSBKwe/LVXIEQdFt6JFMj/oYb6b+h4EsxQ9uZZo=;
  b=pRE7D2vg+NEC+EPh7tYDKjg3285ddCFeyy63z4tZ+/cmxiboQ/klHdze
   VSO70WgRDDyIZBvRSiirLHqqO2HT4eoR5NBipxjTiruMXTDKRGrkRw8u0
   FeKYPYVr7zCo4bq8+wl4ouC+0+eGNdfhVyT0N4lK8S3N9x/uTYkH2NxIq
   A=;
X-IronPort-AV: E=Sophos;i="5.90,188,1643673600"; 
   d="scan'208";a="186691415"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-7dac3c4d.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 17 Mar 2022 03:08:37 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-7dac3c4d.us-east-1.amazon.com (Postfix) with ESMTPS id 60EC4832B5;
        Thu, 17 Mar 2022 03:08:35 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Thu, 17 Mar 2022 03:08:34 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.100) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Thu, 17 Mar 2022 03:08:31 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Rao Shoaib <Rao.Shoaib@oracle.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v4 net 0/2] af_unix: Fix some OOB implementation.
Date:   Thu, 17 Mar 2022 12:08:07 +0900
Message-ID: <20220317030809.63672-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.100]
X-ClientProxiedBy: EX13D04UWB004.ant.amazon.com (10.43.161.103) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes some data-races and adds a missing feature around the
commit 314001f0bf92 ("af_unix: Add OOB support").

Changelog:
  - v4:
    - Separate nit changes from this series for net-next

  - v3: https://lore.kernel.org/netdev/20220315183855.15190-1-kuniyu@amazon.co.jp/
    - Add the first patch

  - v2: https://lore.kernel.org/netdev/20220315054801.72035-1-kuniyu@amazon.co.jp/
    - Add READ_ONCE() to avoid syzbot warning (Eric)
    - Add IS_ENABLED(CONFIG_AF_UNIX_OOB) (Shoaib)

  - v1: https://lore.kernel.org/netdev/20220314052110.53634-1-kuniyu@amazon.co.jp/

Kuniyuki Iwashima (2):
  af_unix: Fix some data-races around unix_sk(sk)->oob_skb.
  af_unix: Support POLLPRI for OOB.

 net/unix/af_unix.c                               | 16 +++++++++-------
 .../selftests/net/af_unix/test_unix_oob.c        |  6 +++---
 2 files changed, 12 insertions(+), 10 deletions(-)

-- 
2.30.2

