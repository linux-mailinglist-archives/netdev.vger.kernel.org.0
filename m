Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35760146D5F
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 16:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbgAWPw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 10:52:28 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:43267 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbgAWPw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 10:52:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1579794748; x=1611330748;
  h=mime-version:content-transfer-encoding:subject:from:to:
   cc:date:message-id;
  bh=okbzb16OjARxNr7dI2up8Xxd3Nt/StOduwT1iuvc0ZI=;
  b=mOMuzmf6N8/89C43j9GI0bQ0EQBNCtnv4w1j0CbB5nTkgMjmw9do2D1v
   US9gvgnru9f9sYvEyMcmUJn5o7qUdI2XAWqz53mMoT3x2sqfpKQMl4X9S
   Y4aoxQm+9Mtraze5lTEO588g9dDDnNL/OOhtVMKddm+myflih8hgpOAD1
   k=;
IronPort-SDR: IHrPwjotR+hUFFw9HW5TZI//2sZaBuFct4lZvigIg5LRh9W8PeL6tBFC99tPHqqhM29yiZRGJh
 bB+3M71i4vNA==
X-IronPort-AV: E=Sophos;i="5.70,354,1574121600"; 
   d="scan'208";a="21983413"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 23 Jan 2020 15:52:27 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id 61E261415F0;
        Thu, 23 Jan 2020 15:52:25 +0000 (UTC)
Received: from EX13D21UWA003.ant.amazon.com (10.43.160.184) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 23 Jan 2020 15:52:24 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D21UWA003.ant.amazon.com (10.43.160.184) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 23 Jan 2020 15:52:24 +0000
Received: from nrt-1800282903.ant.amazon.com (10.85.11.138) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 23 Jan 2020 15:52:24 +0000
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH net-next] soreuseport: Cleanup duplicate initialization of
 more_reuse->max_socks.
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Kuniyuki Iwashima <kuni1840@gmail.com>
Date:   Thu, 23 Jan 2020 15:52:23 +0000
Message-ID: <658d70e554ee4206b753cc2014407d95@EX13MTAUWA001.ant.amazon.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

reuseport_grow() does not need to initialize the more_reuse->max_socks
again. It is already initialized in __reuseport_alloc().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
net/core/sock_reuseport.c | 1 -
1 file changed, 1 deletion(-)

diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index f19f179538b9..91e9f2223c39 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -107,7 +107,6 @@ static struct sock_reuseport *reuseport_grow(struct sock_reuseport *reuse)
	if (!more_reuse)
		return NULL;
-	more_reuse->max_socks = more_socks_size;
	more_reuse->num_socks = reuse->num_socks;
	more_reuse->prog = reuse->prog;
	more_reuse->reuseport_id = reuse->reuseport_id;
--
2.17.2
