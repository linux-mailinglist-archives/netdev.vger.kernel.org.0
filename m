Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A10815960CC
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 19:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236769AbiHPRFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 13:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236765AbiHPRFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 13:05:42 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9F9D72ECC;
        Tue, 16 Aug 2022 10:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660669542; x=1692205542;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kea+2lE3x+13PZn61zhLys5N6n4jB/mv9M7i/1Ogtkc=;
  b=pDlvtZ+soDpTsHkmEoBW1BMJFxuk1YaoEv3ViKxKYg79GykXHnXbjESS
   /RqQVDJl51bVaz6ika0tMA9mejRPjC/OWa8P8/ey8H0Ca0dQGAk+HimFK
   YIWU+pkAwfUjWUHTEhH4U7Tlwq7ghKa/bUme+5yao+S/QU5NTuM7ddq5u
   U=;
X-IronPort-AV: E=Sophos;i="5.93,241,1654560000"; 
   d="scan'208";a="119917450"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-10222bbc.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 16:59:02 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-10222bbc.us-east-1.amazon.com (Postfix) with ESMTPS id 7FDC31A20C9;
        Tue, 16 Aug 2022 16:59:00 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 16 Aug 2022 16:58:58 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 16 Aug 2022 16:58:56 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <kuba@kernel.org>
CC:     <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH v1 net 00/15] sysctl: Fix data-races around net.core.XXX (Round 1)
Date:   Tue, 16 Aug 2022 09:58:48 -0700
Message-ID: <20220816165848.97512-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220816092703.7fe8cbb6@kernel.org>
References: <20220816092703.7fe8cbb6@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.55]
X-ClientProxiedBy: EX13D07UWA003.ant.amazon.com (10.43.160.35) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Jakub Kicinski <kuba@kernel.org>
Date:   Tue, 16 Aug 2022 09:27:03 -0700
> On Mon, 15 Aug 2022 22:23:32 -0700 Kuniyuki Iwashima wrote:
> >   bpf: Fix data-races around bpf_jit_enable.
> >   bpf: Fix data-races around bpf_jit_harden.
> >   bpf: Fix data-races around bpf_jit_kallsyms.
> >   bpf: Fix a data-race around bpf_jit_limit.
> 
> The BPF stuff needs to go via the BPF tree, or get an ack from the BPF
> maintainers. I see Daniel is CCed on some of the patches but not all.

Sorry, I just added the author in CC.
Thanks for CCing bpf mailing list, I'll wait an ACK from them.
