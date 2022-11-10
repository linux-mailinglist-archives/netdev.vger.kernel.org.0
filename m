Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A58E624808
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 18:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiKJRMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 12:12:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbiKJRMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 12:12:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6173E0AC
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 09:12:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26EA2B82262
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 17:12:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508E5C433D6;
        Thu, 10 Nov 2022 17:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668100321;
        bh=I+1LjSpCfEQxFyebxdOJ3jTv2CtZ1cEG9pvlZzuv2tU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VWo/ReT8DDyDcYsWbCnC3kh8Btrv3nYWWm7s10OVMgzdMTRRHftMjuDoJ/wMUkpLo
         8U5Ib9enQzhNpLe8osMKDVDkoXMX7k7vQUWeVpCd163z9fkzE4x5JyRIXyLVqpb3mb
         SQZNJ2sg0Pzoq+GBUyCLvigj2Aq9QOGTmqEzpBWcSAIqOAtXQ5ZhzqVmwAqt2wWgiK
         dA4Onfv6fW1him6l+zBTb3XbaMnK9fnFGGo62nNj+iEDvx+9Z6YNa6r5/0+oA6WIsg
         EjKmNCnAbS7s3gVNChe01t8ugus29wpou4g/kmUevIUvs9i9vajiK4MgbyDQ/ZAgAo
         p8rcL4zsnIeTA==
Date:   Thu, 10 Nov 2022 09:12:00 -0800
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
Message-ID: <20221110091200.157c97bf@kernel.org>
In-Reply-To: <Y2yaSQUC7zdL5V1Y@Laptop-X1>
References: <Yzillil1skRfQO+C@t14s.localdomain>
        <CAM0EoM=EwoXgLW=pxadYjL-OCWE8c-EUTcz57W=vkJmkJp6wZQ@mail.gmail.com>
        <Y1kEtovIpgclICO3@Laptop-X1>
        <CAM0EoMmFCoP=PF8cm_-ufcMP9NktRnpQ+mHmoz2VNN8i2koHbw@mail.gmail.com>
        <20221102163646.131a3910@kernel.org>
        <Y2odOlWlonu1juWZ@Laptop-X1>
        <20221108105544.65e728ad@kernel.org>
        <Y2uUsmVu6pKuHnBr@Laptop-X1>
        <CAM0EoMmx6i42WR=7=9B1rz=6gcOxorgyLDGseeEH7EYRPMgnzg@mail.gmail.com>
        <20221109182053.05ca08b8@kernel.org>
        <Y2yaSQUC7zdL5V1Y@Laptop-X1>
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

On Thu, 10 Nov 2022 14:29:29 +0800 Hangbin Liu wrote:
> On Wed, Nov 09, 2022 at 06:20:53PM -0800, Jakub Kicinski wrote:
> > Unless we want to create a separate netlink multicast channel for 
> > just ext acks of a family. That's fine by me, I guess. I'm mostly
> > objecting to pretending notifications are multi-msg just to reuse
> > NLMSG_DONE, and forcing all notification listeners to deal with it.  
> 
> Actually I'm a little curious about how should we use NLMSG_DONE.
> Does a normal nlmsg(with NLM_F_MULTI flag) + a NLMSG_DONE msg illegal?
> Should we need at least  2 nlmsgs + a NLMSG_DONE message.
> 
> Because when I wrote this patch, I saw some functions, like
> team_nl_send_options_get(), team_nl_send_port_list_get() in team driver,
> devlink_dpipe_tables_fill() in netlink.c, even netlink_dump_done(), could
> *possible* only have 1 nlmsg + 1 NLMSG_DONE message.
> 
> In my understand, we can send only 1 nlmsg without NLM_F_MULTI flag. But if
> there is 1 nlmsg + 1 NLMSG_DONE message. It should be considered as multi
> message, and the first nlmsg need to add NLM_F_MULTI flag. Maybe there is
> a little abuse of using NLMSG_DONE, but should be legal.
> 
> What do you think? Did I miss something?

No, I mean, it's perfectly legal to send a single message with MULTI
and NLMSG_DONE, but it's hard to deserialize that. You can hand parse
anything, but how would you describe that in terms of abstract objects
that a normal high level language can consume directly?
