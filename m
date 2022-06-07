Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 342B9540104
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 16:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244212AbiFGOPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 10:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiFGOPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 10:15:19 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058B9B36C0
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 07:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1654611319; x=1686147319;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sORrrn2ocmVFIl975lquJWzxJ32nv8JdXJ22nxhM530=;
  b=qV+fzY1btN2YkVXj1Q1myyyd8ioO2zROTyyo6XbS6pNV2dTvQUdv7dUr
   mW4nszpOdOmzfeh6p2BDVY8SyTkVTtsTJ6ky+XrrsyaUL8vRfNWfnCynW
   T3m//QPVQzKhI98pxDVgGWevatLSn04rocAI2qq52o5mWww1SZRQBKXgY
   E=;
X-IronPort-AV: E=Sophos;i="5.91,284,1647302400"; 
   d="scan'208";a="208751907"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-1box-2b-3386f33d.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 07 Jun 2022 14:15:05 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-1box-2b-3386f33d.us-west-2.amazon.com (Postfix) with ESMTPS id 7B94B841D4;
        Tue,  7 Jun 2022 14:15:04 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Tue, 7 Jun 2022 14:15:03 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.74) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Tue, 7 Jun 2022 14:15:01 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <pabeni@redhat.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>, <rweikusat@mobileactivedefense.com>
Subject: Re: [PATCH net] af_unix: Fix a data-race in unix_dgram_peer_wake_me().
Date:   Tue, 7 Jun 2022 07:14:53 -0700
Message-ID: <20220607141453.48225-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <67666593dced5eca946ac1639f214133191ebd39.camel@redhat.com>
References: <67666593dced5eca946ac1639f214133191ebd39.camel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.74]
X-ClientProxiedBy: EX13D01UWB004.ant.amazon.com (10.43.161.157) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Paolo Abeni <pabeni@redhat.com>
Date:   Tue, 07 Jun 2022 12:35:13 +0200
> On Sun, 2022-06-05 at 16:23 -0700, Kuniyuki Iwashima wrote:
>> unix_dgram_poll() calls unix_dgram_peer_wake_me() without `other`'s
>> lock held and check if its receive queue is full.  Here we need to
>> use unix_recvq_full_lockless() instead of unix_recvq_full(), otherwise
>> KCSAN will report a data-race.
>> 
>> Fixes: 7d267278a9ec ("unix: avoid use-after-free in ep_remove_wait_queue")
>> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
>> ---
>> As Eric noted in commit 04f08eb44b501, I think rest of unix_recvq_full()
>> can be turned into the lockless version.  After this merge window, I can
>> send a follow-up patch if there is no objection.
> 
> It looks like replacing the remaining instances of unix_recvq_full()
> with unix_recvq_full_lockless() should be safe, but I'm wondering if
> doing that while retaining the current state lock scope it's worthy?!? 
> 
> It may trick later readers of the relevant code to think that such code
> may be reached without a lock. Or are you suggesting to additionally
> shrink the state lock scope? that latter part looks much more tricky,
> IMHO.

I thought removing unix_recvq_full() will prevent the same mistakes, but
I agree that it is confusing for later readers.

Thank you!

