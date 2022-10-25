Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56DED60C060
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 03:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiJYBEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 21:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbiJYBDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 21:03:43 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE37D748FD
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 17:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666656211; x=1698192211;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OCHI/4V2MlMRbyucBYsTujJZ9Zva5EMaEQigrNMTKEs=;
  b=bxeNKiZudgNUuN4mYySEgcbAsAwc+XatgtDL3gKwYlGKu8ggoT1L0Lvd
   Q2hR3kRFUkMcltf7LIstnrm3iQ0TDlqmGs0JwQSdo/otTeXd8Q0qLy+eB
   i+5+iuPLFUbYMJFVeG8wVFUFQYtNbatD06IOrGEnCPGob1WQ85SNLxHux
   M=;
X-IronPort-AV: E=Sophos;i="5.95,210,1661817600"; 
   d="scan'208";a="255804281"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-cadc3fbd.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 00:03:27 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-cadc3fbd.us-west-2.amazon.com (Postfix) with ESMTPS id DC949A286C;
        Tue, 25 Oct 2022 00:03:25 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Tue, 25 Oct 2022 00:03:25 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.223) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Tue, 25 Oct 2022 00:03:22 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <shaozhengchao@huawei.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <jhs@mojatatu.com>,
        <jiri@resnulli.us>, <kaber@trash.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <weiyongjun1@huawei.com>, <xiyou.wangcong@gmail.com>,
        <yuehaibing@huawei.com>, <kuniyu@amazon.com>
Subject: Re: [PATCH net] net: sched: cbq: stop timer in cbq_destroy() when cbq_init() fails
Date:   Mon, 24 Oct 2022 17:03:14 -0700
Message-ID: <20221025000314.9966-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <f7b4472d-013a-2999-7ea5-623af852ed3b@huawei.com>
References: <f7b4472d-013a-2999-7ea5-623af852ed3b@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.223]
X-ClientProxiedBy: EX13P01UWB001.ant.amazon.com (10.43.161.59) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   shaozhengchao <shaozhengchao@huawei.com>
Date:   Mon, 24 Oct 2022 18:53:30 +0800
> On 2022/10/23 10:54, Cong Wang wrote:
> > On Sat, Oct 22, 2022 at 06:40:54PM +0800, Zhengchao Shao wrote:
> >> When qdisc_create() fails to invoke the cbq_init() function for
> >> initialization, the timer has been started. But cbq_destroy() doesn't
> >> stop the timer. Fix it.
> >>
> > 
> > Hmm? qdisc_watchdog_init() only initializes it, not starts it, right?
> > 
> > Thanks.
> Hi Wang:
> 	Thank you for your review. The description is incorrect,
> qdisc_watchdog_init() only initializes timer, and cbq_destroy() missed
> to cancle timer.

In the ->init() failure path, we need not cancel timer.  Another path
where we call ->destroy() is qdisc_destroy(), but just before calling
->destroy(), we call qdisc_reset() and cbq_reset() cancels the timer.

So, I think we need not add qdisc_watchdog_cancel() in cbq_destroy().
