Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA8BF5A5786
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 01:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiH2XXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 19:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiH2XXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 19:23:02 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5057C1AF
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 16:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661815381; x=1693351381;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Esn97lorfvDY50ZEJ4RH23CMf4hV5u+UNR1c2q0/H7c=;
  b=duEBmhbtfsC2AS3/uH3JKGPb1s1HM7uIHCdETWEF6g7zcCanoxZbgWrs
   p6Gnghtbpx5Ky2ociDpCSv9Zg5jSlm+vGf8Raqnt9d6EmNzq11FAaOO9a
   NdjBalJtgtBoSLAT05lGPPyQFWV1ulrG8CxlP7QyAmejMItSewUMykoTc
   k=;
X-IronPort-AV: E=Sophos;i="5.93,273,1654560000"; 
   d="scan'208";a="1049290615"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-1f9d5b26.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2022 23:22:44 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-1f9d5b26.us-west-2.amazon.com (Postfix) with ESMTPS id 1604A44F64;
        Mon, 29 Aug 2022 23:22:42 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Mon, 29 Aug 2022 23:22:39 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.121) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Mon, 29 Aug 2022 23:22:38 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH v2 net-next 3/5] tcp: Access &tcp_hashinfo via net.
Date:   Mon, 29 Aug 2022 16:22:30 -0700
Message-ID: <20220829232230.20308-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iL0FpMHZ0YETN8DaO1Tj+P2kA1FBrH+8D4or9M9beqRug@mail.gmail.com>
References: <CANn89iL0FpMHZ0YETN8DaO1Tj+P2kA1FBrH+8D4or9M9beqRug@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.121]
X-ClientProxiedBy: EX13D11UWB004.ant.amazon.com (10.43.161.90) To
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

From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 29 Aug 2022 16:03:50 -0700
> On Mon, Aug 29, 2022 at 9:20 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > We will soon introduce an optional per-netns ehash.
> >
> > This means we cannot use tcp_hashinfo directly in most places.
> >
> > Instead, access it via net->ipv4.tcp_death_row->hashinfo.
> >
> > The access will be valid only while initialising tcp_hashinfo
> > itself and creating/destroying each netns.
> >
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > ---
> >  .../mellanox/mlx5/core/en_accel/ktls_rx.c     |  5 +-
> >  .../net/ethernet/netronome/nfp/crypto/tls.c   |  5 +-
> 
> I would probably omit changes in these two drivers, they look pure noise to me.
> 
> It is unfortunate enough that some drivers go deep in TCP stack, no need
> to make your patches intrusive.

Ok, I'll drop them.
