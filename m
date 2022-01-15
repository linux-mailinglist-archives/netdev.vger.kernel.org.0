Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D248648F452
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 03:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbiAOCKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 21:10:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232152AbiAOCKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 21:10:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36EDC061574
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 18:10:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33EB2B82A6B
        for <netdev@vger.kernel.org>; Sat, 15 Jan 2022 02:10:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6630AC36AE9;
        Sat, 15 Jan 2022 02:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642212631;
        bh=g6dBg9QZgfEp6vTh8301SKd8VNrRI7D3RQ5tbP7WrKA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qiggvLlJt5shOC116ZqOJWzOjHSOiV+ZnK4qSh3Dl3Qoypmcjy93m82z9glRWjZF5
         m2DltZwez97sFgmqINFGqkmCF493Q7PN1+6VL7V6MCUUBF/Yf5f4gF8qwKBx11cqee
         ycBGIT+uPmf9sTZokwD0ZXQzdGkk9IYp3YkwE/62cacCQHhq6Xcnbe8fs3iIyntaLg
         WXk4WkxUmX8Ewyspp4C58if8KsLwZj91mb0/e3CiQ3xrUHWuTSSkYnw7bUlFlc1Hxl
         MRLamhBzbYrCbsJtG4eLLD60H6toyZ8QRmzD+lK570tzuf3Jn1EzdyF+iVwo7zATgl
         XsFvRw/TRCXrg==
Date:   Fri, 14 Jan 2022 18:10:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Parav Pandit <parav@nvidia.com>,
        Sunil Sudhakar Rani <sunrani@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Bodong Wang <bodong@nvidia.com>
Subject: Re: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Message-ID: <20220114181029.0b4f87d4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <YeE/RfKb0bxQmJOq@nanopsycho>
References: <5c4b51aecd1c5100bffdfab03bc76ef380c9799d.camel@nvidia.com>
        <20211202093110.2a3e69e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d0df87e28497a697cae6cd6f03c00d42bc24d764.camel@nvidia.com>
        <20211215112204.4ec7cf1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1da3385c7115c57fabd5c932033e893e5efc7e79.camel@nvidia.com>
        <20211215150430.2dd8cd15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <SN1PR12MB2574E418C1C6E1A2C0096964D4779@SN1PR12MB2574.namprd12.prod.outlook.com>
        <20211216082818.1fb2dff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR12MB54817CE7826A6E924AE50B9BDC519@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220111102005.4f0fa3a0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <YeE/RfKb0bxQmJOq@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Jan 2022 10:15:49 +0100 Jiri Pirko wrote:
>>> It was implicit that a driver API callback addition for both types of features is not good.
>>> Devlink port function params enables to achieve both generic and device specific features.
>>> Shall we proceed with port function params? What do you think?
>>
>> I already addressed this. I don't like devlink params. They muddy the
>> water between vendor specific gunk and bona fide Linux uAPI. Build a
>> normal dedicated API.
> 
> Well, that is indeed true. But on the other hand, what is the alternative
> solution? There are still going to be things wich are generic and driver-
> specific. Params or no params. Or do you say we need some new well
> defined enum-based api for generic stuff and driver-speficic will just
> go to params?

The latter is where my thinking is right now. I think devlink params
are attracting too much vendor attention, when they should really be
more of control for quirks.
