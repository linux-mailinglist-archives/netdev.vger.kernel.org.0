Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF5059FF96
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 18:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238801AbiHXQg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 12:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239703AbiHXQgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 12:36:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315DE9C8FD
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 09:36:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7E5461A2B
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 16:36:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065C0C433D6;
        Wed, 24 Aug 2022 16:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661358971;
        bh=MXXn8243cAMaDq2lN+ZAeh7+/XHIivUGiBdye5bTWgA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LmgdwF2sLXapNDJnT5NgQVEVn5Yx27be4MOPqvZqBi8cJEK2EkmtnkBejBvf7Yg/5
         jFVnv7PJ7mjVaGWbOmvuk0nRESn8w2wb2eXO+HZ1cZkpGHLLYC96njCQIl3VNrVZAC
         XgPHwfI78+E+YQkBopM9syZKslGytrGHa9/TCvbUWS2Am5LegOOXeWehyCgUMQ1mGs
         0SWuyGnlxEXsR/R2wzO7obXlCtkcydZbgpMydcOX2c9xWmeKf4O0pRsDunGP2nd64g
         84f6TWMf3bJJJaZ28mVZP5nW/hoXeCjf2rPqT+99HqmT9DINwdb2EMok/FriJPP1Zh
         7Sszc8VwQ+eLw==
Date:   Wed, 24 Aug 2022 09:36:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, mkubecek@suse.cz
Subject: Re: [PATCH net-next 1/6] netlink: add support for ext_ack missing
 attributes
Message-ID: <20220824093609.688d48ac@kernel.org>
In-Reply-To: <a3dabe052337a85e1f54d6119bda0c6414325edc.camel@sipsolutions.net>
References: <20220824045024.1107161-1-kuba@kernel.org>
        <20220824045024.1107161-2-kuba@kernel.org>
        <a3dabe052337a85e1f54d6119bda0c6414325edc.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Aug 2022 10:09:55 +0200 Johannes Berg wrote:
> On Tue, 2022-08-23 at 21:50 -0700, Jakub Kicinski wrote:
> > The @offset points to the
> > nest which should have contained the attribute  
> 
> I find this a bit tedious, tbh. You already kernel-side have patch 2 and
> patch 3 that pass different things here.
> 
> Maybe it would be better to have this point to the _end_ of the {nest,
> message} header, which - if there are any - would be equivalent to the
> first sibling attribute?

Pointing at the start of a nest is easier because I can reuse the same
"attr walking" logic in user space as for finding invalid attributes 
to find the nest.

> Though I guess one way or the other userspace has to have an if that
> asks whether or not it's in a nest or the top-level namespace.
> 
> Hmm.
> 
> How about we just _remove_ the NLMSGERR_ATTR_MISS_NEST attribute if it's
> not missing in a nested attribute? That would make sense from the naming
> too:
>  * NLMSGERR_ATTR_MISS_TYPE - which attribute type you missed
>  * NLMSGERR_ATTR_MISS_NEST - which nesting you missed it in, _if any_
> 
> 
> And that way the if simplifies down to something like
> 
> 	if (tb[NLMSGERR_ATTR_MISS_NEST])
> 
> in the consumer too, and you don't need GENL_REQ_ATTR_CHECK() at all,
> you just pass NULL to the second argument of NL_REQ_ATTR_CHECK().

Sounds good!
