Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3E94D8E09
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 21:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244957AbiCNUV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 16:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241268AbiCNUV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 16:21:56 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411CD31933;
        Mon, 14 Mar 2022 13:20:44 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id p15so36652203ejc.7;
        Mon, 14 Mar 2022 13:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XA2aP5Nic7Ru8rrrtaAb2aP/czbKdSvuHA7SK90mhFk=;
        b=JUfo9hahsbfyOV+1YWAdpd7ZQSi79AgJRln0bTaBY/kfgygleF/697oK4v0gYvWLmz
         Jpmhfqe3luT0Y1Dc15sA4D/CzyksBSiLk14ahgqip36BhsvtRRnj5P15SrA698KiE5IW
         AP5/GWrVwu/R7UCBkhdJros6ehhCPIvRnF/svwkbOuly8QwHVUeuRxbZf0Y+uy1FzRaE
         Dh9Gc1aAZ9Jrv+ZzTvy6Tns7KcPmV1H17e/pCLN+RsMkVjAlppMDvwLFIPa8W1Lyt2AQ
         M2/xfla50ew6JqyMKHw+FLYeLSpUXo5wOGcXI0r81HZzWBc+wZfgUiYdgEggzClum1ti
         5cMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XA2aP5Nic7Ru8rrrtaAb2aP/czbKdSvuHA7SK90mhFk=;
        b=Lz1dUhnWvQKLrX0ZtuTk9rwdSMDFv6cQw+4T+UPGhr5zrUyF6OwkKxm/ViiWBVkokv
         XezRl52y8rkEN/RCRZ56Uc8rqPzshQVrG2218fZPPhKcjpypvN/Bcg6OD+xDTbHTqFR6
         KdZblq47FE7vKVWqDJ85AnSIB3PumjiQrbR2iG+oPh5wGmAD1bRsV9jK4/h4w+HFFyV2
         I6HWRtc6gTmnFc23yNsuEF4coXaJ2GA+ZaO3SyqCx9U5yo1Vwn1Rui0/RYahXVShiinh
         EOLrnu5adV+SFArCh4ubJogtqAkDOArX8cMOnZZpqMwJXxe6y35IT4YGvMcC+ArGxbsk
         1MIg==
X-Gm-Message-State: AOAM530McA5vyTJe0CtEPl3b6ONxEhxXv0l5JtEhoLlePmunWom2Jd+s
        En9MIS9HizhtTLtPDCxadaw=
X-Google-Smtp-Source: ABdhPJzgAIAgLYgjQeMcar+yKXCNF8VRMp68hiBa0K+XaXi0U5DOVLCj3x8vqtuQ//JRA1VlttSFOA==
X-Received: by 2002:a17:906:7fc9:b0:6cf:d288:c9ef with SMTP id r9-20020a1709067fc900b006cfd288c9efmr19524300ejs.751.1647289242547;
        Mon, 14 Mar 2022 13:20:42 -0700 (PDT)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id q16-20020a170906145000b006bdaf981589sm7267557ejc.81.2022.03.14.13.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 13:20:41 -0700 (PDT)
Date:   Mon, 14 Mar 2022 22:20:40 +0200
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
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH v3 net-next 09/14] net: dsa: Validate hardware support
 for MST
Message-ID: <20220314202040.f2r4pidcy6ws34qv@skbuf>
References: <20220314095231.3486931-1-tobias@waldekranz.com>
 <20220314095231.3486931-10-tobias@waldekranz.com>
 <20220314165649.vtsd3xqv7htut55d@skbuf>
 <20220314175556.7mjr4tui4vb4i5qn@skbuf>
 <87mthsl2wn.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mthsl2wn.fsf@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 09:01:12PM +0100, Tobias Waldekranz wrote:
> On Mon, Mar 14, 2022 at 19:55, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Mon, Mar 14, 2022 at 06:56:49PM +0200, Vladimir Oltean wrote:
> >> > diff --git a/net/dsa/port.c b/net/dsa/port.c
> >> > index 58291df14cdb..1a17a0efa2fa 100644
> >> > --- a/net/dsa/port.c
> >> > +++ b/net/dsa/port.c
> >> > @@ -240,6 +240,10 @@ static int dsa_port_switchdev_sync_attrs(struct dsa_port *dp,
> >> >  	if (err && err != -EOPNOTSUPP)
> >> >  		return err;
> >> >  
> >> > +	err = dsa_port_mst_enable(dp, br_mst_enabled(br), extack);
> >> > +	if (err && err != -EOPNOTSUPP)
> >> > +		return err;
> >> 
> >> Sadly this will break down because we don't have unwinding on error in
> >> place (sorry). We'd end up with an unoffloaded bridge port with
> >> partially synced bridge port attributes. Could you please add a patch
> >> previous to this one that handles this, and unoffloads those on error?
> >
> > Actually I would rather rename the entire dsa_port_mst_enable() function
> > to dsa_port_mst_validate() and move it to the beginning of dsa_port_bridge_join().
> > This simplifies the unwinding that needs to take place quite a bit.
> 
> Well you still need to unwind vlan filtering if setting the ageing time
> fails, which is the most complicated one, right?

Yes, but we can leave that for another day :)

...ergo

> Should the unwinding patch still be part of this series then?

no.

> Still, I agree that _validate is a better name, and then _bridge_join
> seems like a more reasonable placement.
> 
> While we're here, I actually made this a hard error in both scenarios
> (but forgot to update the log - will do that in v4, depending on what we
> decide here). There's a dilemma:
> 
> - When reacting to the attribute event, i.e. changing the mode on a
>   member we're apart of, we _can't_ return -EOPNOTSUPP as it will be
>   ignored, which is why dsa_port_mst_validate (nee _enable) returns
>   -EINVAL.
> 
> - When joining a bridge, we _must_ return -EOPNOTSUPP to trigger the
>   software fallback.
> 
> Having something like this in dsa_port_bridge_join...
> 
> err = dsa_port_mst_validate(dp);
> if (err == -EINVAL)
> 	return -EOPNOTSUPP;
> else if (err)
> 	return err;
> 
> ...works I suppose, but feels somewhat awkwark. Any better ideas?

What you can do is follow the model of dsa_switch_supports_uc_filtering(),
and create a dsa_switch_supports_mst() which is called inside an
"if br_mst_enabled(br)" check, and returns bool. When false, you could
return -EINVAL or -EOPNOTSUPP, as appropriate.

This is mostly fine, except for the pesky dsa_port_can_configure_learning(dp)
check :) So while you could name it dsa_port_supports_mst() and pass it
a dsa_port, the problem is that you can't put the implementation of this
new dsa_port_supports_mst() next to dsa_switch_supports_uc_filtering()
where it would be nice to sit for symmetry, because the latter is static
inline and we're missing the definition of dsa_port_can_configure_learning().
So.. the second best thing is to keep dsa_port_supports_mst() in the
same place where dsa_port_mst_enable() currently is.

What do you think?
