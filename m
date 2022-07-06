Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6516568ECE
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 18:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233813AbiGFQQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 12:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232424AbiGFQQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 12:16:06 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92FA0252AF;
        Wed,  6 Jul 2022 09:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657124166; x=1688660166;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cn087kP47L9yjKTgn5YkiVUsrVukf0do8ZQX7mf4vSU=;
  b=eYlmdslqHbzMa1ZWerXSKPvusNgK1Q1h6geu1+yEnzbEr2mcDufwTHg6
   hhNINplXfkALyNWmk6AnOgyglmPmGbktVQTZkWSjIPAeibpDJAWz/zIiK
   pFObGjkMk1n9oCuLnGOB1cZO+XeZqvOi2uNUFWmZc8j1Gla2BLIoM2ITG
   U=;
X-IronPort-AV: E=Sophos;i="5.92,250,1650931200"; 
   d="scan'208";a="207775818"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-e6c05252.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 06 Jul 2022 16:15:50 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-e6c05252.us-west-2.amazon.com (Postfix) with ESMTPS id 9908643AF6;
        Wed,  6 Jul 2022 16:15:48 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 6 Jul 2022 16:15:47 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.187) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 6 Jul 2022 16:15:44 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <keescook@chromium.org>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <linux-kernel@vger.kernel.org>, <mcgrof@kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>, <yzaikin@google.com>
Subject: Re: [PATCH v1 net 03/16] sysctl: Add proc_dointvec_lockless().
Date:   Wed, 6 Jul 2022 09:15:36 -0700
Message-ID: <20220706161536.46956-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89i+mJCN=4h5-MM5jUQN8Hv=NdyTmQQb7Oeop+DyYVcEWUg@mail.gmail.com>
References: <CANn89i+mJCN=4h5-MM5jUQN8Hv=NdyTmQQb7Oeop+DyYVcEWUg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.187]
X-ClientProxiedBy: EX13D25UWC003.ant.amazon.com (10.43.162.129) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 6 Jul 2022 09:00:11 +0200
> On Wed, Jul 6, 2022 at 7:22 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > A sysctl variable is accessed concurrently, and there is always a chance of
> > data-race.  So, all readers and writers need some basic protection to avoid
> > load/store-tearing.
> >
> > This patch changes proc_dointvec() to use READ_ONCE()/WRITE_ONCE()
> > internally to fix a data-race on the sysctl side.  For now, proc_dointvec()
> > itself is tolerant to a data-race, but we still need to add annotations on
> > the other subsystem's side.
> >
> > In case we miss such fixes, this patch converts proc_dointvec() to a
> > wrapper of proc_dointvec_lockless().  When we fix a data-race in the other
> > subsystem, we can explicitly set it as a handler.
> >
> > Also, this patch removes proc_dointvec()'s document and adds
> > proc_dointvec_lockless()'s one so that no one will use proc_dointvec()
> > anymore.
> >
> > While we are on it, we remove some trailing spaces.
> 
> 
> I do not see why you add more functions.

It was not to miss where we still need fixes and to be taken care of
by newly added sysctl knob.


> Really all sysctls can change locklessly by nature, as I pointed out.
> 
> So I would simply add WRITE_ONCE() whenever they are written, and
> READ_ONCE() when they are read.
> 
> If stable teams care enough, they will have to backport these changes,
> so I would rather not have to change
> proc_dointvec() to proc_dointvec_lockless() in many files, with many
> conflicts, that ultimately will either
> add bugs, or ask extra work for maintainers.

Indeed, I will drop such changes and just add annotations in *_conv().
Thank you!
