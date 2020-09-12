Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F360B267885
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 09:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725862AbgILHXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 03:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgILHXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 03:23:07 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B249C061573
        for <netdev@vger.kernel.org>; Sat, 12 Sep 2020 00:23:06 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id o8so16450653ejb.10
        for <netdev@vger.kernel.org>; Sat, 12 Sep 2020 00:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jiMkr6IIs3q19+WQDYPwKxngcrDA8Jmx+H0PvKuVrF0=;
        b=dLsI+qAE1b+0OpLVWPGiqo+asqzmSkkmtp/XKF6CyLEJc182dw7tkxF6BAJn0wh2zi
         n7wXTYzD1fqI7p9uiJ8B6skQ6/9V5KYwE51Maf+1Ii/yMALM6z2vPl2l6MLcSe2/zg1V
         U5YyeUdFHpfRuzhCFEGoTVIRNcAqC1tz/BAE4x4SKrYcWlEJo4KcEfGudGaFEwnGvobh
         HqnhbvWvioVQB/5iS991j4xmtPqcvANM/Fo2dr8MITbT59OWBR9widkT7bZs7nABgtVP
         h9MVDg5xrAyB8rFtrUNp40Ene2+V3vSOpJtIyjb8zfdPxsmW/7o2PzTneqmzsPNUchjh
         RIiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jiMkr6IIs3q19+WQDYPwKxngcrDA8Jmx+H0PvKuVrF0=;
        b=KM6h+UnhwgyjVSqCMXCv9bFs2ZwIYpH4rhZKa7zdd+hfGUY79Yf2vKB4GSstajub5+
         PE3f1Z0qePT2H0/6SpbMXmDF4/vuzNZhilO+612svqYLtaPMrK/JWqNg2vFpzM3Lw8pk
         JQSCP59XRfdexiXWBj9FyN9soh+YYrTcJpwbNPPA6/q0gXGP5GqWmlqQex7h91DrExkH
         35s4FygVPrktZspYXpExPI7C5KrGcCxHbI8lzsPaBtn7zWK1wzmczJ9upIHu9D/rHw4U
         T95UPmOC8YrnSwf9J7XKUi6HCTHKIBIoLsvg0ZxxxoW8kkqAGqPNKk8NwZRj/P9NGB9a
         xmEA==
X-Gm-Message-State: AOAM533tXiUOnt5ssOHwWsaimGWdkGC6RwlSY2ayGDGanJQaIOL4N0bQ
        UAtHQOGUdHj782CLdpjIirw=
X-Google-Smtp-Source: ABdhPJwyX1zA6GwoNTdrv1MBTG3Pq2D6aP1sfN/Vg9BG/Rsa7RsCM7US7h5KrQkJ1fK+phnBCPJx0g==
X-Received: by 2002:a17:906:fcc7:: with SMTP id qx7mr5481528ejb.254.1599895385215;
        Sat, 12 Sep 2020 00:23:05 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id cf7sm3781117edb.78.2020.09.12.00.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2020 00:23:04 -0700 (PDT)
Date:   Sat, 12 Sep 2020 10:23:02 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next] net: bridge: pop vlan from skb if filtering is
 disabled but it's a pvid
Message-ID: <20200912072302.xaoxbgusqeesrzaq@skbuf>
References: <20200911231619.2876486-1-olteanv@gmail.com>
 <ddfecf408d3d1b7e4af97cb3b1c1c63506e4218e.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ddfecf408d3d1b7e4af97cb3b1c1c63506e4218e.camel@nvidia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 12, 2020 at 06:56:12AM +0000, Nikolay Aleksandrov wrote:
> Could you point me to a thread where these problems were discussed and why
> they couldn't be resolved within DSA in detail ?

See my discussion with Florian in this thread:
http://patchwork.ozlabs.org/project/netdev/patch/20200907182910.1285496-5-olteanv@gmail.com/
There's a bunch of unrelated stuff going on there, hope you'll manage.

> > - the bridge API only offers a race-free API for determining the pvid of
> >   a port, br_vlan_get_pvid(), under RTNL.
> >
>
> The API can be easily extended.
>

If you can help, cool.

> > And in fact this might not even be a situation unique to DSA. Any driver
> > that receives untagged frames as pvid-tagged is now able to communicate
> > without needing an 8021q upper for the pvid.
> >
>
> I would prefer we don't add hardware/driver-specific fixes in the bridge, when
> vlan filtering is disabled there should be no vlan manipulation/filtering done
> by the bridge. This could potentially break users who have added 8021q devices
> as bridge ports. At the very least this needs to be hidden behind a new option,
> but I would like to find a way to actually push it back to DSA. But again adding
> hardware/driver-specific options should be avoided.
>
> Can you use tc to pop the vlan on ingress ? I mean the cases above are visible
> to the user, so they might decide to add the ingress vlan rule.
>
> Thanks,
>  Nik

I can, but I think that all in all it's a bit strange for the bridge to
not untag pvid-tagged frames.

Thanks!
-Vladimir
