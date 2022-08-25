Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 658F95A056A
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 02:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbiHYAy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 20:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbiHYAy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 20:54:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA486379
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 17:54:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66EA561ABA
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 00:54:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8835FC433C1;
        Thu, 25 Aug 2022 00:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661388894;
        bh=2ZK8Ox7YgBI8BHBToit9cyRcKHNJ/MgbCpq8DEt2f6k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jTzviOJVKb9007oN6I+AEQL8KnVVeJJeySq+ZIBnN9LF6bQXl2FkGJjazFhCfNJqO
         sxY+okvOZIYKWmeH/j7Ah3s+dtl0dZ5A9BVImVXVBylyVwr//JNhwleRTntfoMUIFy
         hpn19ijLQ7ctKFfcFaI7BFIOhn649u/S3C4TVGLLF6VONPszV3KsMMeKZDvfPbWV7d
         bS1NL4jlsxtKjT4nEdM8uic9usAKtV6KEOTPwIKQn6NjFcUpnPOBZazKcVBCU4Bocj
         SqUDPZ4ViwmKe8z6gm57+pQn8+zYSIJYBihp+hykY+m8F8GqpB4p/g3BwVoKgfU51U
         bDIzxccLZZFvQ==
Date:   Wed, 24 Aug 2022 17:54:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     <Daniel.Machon@microchip.com>, <netdev@vger.kernel.org>,
        <vinicius.gomes@intel.com>, <vladimir.oltean@nxp.com>,
        <thomas.petazzoni@bootlin.com>, <Allan.Nielsen@microchip.com>,
        <maxime.chevallier@bootlin.com>, <roopa@nvidia.com>
Subject: Re: Basic PCP/DEI-based queue classification
Message-ID: <20220824175453.0bc82031@kernel.org>
In-Reply-To: <87k06xjplj.fsf@nvidia.com>
References: <Yv9VO1DYAxNduw6A@DEN-LT-70577>
        <874jy8mo0n.fsf@nvidia.com>
        <YwKeVQWtVM9WC9Za@DEN-LT-70577>
        <87v8qklbly.fsf@nvidia.com>
        <YwXXqB64QLDuKObh@DEN-LT-70577>
        <87pmgpki9v.fsf@nvidia.com>
        <YwZoGJXgx/t/Qxam@DEN-LT-70577>
        <87k06xjplj.fsf@nvidia.com>
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

On Wed, 24 Aug 2022 21:36:54 +0200 Petr Machata wrote:
> > So far only subtle changes. Now how do you see trust going in. Can you
> > elaborate a little on the policy selector you mentioned?  
> 
> Sure. In my mind the policy is a array that describes the order in which
> APP rules are applied. "default" is implicitly last.
> 
> So "trust DSCP" has a policy of just [DSCP]. "Trust PCP" of [PCP].
> "Trust DSCP, then PCP" of [DSCP, PCP]. "Trust port" (i.e. just default)
> is simply []. Etc.
> 
> Individual drivers validate whether their device can implement the
> policy.
> 
> I expect most devices to really just support the DSCP and PCP parts, but
> this is flexible in allowing more general configuration in devices that
> allow it.
> 
> ABI-wise it is tempting to reuse APP to assign priority to selectors in
> the same way that it currently assigns priority to field values:
> 
> # dcb app replace dev X sel-prio dscp:2 pcp:1
> 
> But that feels like a hack. It will probably be better to have a
> dedicated object for this:
> 
> # dcb app-policy set dev X sel-order dscp pcp
> 
> This can be sliced in different ways that we can bikeshed to death
> later. Does the above basically address your request?

For an uneducated maintainer like myself, how do embedded people look
at DCB? Only place I've seen it used is in RDMA clusers. I suggested 
to Vladimir to look at DCBNL for frame preemption because it's the only
existing API we have that's vaguely relevant to HW/prio control but he
ended up going with ethtool.
No preference here, just trying to map it out in my head.
