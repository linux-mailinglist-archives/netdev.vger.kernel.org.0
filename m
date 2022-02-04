Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3E314A9F56
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 19:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245645AbiBDSkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 13:40:49 -0500
Received: from mx07-0057a101.pphosted.com ([205.220.184.10]:54816 "EHLO
        mx07-0057a101.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240619AbiBDSkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 13:40:49 -0500
Received: from pps.filterd (m0214197.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 214IL5t0003156;
        Fri, 4 Feb 2022 19:40:37 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=12052020;
 bh=g+4tkg6MRGP5X58Tc4JBCtHoP5bP6Id6lg2cjAeAtAs=;
 b=igqurJ68BUWiFzrOj3L6QDnkSf0ATJUvw63JZsXyP7smkvBtjP5Fs7fw2b9/GsyEq+HS
 Uyr6RjEet7o9aOiAoT7SClz7TyDTBRjlYDJJlDCCh8D+eXU+RTfX1//F1kC7vy4FOWrQ
 2++m37KMMEol1T6Jlc9t0LbfSG846FFcp79SPoTVpcISwJvMWXfTSsM1eHg5nEYOx1QY
 1I0ExBhuT2Mh/pfM3DOthyUL+BKUyVDYE3wVQY35IcTvO+8oZSuqZPjVoQLglWamzuhP
 4xlPVthtUv1geV6FzlDwEnziosK04OpJK2eSwsO0XOn3NHQ0i/1o+pup7TM9NWlSXoKH kg== 
Received: from mail.beijerelectronics.com ([195.67.87.131])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3e0v378m9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 19:40:36 +0100
Received: from jacques-work.labs.westermo.se (192.168.131.30) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Fri, 4 Feb 2022 19:40:36 +0100
From:   Jacques de Laval <Jacques.De.Laval@westermo.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, <netdev@vger.kernel.org>,
        Jacques de Laval <Jacques.De.Laval@westermo.com>
Subject: Re: [PATCH net-next 1/1] net: Add new protocol attribute to IP addresses
Date:   Fri, 4 Feb 2022 19:40:01 +0100
Message-ID: <20220204184001.1622660-1-Jacques.De.Laval@westermo.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220203190757.2be1dd75@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220203190757.2be1dd75@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [192.168.131.30]
X-ClientProxiedBy: wsevst-s0023.westermo.com (192.168.130.120) To
 EX01GLOBAL.beijerelectronics.com (10.101.10.25)
X-Proofpoint-ORIG-GUID: urywH2cuqik_nWJlmrn6A8C7ewHdAqbO
X-Proofpoint-GUID: urywH2cuqik_nWJlmrn6A8C7ewHdAqbO
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-04 19:07 -0800, David Ahern wrote:
> On Thu, 3 Feb 2022 17:31:06 +0100 Jacques de Laval wrote:
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
> nit: the __ types are for uAPI, you can use a normal u8 here.
> 

Thanks you! I will fix this in v2.

> >  };
> >  
> >  struct ip6_sf_socklist {
> > diff --git a/include/uapi/linux/if_addr.h b/include/uapi/linux/if_addr.h
> > index dfcf3ce0097f..2aa46b9c9961 100644
> > --- a/include/uapi/linux/if_addr.h
> > +++ b/include/uapi/linux/if_addr.h
> 
> > @@ -69,4 +70,7 @@ struct ifa_cacheinfo {
> >  #define IFA_PAYLOAD(n) NLMSG_PAYLOAD(n,sizeof(struct ifaddrmsg))
> >  #endif
> >  
> > +/* ifa_protocol */
> > +#define IFAPROT_UNSPEC	0
> > +
> >  #endif
>
> What's the purpose of defining this as a constant?

Agreed, there's not much point if no other protocol labels are reserved.
If I can't come up with a list of labels that a reasonable to reserve I
should remove the constant in v2.
