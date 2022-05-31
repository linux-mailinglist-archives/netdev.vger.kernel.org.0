Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75810538C41
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 09:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244621AbiEaHuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 03:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244628AbiEaHut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 03:50:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 19B8492D39
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 00:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653983440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gk3wrA88gdZQiiLPoIX2el8bh5x2tSllUA2WgzGf1zk=;
        b=TeZ5SrHfDhb7tsp67/8E+5K4cNqHIfdIBWKnDQ1gvc0foiF5DDE0vXYyv346AR8TbdfL48
        2xCOk0zByRHbMcneuZsCVe4AYWFDf5S11fsNVal1sQZ+NDD1x67JqOLlgvrkR2+JGB8PzV
        dyMX/imhMTrOM+ZhhXffjPv26KnilnA=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-543-Fx2PQd16Oc6GFbBOLO4YAg-1; Tue, 31 May 2022 03:50:38 -0400
X-MC-Unique: Fx2PQd16Oc6GFbBOLO4YAg-1
Received: by mail-qv1-f72.google.com with SMTP id u17-20020a0ced31000000b004645738eff6so2285785qvq.8
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 00:50:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=gk3wrA88gdZQiiLPoIX2el8bh5x2tSllUA2WgzGf1zk=;
        b=0QSnf8rdJggLxosTw+TXwIHorYgiHTcAoIlpffmgNAu+rv2sOhNtdIhX5VstI5UN1v
         ZhEn/MdcoBqOhKbMIZU7T64hqj3AzrToV/JJ/dyqm1AGAXng6eScyguj7wJLHVajO7jj
         Zd/ePiaLCw9Pub5LHfqgMGgKknNNlEvIHsEQiJuIsB3wPeZj8AP+qLm1sX+FO1ZjkudH
         mxAfeKi9tmKG5MI4WtotxL0mxy5fpHEM+r5PuNmojXiPVF5V6Ya4lWS1VU2dgi5EUiNk
         dpkSnDq8slM6di0fsJ9mngOwNwWzGGj6qp5ns+WAATQi7ygSH5il3NLMD/5KqCIaXkU0
         2Zbg==
X-Gm-Message-State: AOAM530UHSI70jBQAVGlWMeSy7Y2Eh893dGWSJ5bcty2D2fqXLXdCRdm
        f1Ky21aebVQvxlbnQGzkMh59prvVddZxnnYWdRqWl6x3i04Eb/EDQEh5TTSR+6u1LLeuuJH8o5a
        X4sM1YdgxoQgT0wUO
X-Received: by 2002:a05:6214:2267:b0:461:e790:e80f with SMTP id gs7-20020a056214226700b00461e790e80fmr49237151qvb.81.1653983437877;
        Tue, 31 May 2022 00:50:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx8BQFVl9A7naD7/1sKpGylMw/hBKD94mLnXxequ3nZoTsFt5ByctU62juN1XDRxatd2Gp4Zw==
X-Received: by 2002:a05:6214:2267:b0:461:e790:e80f with SMTP id gs7-20020a056214226700b00461e790e80fmr49237140qvb.81.1653983437613;
        Tue, 31 May 2022 00:50:37 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id l3-20020a37f503000000b006a5c0dce590sm8320099qkk.79.2022.05.31.00.50.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 00:50:37 -0700 (PDT)
