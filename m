Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0225C2B007C
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 08:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbgKLHou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 02:44:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24031 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725898AbgKLHot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 02:44:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605167088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gBYvmTaLLip6W5W4KHqMcgwCLAwq+6PTGHuasKuWRVo=;
        b=Q32wNhJiYahVlpxlMtll8sZhymnrGe8bqSFQpaxS4xhZWtp/O/KtqAq0edJbQMMEapOGR5
        y/xTkJJ1ydirXUSg7fhggD44CTaNLIEw+EXJDol03bTP6MfoP8bdHtfuTF8j8zyVUQwOlx
        GKlZ9GV/beBFm2Xiab0J2VdhakmA88o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-xjcfkOLPMdC8BNrEV6ic8w-1; Thu, 12 Nov 2020 02:44:46 -0500
X-MC-Unique: xjcfkOLPMdC8BNrEV6ic8w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A188801FDC;
        Thu, 12 Nov 2020 07:44:45 +0000 (UTC)
Received: from carbon (unknown [10.36.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EBF265DA74;
        Thu, 12 Nov 2020 07:44:38 +0000 (UTC)
Date:   Thu, 12 Nov 2020 08:44:37 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     brouer@redhat.com, Jesper Dangaard Brouer <hawk@kernel.org>,
        Vincent Bernat <vincent@bernat.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH net-next v2 2/3] net: evaluate
 net.ipv4.conf.all.proxy_arp_pvlan
Message-ID: <20201112084437.37d159e0@carbon>
In-Reply-To: <20201110152118.3636794d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201107193515.1469030-1-vincent@bernat.ch>
        <20201107193515.1469030-3-vincent@bernat.ch>
        <20201110152118.3636794d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 15:21:18 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

> On Sat,  7 Nov 2020 20:35:14 +0100 Vincent Bernat wrote:
> > Introduced in 65324144b50b, the "proxy_arp_vlan" sysctl is a
                                               ^ pvlan

The sysctl is called "proxy_arp_pvlan"

> > per-interface sysctl to tune proxy ARP support for private VLANs.
> > While the "all" variant is exposed, it was a noop and never evaluated.
> > We use the usual "or" logic for this kind of sysctls.
> > 
> > Fixes: 65324144b50b ("net: RFC3069, private VLAN proxy arp support")
> > Signed-off-by: Vincent Bernat <vincent@bernat.ch>
> > ---
> >  include/linux/inetdevice.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >   
> 
> CC Jesper 
> 
> I know this is 10 year old code, but can we get an ack for applying
> this to net-next?

ACK, I agree that the "all" variant doesn't make sense for proxy_arp_pvlan.

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

> > diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
> > index 3bbcddd22df8..53aa0343bf69 100644
> > --- a/include/linux/inetdevice.h
> > +++ b/include/linux/inetdevice.h
> > @@ -105,7 +105,7 @@ static inline void ipv4_devconf_setall(struct in_device *in_dev)
> >  
> >  #define IN_DEV_LOG_MARTIANS(in_dev)	IN_DEV_ORCONF((in_dev), LOG_MARTIANS)
> >  #define IN_DEV_PROXY_ARP(in_dev)	IN_DEV_ORCONF((in_dev), PROXY_ARP)
> > -#define IN_DEV_PROXY_ARP_PVLAN(in_dev)	IN_DEV_CONF_GET(in_dev, PROXY_ARP_PVLAN)
> > +#define IN_DEV_PROXY_ARP_PVLAN(in_dev)	IN_DEV_ORCONF((in_dev), PROXY_ARP_PVLAN)
> >  #define IN_DEV_SHARED_MEDIA(in_dev)	IN_DEV_ORCONF((in_dev), SHARED_MEDIA)
> >  #define IN_DEV_TX_REDIRECTS(in_dev)	IN_DEV_ORCONF((in_dev), SEND_REDIRECTS)
> >  #define IN_DEV_SEC_REDIRECTS(in_dev)	IN_DEV_ORCONF((in_dev), \  

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

