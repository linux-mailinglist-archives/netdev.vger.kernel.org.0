Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CED2490043
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 12:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfHPKwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 06:52:02 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46564 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727110AbfHPKwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 06:52:01 -0400
Received: by mail-pl1-f193.google.com with SMTP id c2so2300724plz.13
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 03:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LYCRkgDKfMqQxnDtmwwtLXZySetJrlEBoEjy46t0lwY=;
        b=XuM+qSciJLvTMPXIjlqOuQPke0/NVpv9VNiQltff0yrDScOCvsN75BDiKx1BTWonTv
         jlzYFdAM8lA1/zu+IiLSqUsvdmy8LL5GHjKJIEUuUNrDIyKP0aGc/qQnOAt9tks+empu
         m8JDoiGV+5ZTKNMqsGRZN6YaRiK1H81riTah8udfx8hKVqjG/iteHb2kL73o+Y0RGxOs
         9+sVyB092yhWQjLOvYEvIe6TTloHMJYX66d9tkPzxLl52iTWP4pDTZNNNXSb7xoANeXs
         4w89QiQxD9CAiftBEIZ8JBL+jUvaYiI3SKLxakDRP77Blvh0WRuCYt1EPMiJ8GO0YsZV
         ltZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LYCRkgDKfMqQxnDtmwwtLXZySetJrlEBoEjy46t0lwY=;
        b=gt2TktDPx/2TAbPoYS7pqRm3cxs+8BtrL/abE0odQETYnB1lfOi/nf59TjDd8AfPQ/
         oF0wnhA081EAEAyv5MP/pDvXCLTpPimEiW6l9CuyA7kf9UuRNYTmrd3hiuHSrenDrGil
         MdzNLRVdRW2+1jACqFqJrVrgVCMjMPOaAc9J3TIvZxrt0p6j14DJjZiuquE09so39OKD
         IVZSRT5W3DHfRiJC7MTcI1qYTt3X10xzqOJO4DUsZ2Ekd6s+wecPOuxVg78U/D5m7Vfg
         vWeRogOQcfskJg4ETRkhXFubO5cb4OUJ88y3o2wE8AfyN0cnRnOz452zZb/Q/qCvaJUy
         hx2Q==
X-Gm-Message-State: APjAAAW34Y7HHbIMiIjmmltycjS8IlA9WvnMO6cKy06KgGBvuGK/KPVI
        eymJbckQwEBgGBKtzX9+DAg=
X-Google-Smtp-Source: APXvYqzrHycMpIYeNU1oJwQ3BCk0pDR7MRMNwVS+JejLnIMv8AOBPIl3JjAPHx490dTVLMltsCwiCA==
X-Received: by 2002:a17:902:d890:: with SMTP id b16mr8480713plz.315.1565952720984;
        Fri, 16 Aug 2019 03:52:00 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a20sm3393674pjo.0.2019.08.16.03.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2019 03:52:00 -0700 (PDT)
Date:   Fri, 16 Aug 2019 18:51:50 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, Stefano Brivio <sbrivio@redhat.com>,
        wenxu <wenxu@ucloud.cn>, Alexei Starovoitov <ast@fb.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] tunnel: fix dev null pointer dereference when send
 pkg larger than mtu in collect_md mode
Message-ID: <20190816105150.GZ18865@dhcp-12-139.nay.redhat.com>
References: <20190815060904.19426-1-liuhangbin@gmail.com>
 <cb5b5d82-1239-34a9-23f5-1894a2ec92a2@gmail.com>
 <20190816032418.GX18865@dhcp-12-139.nay.redhat.com>
 <fe103dee-bba8-1e0d-83b2-f91c2c37089d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe103dee-bba8-1e0d-83b2-f91c2c37089d@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 16, 2019 at 10:23:55AM +0200, Eric Dumazet wrote:
> 
> 
> On 8/16/19 5:24 AM, Hangbin Liu wrote:
> > Hi Eric,
> > 
> > Thanks for the review.
> > On Thu, Aug 15, 2019 at 11:16:58AM +0200, Eric Dumazet wrote:
> >>> diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
> >>> index 38c02bb62e2c..c6713c7287df 100644
> >>> --- a/net/ipv4/ip_tunnel.c
> >>> +++ b/net/ipv4/ip_tunnel.c
> >>> @@ -597,6 +597,9 @@ void ip_md_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
> >>>  		goto tx_error;
> >>>  	}
> >>>  
> >>> +	if (skb_dst(skb) && !skb_dst(skb)->dev)
> >>> +		skb_dst(skb)->dev = rt->dst.dev;
> >>> +
> >>
> >>
> >> IMO this looks wrong.
> >> This dst seems shared. 
> > 
> > If the dst is shared, it may cause some problem. Could you point me where the
> > dst may be shared possibly?
> >
> 
> dst are inherently shared.
> 
> This is why we have a refcount on them.
> 
> Only when the dst has been allocated by the current thread we can make changes on them.
> 

OK, I see now.

Then how about fix the issue in __icmp_send and decode_session{4,6}. The
fix in there is safe, as in __icmp_send() we only want to get net,
dev_net(skb_in->dev) could also do the work, just as icmp6_send() does.

For decode_session{4,6} the oif is also not needed in this scenario as this
is called by xfrm_decode_session_reverse(), we only need the skb_iif
fl4->flowi4_oif = reverse ? skb->skb_iif : oif;

I also need to check more code in OVS..

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 1510e951f451..95d803543df5 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -582,7 +582,11 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,

        if (!rt)
                goto out;
-       net = dev_net(rt->dst.dev);
+
+       if (skb_in->dev)
+               net = dev_net(skb_in->dev);
+       else
+               goto out;

        /*
         *      Find the original header. It is expected to be valid, of course.
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 8ca637a72697..ec94f5795ea4 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3269,7 +3269,7 @@ decode_session4(struct sk_buff *skb, struct flowi *fl, bool reverse)
        struct flowi4 *fl4 = &fl->u.ip4;
        int oif = 0;

-       if (skb_dst(skb))
+       if (skb_dst(skb) && skb_dst(skb)->dev)
                oif = skb_dst(skb)->dev->ifindex;

        memset(fl4, 0, sizeof(struct flowi4));
@@ -3387,7 +3387,7 @@ decode_session6(struct sk_buff *skb, struct flowi *fl, bool reverse)

        nexthdr = nh[nhoff];

-       if (skb_dst(skb))
+       if (skb_dst(skb) && skb_dst(skb)->dev)
                oif = skb_dst(skb)->dev->ifindex;

        memset(fl6, 0, sizeof(struct flowi6));


Thanks
Hangbin