Message-ID: <c1c7a1207986d4ad9e80a301fe5e1415631949a9.camel@redhat.com>
Subject: Re: [PATCH v2] ipv6/addrconf: fix timing bug in tempaddr regen
From:   Paolo Abeni <pabeni@redhat.com>
To:     Sam Edwards <cfsworks@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>
Date:   Tue, 31 May 2022 09:50:33 +0200
In-Reply-To: <20220528004820.5916-1-CFSworks@gmail.com>
References: <20220528004820.5916-1-CFSworks@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, 2022-05-27 at 18:48 -0600, Sam Edwards wrote:
> The addrconf_verify_rtnl() function uses a big if/elseif/elseif/... block
> to categorize each address by what type of attention it needs.  An
> about-to-expire (RFC 4941) temporary address is one such category, but the
> previous elseif branch catches addresses that have already run out their
> prefered_lft.  This means that if addrconf_verify_rtnl() fails to run in
> the necessary time window (i.e. REGEN_ADVANCE time units before the end of
> the prefered_lft), the temporary address will never be regenerated, and no
> temporary addresses will be available until each one's valid_lft runs out
> and manage_tempaddrs() begins anew.
> 
> Fix this by moving the entire temporary address regeneration case out of
> that block.  That block is supposed to implement the "destructive" part of
> an address's lifecycle, and regenerating a fresh temporary address is not,
> semantically speaking, actually tied to any particular lifecycle stage.
> The age test is also changed from `age >= prefered_lft - regen_advance`
> to `age + regen_advance >= prefered_lft` instead, to ensure no underflow
> occurs if the system administrator increases the regen_advance to a value
> greater than the already-set prefered_lft.
> 
> Note that this does not fix the problem of addrconf_verify_rtnl() sometimes
> not running in time, resulting in the race condition described in RFC 4941
> section 3.4 - it only ensures that the address is regenerated.  Fixing THAT
> problem may require either using jiffies instead of seconds for all time
> arithmetic here, or always rounding up when regen_advance is converted to
> seconds.
> 
> Signed-off-by: Sam Edwards <CFSworks@gmail.com>
> ---
>  net/ipv6/addrconf.c | 62 ++++++++++++++++++++++++---------------------
>  1 file changed, 33 insertions(+), 29 deletions(-)
> 
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index b22504176588..57aa46cb85b7 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -4507,6 +4507,39 @@ static void addrconf_verify_rtnl(struct net *net)
>  			/* We try to batch several events at once. */
>  			age = (now - ifp->tstamp + ADDRCONF_TIMER_FUZZ_MINUS) / HZ;
>  
> +			if ((ifp->flags&IFA_F_TEMPORARY) &&
> +			    !(ifp->flags&IFA_F_TENTATIVE) &&
> +			    ifp->prefered_lft != INFINITY_LIFE_TIME &&
> +			    !ifp->regen_count && ifp->ifpub) {
> +				/* This is a non-regenerated temporary addr. */
> +
> +				unsigned long regen_advance = ifp->idev->cnf.regen_max_retry *
> +					ifp->idev->cnf.dad_transmits *
> +					max(NEIGH_VAR(ifp->idev->nd_parms, RETRANS_TIME), HZ/100) / HZ;
> +
> +				if (age + regen_advance >= ifp->prefered_lft) {
> +					struct inet6_ifaddr *ifpub = ifp->ifpub;
> +					if (time_before(ifp->tstamp + ifp->prefered_lft * HZ, next))
> +						next = ifp->tstamp + ifp->prefered_lft * HZ;
> +
> +					ifp->regen_count++;
> +					in6_ifa_hold(ifp);
> +					in6_ifa_hold(ifpub);
> +					spin_unlock(&ifp->lock);
> +
> +					spin_lock(&ifpub->lock);
> +					ifpub->regen_count = 0;
> +					spin_unlock(&ifpub->lock);
> +					rcu_read_unlock_bh();
> +					ipv6_create_tempaddr(ifpub, true);
> +					in6_ifa_put(ifpub);
> +					in6_ifa_put(ifp);
> +					rcu_read_lock_bh();
> +					goto restart;
> +				} else if (time_before(ifp->tstamp + ifp->prefered_lft * HZ - regen_advance * HZ, next))
> +					next = ifp->tstamp + ifp->prefered_lft * HZ - regen_advance * HZ;
> +			}
> +
>  			if (ifp->valid_lft != INFINITY_LIFE_TIME &&
>  			    age >= ifp->valid_lft) {
>  				spin_unlock(&ifp->lock);
> @@ -4540,35 +4573,6 @@ static void addrconf_verify_rtnl(struct net *net)
>  					in6_ifa_put(ifp);
>  					goto restart;
>  				}
> -			} else if ((ifp->flags&IFA_F_TEMPORARY) &&
> -				   !(ifp->flags&IFA_F_TENTATIVE)) {
> -				unsigned long regen_advance = ifp->idev->cnf.regen_max_retry *
> -					ifp->idev->cnf.dad_transmits *
> -					max(NEIGH_VAR(ifp->idev->nd_parms, RETRANS_TIME), HZ/100) / HZ;
> -
> -				if (age >= ifp->prefered_lft - regen_advance) {
> -					struct inet6_ifaddr *ifpub = ifp->ifpub;
> -					if (time_before(ifp->tstamp + ifp->prefered_lft * HZ, next))
> -						next = ifp->tstamp + ifp->prefered_lft * HZ;
> -					if (!ifp->regen_count && ifpub) {
> -						ifp->regen_count++;
> -						in6_ifa_hold(ifp);
> -						in6_ifa_hold(ifpub);
> -						spin_unlock(&ifp->lock);
> -
> -						spin_lock(&ifpub->lock);
> -						ifpub->regen_count = 0;
> -						spin_unlock(&ifpub->lock);
> -						rcu_read_unlock_bh();
> -						ipv6_create_tempaddr(ifpub, true);
> -						in6_ifa_put(ifpub);
> -						in6_ifa_put(ifp);
> -						rcu_read_lock_bh();
> -						goto restart;
> -					}
> -				} else if (time_before(ifp->tstamp + ifp->prefered_lft * HZ - regen_advance * HZ, next))
> -					next = ifp->tstamp + ifp->prefered_lft * HZ - regen_advance * HZ;
> -				spin_unlock(&ifp->lock);
>  			} else {
>  				/* ifp->prefered_lft <= ifp->valid_lft */
>  				if (time_before(ifp->tstamp + ifp->prefered_lft * HZ, next))

The change looks correct to me, but it feels potentially
dangerous/impacting currently correct behaviours - especially
considering the lack of selftests for this code-path.

This looks like net-next material, and net-next is currently close. I
suggest to add a self-test verifying the tmp address regeneration and
expiration - I'm not sure how complext that will be, sorry - and re-
post when net-next re-opens.
While at that, please fix your SoB tag (there is a case mismatch with
the sender address) and it would be probably nice to shorten the line
exceeding the 100 chars limit.

Thanks,

Paolo

