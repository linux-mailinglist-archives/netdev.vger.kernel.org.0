Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 217125A8992
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 01:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbiHaXoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 19:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiHaXoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 19:44:00 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E18EA14D;
        Wed, 31 Aug 2022 16:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661989439; x=1693525439;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nVI9hpGdN7+2Py/ncBaSbxvh8j63Q/RIcB7AvrFyhEk=;
  b=gEsPCTo/nDd6QITe8oiIyymIS3eHBIBOfDD58UjXzT/j8XXNdHUsPOl6
   kiOQeFeu/Twot0mJjGpET64yvEOZBSbyHXOHnkrZV19a6YLvucsNgSVqw
   +8XYvDiLzeQlPnV5dDltRQ4rmHtFygpT7cwVjuNGt8GH2piN5xRDbtsex
   s=;
X-IronPort-AV: E=Sophos;i="5.93,279,1654560000"; 
   d="scan'208";a="1050120380"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-11a39b7d.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 23:43:42 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-11a39b7d.us-west-2.amazon.com (Postfix) with ESMTPS id 28CCC44CEE;
        Wed, 31 Aug 2022 23:43:42 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Wed, 31 Aug 2022 23:43:36 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.191) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Wed, 31 Aug 2022 23:43:34 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <kafai@fb.com>
CC:     <aditivghag@gmail.com>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>, <yhs@fb.com>
Subject: Re: [RFC] Socket termination for policy enforcement and load-balancing
Date:   Wed, 31 Aug 2022 16:43:25 -0700
Message-ID: <20220831234326.49672-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220831230157.7lchomcdxmvq3qqw@kafai-mbp.dhcp.thefacebook.com>
References: <20220831230157.7lchomcdxmvq3qqw@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.191]
X-ClientProxiedBy: EX13D28UWB004.ant.amazon.com (10.43.161.56) To
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

Thanks for CCing, Martin.

Date:   Wed, 31 Aug 2022 16:01:57 -0700
From:   Martin KaFai Lau <kafai@fb.com>
> On Wed, Aug 31, 2022 at 09:37:41AM -0700, Aditi Ghag wrote:
> > - Use BPF (sockets) iterator to identify sockets connected to a
> > deleted backend. The BPF (sockets) iterator is network namespace aware
> > so we'll either need to enter every possible container network
> > namespace to identify the affected connections, or adapt the iterator
> > to be without netns checks [3]. This was discussed with my colleague
> > Daniel Borkmann based on the feedback he shared from the LSFMMBPF
> > conference discussions.
> Being able to iterate all sockets across different netns will
> be useful.
> 
> It should be doable to ignore the netns check.  For udp, a quick
> thought is to have another iter target. eg. "udp_all_netns".
> From the sk, the bpf prog should be able to learn the netns and
> the bpf prog can filter the netns by itself.
> 
> The TCP side is going to have an 'optional' per netns ehash table [0] soon,
> not lhash2 (listening hash) though.  Ideally, the same bpf
> all-netns iter interface should work similarly for both udp and
> tcp case.  Thus, both should be considered and work at the same time.

I'm going to add optional hash tables for UDP as well.  The first series [1]
had TCP/UDP stuff and was split, and UDP part is pending for now.

So, if the both series was merged, the TCP/UDP all netns iter would have
similar logic.

[1]: https://lore.kernel.org/netdev/20220826000445.46552-14-kuniyu@amazon.com/


> 
> For udp, something more useful than plain udp_abort() could potentially
> be done.  eg. directly connect to another backend (by bpf kfunc?).
> There may be some details in socket locking...etc but should
> be doable and the bpf-iter program could be sleepable also.
> fwiw, we are iterating the tcp socket to retire some older
> bpf-tcp-cc (congestion control) on the long-lived connections
> by bpf_setsockopt(TCP_CONGESTION).
> 
> Also, potentially, instead of iterating all,
> a more selective case can be done by
> bpf_prog_test_run()+bpf_sk_lookup_*()+udp_abort().
> 
> [0]: https://lore.kernel.org/netdev/20220830191518.77083-1-kuniyu@amazon.com/
