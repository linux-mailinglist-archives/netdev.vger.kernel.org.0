Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19EA1597388
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 18:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240759AbiHQQF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 12:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240529AbiHQQFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 12:05:01 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D6E58DDD;
        Wed, 17 Aug 2022 09:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660752284; x=1692288284;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jSMzJmsv5zZdwNsDf2ZAA/OBZAeYGW+qRikDM2IiA44=;
  b=gg4BigT/8QvdhEnEJb1bA/q+k31jmPrFBGfM3wml/ZfoYzk5z4Nb1yLd
   PA++PeszdfKvXIC5QqQ30ISztMIgDu63Zju24r1m99yD/4ZsWvqcFSyie
   w2XyFtKNuA/NBoqvUHWAlXBjLPXq2ktVSulgfqy9UEUGDhf7oaW/iRAhH
   w=;
X-IronPort-AV: E=Sophos;i="5.93,243,1654560000"; 
   d="scan'208";a="234163189"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-718d0906.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 16:04:25 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-718d0906.us-west-2.amazon.com (Postfix) with ESMTPS id 3DE783E0446;
        Wed, 17 Aug 2022 16:04:24 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Wed, 17 Aug 2022 16:04:23 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.201) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Wed, 17 Aug 2022 16:04:20 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <kuba@kernel.org>
CC:     <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH v1 net 00/15] sysctl: Fix data-races around net.core.XXX (Round 1)
Date:   Wed, 17 Aug 2022 09:04:11 -0700
Message-ID: <20220817160411.53641-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220817085841.60ef3b85@kernel.org>
References: <20220817085841.60ef3b85@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.201]
X-ClientProxiedBy: EX13D38UWB004.ant.amazon.com (10.43.161.30) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Jakub Kicinski <kuba@kernel.org>
Date:   Wed, 17 Aug 2022 08:58:41 -0700
> On Tue, 16 Aug 2022 09:58:48 -0700 Kuniyuki Iwashima wrote:
> > From:   Jakub Kicinski <kuba@kernel.org>
> > Date:   Tue, 16 Aug 2022 09:27:03 -0700
> > > On Mon, 15 Aug 2022 22:23:32 -0700 Kuniyuki Iwashima wrote:  
> > > >   bpf: Fix data-races around bpf_jit_enable.
> > > >   bpf: Fix data-races around bpf_jit_harden.
> > > >   bpf: Fix data-races around bpf_jit_kallsyms.
> > > >   bpf: Fix a data-race around bpf_jit_limit.  
> > > 
> > > The BPF stuff needs to go via the BPF tree, or get an ack from the BPF
> > > maintainers. I see Daniel is CCed on some of the patches but not all.  
> > 
> > Sorry, I just added the author in CC.
> > Thanks for CCing bpf mailing list, I'll wait an ACK from them.
> 
> So we got no reply from BPF folks and the patch got marked as Changes
> Requested overnight, so probably best if you split the series up 
> and send to appropriate trees.

I see, I'll do so.
Sorry for bothering you.

