Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18112E6C6D
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729972AbgL1Wzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729500AbgL1VPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 16:15:01 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E054C0613D6
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 13:14:21 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id n142so9942418qkn.2
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 13:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0IcPqjJuXzyja4/HZByp2wLpMla3nnYxuZgHRK+kEpg=;
        b=R0yjRLQf0gf5l5fFIhNqdbJT44eMN4tJthRN6Kd5hfw/i9jqQkGvay4NKsu4OXHVMc
         2CL9uwZXAef+ZIoocw9Mag8LOmk5eAmZZUTl9W6RitINpQNgQXwdcMqgMo3BRA4hnMK5
         dKzJXlVkz1e1xoliLGtd3D/B3uBXPnMlInGGE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0IcPqjJuXzyja4/HZByp2wLpMla3nnYxuZgHRK+kEpg=;
        b=BTLknEe/iBCGtPWF9N1RWp7e3/p1bt2FOLf4A8qpGKUNGiBz+3ngSIF48dYXT9+LVy
         twhyyPiweEDAS60iTre729vcd8iV3Gd/HWIaOx0lhmuYqkc/wsP06tacBegfAi9vZ6C+
         Ufh4koPI/cs3xZGP1Oh+GhW8Lf+DvBgqoOoKi8QAW3VItbHs9wwGT8owUO3yDxvAUFP8
         uztiA29yuk3MOuSBHsK6/K/Xe1bOXhPpUuWMBve2BeH8BOo7DsG9lryNeNsC1D3CpTAW
         a3nQ5SZyeT2rDpu37Na4JAf7IeMJCoosrdulKR/5u7k1M2zxBm2ukpqVJhv6QVSb5aXQ
         j65A==
X-Gm-Message-State: AOAM530KC6QWUSKO/CImbRQnqGH/mRKM9cNIG5QAhT9xbz7bEpnjHJI1
        Hn5hOWd05US7mWID+POsPeuAQg==
X-Google-Smtp-Source: ABdhPJxeJlOgTA8mk7Eb7m1PcBks8+9/NrgFo3yZnFwcDA+MKlakheuKtol8Qx2SxVVvGUsmUlyOyA==
X-Received: by 2002:a37:a80a:: with SMTP id r10mr47820849qke.448.1609190060612;
        Mon, 28 Dec 2020 13:14:20 -0800 (PST)
Received: from chatter.i7.local ([89.36.78.230])
        by smtp.gmail.com with ESMTPSA id 16sm12006556qkf.112.2020.12.28.13.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 13:14:20 -0800 (PST)
Date:   Mon, 28 Dec 2020 16:14:17 -0500
From:   Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>, kjlu@umn.edu,
        "David S. Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: Fix memleak in ethoc_probe
Message-ID: <20201228211417.m5gdnqexjzgt4ix6@chatter.i7.local>
References: <20201223153304.GD3198262@lunn.ch>
 <20201223123218.1cf7d9cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201223210044.GA3253993@lunn.ch>
 <20201223131149.15fff8d2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <680850a9-8ab0-4672-498e-6dc740720da3@gmail.com>
 <20201223174146.37e62326@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201224180631.l4zieher54ncqvwl@chatter.i7.local>
 <fc7be127-648c-6b09-6f00-3542e0388197@gmail.com>
 <20201228202302.afkxtco27j4ahh6d@chatter.i7.local>
 <08e2b663-c144-d1bb-3f90-5e4ef240d14b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <08e2b663-c144-d1bb-3f90-5e4ef240d14b@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 28, 2020 at 01:05:26PM -0800, Florian Fainelli wrote:
> On 12/28/2020 12:23 PM, Konstantin Ryabitsev wrote:
> > On Thu, Dec 24, 2020 at 01:57:40PM -0800, Florian Fainelli wrote:
> >>>> Konstantin, would you be willing to mod the kernel.org instance of
> >>>> patchwork to populate Fixes tags in the generated mboxes?
> >>>
> >>> I'd really rather not -- we try not to diverge from project upstream if at all
> >>> possible, as this dramatically complicates upgrades.
> >>
> >> Well that is really unfortunate then because the Linux developer
> >> community settled on using the Fixes: tag for years now and having
> >> patchwork automatically append those tags would greatly help maintainers.
> > 
> > I agree -- but this is something that needs to be implemented upstream.
> > Picking up a one-off patch just for patchwork.kernel.org is not the right way
> > to go about this.
> 
> You should be able to tune this from the patchwork administrative
> interface and add new tags there, would not that be acceptable?

Oh, oops, I got confused by the mention of a rejected upstream patch -- I
didn't realize that this is already possible with a configuration setting.

Sure, I added a match for ^Fixes: -- let me know if it's not doing the right
thing.

-K
