Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303B55E6737
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 17:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbiIVPfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 11:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiIVPe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 11:34:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBF358B7E;
        Thu, 22 Sep 2022 08:34:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BD7860B4D;
        Thu, 22 Sep 2022 15:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A42BC433D6;
        Thu, 22 Sep 2022 15:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663860895;
        bh=sJXAH3EXSAELsL3FBaVZLmcKpg+EFzU0zQj/ilHdxKQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sH08VxiesoHQx1m209f3GrudMrcvx5xose4r0Fm28b5YiGYL8X1PCNmkQD98N1K2d
         fD1bvdf+FZlY1gwlJMAOEN/6YHWGiNOj2LkQGDbftoXo5JHG4FfafxiuYNDFeONpNB
         Y0D4wcbPTAnthxZju9Gl+v1QzlsW+mk5mrBjo9MPeCgKqgKEZH//Tu53BcllTReMXT
         NhKpPCNKFakLSOSX0ixNx6k946R++Z6fPE1ikr6iSMGAQSXGLA7DGNXx3I58px/a7W
         Sbdf/ol1h/r0DbNhF6/U2CFO3MM7LiIykw6MNn2+pfNMgUSl7h4sK26tRzV3nM0NYN
         0DUIrHexV7T/g==
Date:   Thu, 22 Sep 2022 08:34:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     Thierry Reding <thierry.reding@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Bhadram Varka <vbhadram@nvidia.com>,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 9/9] stmmac: tegra: Add MGBE support
Message-ID: <20220922083454.1b7936b2@kernel.org>
In-Reply-To: <64414eac-fa09-732e-6582-408cfb9d41dd@nvidia.com>
References: <20220707074818.1481776-1-thierry.reding@gmail.com>
        <20220707074818.1481776-10-thierry.reding@gmail.com>
        <YxjIj1kr0mrdoWcd@orome>
        <64414eac-fa09-732e-6582-408cfb9d41dd@nvidia.com>
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

On Thu, 22 Sep 2022 16:05:22 +0100 Jon Hunter wrote:
> On 07/09/2022 17:36, Thierry Reding wrote:
> > On Thu, Jul 07, 2022 at 09:48:18AM +0200, Thierry Reding wrote:  
> >> From: Bhadram Varka <vbhadram@nvidia.com>
> >>
> >> Add support for the Multi-Gigabit Ethernet (MGBE/XPCS) IP found on
> >> NVIDIA Tegra234 SoCs.
> >>
> >> Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
> >> Signed-off-by: Thierry Reding <treding@nvidia.com>
> >> ---
> >> Note that this doesn't have any dependencies on any of the patches
> >> earlier in the series, so this can be applied independently.
>
> > Patches 1-8 of this have already been applied to the Tegra tree. Are
> > there any more comments on this or can this be merged as well?
> > 
> >  From a Tegra point of view this looks good, so:
> > 
> > Acked-by: Thierry Reding <treding@nvidia.com>  
> 
> Acked-by: Jon Hunter <jonathanh@nvidia.com>
> 
> Please can we queue this for v6.1? I have added the stmmac maintainers 
> to the email, but not sure if you can pick this up?

Could you repost it independently of the series so that it can go thru
the net auto-checkers? It should be able to make 6.1 pretty comfortably.
