Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBDD06EB135
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 19:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233066AbjDURwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 13:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbjDURwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 13:52:43 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D47DE79
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 10:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1682099563; x=1713635563;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ElZhWOBQoyUQvRyRYIoa0gUl9QQRKUE/PyGzZrtLXhw=;
  b=gguloNZmV/zVb6Xa6E+1ugrSqU1AkKZ4EZVi3kvNZ5ogmZwOQN0FId51
   usBnwX0smJp7L9ZUMueCmxp/dl2BNiAtPZThVSw2D9d4hzvOCYxslEGJX
   7qqh2CQo3H7jqvf4VIxnGxqpzI0TpzQl1PcA7KO4thxc8Khc19NU+l7u1
   Y=;
X-IronPort-AV: E=Sophos;i="5.99,214,1677542400"; 
   d="scan'208";a="317017990"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-7fa2de02.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 17:52:38 +0000
Received: from EX19MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-7fa2de02.us-west-2.amazon.com (Postfix) with ESMTPS id 1FE6C40E00;
        Fri, 21 Apr 2023 17:52:36 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 21 Apr 2023 17:52:35 +0000
Received: from 88665a182662.ant.amazon.com (10.119.183.123) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 21 Apr 2023 17:52:31 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <johannes@sipsolutions.net>
CC:     <bspencer@blackberry.com>, <christophe-h.ricard@st.com>,
        <davem@davemloft.net>, <dsahern@gmail.com>, <edumazet@google.com>,
        <kaber@trash.net>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
Subject: Re: [PATCH v2 net] netlink: Use copy_to_user() for optval in netlink_getsockopt().
Date:   Fri, 21 Apr 2023 10:52:23 -0700
Message-ID: <20230421175223.77692-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <4624a731a9a222bc116364d26cfdfd8067a3acfc.camel@sipsolutions.net>
References: <4624a731a9a222bc116364d26cfdfd8067a3acfc.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.119.183.123]
X-ClientProxiedBy: EX19D043UWC004.ant.amazon.com (10.13.139.206) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Johannes Berg <johannes@sipsolutions.net>
Date:   Fri, 21 Apr 2023 09:56:37 +0200
> On Thu, 2023-04-20 at 23:33 +0000, Kuniyuki Iwashima wrote:
> > Brad Spencer provided a detailed report [0] that when calling getsockopt()
> > for AF_NETLINK, some SOL_NETLINK options set only 1 byte even though such
> > options require more than int as length.
> 
> Nit: not "more than" but "at least" (and sizeof(int), I guess).

Will change in v3.

> 
> > The options return a flag value that fits into 1 byte, but such behaviour
> > confuses users who do not initialise the variable before calling
> > getsockopt() and do not strictly check the returned value as char.
> > 
> > Currently, netlink_getsockopt() uses put_user() to copy data to optlen and
> > optval, but put_user() casts the data based on the pointer, char *optval.
> > As a result, only 1 byte is set to optval.
> 
> Maybe as a future thing, we should make the getsockopt method prototype
> have void here, so this kind of thing becomes a compilation error? That
> affects a fair number I guess, though I can't think of any socket
> options that really _should_ be just a char, so if it fails anywhere
> that might uncover additional bugs (and potentially avoid future ones)?

Ah, cool, we can uncover the same issue easily by doing so and
fix it unless the handler accepts char.

Thanks!
