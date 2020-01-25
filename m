Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 327F514945E
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 11:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgAYKlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 05:41:10 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:56507 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgAYKlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 05:41:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1579948870; x=1611484870;
  h=mime-version:content-transfer-encoding:subject:from:to:
   cc:date:in-reply-to:references:message-id;
  bh=yzs0IiyYXRqBrcVeLvEPS2k24thqDHcCb1hvWXUqtlQ=;
  b=o46GppRszJnKMVosf7uyII9PY68eEa3lo1zagyJV1N3G7Z6HGWQH8KrA
   XkmsuU3GsOXavqqbc5g+1lt7BHP6GcgkkpOE1A38HO71ipKceRdJSeE2d
   8lIWmAFcj5yuOvq9XJx0bXjC+Cl9mt+nbu2CTrYN4/bT8bVeTHFbG9jM/
   M=;
IronPort-SDR: dHV6wMYiYjuKdWd0scufCy+xv7ah33Se034k1CoCGcgP3/EBYhQzKCPtfqdHwPWb6xFXmQnmNf
 p+sdPZ/ITq3g==
X-IronPort-AV: E=Sophos;i="5.70,361,1574121600"; 
   d="scan'208";a="13223541"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 25 Jan 2020 10:41:08 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (Postfix) with ESMTPS id B3506A22FA;
        Sat, 25 Jan 2020 10:41:07 +0000 (UTC)
Received: from EX13D04ANC003.ant.amazon.com (10.43.157.44) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sat, 25 Jan 2020 10:41:07 +0000
Received: from EX13MTAUEA002.ant.amazon.com (10.43.61.77) by
 EX13D04ANC003.ant.amazon.com (10.43.157.44) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sat, 25 Jan 2020 10:41:05 +0000
Received: from hnd-1800232320.ant.amazon.com (10.85.11.118) by
 mail-relay.amazon.com (10.43.61.169) with Microsoft SMTP Server id
 15.0.1236.3 via Frontend Transport; Sat, 25 Jan 2020 10:41:03 +0000
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH v2 net-next] soreuseport: Cleanup duplicate initialization of
 more_reuse->max_socks.
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>
Date:   Sat, 25 Jan 2020 10:41:02 +0000
In-Reply-To: <20200125.102936.1710420903506965271.davem@davemloft.net>
References: <20200125.102936.1710420903506965271.davem@davemloft.net>
Message-ID: <336488a1ae764c05acffe4b930dfe787@EX13MTAUEA002.ant.amazon.com>
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
