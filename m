Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7344B5FDCED
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 17:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiJMPR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 11:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiJMPR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 11:17:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1BCC149F;
        Thu, 13 Oct 2022 08:17:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C9CA6183C;
        Thu, 13 Oct 2022 15:17:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8B7C433C1;
        Thu, 13 Oct 2022 15:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665674246;
        bh=yatlLHSqxUtoD/+/RComVTMF7cyfCFtUK70jh+/Y9Uo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RB8lMH2hYP38YlLrXrCjPDqpjWmw50pNmZ/FDXhc0H1/QrFnAd7uUwk6xYhvF7Kq0
         ncH7WKj7vDvdXHbMDiwA/KRvN8M2J8jESXLB85tVkBXKoYwi/v1W0eqTMbEr7IK+jA
         VWiCsg2DCDyC5muKC2bmNJc5adbmKARJv+0E7KLfTSt2V3j5HGd7Ldxtm+K0vy/lOl
         mPyxpyHuUNkH/nDRsh30fIhllowV505ra9GYb0h9MKjBkF3nAIYDbUbuB+kqbyRUxc
         FFju9UcX3ke8DiOVxri/grlyjMKpV1MCXZRT4n+plYDrlBX6FswdKRMKsHTFSEFk3d
         SToMZnvLpr0Cw==
Date:   Thu, 13 Oct 2022 08:17:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>
Subject: Re: [RFC PATCH v3 1/6] dpll: Add DPLL framework base functions
Message-ID: <20221013081725.501b0f58@kernel.org>
In-Reply-To: <Y0e2Zn4pbhPnKGQJ@nanopsycho>
References: <20221010011804.23716-1-vfedorenko@novek.ru>
        <20221010011804.23716-2-vfedorenko@novek.ru>
        <Y0PjULbYQf1WbI9w@nanopsycho>
        <24d1d750-7fd0-44e2-318c-62f6a4a23ea5@novek.ru>
        <Y0UqFml6tEdFt0rj@nanopsycho>
        <Y0UtiBRcc8aBS4tD@nanopsycho>
        <ecf59dda-2d6a-2c56-668b-5377ae107439@novek.ru>
        <Y0ZiQbqQ+DsHinOf@nanopsycho>
        <9a3608cf-21bb-18b1-796a-7325a613b641@novek.ru>
        <Y0e2Zn4pbhPnKGQJ@nanopsycho>
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

On Thu, 13 Oct 2022 08:55:34 +0200 Jiri Pirko wrote:
>> AFAIU, some mux devices are not smart enough to make a decision suitable for
>> autoselect for the pins they have. In this case the autoselect process is
>> done in the DPLL device, which selects mux and not the pin directly. At the
>> same time there could be muxes that are smart enough to make a decision, and
>> it will be autoselect on top of autoselect (and several more layers) and it
>> doesn't sound great to me. I believe Arkadiusz will explain the mux a bit
>> better.  
> 
> From what you write in this reply, I have a feeling that these details
> are not really interesting for user to see. So I tend to lean forward to
> abstract this out and leave the details to HW/FW/driver.

Are you saying we don't need to model MUXes?  Topology of the signals
imposes restrictions on the supported configuration, it's not something
you can "abstract out in the FW".

My thinking was we can let the user ignore it and have the core figure
out the configuration of the muxes if users asks for a pin behind a mux.
But it's better if the mux is visible so that it's clear which signals
can't be selected simultaneously. (IIRC Arkadiusz may have even had
muxes shared between DPLLs :S)

Anyway, I may just be confused about the state of the series because
most of the points you brought up were already discussed. I guess you
were right that off-list reviews are a bad idea :(
