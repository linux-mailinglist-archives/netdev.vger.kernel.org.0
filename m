Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A158C5AA0D9
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 22:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234903AbiIAUXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 16:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232088AbiIAUXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 16:23:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB40C7285D;
        Thu,  1 Sep 2022 13:23:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D890B82934;
        Thu,  1 Sep 2022 20:23:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170CEC433D6;
        Thu,  1 Sep 2022 20:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662063819;
        bh=DZet2g1JTuCOMZjHO51L2oDBFmnNX7de9n0/D5jATac=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HjtXBYxssHpdX+ioUY/pQvnV7rZEjNef3L1Er6ytDW2hu3sERZg8CZCG/CzIBjoY5
         f9TffmuV8aCckpJc4oojYAGPPjv6sB7TsGBiOsCo74bqSpXVzjwwH7aK2ulWd90FH+
         8bkqXhpTLriLzPW3jq4diOfeAxEK5lHZoT4uMEcKQg7h4a9g3OGlMAOd9sp6k8KqQ6
         l1HbhSxnvhiz5iD23BQ8LQg5nbo3JcIL5QBqjge4ljqiVy4Wt8udBHXPk5H2R2PAf0
         kddC3QU8U+CIbQNg4tGp3fcnkcf1YnWFDQ8aiPGJbC9SDKvRS/uzj7b8h6bYZjuUKN
         VyJbyNd28cWlQ==
Date:   Thu, 1 Sep 2022 13:23:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        Alexander Aring <alex.aring@gmail.com>,
        Gal Pressman <gal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-wpan@vger.kernel.org
Subject: Re: [PATCH net-next] net: ieee802154: Fix compilation error when
 CONFIG_IEEE802154_NL802154_EXPERIMENTAL is disabled
Message-ID: <20220901132338.2953518c@kernel.org>
In-Reply-To: <YxBTaxMmHKiLjcCo@unreal>
References: <20220830101237.22782-1-gal@nvidia.com>
        <20220830231330.1c618258@kernel.org>
        <4187e35d-0965-cf65-bff5-e4f71a04d272@nvidia.com>
        <20220830233124.2770ffc2@kernel.org>
        <20220831112150.36e503bd@kernel.org>
        <36f09967-b211-ef48-7360-b6dedfda73e3@datenfreihafen.org>
        <20220831140947.7e8d06ee@kernel.org>
        <YxBTaxMmHKiLjcCo@unreal>
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

On Thu, 1 Sep 2022 09:38:35 +0300 Leon Romanovsky wrote:
> There is no such thing like experimental UAPI. Once you put something
> in UAPI headers and/or allowed users to issue calls from userspace
> to kernel, they can use it. We don't control how users compile their
> kernels.
> 
> So it is not break "experimental commands", but break commands that
> maybe shouldn't exist in first place.
> 
> nl802154 code suffers from two basic mistakes:
> 1. User visible defines are not part of UAPI headers. For example,
> include/net/nl802154.h should be in include/uapi/net/....
> 2. Used Kconfig option for pseudo-UAPI header.
> 
> In this specific case, I checked that Fedora didn't enable this
> CONFIG_IEEE802154_NL802154_EXPERIMENTAL knob, but someone needs
> to check debian and other distros too.
> 
> Most likely it is not used at all.

You're right, FWIW. I didn't want to get sidetracked into that before
we fix the immediate build issue. It's not the only family playing uAPI
games :(
