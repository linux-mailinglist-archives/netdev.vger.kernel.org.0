Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7741F607F7E
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 22:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiJUUE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 16:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiJUUEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 16:04:55 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505FD46623
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 13:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666382693; x=1697918693;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4+IlTYpHwdpNbeJxK3hBQy29gjRirvLHg7L8Y7dKaQk=;
  b=fPns+mcSLycksj60Y6PqpqTRmTf5lWg6ptgKgiTYf9/M3jaZAbmtiIyf
   yKNXmRm10HXlV4dXInb4HCU8eVlLzZTW7BoXF9UiCZoboDS3MIcajTGmk
   4EDmc6lEQtS6SAOHPNUKIJL2fdJc38xdXUJUF40hQM09g0RSsIwcuZcz1
   4=;
X-IronPort-AV: E=Sophos;i="5.95,203,1661817600"; 
   d="scan'208";a="254971905"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-f323d91c.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 20:04:47 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-f323d91c.us-west-2.amazon.com (Postfix) with ESMTPS id 76F69416BB;
        Fri, 21 Oct 2022 20:04:46 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Fri, 21 Oct 2022 20:04:46 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.162.134) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Fri, 21 Oct 2022 20:04:42 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <kuniyu@amazon.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>,
        <kazuhooku@gmail.com>, <kraig@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <martin.lau@kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH v2 net-next 0/2] soreuseport: Fix issues related to the faster selection algorithm.
Date:   Fri, 21 Oct 2022 13:04:34 -0700
Message-ID: <20221021200434.543-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221020163954.93618-1-kuniyu@amazon.com>
References: <20221020163954.93618-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.134]
X-ClientProxiedBy: EX13D36UWB001.ant.amazon.com (10.43.161.84) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Kuniyuki Iwashima <kuniyu@amazon.com>
Date:   Thu, 20 Oct 2022 09:39:52 -0700
> setsockopt(SO_INCOMING_CPU) for UDP/TCP is broken since 4.5/4.6 due to
> these commits:
> 
>   * e32ea7e74727 ("soreuseport: fast reuseport UDP socket selection")
>   * c125e80b8868 ("soreuseport: fast reuseport TCP socket selection")
> 
> These commits introduced the O(1) socket selection algorithm and removed
> O(n) iteration over the list, but it ignores the score calculated by
> compute_score().  As a result, it caused two misbehaviours:
> 
>   * Unconnected sockets receive packets sent to connected sockets
>   * SO_INCOMING_CPU does not work
> 
> The former is fixed by commit acdcecc61285 ("udp: correct reuseport
> selection with connected sockets").  This series fixes the latter and
> adds some tests for SO_INCOMING_CPU.

This cannot be applied on net-next cleanly for now, I'll rebase.
