Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 120946E80A4
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 19:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbjDSRvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 13:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjDSRvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 13:51:20 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9305B194
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 10:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1681926679; x=1713462679;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=URbjtbZEgM1ALlRRY15GL/JCWHb9BUrNKoK/uxS0MQc=;
  b=Y2r3/eYn3mXt5sxQBpl5uuT845JYHEei3+uFWHh3gskOOoBGzdJZz6Ex
   92iRn8vIjPRtWVu6xpLNFXs3Rqfy316bi33XvZsZdnBLLc2MPoyKF6/md
   rpgJvRi9ZUhDwFHp4eEroGuwENnxcfEncrUXDqafmvU/gx9nAGlYi8D+d
   c=;
X-IronPort-AV: E=Sophos;i="5.99,208,1677542400"; 
   d="scan'208";a="1124116796"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-a65ebc6e.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2023 17:51:11 +0000
Received: from EX19MTAUWA002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-m6i4x-a65ebc6e.us-east-1.amazon.com (Postfix) with ESMTPS id 4460D636D4;
        Wed, 19 Apr 2023 17:51:06 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 19 Apr 2023 17:50:55 +0000
Received: from 88665a182662.ant.amazon.com (10.187.170.33) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 19 Apr 2023 17:50:52 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <kuba@kernel.org>
CC:     <bspencer@blackberry.com>, <christophe-h.ricard@st.com>,
        <davem@davemloft.net>, <dsahern@gmail.com>, <edumazet@google.com>,
        <johannes.berg@intel.com>, <kaber@trash.net>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
Subject: Re: [PATCH v1 net] netlink: Use copy_to_user() for optval in netlink_getsockopt().
Date:   Wed, 19 Apr 2023 10:50:43 -0700
Message-ID: <20230419175043.37093-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230418203318.2053c4f9@kernel.org>
References: <20230418203318.2053c4f9@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.170.33]
X-ClientProxiedBy: EX19D038UWB003.ant.amazon.com (10.13.139.157) To
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

From:   Jakub Kicinski <kuba@kernel.org>
Date:   Tue, 18 Apr 2023 20:33:18 -0700
> On Tue, 18 Apr 2023 17:42:46 -0700 Kuniyuki Iwashima wrote:
> > Brad Spencer provided a detailed report that when calling getsockopt()
> > for AF_NETLINK, some SOL_NETLINK options set only 1 byte even though such
> > options require more than int as length.
> > 
> > The options return a flag value that fits into 1 byte, but such behaviour
> > confuses users who do not strictly check the value as char.
> > 
> > Currently, netlink_getsockopt() uses put_user() to copy data to optlen and
> > optval, but put_user() casts the data based on the pointer, char *optval.
> > So, only 1 byte is set to optval.
> > 
> > To avoid this behaviour, we need to use copy_to_user() or cast optval for
> > put_user().
> > 
> > Now getsockopt() accepts char as optval as the flags are only 1 byte.
> 
> I think it's worth doing, but it will change the return value on big
> endian, right?

Ah, I missed that point, yes.  I hope big endian users always
initialise the value to avoid the tricky behaviour.
