Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9551660CC
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 16:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728446AbgBTPUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 10:20:43 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:52652 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728377AbgBTPUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 10:20:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1582212042; x=1613748042;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=VtdoAyWCZEUy5xLg+rfXV0SxgKajIxEMYj0YhOXS7b4=;
  b=iv4WfnVrPjIJu7Yrp7a2jYz0SDXBDI3u+LL4VdkOyx4hwtDZgR4Ba5F7
   Et1WlhqzYhIrZ9kTpKLp4VkS8BUeMwqbIiFz+ZKAQzP1c1hlaN9VC/RVS
   FUI1bjxQVhdTXiMuVH5VeStfGx0CqviHsnFY1Q0svKslzBU600MeVRs2n
   c=;
IronPort-SDR: vOkAJ9GMEOdNWABC4YJJj3i7uoS10pjH+65sl/rrIlKd0NTKwN52mMpsGvn6E6/bgvxJ84977b
 We6694QEzuoQ==
X-IronPort-AV: E=Sophos;i="5.70,464,1574121600"; 
   d="scan'208";a="27726735"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 20 Feb 2020 15:20:41 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id D8D3DA33E8;
        Thu, 20 Feb 2020 15:20:39 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 20 Feb 2020 15:20:38 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.162.50) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 20 Feb 2020 15:20:35 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <edumazet@google.com>
CC:     <kuniyu@amazon.co.jp>, <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <osa-contribution-log@amazon.com>
Subject: [PATCH net-next 0/3] Improve bind(addr, 0) behaviour.
Date:   Fri, 21 Feb 2020 00:20:17 +0900
Message-ID: <20200220152020.13056-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.50]
X-ClientProxiedBy: EX13P01UWA001.ant.amazon.com (10.43.160.213) To
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

Kuniyuki Iwashima (3):
  tcp: Remove unnecessary conditions in inet_csk_bind_conflict().
  tcp: bind(addr, 0) remove the SO_REUSEADDR restriction when ephemeral
    ports are exhausted.
  tcp: Prevent port hijacking when ports are exhausted

 net/ipv4/inet_connection_sock.c | 36 ++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 12 deletions(-)

-- 
2.17.2 (Apple Git-113)

