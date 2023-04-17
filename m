Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0DC76E4D65
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 17:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbjDQPia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 11:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjDQPi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 11:38:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D2A10A;
        Mon, 17 Apr 2023 08:38:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9576761EEF;
        Mon, 17 Apr 2023 15:38:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E547C433EF;
        Mon, 17 Apr 2023 15:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681745907;
        bh=4i6VBofjlrioISVoBLcLekp8PdpA1EPCRmK3FSnQyjk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F9hpOc02bKSLJI8cRStSVufD3UbASclxCS+TDx0H92O6DXnglOcDzZTR0OZeE5Uj3
         v2BRb9Yr7nx1pCZdCBKYWCZW0gYwjMUu8fP3UbFdYLkmYAG0vemEI6xazrz8NrDFVB
         joSuRH21sT0QT14R0zJrwmPFqWKyq3NEmpATgbbMpFIy4ZPH+F5u7TRkEG7bz9EbRI
         aI+emMSHyQ3e28cv0Cnje78FGCwYOXvQErZvsp2ywS2MEBiV2OXaNJaO/hIfs9UKl0
         KiZyVLQ7UCpYw/Ra501UXuAxa7MkcKNwZvpRfvv6T0EXWIKS+eq0jiNWrIPBZMSVDG
         s7ApjzsFz9FEA==
Date:   Mon, 17 Apr 2023 08:38:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        Leon Romanovsky <leon@kernel.org>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Saeed Mahameed <saeed@kernel.org>,
        Shay Drory <shayd@nvidia.com>, netdev@vger.kernel.org,
        selinux@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>
Subject: Re: Potential regression/bug in net/mlx5 driver
Message-ID: <20230417083825.6e034c75@kernel.org>
In-Reply-To: <ZDoqw8x7+UHOTCyM@x130>
References: <20230413075421.044d7046@kernel.org>
        <CAHC9VhRKBLHfGHvFAsmcBQQEmbOxZ=M9TE4-pV70E+Y6G=uXWA@mail.gmail.com>
        <ZDhwUYpMFvCRf1EC@x130>
        <20230413152150.4b54d6f4@kernel.org>
        <ZDiDbQL5ksMwaMeB@x130>
        <20230413155139.22d3b2f4@kernel.org>
        <ZDjCdpWcchQGNBs1@x130>
        <20230413202631.7e3bd713@kernel.org>
        <ZDnRkVNYlHk4QVqy@x130>
        <20230414173445.0800b7cf@kernel.org>
        <ZDoqw8x7+UHOTCyM@x130>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Apr 2023 21:40:35 -0700 Saeed Mahameed wrote:
> >What do we do now, tho? If the main side effect of a revert is that
> >users of a newfangled device with an order of magnitude lower
> >deployment continue to see a warning/error in the logs - I'm leaning
> >towards applying it :(  
> 
> I tend to agree with you but let me check with the FW architect what he has
> to offer, either we provide a FW version check or another more accurate
> FW cap test that could solve the issue for everyone. If I don't come up with
> a solution by next Wednesday I will repost your revert in my next net PR
> on Wednesday. You can mark it awaiting-upstream for now, if that works for
> you.

OK, sounds good.
