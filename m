Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B904763C3FC
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 16:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbiK2PnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 10:43:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbiK2PnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 10:43:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCC22E9C2
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 07:43:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3661361715
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 15:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287AFC433C1;
        Tue, 29 Nov 2022 15:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669736601;
        bh=mYezSnBXu0+2mR0LAf7YXSGD3ggh/CshBSmkFE4vxik=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nUpd9hUAihGjlLJdM87xLwfrf2sH48NkQkm/v0N4dFfSh0Wlrgwo2rPoetY+KTQkR
         rYF34cjqscX261hmKF/ynGpa8O16gkbw7s4JaTfFlihNlQiNw0ZyU+52/y0Iqlx2Pa
         gt36Y3ri9lsjv/yx59W374/7N3IlnJXbPTTkIZMWxEMvwGqEsLLSi9IEyKkuEM5s9z
         XfYJEdYGlTmrWj/c034vwtlnsmv84MxZNkaOJ0qfhq5eGR4lrpoG/vcJkYXjHr97ua
         fvP7A518skB7JcruALw2ZwCdZWqr4iF8y37QQT9S6x2CPUhMQF+Eec32PJmWYyr0yo
         0pMIIIKPdwibw==
Date:   Tue, 29 Nov 2022 07:43:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH (repost) net-next] sched: add extack for tfilter_notify
Message-ID: <20221129074320.7c15bcf5@kernel.org>
In-Reply-To: <Y4W9qEHzg5h9n/od@Laptop-X1>
References: <CAM0EoMmx6i42WR=7=9B1rz=6gcOxorgyLDGseeEH7EYRPMgnzg@mail.gmail.com>
        <20221109182053.05ca08b8@kernel.org>
        <CAM0EoMm1Jx3mcGJK_XasTpVjm7uGHzVXhXN8=MAQUExJhuPFvw@mail.gmail.com>
        <20221110092709.06859da9@kernel.org>
        <Y3MCaaHoMeG7crg5@Laptop-X1>
        <20221114205143.717fd03f@kernel.org>
        <Y3OJucOnuGrBvwYM@Laptop-X1>
        <CAM0EoMmiGBb1B=mYyG1FEvX7RRh+UvTFwguuEy9UwBPg2Jd0KA@mail.gmail.com>
        <Y3Oa1NRF9frEiiZ3@Laptop-X1>
        <CAM0EoMk_LdcSLAeQ8kLTaWNDXFe7HgBcOxZpDPtk68+TdER-Zg@mail.gmail.com>
        <Y4W9qEHzg5h9n/od@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Nov 2022 16:07:04 +0800 Hangbin Liu wrote:
> +unsigned int get_nlgroup(__u16 nlmsg_type)
> +{
> +	switch (nlmsg_type) {
> +	case RTM_NEWTFILTER:
> +	case RTM_DELTFILTER:
> +	case RTM_NEWCHAIN:
> +	case RTM_DELCHAIN:
> +	case RTM_NEWTCLASS:
> +	case RTM_DELTCLASS:
> +	case RTM_NEWQDISC:
> +	case RTM_DELQDISC:
> +	case RTM_GETACTION:
> +	case RTM_NEWACTION:
> +	case RTM_DELACTION:
> +		return RTNLGRP_TC;
> +	}

These are rtnl message ids, they don't belong in af_netlink.
