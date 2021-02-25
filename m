Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE84325A14
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 00:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbhBYXJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 18:09:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbhBYXJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 18:09:03 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868FEC06174A
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 15:08:23 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id c23so2420756edr.13
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 15:08:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FvmtRgyQp0Yn//lwJJlWR4Y8tuee06I1p/pnziYs/yg=;
        b=q0uDXX9E/aPVVTqchUjJUTRr3NC3fiF8+Bm1BjiWqsx3MhjbUYKHcrM6RvHvuXZrEn
         inCXxBYSLQ/VtxuK3GpnrcotrkVQNouRYUCJZ6jCXeMaM4lh6Djy+qTsc++IwlFg64mb
         KyrlCC8WzTj5fzHq56fvv9z3b1DzqP/84GGP6bUAPaRHNvB17sI+UJuytIzglZTTmIkV
         t2SA4w/8BqFMdBBQqhpE/bAW/zqkanq7aLBH7oxfy9KcEPK9lrXwFutLks+kYVrXJzUl
         wWh3SFSmSQScfPrpWs3ESLfWvn8sJAruu7/6GbZ2zERfWjecEfOYiCpM5nJwmWfLGrMc
         y8eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FvmtRgyQp0Yn//lwJJlWR4Y8tuee06I1p/pnziYs/yg=;
        b=NW6YnuPp6x7vz9tKxRKSezTV0TqN8AkE9C9Nl9tJpg161aIWOTb9/QK6LmPuOj34zN
         3gGXVdcxtp3BuL+5WxC+QaniCHluflLLkWLlpKtMgRM1u/3loiu5zWssMU4CJ/v4dNuT
         dMrorDb/Kv1TfKTNNhe4nfhKLyTkO8foLSgjAb3/xubvjtkA86qnUSd0iTStPjptSnwl
         TM7uc29IT+lGMNKhgAARL/U/M1/JvYh+VGlx+flIB5Z6M8JfgYjh4cUbtAogIa4p12tz
         DEOKqvha1zLp5kfsJe7qQ01B75sO29tmWpAeJK6lXYnsXbes0DFArLSWR2RUPuykfcs8
         jz5A==
X-Gm-Message-State: AOAM533feQpSI0il9JSaxffiBnMdO3sx6Bn98pEResQNAG2lQ2ehHTAb
        oiL+usP980cHJQzTLFfIi50=
X-Google-Smtp-Source: ABdhPJyuNRwUdhso9xpNLuyO1LI9A/rX3E10DPQFP6Svd1vdfoi8l30PbDKqWP9wl9VI9k56aRhwQw==
X-Received: by 2002:aa7:c3c7:: with SMTP id l7mr278963edr.207.1614294502319;
        Thu, 25 Feb 2021 15:08:22 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id bz20sm3908230ejc.28.2021.02.25.15.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 15:08:22 -0800 (PST)
Date:   Fri, 26 Feb 2021 01:08:20 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net 3/6] net: enetc: take the MDIO lock only once per
 NAPI poll cycle
Message-ID: <20210225230820.m4ymxayzsm2dns2g@skbuf>
References: <20210225121835.3864036-1-olteanv@gmail.com>
 <20210225121835.3864036-4-olteanv@gmail.com>
 <YDgqI8eGDpJKxiLY@lunn.ch>
 <20210225230026.gvtm3esbmrfb5dk5@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225230026.gvtm3esbmrfb5dk5@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 01:00:26AM +0200, Vladimir Oltean wrote:
> The goal is to eventually get rid of all the _hot stuff and always take
> the lock from the top level, this would allow us to do more register
> read/write batching and that would amortize the cost of the locking
> overall.

Of course when I say 'get rid of the hot stuff', I mean get rid of the
'hot' _naming_ and not the behavior, since the goal is for all register
accessors to be 'hot' aka unlocked.
