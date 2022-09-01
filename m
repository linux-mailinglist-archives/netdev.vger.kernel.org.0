Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 631FD5AA2F8
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 00:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234471AbiIAWZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 18:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233931AbiIAWYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 18:24:36 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F62A833B
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 15:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1662070873; x=1693606873;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=erSoxjQKGP3fPOV61w051dVsCqkqx5Rj1Dn8Q/nY93s=;
  b=KMiCE6YpLWnlMBHhLf5fqz23fEvPLcCl65eQ9pZTM40uQkDjz8d5L33N
   6cl400qpxrJyWwwz2lqf/7iKVqtdu2TxeJdMr5y+0TFCyenrgh0LTqr9y
   L3kzltXzakB7WpsjS7qIcJH1DbYiX9f2qezK9/CWYojdKkEdkLUWrYAWB
   E=;
X-IronPort-AV: E=Sophos;i="5.93,281,1654560000"; 
   d="scan'208";a="1050492615"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-90d70b14.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 22:19:31 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-90d70b14.us-east-1.amazon.com (Postfix) with ESMTPS id 8D0B3C0916;
        Thu,  1 Sep 2022 22:19:28 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 1 Sep 2022 22:19:27 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.191) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 1 Sep 2022 22:19:25 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <kuba@kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH v3 net-next 3/5] tcp: Access &tcp_hashinfo via net.
Date:   Thu, 1 Sep 2022 15:19:17 -0700
Message-ID: <20220901221917.15331-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220901144936.4aaef04b@kernel.org>
References: <20220901144936.4aaef04b@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.191]
X-ClientProxiedBy: EX13D20UWA003.ant.amazon.com (10.43.160.97) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Jakub Kicinski <kuba@kernel.org>
Date:   Thu, 1 Sep 2022 14:49:36 -0700
> On Thu, 1 Sep 2022 14:25:20 -0700 Kuniyuki Iwashima wrote:
> > > I looks to me that the above chunks are functionally a no-op and I
> > > think that omitting the 2 drivers from the v2:
> > > 
> > > https://lore.kernel.org/netdev/20220829161920.99409-4-kuniyu@amazon.com/
> > > 
> > > should break mlx5/nfp inside a netns. I don't understand why including
> > > the above and skipping the latters?!? I guess is a question mostly for
> > > Eric :)  
> > 
> > My best guess is that it's ok unless it does not touch TCP stack deeply
> > and if it does, the driver developer must catch up with the core changes
> > not to burden maintainers...?
> > 
> > If so, I understand that take.  OTOH, I also don't want to break anything
> > when we know the change would do.
> > 
> > So, I'm fine to either stay as is or add the change in v4 again.
> 
> FWIW I share Paolo's concern. If we don't want the drivers to be
> twiddling with the hash tables we should factor out that code to
> a common helper in net/tls/

That makes sense.
For the moment, I'll add the changes back in v4.
