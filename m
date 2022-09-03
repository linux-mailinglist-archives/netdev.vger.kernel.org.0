Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 177885ABC91
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 05:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbiICDZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 23:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbiICDZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 23:25:54 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8979CCE4A4
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 20:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1662175553; x=1693711553;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8m4gYiA/2BFMggmUhsi2lE/4Gdcl/CKlVeyJWRVl3DU=;
  b=nQYviIRH4udV5twKzBkA2N2/XZBADEHtd02U2ymRL8EVUs+neGRkVGxm
   qSoKRhw9GD6yc4r3BM5vJJZUaZ5NwahdD26QX63qqwR/LsgPiyPEDJJ/L
   MkrNLTChGzYAY7WMsc/HYV67TWrYdVhGuBpH9xk1U0+30xVJBLm+hNWRN
   g=;
X-IronPort-AV: E=Sophos;i="5.93,286,1654560000"; 
   d="scan'208";a="237209421"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-8bf71a74.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2022 03:25:52 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-8bf71a74.us-east-1.amazon.com (Postfix) with ESMTPS id 858EDC0A2B;
        Sat,  3 Sep 2022 03:25:50 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Sat, 3 Sep 2022 03:25:49 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.172) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Sat, 3 Sep 2022 03:25:47 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH v3 net-next 3/5] tcp: Access &tcp_hashinfo via net.
Date:   Fri, 2 Sep 2022 20:25:39 -0700
Message-ID: <20220903032539.99724-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iJajB9Jp_fJO5jd8_sF1sL6g=NFTw-jgiBRcFT18P0d-w@mail.gmail.com>
References: <CANn89iJajB9Jp_fJO5jd8_sF1sL6g=NFTw-jgiBRcFT18P0d-w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.172]
X-ClientProxiedBy: EX13D06UWC002.ant.amazon.com (10.43.162.205) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 2 Sep 2022 20:16:11 -0700
> On Fri, Sep 2, 2022 at 7:50 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> 
> > Ah, exactly.
> > Then I will add ____cacheline_aligned_in_smp to tw_refcount, instead of
> > keeping the original order, to avoid invalidation by sysctl_max_tw_buckets
> > change, which wouldn't be so frequently done though.
> >
> >  struct inet_timewait_death_row {
> > -       refcount_t              tw_refcount;
> > -
> > -       struct inet_hashinfo    *hashinfo ____cacheline_aligned_in_smp;
> > +       struct inet_hashinfo    *hashinfo;
> > +       refcount_t              tw_refcount ____cacheline_aligned_in_smp;
> >         int                     sysctl_max_tw_buckets;
> 
> This would move sysctl_max_tw_buckets in a separate/dedicated cache line :/
> 
> -->
> 
> {
>    refcount_t              tw_refcount;
>    /* Padding to avoid false sharing, tw_refcount can be often written */
>     struct inet_hashinfo    *hashinfo ____cacheline_aligned_in_smp;
>    int                     sysctl_max_tw_buckets;
> 
>   .. other read only fields could fit here.
> 
> >  };
> 
> Explicit alignment of the structure or first field is not needed,
> they will already be cache line aligned.

I got it.  I'll add that change.
Thank you so much!
