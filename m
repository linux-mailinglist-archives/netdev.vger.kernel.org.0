Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6603A2678A2
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 09:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725834AbgILHuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 03:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgILHuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 03:50:12 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F390C061573
        for <netdev@vger.kernel.org>; Sat, 12 Sep 2020 00:50:10 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id i26so16475437ejb.12
        for <netdev@vger.kernel.org>; Sat, 12 Sep 2020 00:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+3Xm1UyhEOL2ADLdsx5xqjL9oRycFn4NdebCEBflCZ4=;
        b=drWmuLyve4oBVhrbCkglnvQ4I664gpe9ZB01B0OegIZ2Uj80l9oA5l2LZb4HiaY1PN
         5DWgKvSI3eDndkGl0hJP3ajgLQTlNRuVJBp6Jf7iUeqQcCChi9AoUXVqXVrlNdaQs79v
         vAFcvFR4MmZRvyslcPGPw+YtY31TkDqeDmWWn7i2I78M6SyWqM7R89kFFGICBHHuiQYy
         aoOD5qH+dLPk3JM0ZUo1w886TbhbicJdPE24yKvKvQ9ZIsJ6ET73LlDnmYZKqiitW2If
         7shxbJJQl96CPQa+GxYe0qoMky0uf+xTSTrQQE0TdPhFSYwW9hY3BkQQmAJdcI2rwV+x
         qJkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+3Xm1UyhEOL2ADLdsx5xqjL9oRycFn4NdebCEBflCZ4=;
        b=iKE9+eCRQm03DFsTOuMZx3U6yLD9Padjk7TLjXY3/bz8wnn/G6zD2PATDr9xbLLr+J
         o0WFquc08e1zmUZ3ZKfxmqTkZJZDht16zrc+CHcZ+MDzuFE5WyHxfrUK0Dh4Y7b0/oJR
         IVtKnTTXYoedesN2H94BUJstkWe2hoJKPrQ99jl0SfxaV359gxuYPqLJqdlOw+SgVfAR
         SaZ2fmRiQ09UpLP8WUVbm04zjQdu0RxD17kG71T+52yd9URIhVD8v1uucYgAW0X3xcyA
         pnc/i44atbglZd68igHk9xuFRfMlPLH7gDZ5nsT0XFeMhcHf2mlPUi8RMlF3Fb3swDjm
         EivA==
X-Gm-Message-State: AOAM533+q5v9ukQORk+Qqmjlgot7rJGOVWXMlwAyaCn/nGFMH9x0ppwI
        ztzSrSuAEe9bYbWjXW/mDNw1yPTbcS4=
X-Google-Smtp-Source: ABdhPJzJYeA/NF9DSK/7rFb8YXNp/96oOqkZQlJmzO1xjqBp8ML8FzyRyD8XHByAZna0n9kFRoy74A==
X-Received: by 2002:a17:906:ae45:: with SMTP id lf5mr5031104ejb.339.1599897009516;
        Sat, 12 Sep 2020 00:50:09 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id b6sm4101479edm.97.2020.09.12.00.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2020 00:50:09 -0700 (PDT)
Date:   Sat, 12 Sep 2020 10:50:06 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>
Subject: Re: [PATCH net-next] net: bridge: pop vlan from skb if filtering is
 disabled but it's a pvid
Message-ID: <20200912075006.zf4jx72g37osesic@skbuf>
References: <20200911231619.2876486-1-olteanv@gmail.com>
 <ddfecf408d3d1b7e4af97cb3b1c1c63506e4218e.camel@nvidia.com>
 <20200912072302.xaoxbgusqeesrzaq@skbuf>
 <ce71707b0a4065cc0fc5c5b61ee397152491ba48.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce71707b0a4065cc0fc5c5b61ee397152491ba48.camel@nvidia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 12, 2020 at 07:37:42AM +0000, Nikolay Aleksandrov wrote:
> On Sat, 2020-09-12 at 10:23 +0300, Vladimir Oltean wrote:
> > On Sat, Sep 12, 2020 at 06:56:12AM +0000, Nikolay Aleksandrov wrote:
> > > Could you point me to a thread where these problems were discussed and why
> > > they couldn't be resolved within DSA in detail ?
> >
> > See my discussion with Florian in this thread:
> > http://patchwork.ozlabs.org/project/netdev/patch/20200907182910.1285496-5-olteanv@gmail.com/
> > There's a bunch of unrelated stuff going on there, hope you'll manage.
> >
>
> Thanks!
> I'm traveling and will be back on Sun evening, will go through the thread then.
>

Ok, take your time.
For some reason patchwork seems to have trimmed the discussion thread.
See on lore here:
https://lore.kernel.org/netdev/20200907182910.1285496-5-olteanv@gmail.com/T/#t

Thanks,
-Vladimir
