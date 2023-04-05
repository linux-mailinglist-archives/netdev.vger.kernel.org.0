Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6FB76D81B4
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 17:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237448AbjDEP0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 11:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232985AbjDEP0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 11:26:10 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42157E5
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 08:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1680708369; x=1712244369;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6dVt6BszMNHJXj3kgt5XV4Lk5CptYC1i+H9cV3oXZUI=;
  b=i0d7HkC+XrUUQPp/bH+B8e1kILCcaEE8U8hg6xSOIZV3EtZ3pephayQ2
   22V0tvOcg+3+vn7KSIyofiMD8k2DJvfhCYtCGDMjiavUviyK7Uee7B2pA
   UKpdGNLn/IQ+qsgNkrMZkMd8Z/tzD98pvFWY+0XtIFnM/0Y0+ffn9CKwZ
   A=;
X-IronPort-AV: E=Sophos;i="5.98,321,1673913600"; 
   d="scan'208";a="310853915"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-f253a3a3.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 15:26:05 +0000
Received: from EX19MTAUWA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-f253a3a3.us-west-2.amazon.com (Postfix) with ESMTPS id 290F580E30;
        Wed,  5 Apr 2023 15:26:04 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 5 Apr 2023 15:26:03 +0000
Received: from 88665a182662.ant.amazon.com (10.106.101.44) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 5 Apr 2023 15:26:00 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <lixiaoyan@google.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH v1 net-next] selftest/net: Fix uninit val warning in tcp_mmap.c.
Date:   Wed, 5 Apr 2023 08:25:51 -0700
Message-ID: <20230405152551.56141-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iK+Gv2AbNH5DGxTUX_LAXZ8dzyrp0ivCKq6rYaJB1dYsQ@mail.gmail.com>
References: <CANn89iK+Gv2AbNH5DGxTUX_LAXZ8dzyrp0ivCKq6rYaJB1dYsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.106.101.44]
X-ClientProxiedBy: EX19D032UWB003.ant.amazon.com (10.13.139.165) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 5 Apr 2023 09:05:38 +0200
> On Wed, Apr 5, 2023 at 4:33 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > Commit 5c5945dc695c ("selftests/net: Add SHA256 computation over data
> > sent in tcp_mmap") forgot to initialise a local var.
> >
> >   $ make -s -C tools/testing/selftests/net
> >   tcp_mmap.c: In function ‘child_thread’:
> >   tcp_mmap.c:211:61: warning: ‘lu’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> >     211 |                         zc.length = min(chunk_size, FILE_SZ - lu);
> >         |                                                             ^
> >
> > Fixes: 5c5945dc695c ("selftests/net: Add SHA256 computation over data sent in tcp_mmap")
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > ---
> > Note that the cited commit is not merged in net.git.
> > ---
> >  tools/testing/selftests/net/tcp_mmap.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/net/tcp_mmap.c b/tools/testing/selftests/net/tcp_mmap.c
> > index 607cc9ad8d1b..1056e37f4d98 100644
> > --- a/tools/testing/selftests/net/tcp_mmap.c
> > +++ b/tools/testing/selftests/net/tcp_mmap.c
> > @@ -168,7 +168,7 @@ void *child_thread(void *arg)
> >         double throughput;
> >         struct rusage ru;
> >         size_t buffer_sz;
> > -       int lu, fd;
> > +       int lu = 0, fd;
> >
> >         fd = (int)(unsigned long)arg;
> >
> > --
> > 2.30.2
> >
> 
> This is not the right fix. I sent it yesterday, not sure if you have seen it ?

Yes, I missed that.
Sorry for noise and thank you for your fix!
