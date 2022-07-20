Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC9D57AB15
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 02:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238368AbiGTAng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 20:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238348AbiGTAne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 20:43:34 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643E45E336
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 17:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1658277814; x=1689813814;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kqwROW6Syo6Pv1EncG39U7b/F39b5Rj9CiTFa8XSdu8=;
  b=C9CZke/cw5dikRy5FtDU/nA3R8l1O4aN+7jFGTPO+aV74KlvH64nBfJ1
   yUXfi/sAl+W6l02BDORRNM5vwbpikhY8m+5+3CiPpviuHQ25zybPfGuWe
   tLflQo5GQ8CKqsKzb6gvkL4h7TcRkGaLeM6pzG39dmUKnJlpjs9DOqzc9
   g=;
X-IronPort-AV: E=Sophos;i="5.92,285,1650931200"; 
   d="scan'208";a="211379726"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-6fd66c4a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 20 Jul 2022 00:43:18 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-6fd66c4a.us-west-2.amazon.com (Postfix) with ESMTPS id CD95596D2E;
        Wed, 20 Jul 2022 00:43:16 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 20 Jul 2022 00:43:16 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.162.71) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 20 Jul 2022 00:43:14 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <kuba@kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <lkp@intel.com>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>
Subject: Re: [PATCH v1 net-next] selftests: net: af_unix: Fix a build error of unix_connect.c.
Date:   Tue, 19 Jul 2022 17:43:05 -0700
Message-ID: <20220720004305.15822-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220719173201.01807d65@kernel.org>
References: <20220719173201.01807d65@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.43.162.71]
X-ClientProxiedBy: EX13D32UWA001.ant.amazon.com (10.43.160.4) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Jakub Kicinski <kuba@kernel.org>
Date:   Tue, 19 Jul 2022 17:32:01 -0700
> On Mon, 18 Jul 2022 09:23:50 -0700 Kuniyuki Iwashima wrote:
> > This patch fixes a build error reported in the link. [0]
> > 
> >   unix_connect.c: In function ‘unix_connect_test’:
> >   unix_connect.c:115:55: error: expected identifier before ‘(’ token
> >    #define offsetof(type, member) ((size_t)&((type *)0)->(member))
> >                                                        ^
> >   unix_connect.c:128:12: note: in expansion of macro ‘offsetof’
> >     addrlen = offsetof(struct sockaddr_un, sun_path) + variant->len;
> >               ^~~~~~~~
> 
> Can we delete this define and use stddef.h instead?  man offsetof
> This is not kernel code the C standard lib is at our disposal.

Ah, it works.
I'll respin v2.

Thank you!
