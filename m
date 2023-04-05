Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03BA96D8719
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 21:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbjDETmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 15:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbjDETmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 15:42:35 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553687DA1;
        Wed,  5 Apr 2023 12:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1680723730; x=1712259730;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Il/c9zrZadYU+NJze4owrkPjczvBjhetfSLhJPy5Zbs=;
  b=GQUoC3wxNbxhgcHYv8aW7Aky2HeAlY4R0PU05DYypWVf3oxiC4Vu5vo/
   J2PciWleRKWIDf7SuE4KjJvPeXFsSy6rP4hAtis1CeVaQ/xh0U/k8WqFC
   CDc7E44BFYjUT+1p2o8uQAAtSqS6g+fjIk0EJpUAp9S3uVrq2EHRUYcjQ
   M=;
X-IronPort-AV: E=Sophos;i="5.98,321,1673913600"; 
   d="scan'208";a="201472885"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 19:41:58 +0000
Received: from EX19MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com (Postfix) with ESMTPS id 2F1CCC060D;
        Wed,  5 Apr 2023 19:41:57 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Wed, 5 Apr 2023 19:41:56 +0000
Received: from 88665a182662.ant.amazon.com.com (10.106.101.44) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 5 Apr 2023 19:41:53 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <bpf@vger.kernel.org>, <davem@davemloft.net>, <dsahern@kernel.org>,
        <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <threeearcat@gmail.com>, <yoshfuji@linux-ipv6.org>,
        <kuniyu@amazon.com>
Subject: Re: KASAN: use-after-free Read in tcp_write_timer_handler
Date:   Wed, 5 Apr 2023 12:41:43 -0700
Message-ID: <20230405194143.15708-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iKn4rpqj_8fYt0UMMgAq5L_2PNoY0Ev70ck8u4t4FC_=g@mail.gmail.com>
References: <CANn89iKn4rpqj_8fYt0UMMgAq5L_2PNoY0Ev70ck8u4t4FC_=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.106.101.44]
X-ClientProxiedBy: EX19D032UWA004.ant.amazon.com (10.13.139.56) To
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
Date:   Wed, 5 Apr 2023 13:28:16 +0200
> On Wed, Apr 5, 2023 at 12:41 PM Dae R. Jeong <threeearcat@gmail.com> wrote:
> >
> > Hi,
> >
> > We observed an issue "KASAN: use-after-free Read in tcp_write_timer_handler" during fuzzing.
> >
> > Unfortunately, we have not found a reproducer for the crash yet. We
> > will inform you if we have any update on this crash.  Detailed crash
> > information is attached below.
> >
> 
> Thanks for the report.
> 
> I have dozens of similar syzbot reports, with no repro.
> 
> I usually hold them, because otherwise it is just noise to mailing lists.
> 
> Normally, all user TCP sockets hold a reference on the netns
> 
> In all these cases, we see a netns being dismantled while there is at
> least one socket with a live timer.
> 
> This is therefore a kernel TCP socket, for which we do not have yet
> debugging infra ( REF_TRACKER )
> 
> CONFIG_NET_DEV_REFCNT_TRACKER=y is helping to detect too many dev_put(),
> we need something tracking the "kernel sockets" as well.

Maybe I missed something, but we track kernel sockets with netns
by notrefcnt_tracker ?

I thought now CONFIG_NET_NS_REFCNT_TRACKER can catch the case.


> 
> Otherwise bugs in subsystems not properly dismantling their kernel
> socket at netns dismantle are next to impossible to track and fix.
> 
> If anyone has time to implement this, feel free to submit patches.
> 
> Thanks.
