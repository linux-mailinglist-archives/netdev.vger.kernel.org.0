Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF42446D25
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 10:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbhKFJUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 05:20:12 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:12983 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbhKFJUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 05:20:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1636190250; x=1667726250;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eLms/cF8sp/7sdS4urV6Uf1FQrfnjQQ22TuCqm8Ih1s=;
  b=lHcrJ0gkQKrPaWzkA+5OlLV70bsTfXxNGBAaJZoABSxb7yaQHN8AarfM
   RGU0T1lG0z6qjfaIufExA4W69hoMMmpHloz4ZdcxQsPuAjVpNR7gRE5h9
   +Y6tAoSAAyTe9FBeAo6GaOuYTi0Rqa/DUZ9xsZdqL2fG5FRuGrdVN+V3+
   Q=;
X-IronPort-AV: E=Sophos;i="5.87,213,1631577600"; 
   d="scan'208";a="969837647"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-98691110.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 06 Nov 2021 09:17:29 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-98691110.us-east-1.amazon.com (Postfix) with ESMTPS id 5BA1B81422;
        Sat,  6 Nov 2021 09:17:29 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.24; Sat, 6 Nov 2021 09:17:28 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.153) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.24; Sat, 6 Nov 2021 09:17:25 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH net-next 00/13] af_unix: Replace unix_table_lock with per-hash locks.
Date:   Sat, 6 Nov 2021 18:16:59 +0900
Message-ID: <20211106091712.15206-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.153]
X-ClientProxiedBy: EX13D03UWA001.ant.amazon.com (10.43.160.141) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hash table of AF_UNIX sockets is protected by a single big lock,
unix_table_lock.  This series replaces it with small per-hash locks.

1st -  2nd : Misc refactoring
3rd -  8th : Separate BSD/abstract address logics
9th - 11th : Prep to save a hash in each socket
12th       : Replace the big lock
13th       : Speed up autobind()

After this series land in bpf-next, I will post another series to support
bpf batching iteration and bpf_(get|set)sockopt for AF_UNIX sockets.


Kuniyuki Iwashima (13):
  af_unix: Use offsetof() instead of sizeof().
  af_unix: Pass struct sock to unix_autobind().
  af_unix: Factorise unix_find_other() based on address types.
  af_unix: Return an error as a pointer in unix_find_other().
  af_unix: Cut unix_validate_addr() out of unix_mkname().
  af_unix: Copy unix_mkname() into unix_find_(bsd|abstract)().
  af_unix: Remove unix_mkname().
  af_unix: Allocate unix_address in unix_bind_(bsd|abstract)().
  af_unix: Remove UNIX_ABSTRACT() macro and test sun_path[0] instead.
  af_unix: Add helpers to calculate hashes.
  af_unix: Save hash in sk_hash.
  af_unix: Replace the big lock with small locks.
  af_unix: Relax race in unix_autobind().

 include/net/af_unix.h                         |   3 +-
 net/unix/af_unix.c                            | 556 ++++++++++--------
 net/unix/diag.c                               |  23 +-
 .../selftests/bpf/progs/bpf_iter_unix.c       |   2 +-
 .../selftests/bpf/progs/bpf_tracing_net.h     |   2 -
 .../bpf/progs/test_skc_to_unix_sock.c         |   2 +-
 6 files changed, 334 insertions(+), 254 deletions(-)

-- 
2.30.2

