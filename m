Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82FE569564A
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 03:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbjBNCC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 21:02:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjBNCCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 21:02:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136A719A
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 18:02:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D5B66136F
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 02:02:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70296C433D2;
        Tue, 14 Feb 2023 02:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676340168;
        bh=HN8b+DHVyG8l7eOl8vdGLyZjG7Lz/OjKbKLcTPU9tA4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UbTC6LEMsP4wzcgN0qJkG7F5EWHVBTKIkhajj8SMnWKIlgHnWIskZgPwExLnVcKdH
         XmSGmRE+JKKz37TAzMjeyAIIRWqKq9xX9XfdiAq0MNGClYkLEjGKXd+J0UzyF/gb7K
         evKt9IGTn5wxPKplVakpGhTG0Yo6JL8AjtI99C9nb52+koi1Uyx2XrRoNVBSngyfdR
         vQJKrUttu5lYBBj/nwCklnFe00sETvCvR0JPqEj0N678Bbvqb2zyhRrJP/54SbNE2W
         M0HUBKll9X/XK8vTl7Fc2m6T08AMwtbosmxFJDuI3h+xNzKSUuCoh7BKRSNSCpq0gI
         vTkjIyiLJKcEg==
Date:   Mon, 13 Feb 2023 18:02:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mark Bloch <mbloch@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: Re: [net-next 01/15] net/mlx5: Lag, Let user configure multiport
 eswitch
Message-ID: <20230213180246.06ae4acd@kernel.org>
In-Reply-To: <db85436e-67a3-4236-dcb5-590cf3c9eafa@nvidia.com>
References: <20230210221821.271571-1-saeed@kernel.org>
        <20230210221821.271571-2-saeed@kernel.org>
        <20230210200329.604e485e@kernel.org>
        <db85436e-67a3-4236-dcb5-590cf3c9eafa@nvidia.com>
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

On Mon, 13 Feb 2023 21:00:16 +0200 Mark Bloch wrote:
> I agree with you this definitely should be the default. That was
> the plan in the beginning. Testing uncovered that making it the default
> breaks users. It changes the look and feel of the driver when in switchdev
> mode, the customers we've talked with are very afraid
> it will break their software and actually, we've seen real breakages
> and I fully expect more to pop up once this feature goes live.

Real breakages as in bugs that are subsequently addressed or inherent
differences which customers may need to adjust their code for?
Either way we need the expectation captured in the docs - 
an "experimental" warning or examples of cases which behave differently.

> We've started reaching out to customers and working with them on updating
> their software but such a change takes time and honestly, we would like to
> push this change out as soon as possible and start building
> on top of this new mode. Once more features that are only possible in this
> new mode are added it will be an even bigger incentive to move to it.
> 
> We believe this parameter will allow customers to transition to the new
> mode faster as we know this is a big change, let's start the transition
> as soon as possible as we know delaying it will only make things worse.
> Add a flag so we can control it and in the future, once all the software
> is updated switch the flag to be the default and keep it for legacy
> software where updating the logic isn't possible.

Oh, the "legacy software where updating the logic isn't possible"
sounds concerning. Do we know what those cases are? Can we perhaps
constrain them to run on a specific version of HW (say starting with
CX8 the param will no longer be there and only the right behavior will
be supported upstream)?

I'm speaking under assumption that the document+deprecate plan is okay
with Jiri.
