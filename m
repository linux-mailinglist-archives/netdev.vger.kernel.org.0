Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A37E8557FF7
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 18:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbiFWQgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 12:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbiFWQgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 12:36:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F350242A1D
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 09:36:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F4F261F4A
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 16:36:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8720FC3411B;
        Thu, 23 Jun 2022 16:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656002178;
        bh=RsDPzFgvYNRLpz/ox6kaO3NMlEjwDu8rxRGI+7CXLso=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kD5ldIdeuF6tWq7GXi2RQkLNudcGysU7LlwH0GYg8PlBKg2KGa3J3MM+3gRUe9lal
         Fx/iWyX9l0Fr/sk2434dsdQMYp4dP6DDDP918GjBJGyWgDPkxEyU68cbvZaVnyBeqT
         HrnvmO875stIKFL9D46yVTQ+wvoBVPAzrswaf9pcz1aoHxRmf1N8IewifGY6mmr3sR
         FUy4e79tX/sSmdyldXzx+wRHUDok3rlpMerovwWf5hbBLCPtXU2doG3hM849nahTbD
         JmefSy29JKCvk+wCNlXFsYe4h0VYH/WFpE97vG61Q9mzkHocUJF87r334Y0BzW/kPG
         yoY0ZEAmfi/ZQ==
Date:   Thu, 23 Jun 2022 09:36:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Ismael Luceno <iluceno@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Netlink NLM_F_DUMP_INTR flag lost
Message-ID: <20220623093609.1b104859@kernel.org>
In-Reply-To: <bd76637b-0404-12e3-37b6-4bdedd625965@gmail.com>
References: <20220615171113.7d93af3e@pirotess>
        <20220615090044.54229e73@kernel.org>
        <20220616171016.56d4ec9c@pirotess>
        <20220616171612.66638e54@kernel.org>
        <20220617150110.6366d5bf@pirotess>
        <20220622131218.1ed6f531@pirotess>
        <20220622165547.71846773@kernel.org>
        <fef8b8d5-e07d-6d8f-841a-ead4ebee8d29@gmail.com>
        <20220623090352.69bf416c@kernel.org>
        <bd76637b-0404-12e3-37b6-4bdedd625965@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Jun 2022 10:17:17 -0600 David Ahern wrote:
> > Yup, the question for me is what's the risk / benefit of sending 
> > the empty message vs putting the _DUMP_INTR on the next family.
> > I'm leaning towards putting it on the next family and treating 
> > the entire dump as interrupted, do you reckon that's suboptimal?  
> 
> I think it is going to be misleading; the INTR flag needs to be set on
> the dump that is affected.

Right, it's a bit of a philosophical discussion but dump is delineated
but NLMSG_DONE. PF_UNSPEC dump is a single dump, not a group of multiple
independent per-family dumps. If we think of a nlmsg as a representation
of an object having an empty one is awkward. What if someone does a dump
to just count objects? Too speculative?

I guess one can argue either way, no empty messages is a weaker promise
and hopefully lower risk, hence my preference. Do you feel strongly for
the message? Do we flip a coin? :)

> All of the dumps should be checking the consistency at the end of the
> dump - regardless of any remaining entries on a particular round (e.g.,
> I mentioned this what the nexthop dump does). Worst case then is DONE
> and INTR are set on the same message with no data, but it tells
> explicitly the set of data affected.

Okay, perhaps we should put a WARN_ON_ONCE(seq && seq != prev_seq)
in rtnl_dump_all() then, to catch those who get it wrong.
