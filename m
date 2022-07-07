Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5022656AE2C
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 00:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236774AbiGGWQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 18:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236216AbiGGWQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 18:16:08 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5B15C9CE;
        Thu,  7 Jul 2022 15:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657232168; x=1688768168;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BM2zMPU85nbWlOcfoqMc00B4n9YA5LFINlWt3reCGNg=;
  b=L4f8IQ4jUCiTNRrWWOhJP+m2xminJSU1KLDNH8zD4WtAMmGGXxwZUpX2
   MBbyX2LKmJ666PszdcsHOYX4GQBASMhqXNdztHO3ypV+W+uupIQVtEIpd
   voopSYIeIbW0RWz3KOvSinrQqZERzPrqUNYmCx7N466L/OhB7Udy7scwN
   0=;
X-IronPort-AV: E=Sophos;i="5.92,253,1650931200"; 
   d="scan'208";a="215922474"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-828bd003.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 07 Jul 2022 22:15:54 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-828bd003.us-east-1.amazon.com (Postfix) with ESMTPS id A286F81080;
        Thu,  7 Jul 2022 22:15:50 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Thu, 7 Jul 2022 22:15:49 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.50) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Thu, 7 Jul 2022 22:15:46 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <paul@paul-moore.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>,
        <keescook@chromium.org>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <linux-kernel@vger.kernel.org>,
        <mcgrof@kernel.org>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <yzaikin@google.com>
Subject: Re: [PATCH v2 net 10/12] cipso: Fix data-races around sysctl.
Date:   Thu, 7 Jul 2022 15:15:37 -0700
Message-ID: <20220707221537.29461-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CAHC9VhQMigGi65-j0c9WBN+dWLjjaYqTti-eP99c1RRrQzWj5g@mail.gmail.com>
References: <CAHC9VhQMigGi65-j0c9WBN+dWLjjaYqTti-eP99c1RRrQzWj5g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.50]
X-ClientProxiedBy: EX13D36UWB002.ant.amazon.com (10.43.161.149) To
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

From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 7 Jul 2022 15:15:52 -0400
> On Wed, Jul 6, 2022 at 7:43 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > While reading cipso sysctl variables, they can be changed concurrently.
> > So, we need to add READ_ONCE() to avoid data-races.
> >
> > Fixes: 446fda4f2682 ("[NetLabel]: CIPSOv4 engine")
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > ---
> > CC: Paul Moore <paul@paul-moore.com>
> 
> Thanks for the patch, this looks good to me.  However, in the future
> you should probably drop the extra "---" separator (just leave the one
> before the diffstat below) and move my "Cc:" up above "Fixes:".
> 
> Acked-by: Paul Moore <paul@paul-moore.com>

I was wondering if both CC and Acked-by should stay in each commit, but
will do so in the next time.

Thank you for taking a look!
