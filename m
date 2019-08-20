Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1F89523D
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 02:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbfHTAMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 20:12:09 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:45241 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728578AbfHTAMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 20:12:08 -0400
Received: by mail-lf1-f68.google.com with SMTP id a30so2682701lfk.12
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 17:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wvDb3cRNeqyQkEnlMv/q5p9fjN71O5VnLdbSqsJNW7U=;
        b=SjSYm9aI/UZagFGnpNJHLGdY1VmPhjAJCz+eup6pbWpp/fNoVzHs2E7Tw1uJw2LhNA
         Tf8J1E42TZOtINI8Cp/9crBJ0NaEnDXUU0ptKYbC0uIrjBYug2b4EqeLYjd5Fi/PKctL
         wc8tcsBvMGQZRhsXDYZ9g9pnxJQf5nawzv1G8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wvDb3cRNeqyQkEnlMv/q5p9fjN71O5VnLdbSqsJNW7U=;
        b=iSURp8db0Sq39D3hk6ri3xs1aaO6xiY2HygZzu2icaAOa5SPH4uIQqVQqJvY39plG3
         Pyovb6V1NjdZ2msw0p0SfGsxllUO6HtGq1O0fOjkbOjshGNaH80GGCDDona/3Ch1dLrc
         2OmkORxWovKuuV/Gv1tCwrwEAHkTnyp6CS/iOmDu7nxUwoHPHzzGdzdbiEqV/3+lS3Md
         h1fb1cXrrlmvBhGqEmd2c1Fgs4eypC3C2mRMWMaXvYJ/xkNkjWSDhFoXMCrCvVVYS4R3
         0j0QwaVRr0JK3atA4+z2h1bMUUsWI/NbRyVENBgv7BSnnWAYzG2EfVkYYV96Qrh4+UKo
         rIGA==
X-Gm-Message-State: APjAAAVkN7R9R7GUbGfvfrIGzW3pkAwKQkaFU3RI4gj/MB+rgvsa3bTj
        u9A5p/6AFS6qdssOKEQ9dWdb71xUfIsqDA==
X-Google-Smtp-Source: APXvYqzYuy/LLeZld9+D+gVy82o+hWxZ8H77bCQdPj4paJcLeBsar6Odlr+HV2y4v4lwXVDQKnVGdQ==
X-Received: by 2002:a19:a419:: with SMTP id q25mr14110463lfc.136.1566259926672;
        Mon, 19 Aug 2019 17:12:06 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.googlemail.com with ESMTPSA id s21sm2557412ljm.28.2019.08.19.17.12.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2019 17:12:06 -0700 (PDT)
Subject: Re: [PATCH net-next 2/6] net: bridge: Populate the pvid flag in
 br_vlan_get_info
To:     Vladimir Oltean <olteanv@gmail.com>, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, idosch@idosch.org,
        roopa@cumulusnetworks.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20190820000002.9776-1-olteanv@gmail.com>
 <20190820000002.9776-3-olteanv@gmail.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <e31d0846-b783-4ace-e9c2-54ec993a1bdf@cumulusnetworks.com>
Date:   Tue, 20 Aug 2019 03:12:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190820000002.9776-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/20/19 2:59 AM, Vladimir Oltean wrote:
> Currently this simplified code snippet fails:
> 
> 	br_vlan_get_pvid(netdev, &pvid);
> 	br_vlan_get_info(netdev, pvid, &vinfo);
> 	ASSERT(!(vinfo.flags & BRIDGE_VLAN_INFO_PVID));
> 
> It is intuitive that the pvid of a netdevice should have the
> BRIDGE_VLAN_INFO_PVID flag set.
> 
> However I can't seem to pinpoint a commit where this behavior was
> introduced. It seems like it's been like that since forever.
> 
> At a first glance it would make more sense to just handle the
> BRIDGE_VLAN_INFO_PVID flag in __vlan_add_flags. However, as Nikolay
> explains:
> 
>   There are a few reasons why we don't do it, most importantly because
>   we need to have only one visible pvid at any single time, even if it's
>   stale - it must be just one. Right now that rule will not be violated
>   by this change, but people will try using this flag and could see two
>   pvids simultaneously. You can see that the pvid code is even using
>   memory barriers to propagate the new value faster and everywhere the
>   pvid is read only once.  That is the reason the flag is set
>   dynamically when dumping entries, too.  A second (weaker) argument
>   against would be given the above we don't want another way to do the
>   same thing, specifically if it can provide us with two pvids (e.g. if
>   walking the vlan list) or if it can provide us with a pvid different
>   from the one set in the vg. [Obviously, I'm talking about RCU
>   pvid/vlan use cases similar to the dumps.  The locked cases are fine.
>   I would like to avoid explaining why this shouldn't be relied upon
>   without locking]
> 
> So instead of introducing the above change and making sure of the pvid
> uniqueness under RCU, simply dynamically populate the pvid flag in
> br_vlan_get_info().
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  net/bridge/br_vlan.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
> index f5b2aeebbfe9..bb98984cd27d 100644
> --- a/net/bridge/br_vlan.c
> +++ b/net/bridge/br_vlan.c
> @@ -1281,6 +1281,8 @@ int br_vlan_get_info(const struct net_device *dev, u16 vid,
>  
>  	p_vinfo->vid = vid;
>  	p_vinfo->flags = v->flags;
> +	if (vid == br_get_pvid(vg))
> +		p_vinfo->flags |= BRIDGE_VLAN_INFO_PVID;
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(br_vlan_get_info);
> 

Looks good, thanks!
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

