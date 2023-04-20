Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1919D6E88CD
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 05:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbjDTDlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 23:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjDTDlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 23:41:06 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FEB4495
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 20:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1681962065; x=1713498065;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BVnlJq76PuLHCsM3+Qe8sNqae2QoHSQrI2F15Nk32Fw=;
  b=Exp+rWKa/eBdO+5htDF0r9Yps8wF8POMjqqaKT3uTnEKKQGfELKWk36J
   XlDBW5nX4rJlUnhUU1cTVUX8QTFp/1f5WFDh/++HyguXBAPTkKgRR9KTr
   yz9DkMpAeRtecs2aY0x0EwMpgSVLKb3sSEhRmoNPpI4QqKkmd4UH1ielp
   g=;
X-IronPort-AV: E=Sophos;i="5.99,211,1677542400"; 
   d="scan'208";a="320474967"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-d8e96288.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 03:41:04 +0000
Received: from EX19MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-d8e96288.us-east-1.amazon.com (Postfix) with ESMTPS id 5AF00844F2;
        Thu, 20 Apr 2023 03:41:02 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Thu, 20 Apr 2023 03:41:01 +0000
Received: from 88665a182662.ant.amazon.com (10.106.100.17) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 20 Apr 2023 03:40:58 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <kuba@kernel.org>
CC:     <bspencer@blackberry.com>, <christophe-h.ricard@st.com>,
        <davem@davemloft.net>, <dsahern@gmail.com>, <edumazet@google.com>,
        <johannes.berg@intel.com>, <kaber@trash.net>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
Subject: Re: [PATCH v1 net] netlink: Use copy_to_user() for optval in netlink_getsockopt().
Date:   Wed, 19 Apr 2023 20:40:50 -0700
Message-ID: <20230420034050.48415-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230419160908.5469e9bf@kernel.org>
References: <20230419160908.5469e9bf@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.100.17]
X-ClientProxiedBy: EX19D046UWA004.ant.amazon.com (10.13.139.76) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Wed, 19 Apr 2023 16:09:08 -0700
> On Wed, 19 Apr 2023 09:17:37 +0200 Johannes Berg wrote:
> > > @@ -1754,39 +1754,17 @@ static int netlink_getsockopt(struct socket *sock, int level, int optname,
> > >
> > >         switch (optname) {
> > >         case NETLINK_PKTINFO:
> > > -               if (len < sizeof(int))
> > > -                       return -EINVAL;
> > > -               len = sizeof(int);
> >
> > On the other hand, this is actually accepting say a u64 now, and then
> > sets only 4 bytes of it, though at least it also sets the size to what
> > it wrote out.
> >
> > So I guess here we can argue either
> >  1) keep writing len to 4 and set 4 bytes of the output
> >  2) keep the length as is and set all bytes of the output
> >
> > but (2) gets confusing if you say used 6 bytes buffer as input? I mean,
> > yeah, I'd really hope nobody does that.
> >
> > If Jakub is feeling adventurous maybe we should attempt to see if we
> > break anything by accepting only == sizeof(int) rather than >= ... :-)
> 
> Can't think of a strong reason either way, so I'd keep the check
> and len setting as is.

Ok, I'll respin v2 with the existing check and len setting.

Thank you, Johannes and Jakub!
