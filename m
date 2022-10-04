Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639655F462D
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 17:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiJDPI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 11:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiJDPI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 11:08:28 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D9A5AC6B;
        Tue,  4 Oct 2022 08:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1664896105; x=1696432105;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/5qQt6Ot5CenKNhYH38rGblgAfedEEAR7Mk5oEVODkI=;
  b=Ertd/EigvYmCes8jQMwciWa9jnnGrQdDkk4TA1StZ9uC10DEEZ9qs+Gt
   iyAbcrUfimPo66dgEIKoEX1ZLeYp0Zv9SZUKGGkCb059nwi5bxWGgzrLC
   hs+n23440743ymI+BQ3oDOJU0T4zusSYh0d8BgqKuZb9BkpRk5kwKI/3+
   Q=;
X-IronPort-AV: E=Sophos;i="5.95,158,1661817600"; 
   d="scan'208";a="1060718463"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-7d0c7241.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2022 14:55:41 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-7d0c7241.us-west-2.amazon.com (Postfix) with ESMTPS id 37CF745C8F;
        Tue,  4 Oct 2022 14:55:41 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 4 Oct 2022 14:55:40 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.35) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 4 Oct 2022 14:55:34 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <pabeni@redhat.com>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <syzkaller-bugs@googlegroups.com>, <vyasevic@redhat.com>,
        <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH RESEND v3 net 3/5] tcp/udp: Call inet6_destroy_sock() in IPv6 sk->sk_destruct().
Date:   Tue, 4 Oct 2022 07:55:24 -0700
Message-ID: <20221004145524.32829-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <122af5c891fcc65fb6179ec53a89374daa4600aa.camel@redhat.com>
References: <122af5c891fcc65fb6179ec53a89374daa4600aa.camel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.35]
X-ClientProxiedBy: EX13D08UWB004.ant.amazon.com (10.43.161.232) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Paolo Abeni <pabeni@redhat.com>
Date:   Tue, 04 Oct 2022 12:21:20 +0200
> Hello,
> 
> On Mon, 2022-10-03 at 08:44 -0700, Kuniyuki Iwashima wrote:
> [...]
> > @@ -1723,7 +1736,7 @@ struct proto udpv6_prot = {
> >  	.connect		= ip6_datagram_connect,
> >  	.disconnect		= udp_disconnect,
> >  	.ioctl			= udp_ioctl,
> > -	.init			= udp_init_sock,
> > +	.init			= udpv6_init_sock,
> >  	.destroy		= udpv6_destroy_sock,
> >  	.setsockopt		= udpv6_setsockopt,
> >  	.getsockopt		= udpv6_getsockopt,
> 
> It looks like even UDPv6 lite can be ADDRFORMed to ipv4, so I guess we
> need a similar chunk for udplitev6_prot? With that we can unexport 
> udp_init_sock, I guess.

Good catch!
Yes, I'll add that changes in v4.
Thank you.
