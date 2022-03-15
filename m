Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E544DA589
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 23:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352281AbiCOWnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 18:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234029AbiCOWnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 18:43:22 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5835D19A;
        Tue, 15 Mar 2022 15:42:09 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id b15so643319edn.4;
        Tue, 15 Mar 2022 15:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QwK4SCTHESWH9opGqBpp4sqUaushZIwW8QXUMdBftVo=;
        b=ESShF7zVcCseeQJQL5/QUswiIDZA0RkSF/Mz/5ZlrdvpAPx3bb9w3stSHYXfSfz4Wb
         KKfwZRCzYv341ZNom9QXqC3iWs/ISy2yeKhyjxgxEDEUuTBnbAeu8wObNKLlOnwlA8V1
         JYjauXCU7JAl1mVlW5xLg2n55+qoj0W/NGI1icJKpmp598LMGBZQS5bGfU5pdX4UWQkc
         G+gb1tV8zSFItGNLH0QxEdseVK8fGj1g79QBRT9Px5KG/+lyGLezcd2QshqV0RlEe34g
         5kCWpPeZtVUNhlObG5x0SelyY4WcZfznWK0C7lJr5BRrorRDkjJgfDaAfoDjnscWhBtm
         fkew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QwK4SCTHESWH9opGqBpp4sqUaushZIwW8QXUMdBftVo=;
        b=ghfTxRc0hDFdilw+ftkq59JyZat2mLtfVv4ecZN2A0kUL+U00UY0yNumiquocWiSHW
         QZGkebVefJleP1gIQWkWHFfGaW+gntd2LjnAgfE+nExQ7EC0qwh1p/GWZLUpsLLAlX1G
         C1KtwQdFVQvymO9GevnpbxMVZbUZB8QA0nfOUpO+6yCk4TH0otUW40axP9kvfXxf5r/M
         D94RelkhhxjrF+h/qtN85GewF2WJhhxrcdEfQqkLiu8pFySSCH55Z7E6aPSJxatELvI7
         ctdkpRZayorLgg3BGYYN9stOVFerwGIgobKZMmbWxSCB0dMubsOGQzmSf8yrVnmbYASI
         xKcA==
X-Gm-Message-State: AOAM532O6Jtipr+VD9PjQ+gXpbcJtsQHPgoOMtD8yeWZQOqEZPL/jy7T
        uwtgkEPS4nr703UQuJGWJLM=
X-Google-Smtp-Source: ABdhPJxtb/mBc8Sd8bAUcjJEexSgJAO9RoI75nDxUE0MpzKX7svF4MnsInMPdRxYDO0jYV4OATPBzg==
X-Received: by 2002:a05:6402:5179:b0:415:d7f3:c270 with SMTP id d25-20020a056402517900b00415d7f3c270mr27019343ede.259.1647384127745;
        Tue, 15 Mar 2022 15:42:07 -0700 (PDT)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id jg28-20020a170907971c00b006dbd9d72c03sm127164ejc.128.2022.03.15.15.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 15:42:07 -0700 (PDT)
Date:   Wed, 16 Mar 2022 00:42:05 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH v4 net-next 09/15] net: dsa: Never offload FDB entries on
 standalone ports
Message-ID: <20220315224205.jzz3m2mroytanesh@skbuf>
References: <20220315002543.190587-1-tobias@waldekranz.com>
 <20220315002543.190587-10-tobias@waldekranz.com>
 <20220315163349.k2rmfdzrd3jvzbor@skbuf>
 <87ee32lumk.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ee32lumk.fsf@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 11:26:59PM +0100, Tobias Waldekranz wrote:
> On Tue, Mar 15, 2022 at 18:33, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Tue, Mar 15, 2022 at 01:25:37AM +0100, Tobias Waldekranz wrote:
> >> If a port joins a bridge that it can't offload, it will fallback to
> >> standalone mode and software bridging. In this case, we never want to
> >> offload any FDB entries to hardware either.
> >> 
> >> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> >> ---
> >
> > When you resend, please send this patch separately, unless something
> > breaks really ugly with your MST series in place.
> 
> Sure. I found this while testing the software fallback. It prevents a
> segfault in dsa_port_bridge_host_fdb_add, which (rightly, I think)
> assumes that dp->bridge is valid. I feel like this should have a Fixes:
> tag, but I'm not sure which commit to blame. Any suggestions?

Ok, makes sense. So far, unoffloaded bridge ports meant that the DSA
switch driver didn't have a ->port_bridge_join() implementation.
Presumably that also came along with a missing ->port_fdb_add()
implementation. So probably no NPD for the existing code paths, it is
just your unoffloaded MST support that opens up new possibilities.

Anyway, the dereference of dp->bridge first appeared in commit
c26933639b54 ("net: dsa: request drivers to perform FDB isolation")
which is still just in net-next.

> >>  net/dsa/slave.c | 3 +++
> >>  1 file changed, 3 insertions(+)
> >> 
> >> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> >> index a61a7c54af20..647adee97f7f 100644
> >> --- a/net/dsa/slave.c
> >> +++ b/net/dsa/slave.c
> >> @@ -2624,6 +2624,9 @@ static int dsa_slave_fdb_event(struct net_device *dev,
> >>  	if (ctx && ctx != dp)
> >>  		return 0;
> >>  
> >> +	if (!dp->bridge)
> >> +		return 0;
> >> +
> >>  	if (switchdev_fdb_is_dynamically_learned(fdb_info)) {
> >>  		if (dsa_port_offloads_bridge_port(dp, orig_dev))
> >>  			return 0;
> >> -- 
> >> 2.25.1
> >> 
