Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B065E55F4AF
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 06:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiF2D5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 23:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiF2D4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 23:56:30 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACBA2EA0C
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 20:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1656474972; x=1688010972;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CpARIZ88B6LpHVrC9VDFCk/8IW9GbXo1UW3T9JUvOVk=;
  b=V8p4s/QSDQAUppXdkjAp9v9/sEFqmurceNuOon3S6x/74S8YYchn3DTq
   aJgw2XlJxygBok0MToI1mDsF+LT8Sn/JIor9DwkpaTRkLGczb+JlYfwq6
   kIUkVIo4dHTxpiGLhuUzvoHdjvMRSbX8mBpwLnAR9gsBq26oxFExDeorZ
   U=;
X-IronPort-AV: E=Sophos;i="5.92,230,1650931200"; 
   d="scan'208";a="212897893"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-9a235a16.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 29 Jun 2022 03:56:01 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-9a235a16.us-east-1.amazon.com (Postfix) with ESMTPS id B3B7F800C0;
        Wed, 29 Jun 2022 03:55:58 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 29 Jun 2022 03:55:57 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.183) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 29 Jun 2022 03:55:54 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <kuba@kernel.org>
CC:     <davem@davemloft.net>, <ebiederm@xmission.com>,
        <edumazet@google.com>, <herbert@gondor.apana.org.au>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>, <xemul@openvz.org>
Subject: Re: [PATCH v3 net] af_unix: Do not call kmemdup() for init_net's sysctl table.
Date:   Tue, 28 Jun 2022 20:55:46 -0700
Message-ID: <20220629035546.58196-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220628205125.2b443819@kernel.org>
References: <20220628205125.2b443819@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.183]
X-ClientProxiedBy: EX13D02UWB004.ant.amazon.com (10.43.161.11) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Jakub Kicinski <kuba@kernel.org>
Date:   Tue, 28 Jun 2022 20:51:25 -0700
> On Mon, 27 Jun 2022 16:36:27 -0700 Kuniyuki Iwashima wrote:
> > While setting up init_net's sysctl table, we need not duplicate the
> > global table and can use it directly as ipv4_sysctl_init_net() does.
> > 
> > Unlike IPv4, AF_UNIX does not have a huge sysctl table for now, so it
> > cannot be a problem, but this patch makes code consistent.
> 
> Thanks for the extra info. It sounds like an optimization, tho.
> We save one table's worth of memory. Any objections to applying
> this to net-next?

I'm fine with net-next.

Thank you,
Kuniyuki


> > Fixes: 1597fbc0faf8 ("[UNIX]: Make the unix sysctl tables per-namespace")
> > Acked-by: Eric W. Biederman <ebiederm@xmission.com>
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
