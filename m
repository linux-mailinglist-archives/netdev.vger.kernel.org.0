Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5365568EFA
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 18:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbiGFQV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 12:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233393AbiGFQV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 12:21:56 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A719B27FE3;
        Wed,  6 Jul 2022 09:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657124517; x=1688660517;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Eaj9/yOg2UhCILgc9XiB3gHB5uE1RD3Q9WqGHLjhDQY=;
  b=ufwIsmTp0oy3Zcu7NrNgwfwttvjYZtsk/g5JJaseR+1+mNI3Dl5HyX1t
   lbSN7EmLPimhAJK3p9BDE8VmLEokiBRcOJZ8IeUnAa2/vKxp3LvoWQuT5
   nPZNw3KkL22s6p0fCjHUkuPzYde/jxgx2lWYYSH820edGM+7zO15uwEXB
   M=;
X-IronPort-AV: E=Sophos;i="5.92,250,1650931200"; 
   d="scan'208";a="215373612"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-7d0c7241.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 06 Jul 2022 16:21:43 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-7d0c7241.us-west-2.amazon.com (Postfix) with ESMTPS id 9FA2F43B76;
        Wed,  6 Jul 2022 16:21:41 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 6 Jul 2022 16:21:41 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 6 Jul 2022 16:21:38 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <rostedt@goodmis.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuniyu@amazon.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <nhorman@tuxdriver.com>
Subject: Re: [PATCH] net: sock: tracing: Fix sock_exceed_buf_limit not to dereference stale pointer
Date:   Wed, 6 Jul 2022 09:21:13 -0700
Message-ID: <20220706162113.47275-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220706105040.54fc03b0@gandalf.local.home>
References: <20220706105040.54fc03b0@gandalf.local.home>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.55]
X-ClientProxiedBy: EX13D17UWC002.ant.amazon.com (10.43.162.61) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Steven Rostedt <rostedt@goodmis.org>
Date:   Wed, 6 Jul 2022 10:50:40 -0400
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> The trace event sock_exceed_buf_limit saves the prot->sysctl_mem pointer
> and then dereferences it in the TP_printk() portion. This is unsafe as the
> TP_printk() portion is executed at the time the buffer is read. That is,
> it can be seconds, minutes, days, months, even years later. If the proto
> is freed, then this dereference will can also lead to a kernel crash.
> 
> Instead, save the sysctl_mem array into the ring buffer and have the
> TP_printk() reference that instead. This is the proper and safe way to
> read pointers in trace events.
> 
> Link: https://lore.kernel.org/all/20220706052130.16368-12-kuniyu@amazon.com/
> 
> Cc: stable@vger.kernel.org
> Fixes: 3847ce32aea9f ("core: add tracepoints for queueing skb to rcvbuf")
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Acked-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Thanks for shipping the proper fix quickly!
