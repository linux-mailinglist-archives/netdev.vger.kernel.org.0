Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56C944C06D7
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 02:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235476AbiBWB1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 20:27:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbiBWB1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 20:27:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4CE1615F
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 17:26:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D3C5B81DC6
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 01:26:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34F1C340E8;
        Wed, 23 Feb 2022 01:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645579592;
        bh=HUvg5ML+YLYS6mliX9c8QzOvwIb/uOzx67dutCBHZ1c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xx+zrWgxPMT8IIx2Nd4Cvtn2wi8W6lrW8eSXtVsnIkvAce8N56nUsmXF2G/Zia8r7
         MkYKOERN37qN7ZYSl629Ii/ZxvnOnc9+o/0jIVPs50LyrM5zlwgVaQXfKdM24OHv14
         azVddEbnDNXmzT2h8LxBn0DW1RPKEB6THNeLKWurwV6X+A1zenxaOqTXurncCfo3Z4
         Xo9fddUwIvbK92Wd/8Os50CAJ+/rLnRLCL3wOuNVpjwvLAU1s+/+Qp4zRvXo39oHaL
         DdsZl3iV9GRmecsz+n+XmdeUlToelv5g4G/OoyNHH8p5WrFdV3VCRvmYPNxHjqmybM
         dxtX4lEwaCuSg==
Date:   Tue, 22 Feb 2022 17:26:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Roopa Prabhu <roopa@nvidia.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <stephen@networkplumber.org>, <nikolay@cumulusnetworks.com>,
        <idosch@nvidia.com>, <dsahern@gmail.com>, <bpoirier@nvidia.com>
Subject: Re: [PATCH net-next v2 07/12] rtnetlink: add new rtm tunnel api for
 tunnel id filtering
Message-ID: <20220222172630.44bba0d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220222025230.2119189-8-roopa@nvidia.com>
References: <20220222025230.2119189-1-roopa@nvidia.com>
        <20220222025230.2119189-8-roopa@nvidia.com>
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

On Tue, 22 Feb 2022 02:52:25 +0000 Roopa Prabhu wrote:
> +	RTM_NEWTUNNEL = 120,
> +#define RTM_NEWTUNNEL	RTM_NEWTUNNEL
> +	RTM_DELTUNNEL,
> +#define RTM_DELTUNNEL	RTM_DELTUNNEL
> +	RTM_GETTUNNEL,
> +#define RTM_GETTUNNEL	RTM_GETTUNNEL

Why create new RTM_ commands instead of using changelink?

I thought we had to add special commands for bridge because
if the target of the command is not a bridge device but possibly 
a bridge port, which could be anything. That's not the case here.

Is it only about the convenience of add/del vs changelink where
we'd potentially have to pass and parse the entire vni list each time?
