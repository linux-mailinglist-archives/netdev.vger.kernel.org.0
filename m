Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2E556CCA06
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 20:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjC1Saa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 14:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjC1Sa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 14:30:29 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0EC19A4
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 11:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1680028222; x=1711564222;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wmbpk+AEd2vI1hTK6tpY/Iy/kIkZ3CH5fHon1oa+J0k=;
  b=lLdjw9d25p2a9aUEOw/XwK8csVCja6zy9VFJMjJ34JTbe3i1P5EywhJk
   Fkh09NcfSVwNQy9F1Rm3Rub7bKPDL7lqkAf9n+DQRyLfxPgQX+8Mj4xeO
   +plglxVVnlRckwGAfTsFd3A0znIL0KOkKcvticOmXWQjesHBttIxP1vQo
   E=;
X-IronPort-AV: E=Sophos;i="5.98,297,1673913600"; 
   d="scan'208";a="198476759"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-189d700f.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 18:30:19 +0000
Received: from EX19MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-m6i4x-189d700f.us-west-2.amazon.com (Postfix) with ESMTPS id 4A2BD41228;
        Tue, 28 Mar 2023 18:30:18 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Tue, 28 Mar 2023 18:30:17 +0000
Received: from 88665a182662.ant.amazon.com (10.187.171.35) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 28 Mar 2023 18:30:15 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH v1 net] tcp: Refine SYN handling for PAWS.
Date:   Tue, 28 Mar 2023 11:30:07 -0700
Message-ID: <20230328183007.61180-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iKxEwUq8NSHuPmF89LB6mboj9v6+94b0wikoDohsNTrLg@mail.gmail.com>
References: <CANn89iKxEwUq8NSHuPmF89LB6mboj9v6+94b0wikoDohsNTrLg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.171.35]
X-ClientProxiedBy: EX19D046UWB001.ant.amazon.com (10.13.139.187) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 28 Mar 2023 19:48:03 +0200
> On Tue, Mar 28, 2023 at 6:41=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazon.co=
> m> wrote:
> 
> > I see.
> > Should I replace the tag with add 'CC: stable # backport ver', or
> > respin for net-next without the tag ?
> 
> Yes, net-next should be a better target I think, but no hard feelings
> if this makes your life easier.

Sure, I'll post it for net-next.

