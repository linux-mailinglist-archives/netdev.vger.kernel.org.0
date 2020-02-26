Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F89016F8B6
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 08:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbgBZHqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 02:46:48 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:36896 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727276AbgBZHqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 02:46:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1582703208; x=1614239208;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=Cy0He23WJr2pRe/l4V3cPqMWM+rzD946Ucvew68i0ko=;
  b=aFyAROs5aj/1Qp4V6DdqhaJ1XTFWkq1KRQpCMCZ1HWs38SctDYVg7e1I
   thXWVin+QA6Wpp11uCW8g+gAw/jWFdZMdwxfarORS+4W2gXqvr8ovAPJG
   MgMb11acoYvW27EzB3NFI6OZCxicqQ/NVbo+lk4lvi5m0yK9Cm/o/cYYM
   E=;
IronPort-SDR: qUXkkDSnRixoMfRDIrt6I1hje3SIhTL9Tsp+NkvKP5rTMHQ3nS9O51vtJ0r/WdrOn0c5cTp8OL
 OYXNbPEp687g==
X-IronPort-AV: E=Sophos;i="5.70,487,1574121600"; 
   d="scan'208";a="28929173"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 26 Feb 2020 07:46:47 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 6EE2F24367B;
        Wed, 26 Feb 2020 07:46:44 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 26 Feb 2020 07:46:43 +0000
Received: from 38f9d3582de7.ant.amazon.com.com (10.43.160.8) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 26 Feb 2020 07:46:39 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <edumazet@google.com>
CC:     <kuniyu@amazon.co.jp>, <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <osa-contribution-log@amazon.com>
Subject: [PATCH v2 net-next 0/3] Improve bind(addr, 0) behaviour.
Date:   Wed, 26 Feb 2020 16:46:28 +0900
Message-ID: <20200226074631.67688-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.8]
X-ClientProxiedBy: EX13D21UWA003.ant.amazon.com (10.43.160.184) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we fail to bind sockets to ephemeral ports when all of the ports
are exhausted even if all sockets have SO_REUSEADDR enabled. In this case,
we still have a chance to connect to the different remote hosts.

The second and third patches fix the behaviour to fully utilize all space
of the local (addr, port) tuples.

---
Changes in v2:
 - Change the description of the 2nd patch ('localhost' -> 'address').
 - Correct the description and the if statement of the 3rd patch.

v1 with tests:
 https://lore.kernel.org/netdev/20200220152020.13056-1-kuniyu@amazon.co.jp/
---

Kuniyuki Iwashima (3):
  tcp: Remove unnecessary conditions in inet_csk_bind_conflict().
  tcp: bind(addr, 0) remove the SO_REUSEADDR restriction when ephemeral
    ports are exhausted.
  tcp: Prevent port hijacking when ports are exhausted.

 net/ipv4/inet_connection_sock.c | 36 ++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 12 deletions(-)

-- 
2.17.2 (Apple Git-113)

