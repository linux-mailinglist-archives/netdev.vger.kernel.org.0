Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3E205A5782
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 01:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiH2XSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 19:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiH2XSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 19:18:42 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C6A80B43
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 16:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661815121; x=1693351121;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ORgV+Bj+dHRlX9ftk7Wrbbl3jQh24MQhovkBeCt4bao=;
  b=fxauG28NJukD9x2emNRzP7/2L6XgetzES7Z5pIX7n527NakYlOFgy5+6
   ZWPJE994fELXwWdED9lLWjJ5AjaWl/lCOrlx2aoMjUgJkbjwh4Wis5whP
   CnPywLRvUak0VTUsd4YQjBG3Uz9aMKsEfKymlH4SWGoGvuQsSWCocmsSM
   M=;
X-IronPort-AV: E=Sophos;i="5.93,273,1654560000"; 
   d="scan'208";a="124674452"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-7a21ed79.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2022 23:18:25 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-7a21ed79.us-east-1.amazon.com (Postfix) with ESMTPS id 2AA06220020;
        Mon, 29 Aug 2022 23:18:22 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Mon, 29 Aug 2022 23:18:22 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.121) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Mon, 29 Aug 2022 23:18:20 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH v2 net-next 5/5] tcp: Introduce optional per-netns ehash.
Date:   Mon, 29 Aug 2022 16:18:12 -0700
Message-ID: <20220829231812.19979-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iJ55OHnWh88-pRxMt4d_4cbr5Fa+JOH2VDrT1SWq1t=ZA@mail.gmail.com>
References: <CANn89iJ55OHnWh88-pRxMt4d_4cbr5Fa+JOH2VDrT1SWq1t=ZA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.121]
X-ClientProxiedBy: EX13D30UWC003.ant.amazon.com (10.43.162.122) To
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
Date:   Mon, 29 Aug 2022 15:59:04 -0700
> On Mon, Aug 29, 2022 at 9:21 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > The more sockets we have in the hash table, the longer we spend looking
> > up the socket.  While running a number of small workloads on the same
> > host, they penalise each other and cause performance degradation.>
> 
> ...
> > +static int proc_tcp_child_ehash_entries(struct ctl_table *table, int write,
> > +                                       void *buffer, size_t *lenp, loff_t *ppos)
> > +{
> > +       unsigned int tcp_child_ehash_entries;
> > +       int ret;
> > +
> > +       ret = proc_douintvec_minmax(table, write, buffer, lenp, ppos);
> > +       if (!write || ret)
> > +               return ret;
> > +
> > +       tcp_child_ehash_entries = READ_ONCE(*(unsigned int *)table->data);
> > +       if (tcp_child_ehash_entries)
> > +               tcp_child_ehash_entries = roundup_pow_of_two(tcp_child_ehash_entries);
> 
> This is not thread safe.

Oh, I didn't know that.
Thank you for pointing out!

> 
> You could simply perform the roundup_pow_of_two() elsewhere,
> eg in tcp_set_hashinfo() (and leave the sysctl as set by the user)

Will do so and update the doc and changelog.


> 
> > +
> > +       WRITE_ONCE(*(unsigned int *)table->data, tcp_child_ehash_entries);
> > +
> > +       return 0;
> > +}
> > +
