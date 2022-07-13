Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9530573C93
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 20:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbiGMSe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 14:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235287AbiGMSe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 14:34:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA1420BD6
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 11:34:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 714CCB82113
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 18:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79AEC34114;
        Wed, 13 Jul 2022 18:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657737294;
        bh=spc7hgwRuaP/2rbf/QGBCGdvz5JUNeVpgKQKyMVnRAA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EGLsznN2BfinicoVflklkiGJCYklxn0XaM3mCyu88+viuARStFHeIcNvhQPvAbGDi
         lx0hKNt56WlV3pEN9LYQ7e/xy5a//0+HT99BvWB76qGo7h4eBS/4W4AdSAQpu3KXgh
         NbXEj0i8HJ4GDQEsiUysDr+7k9s9D5m0OZsXG1x76eKPI1mSb2OhcGO9T5e0rXrD1f
         glB+opE8uPoUTfUrnfLsN2ZrXTqKxrBa+0mc5b2MGlOdJdCFm4PGDULhhQm44iUETT
         9ReXn7UDyPjhZTKp5Zbac7lYnHt5fZ0uO6eXgDKUrviDbHQJ7hLGEtOIHwu/Y45MCh
         5+0vrZwYa04xg==
Date:   Wed, 13 Jul 2022 11:34:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lior Nahmanson <liorna@nvidia.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>
Subject: Re: [PATCH net-next v3 2/3] net/macsec: Add MACsec skb extension Rx
 Data path support
Message-ID: <20220713113452.3bbf10fd@kernel.org>
In-Reply-To: <PH0PR12MB544980DAD3694E4F532AB6B1BF899@PH0PR12MB5449.namprd12.prod.outlook.com>
References: <20220613111942.12726-1-liorna@nvidia.com>
        <20220613111942.12726-3-liorna@nvidia.com>
        <e95ebed542745609619701b21220647668c89081.camel@redhat.com>
        <20220614091438.3d0665d9@kernel.org>
        <PH0PR12MB5449F670E890436B0C454D2ABFB39@PH0PR12MB5449.namprd12.prod.outlook.com>
        <20220621122641.3cba3d38@kernel.org>
        <PH0PR12MB54490D24F44759ACDABC950FBF869@PH0PR12MB5449.namprd12.prod.outlook.com>
        <20220712170159.6da38d1b@kernel.org>
        <PH0PR12MB544980DAD3694E4F532AB6B1BF899@PH0PR12MB5449.namprd12.prod.outlook.com>
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

On Wed, 13 Jul 2022 06:21:25 +0000 Lior Nahmanson wrote:
> For Rx there is no limitation for the number of different SCIs.
> from MACsec driver code:
> 
> struct macsec_secy {
> ...
>      struct macsec_rx_sc __rcu *rx_sc; // each rx_sc contains unique SCI
> };
> 
> static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
> {
> ...
>     rx_sc = create_rx_sc(dev, sci);
> ...
> }
> 
> where create_rx_sc() adds new rx_sc node to the secy->rx_sc list.

Right, so instead of putting them on a list put them in a map (IDR?)
and pre-allocate the metadata dst here. Then the driver just does a
lookup. If lookup failed then the SCI is not configured and macsec will
not consume the packet, anyway.
