Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D006C6DFB
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbjCWQoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbjCWQn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:43:56 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713A536FC0
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 09:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1679589736; x=1711125736;
  h=references:from:to:cc:subject:date:in-reply-to:
   message-id:mime-version;
  bh=PbaUGuS54P6C4Ggyb+T5EjnsXbArT6MfGK2I/WdOuck=;
  b=vjJt69NBhWJmRoWEUiOULCNcAI8LWlkOoh5KkpOG85uZ9kh+ux5yDjWW
   nCDyeqSfbex6H1WctNES9KMHtsJ5fA269gOEPUEl+oiUe+DuyPwvRCSYf
   LryHUa50eJ9pNywI6Dkk+L79ifXo4y5pmOPoOgI0UCijGpkWp6KAZqmJ5
   4=;
X-IronPort-AV: E=Sophos;i="5.98,285,1673913600"; 
   d="scan'208";a="271869949"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-83883bdb.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 16:42:09 +0000
Received: from EX19D008EUA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-83883bdb.us-west-2.amazon.com (Postfix) with ESMTPS id 0D0CC61508;
        Thu, 23 Mar 2023 16:42:05 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D008EUA001.ant.amazon.com (10.252.50.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Thu, 23 Mar 2023 16:42:04 +0000
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.85.143.177) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Thu, 23 Mar 2023 16:41:54 +0000
References: <20230320132523.3203254-1-shayagr@amazon.com>
 <20230320132523.3203254-2-shayagr@amazon.com>
 <ed1b26c32307ecfc39da3eaba474645280809dec.camel@redhat.com>
 <pj41zlsfdxymx0.fsf@u570694869fb251.ant.amazon.com>
 <20230322114041.71df75d1@kernel.org>
User-agent: mu4e 1.8.13; emacs 28.0.91
From:   Shay Agroskin <shayagr@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Saeed Bshara" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>,
        Eric Dumazet <edumazet@google.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jie Wang <wangjie125@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "Florian Westphal" <fw@strlen.de>
Subject: Re: [PATCH v6 net-next 1/7] netlink: Add a macro to set policy
 message with format string
Date:   Thu, 23 Mar 2023 18:38:59 +0200
In-Reply-To: <20230322114041.71df75d1@kernel.org>
Message-ID: <pj41zlmt432zea.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.85.143.177]
X-ClientProxiedBy: EX19D036UWB001.ant.amazon.com (10.13.139.133) To
 EX19D028EUB003.ant.amazon.com (10.252.61.31)
X-Spam-Status: No, score=-10.0 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Wed, 22 Mar 2023 14:39:49 +0200 Shay Agroskin wrote:
>> > You should use '__extack' even above, to avoid multiple 
>> > evaluation of
>> > the 'extack' expression.  
>> 
>> I've got to admit that I don't understand the cost of such 
>> evaluations. I thought that it was added to help readers of the 
>> source code to understand what is the type of this attribute 
>> and 
>> have a better warning message when the wrong variable is passed 
>> (kind of typing in Python which isn't strictly needed).
>> What cost is there for casting a pointer ?
>
> It's not about the cost, the macros are unfolded by the 
> preprocessor,
> in the unlikely case someone passes extack++ as an argument 
> using it
> twice inside the body of the macro will increment the value 
> twice.
>
> #define MACRO(arg) function_bla(arg, arg) // use arg twice
>
> int a = 1;
> MACRO(a++);
> print(a); // should print 2, will print 3

Thanks for explaining, that's quite cool how something like this 
can cause a very hard to find bug.
Couldn't find a way to avoid both code duplication and evaluating 
extact only once \= Submitted a new patchset with the modified 
version of this macro.

Also added Reviewed-by tags where appropriate
