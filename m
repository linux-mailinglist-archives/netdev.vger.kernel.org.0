Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E19576EB134
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 19:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbjDURv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 13:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbjDURvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 13:51:25 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662E910F6
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 10:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1682099484; x=1713635484;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y3tXzPqQkfk9Md+sNHAo+ILU1cW9mT4udiUzfJoFz8I=;
  b=VKUQOucGsp0Od8eixYOqqck7Oux7npSs7dJqvm5XMxUVX/xLH8MuXtUC
   5dsrDqHoU4TiJNZX3t8I3CdNHxRWfPJWbhI+jofUYcGHdmHLsMioNNEoW
   QWhdMMQlnQLkoraXm4SaskBOcyVS/wDn7MnezlaEHrX/btnDAu8OLPNMC
   w=;
X-IronPort-AV: E=Sophos;i="5.99,214,1677542400"; 
   d="scan'208";a="1124893762"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-9fe6ad2f.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 17:51:17 +0000
Received: from EX19MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-9fe6ad2f.us-east-1.amazon.com (Postfix) with ESMTPS id E05F38131D;
        Fri, 21 Apr 2023 17:51:13 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Fri, 21 Apr 2023 17:51:05 +0000
Received: from 88665a182662.ant.amazon.com (10.119.183.123) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 21 Apr 2023 17:51:01 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <kuba@kernel.org>
CC:     <bspencer@blackberry.com>, <christophe-h.ricard@st.com>,
        <davem@davemloft.net>, <dsahern@gmail.com>, <edumazet@google.com>,
        <johannes.berg@intel.com>, <kaber@trash.net>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
Subject: Re: [PATCH v2 net] netlink: Use copy_to_user() for optval in netlink_getsockopt().
Date:   Fri, 21 Apr 2023 10:50:52 -0700
Message-ID: <20230421175052.75494-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230420203324.04c50e8d@kernel.org>
References: <20230420203324.04c50e8d@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.119.183.123]
X-ClientProxiedBy: EX19D043UWC003.ant.amazon.com (10.13.139.240) To
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
Date:   Thu, 20 Apr 2023 20:33:24 -0700
> On Thu, 20 Apr 2023 16:33:51 -0700 Kuniyuki Iwashima wrote:
> > diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> > index f365dfdd672d..5c0d17b3984c 100644
> > --- a/net/netlink/af_netlink.c
> > +++ b/net/netlink/af_netlink.c
> > @@ -1742,7 +1742,7 @@ static int netlink_getsockopt(struct socket *sock, int level, int optname,
> >  {
> >  	struct sock *sk = sock->sk;
> >  	struct netlink_sock *nlk = nlk_sk(sk);
> > -	int len, val, err;
> > +	int len, val;
> >  
> >  	if (level != SOL_NETLINK)
> >  		return -ENOPROTOOPT;
> > @@ -1753,40 +1753,27 @@ static int netlink_getsockopt(struct socket *sock, int level, int optname,
> >  		return -EINVAL;
> >  
> >  	switch (optname) {
> > -	case NETLINK_PKTINFO:
> > +	case NETLINK_LIST_MEMBERSHIPS:
> > +		break;
> > +	default:
> >  		if (len < sizeof(int))
> >  			return -EINVAL;
> >  		len = sizeof(int);
> > +	}
> 
> 
> > -		err = 0;
> >  		break;
> >  	default:
> > -		err = -ENOPROTOOPT;
> > +		return -ENOPROTOOPT;
> >  	}
> > -	return err;
> > +
> > +	if (put_user(len, optlen) ||
> > +	    copy_to_user(optval, &val, len))
> > +		return -EFAULT;
> 
> Maybe this is a nit pick but we'd unnecessarily change the return value
> to unknown opts when len < 4, from -ENOPROTOOPT to -EINVAL, right?

Exactly, we should not change it.

> 
> How about we do:

This is cleaner, will do in v3.

Thanks!

> 
> 	unsigned int flag;
> 
> 	flag = 0;
> 	switch (optname) {
> 	case NETLINK_PKTINFO:
> 		flag = NETLINK_F_RECV_PKTINFO;
>  		break;
>  	case NETLINK_BROADCAST_ERROR:
> 		flag = NETLINK_F_BROADCAST_SEND_ERROR;
> 		break;
> 	...
> 	case NETLINK_LIST_MEMBERSHIPS: {
> 	...
> 	default:
> 		return -ENOPROTOOPT;
> 	}
> 
> 	if (flag) {
> 		if (len < sizeof(int))
> 			return -EINVAL;
> 		len = sizeof(int);
>  		val = nlk->flags & flag ? 1 : 0;
> 		if (put_user(len, optlen) || 
> 		    copy_to_user(optval, &val, len))
> 			return -EFAULT;
> 		...
> 	}
