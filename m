Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0DB5EAF7F
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 20:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbiIZSTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 14:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbiIZSSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 14:18:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E936F60CF
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 11:11:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 946A5B80171
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 18:11:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D88C433D6;
        Mon, 26 Sep 2022 18:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664215892;
        bh=EifIZlu8ZbXJtOgAxrui4gEPnFmSfgPZNzS7SEzQN0A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OXmEA4B1KuR3qPOY9ju21HnkVjXiN73mozBETgQgIMb8suvKi6P1LmaISPlLpIKdX
         z9BGtWWbDFm0e+Y4tT/yt83mhi6ELktOWF0+bLwoBGBU2FUvPJ4uahEKgf3j8Xkj50
         16/uXm7GDalha34fWPrEFjqbfDJNGDuPRu7GtY0+8751BO4mjwVWbXBGE8ehe3XsYp
         dyKeAGQeHIo/Tzj97HKxPFFPiqz+zQnHp0ZD+z3DioCHHWpb+osdQLox0Z0qFOfrOs
         8pRHBMlxxpbe7o1bbhGglFc6NTnZCWx9b+bhmSGXLFAYoHXxpp8us/ptmLI+kCd9+z
         qYFum6r6oQydg==
Date:   Mon, 26 Sep 2022 11:11:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [RFC PATCH net-next] net: linkwatch: only report
 IF_OPER_LOWERLAYERDOWN if iflink is actually down
Message-ID: <20220926111131.252ee69f@kernel.org>
In-Reply-To: <20220921220506.1817533-1-vladimir.oltean@nxp.com>
References: <20220921220506.1817533-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Sep 2022 01:05:06 +0300 Vladimir Oltean wrote:
> RFC 2863 says:
> 
>    The lowerLayerDown state is also a refinement on the down state.
>    This new state indicates that this interface runs "on top of" one or
>    more other interfaces (see ifStackTable) and that this interface is
>    down specifically because one or more of these lower-layer interfaces
>    are down.
> 
> DSA interfaces are virtual network devices, stacked on top of the DSA
> master, but they have a physical MAC, with a PHY that reports a real
> link status.
> 
> But since DSA (perhaps improperly) uses an iflink to describe the
> relationship to its master since commit c084080151e1 ("dsa: set ->iflink
> on slave interfaces to the ifindex of the parent"), default_operstate()
> will misinterpret this to mean that every time the carrier of a DSA
> interface is not ok, it is because of the master being not ok.
> 
> In fact, since commit c0a8a9c27493 ("net: dsa: automatically bring user
> ports down when master goes down"), DSA cannot even in theory be in the
> lowerLayerDown state, because it just calls dev_close_many(), thereby
> going down, when the master goes down.
> 
> We could revert the commit that creates an iflink between a DSA user
> port and its master, especially since now we have an alternative
> IFLA_DSA_MASTER which has less side effects. But there may be tooling in
> use which relies on the iflink, which has existed since 2009.
> 
> We could also probably do something local within DSA to overwrite what
> rfc2863_policy() did, in a way similar to hsr_set_operstate(), but this
> seems like a hack.
> 
> What seems appropriate is to follow the iflink, and check the carrier
> status of that interface as well. If that's down too, yes, keep
> reporting lowerLayerDown, otherwise just down.

Well explained. Seems like a judgment call. IMHO the RFC is acceptable.
I'd be tempted to extend it with a comment explaining that some special
uppers (i.e. DSA) have additional sources for being down so we should
double check the lower is indeed the source of the state.
