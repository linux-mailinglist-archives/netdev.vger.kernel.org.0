Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47A9F6474D1
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 18:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbiLHRFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 12:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiLHRFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 12:05:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509CF2A711;
        Thu,  8 Dec 2022 09:05:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09C0DB82569;
        Thu,  8 Dec 2022 17:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592BDC433D2;
        Thu,  8 Dec 2022 17:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670519118;
        bh=mVa4rAGYCODwDCVnY1411oDOU/OwbCxVWI/1gCV76L4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TVJAMl42DI3KGjqjl4yeG1Wb6wkYJ+HxG3Pl28rRAwWLrbFkeKsbGjSrXw5wYJOQw
         Va7W/v57CD8QmKvGBsWThaTFS4pyk5a+1NVSc7aAtlFJ1E4OvTcIYHgCy7d7qmudi/
         3gQ8Shs0AxWEmrIMBtlkjow+1GOdhiFcCuburUbDwqgbyB8bVD1mPo28Enl7zPXLXS
         MsGC7E63EqRyb7lYqZ5kNjZ+lqeWMomsNqaP/kdEtnS1RjIbrYeTzQCUyrQEmqdvPW
         mFrc5X3u9GoSuA1hlt9zsMVWCOOJPKw41Jp6cn1W0EQdRbtH/YAkEFWNa1XKIxj6UH
         f6stCSkh8wQYA==
Date:   Thu, 8 Dec 2022 09:05:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vadim Fedorenko <vadfed@fb.com>,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        "Olech, Milena" <milena.olech@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: Re: [RFC PATCH v4 2/4] dpll: Add DPLL framework base functions
Message-ID: <20221208090517.643277e8@kernel.org>
In-Reply-To: <Y5IR2MzXfqgFXGHW@nanopsycho>
References: <Y4okm5TrBj+JAJrV@nanopsycho>
        <20221202212206.3619bd5f@kernel.org>
        <Y43IpIQ3C0vGzHQW@nanopsycho>
        <20221205161933.663ea611@kernel.org>
        <Y48CS98KYCMJS9uM@nanopsycho>
        <20221206092705.108ded86@kernel.org>
        <Y5CQ0qddxuUQg8R8@nanopsycho>
        <20221207085941.3b56bc8c@kernel.org>
        <Y5Gc6E+mpWeVSBL7@nanopsycho>
        <20221208081955.335ca36c@kernel.org>
        <Y5IR2MzXfqgFXGHW@nanopsycho>
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

On Thu, 8 Dec 2022 17:33:28 +0100 Jiri Pirko wrote:
> For any synce pin manipulation over dpll netlink, we can use the netns
> check of the linked netdev. This is the netns aware leg of the dpll,
> it should be checked for.

The OCP card is an atomic clock, it does not have any networking.

> I can't imagine practically havind the whole dpll instance netns aware.
> Omitting the fact that it really has no meaning for non-synce pins, what
> would be the behaviour when for example pin 1 is in netns a, pin 2 in
> netns b and dpll itself in netns c?

To be clear I don't think it's a bad idea in general, I've done 
the same thing for my WIP PSP patches. But we already have one
device without netdevs, hence I thought maybe devlink. So maybe
we do the same thing with devlink? I mean - allow multiple devlink
instances to be linked and require caps on any of them?
