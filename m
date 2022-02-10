Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9B6D4B0508
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 06:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbiBJF2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 00:28:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233325AbiBJF2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 00:28:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0FC5EAE
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 21:28:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CF3A61BD4
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 05:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B794C004E1;
        Thu, 10 Feb 2022 05:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644470898;
        bh=cVoMuLQCkJthyCiJd9QX9TLWn5fva/2+0LVZFnRdWyg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sW5YwDPb0HZV4foZIKU+vyjSMnPHBsNnGCp+QqhZ0rvqUn2Bui2rinpsw3Q65sB14
         XIbarz/cI2La778DP0vPHbKSMw3KtMYLUk85bAwDC7otGi4MONuo9MwnjsWtEF+xrE
         91Els/TxbOkxxaUvgNsslRb1MYDe23LInr4zeej7UV2/eSHCRA+oH0Vxex1M2Aj/Sl
         lTR08zH6XbTU+3DXLUBsHgwihqmSbzaV3EADmoN9Jkk4wpJScgxYLv0NDMVCb16GoV
         yWEbTkS2FSASqj79pN1VIpibnoQqOrxU8HyXKcG9JhxCJtXBFWUOnHdVVVKGmYV3XO
         leh5lcyt5ZM8Q==
Date:   Wed, 9 Feb 2022 21:28:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Ziyang Xuan <william.xuanziyang@huawei.com>
Subject: Re: [PATCH net 2/2] vlan: move dev_put into vlan_dev_uninit
Message-ID: <20220209212817.4fe52d3a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CADvbK_ckY31iZq+++z6kOdd5rBYMyZDNe8N_cHT2wAWu8ZzoZA@mail.gmail.com>
References: <cover.1644394642.git.lucien.xin@gmail.com>
        <76c52badfdccaa7f094d959eaf24f422ae09dec6.1644394642.git.lucien.xin@gmail.com>
        <20220209175558.3117342d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CADvbK_ckY31iZq+++z6kOdd5rBYMyZDNe8N_cHT2wAWu8ZzoZA@mail.gmail.com>
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

On Thu, 10 Feb 2022 11:40:42 +0800 Xin Long wrote:
> > I think better fix would be to rewrite netdev_run_todo() to free the
> > netdevs in any order they become ready. That's gonna solve any
> > dependency problems and may even speed things up.
>
> What about I keep dev_put() in dev->priv_destructor()/vlan_dev_free() for
> vlan as before, and fix this problem by using for_each_netdev_reverse()
> in __rtnl_kill_links()?
> It will make sense as the late added dev should be deleted early when
> rtnl_link_unregister a rtnl_link_ops.

Feels like sooner or later we'll run into a scenario when reversing will
cause a problem. Or some data structure will stop preserving the order.

Do you reckon rewriting netdev_run_todo() will be a lot of effort or
it's too risky?
