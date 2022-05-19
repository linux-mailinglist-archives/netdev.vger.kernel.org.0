Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4FB252CD94
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 09:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235050AbiESHv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 03:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235048AbiESHvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 03:51:46 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3998E434B6;
        Thu, 19 May 2022 00:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1652946705; x=1684482705;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2iFj8eMw07xwx7nl36uCuyivAkU8E8HF5KmfsEJEFiI=;
  b=RcVS4LKheWUKjdN6wzDmcHQS8Q+iZFimw+78eIef9L0sORKMHHi7eRZ8
   24bIZIpKyrjOWj5I8Ul23HX79tZE6f4ypCs2d1Nt2VPkkIb8Y6cuBNk5g
   wJHUXiQUyTk1aM4owyu5yUflIv1epqy/TnGZnU6jK1hn1Sj4lPrNtw4OU
   E=;
X-IronPort-AV: E=Sophos;i="5.91,237,1647302400"; 
   d="scan'208";a="89838153"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-ca048aa0.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 19 May 2022 07:51:43 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1d-ca048aa0.us-east-1.amazon.com (Postfix) with ESMTPS id 15D7281303;
        Thu, 19 May 2022 07:51:38 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Thu, 19 May 2022 07:51:31 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.12) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Thu, 19 May 2022 07:51:27 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <joannelkoong@gmail.com>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
        <kafai@fb.com>, <kuba@kernel.org>, <kuniyu@amazon.co.jp>,
        <pabeni@redhat.com>, <richard_siegfried@systemli.org>,
        <yoshfuji@linux-ipv6.org>, <netdev@vger.kernel.org>,
        <dccp@vger.kernel.org>
Subject: Re: [PATCH net-next v5 1/2] net: Add a second bind table hashed by port and address
Date:   Thu, 19 May 2022 16:51:19 +0900
Message-ID: <20220519075119.87442-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220518231912.2891175-2-joannelkoong@gmail.com>
References: <20220518231912.2891175-2-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.12]
X-ClientProxiedBy: EX13D30UWC003.ant.amazon.com (10.43.162.122) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 18 May 2022 16:19:11 -0700
> We currently have one tcp bind table (bhash) which hashes by port
> number only. In the socket bind path, we check for bind conflicts by
> traversing the specified port's inet_bind2_bucket while holding the
> bucket's spinlock (see inet_csk_get_port() and inet_csk_bind_conflict()).
> 
> In instances where there are tons of sockets hashed to the same port
> at different addresses, checking for a bind conflict is time-intensive
> and can cause softirq cpu lockups, as well as stops new tcp connections
> since __inet_inherit_port() also contests for the spinlock.
> 
> This patch proposes adding a second bind table, bhash2, that hashes by
> port and ip address. Searching the bhash2 table leads to significantly
> faster conflict resolution and less time holding the spinlock.
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Acked-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

To maintainers:
lore and patchwork seem to miss this version...?

Thank you.
