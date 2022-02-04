Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F05A4A9EA8
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 19:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351918AbiBDSIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 13:08:38 -0500
Received: from mx07-0057a101.pphosted.com ([205.220.184.10]:50930 "EHLO
        mx07-0057a101.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231759AbiBDSIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 13:08:37 -0500
Received: from pps.filterd (m0214197.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 214Hp4p7000860;
        Fri, 4 Feb 2022 19:08:18 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=12052020;
 bh=bKRPVGjQmKF1+P5z6LecwtsjtzITD8f58g1KnJVOWEs=;
 b=rO2U1OPV2gLv5NYJsAVC8uLbGW0A4P57HNXMYr9RMEXx+mMBXHJALbEEn8gSlZAouXZq
 m5zHxPiWoNTszWYYpILcgIhEBN07z8Kz7tJpWTHxQETbD7jk7Qv0M0xoahFb41Go/hgL
 Sx+k3ytutzetunozpEF0msSTzI6RZMf8aZ0Wauhsj8BL2SwOUtxeKfJb6jjuHNIfyo8e
 /bhbdfv2whX2q9jxOscUJ167o9IZRxqjpBj35cgi5eWhiRmvNGgGnJRGHQjvjRB8z3n3
 C/OCFQNr6Mb8pxE5zL3DTFHAbYzG9kPTSoTXRSxfXUX6kj5tDZ7xlM58f0/J8sshOETt 6w== 
Received: from mail.beijerelectronics.com ([195.67.87.131])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3e0v378kpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 19:08:18 +0100
Received: from jacques-work.labs.westermo.se (192.168.131.30) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Fri, 4 Feb 2022 19:08:17 +0100
From:   Jacques de Laval <Jacques.De.Laval@westermo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
CC:     <netdev@vger.kernel.org>,
        Jacques de Laval <Jacques.De.Laval@westermo.com>
Subject: Re: [PATCH net-next 1/1] net: Add new protocol attribute to IP addresses
Date:   Fri, 4 Feb 2022 19:07:28 +0100
Message-ID: <20220204180728.1597731-1-Jacques.De.Laval@westermo.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <42653bf5-ba76-2561-9cf9-27b0ae730210@gmail.com>
References: <42653bf5-ba76-2561-9cf9-27b0ae730210@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [192.168.131.30]
X-ClientProxiedBy: wsevst-s0023.westermo.com (192.168.130.120) To
 EX01GLOBAL.beijerelectronics.com (10.101.10.25)
X-Proofpoint-ORIG-GUID: 0ojS78paAe_I4idTk2ei4cIhHwhWnqkJ
X-Proofpoint-GUID: 0ojS78paAe_I4idTk2ei4cIhHwhWnqkJ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-04 16:16 UTC, David Ahern wrote:
> > diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
> > index a038feb63f23..caa6b7a5b5ac 100644
> > --- a/include/linux/inetdevice.h
> > +++ b/include/linux/inetdevice.h
> > @@ -148,6 +148,7 @@ struct in_ifaddr {
> >  	unsigned char		ifa_prefixlen;
> >  	__u32			ifa_flags;
> >  	char			ifa_label[IFNAMSIZ];
> > +	unsigned char		ifa_proto;
>
> there is a hole after ifa_prefixlen where this can go and not affect
> struct size.
>
> >  
> >  	/* In seconds, relative to tstamp. Expiry is at tstamp + HZ * lft. */
> >  	__u32			ifa_valid_lft;
> > diff --git a/include/net/addrconf.h b/include/net/addrconf.h
> > index 78ea3e332688..e53d8f4f4166 100644
> > --- a/include/net/addrconf.h
> > +++ b/include/net/addrconf.h
> > @@ -69,6 +69,7 @@ struct ifa6_config {
> >  	u32			preferred_lft;
> >  	u32			valid_lft;
> >  	u16			scope;
> > +	u8			ifa_proto;
> >  };
> >  
> >  int addrconf_init(void);
> > diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
> > index 653e7d0f65cb..f7c270b24167 100644
> > --- a/include/net/if_inet6.h
> > +++ b/include/net/if_inet6.h
> > @@ -73,6 +73,8 @@ struct inet6_ifaddr {
> >  
> >  	struct rcu_head		rcu;
> >  	struct in6_addr		peer_addr;
> > +
> > +	__u8			ifa_proto;
>
> similarly for this struct; couple of holes that you can put this.

Thank you! I will fix this in v2.

> >  };
> >  
> >  struct ip6_sf_socklist {
> > diff --git a/include/uapi/linux/if_addr.h b/include/uapi/linux/if_addr.h
> > index dfcf3ce0097f..2aa46b9c9961 100644
> > --- a/include/uapi/linux/if_addr.h
> > +++ b/include/uapi/linux/if_addr.h
> > @@ -35,6 +35,7 @@ enum {
> >  	IFA_FLAGS,
> >  	IFA_RT_PRIORITY,  /* u32, priority/metric for prefix route */
> >  	IFA_TARGET_NETNSID,
> > +	IFA_PROTO,
> >  	__IFA_MAX,
> >  };
> >  
> > @@ -69,4 +70,7 @@ struct ifa_cacheinfo {
> >  #define IFA_PAYLOAD(n) NLMSG_PAYLOAD(n,sizeof(struct ifaddrmsg))
> >  #endif
> >  
> > +/* ifa_protocol */
> > +#define IFAPROT_UNSPEC	0
> 
> *If* the value is just a passthrough (userspace to kernel and back), no
> need for this uapi. However, have you considered builtin protocol labels
> - e.g. for autoconf, LLA, etc. Kernel generated vs RAs vs userspace
> adding it.

Agreed. For my own (very isolated) use case I only need the passthrough,
but I can see that it would make sense to standardize some labels.
I was trying to give this some thought but I have to admit I copped out
because of my limited knowledge on what labels would be reasonable to
reserve.

Based on what you mention, do you think the list bellow would make sense?

#define IFAPROT_UNSPEC		0  /* unspecified */
#define IFAPROT_KERNEL_LO	1  /* loopback */
#define IFAPROT_KERNEL_RA	2  /* auto assigned by kernel from router announcement */
#define IFAPROT_KERNEL_LL	3  /* link-local set by kernel */
#define IFAPROT_STATIC		4  /* set by admin */
#define IFAPROT_AUTO		5  /* DHCP, BOOTP etc. */
#define IFAPROT_LL		6  /* link-local set by userspace */

Or do you think it needs more granularity?
