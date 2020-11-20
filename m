Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354392BB81A
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 22:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731739AbgKTVEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 16:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731276AbgKTVEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 16:04:40 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180E0C0613CF;
        Fri, 20 Nov 2020 13:04:40 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id y17so14719414ejh.11;
        Fri, 20 Nov 2020 13:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KOjtLDn9Uq/1YraWwS0wYrH/Ks+SKmiXRPSVSpOE9WQ=;
        b=PX7ZPBqTcqPGEMMwyLwueVuPCxRPhzurlpiVDbLWahTJzoQQR8EJdYpOQ8YJfLnFKq
         DMDGN8Uo8Wga3TDxFqgghH20tKBpP+E4U9W1+VDMYIFmkVgRmAexviaYDuX0fFqzLbeK
         QD2lSl22LVhQ0SrAd7D1knlebBhAaGKPu5vQF4qir+i86zLk12S4XkGg64RTjcKUGMXP
         VW8YLY7m2jCWKR9I+ON/hKe6cY+6utWbIqBHxzEQiPgSDIP6+mRTZiJIk1dSvyZ4r+d+
         jCNT0IFYiGPd2aZQ2Pf63/3MtvtQtsBqsCu/njOjAMFfqPsvWnvBDaqICwycw3oc1eKR
         GxrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KOjtLDn9Uq/1YraWwS0wYrH/Ks+SKmiXRPSVSpOE9WQ=;
        b=VtUGf/dK+Ay8Kcd8rj09HTcWF/wxFq0NgxrBY+8z032kPAPx53MUm/cXrgBqVuPhxl
         YNLN0GKJpsKBV8inCbuVIIvRvhQu+0eH2QKmM0tmtCyyTlI8xxz2eRJed96d4nztkgI2
         kgu2dKTKqJyEzf9DKBBDcnanNZRpkZGar4LXijbA9eHUbtn0a4LOMHI+BisWP99Y61tM
         i2lRMATCBRqE33KZilfB46TLBZX+Yzt7pLryAHPQBlGxL/1adjhhnPyLllU4sMiPbPt5
         vvpg2HzCAVFau06EMj356H3XuMiU4KRjqJC/0HuyD8SSkgiNLV6Eqm/Cy6U0wmycNQfV
         HFyg==
X-Gm-Message-State: AOAM533D3/qRuJngBQZKcOPTLg1HEtsna92Q7d7YAKOljltX0uvA/VkC
        vw/1rOOkqxm4Ta/PF6Sf1cE=
X-Google-Smtp-Source: ABdhPJx5WdXUwcPVW61sHrqi3xa8l7C3rM5KAKhXBNca2Tlq8NEsAxQ+Na6SRG3UHRhSPeVoH1eWTw==
X-Received: by 2002:a17:906:dbf4:: with SMTP id yd20mr33533558ejb.53.1605906278755;
        Fri, 20 Nov 2020 13:04:38 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id k23sm1527243edv.97.2020.11.20.13.04.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 13:04:38 -0800 (PST)
Date:   Fri, 20 Nov 2020 23:04:36 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Christian Eggers <ceggers@arri.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: dsa: avoid potential use-after-free
 error
Message-ID: <20201120210436.scmic7ygrzviy53o@skbuf>
References: <20201119110906.25558-1-ceggers@arri.de>
 <20201120180149.wp4ehikbc2ngvwtf@skbuf>
 <20201120125921.1cb76a12@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120125921.1cb76a12@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 12:59:21PM -0800, Jakub Kicinski wrote:
> On Fri, 20 Nov 2020 20:01:49 +0200 Vladimir Oltean wrote:
> > On Thu, Nov 19, 2020 at 12:09:06PM +0100, Christian Eggers wrote:
> > > If dsa_switch_ops::port_txtstamp() returns false, clone will be freed
> > > immediately. Shouldn't store a pointer to freed memory.
> > >
> > > Signed-off-by: Christian Eggers <ceggers@arri.de>
> > > Fixes: 146d442c2357 ("net: dsa: Keep a pointer to the skb clone for TX timestamping")
> > > ---
> >
> > IMO this is one of the cases to which the following from
> > Documentation/process/stable-kernel-rules.rst does not apply:
> >
> >  - It must fix a real bug that bothers people (not a, "This could be a
> >    problem..." type thing).
> >
> > Therefore, specifying "net-next" as the target tree here as opposed to
> > "net" is the correct choice.
>
> The commit message doesn't really explain what happens after.
>
> Is the dangling pointer ever accessed?

Nothing happens afterwards. He explained that he accessed it once while
working on his ksz9477 PTP series. There's no code affected by this in
mainline.
