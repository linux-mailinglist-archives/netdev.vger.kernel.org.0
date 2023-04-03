Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE21C6D5021
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 20:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbjDCSSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 14:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232434AbjDCSSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 14:18:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3C11FD8;
        Mon,  3 Apr 2023 11:18:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04E226252A;
        Mon,  3 Apr 2023 18:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D63C433EF;
        Mon,  3 Apr 2023 18:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680545894;
        bh=aBv3MIAl7MHy2gxFkA3aRokEYOsWf9pvu+LOh3HggEM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QfMW9qU5BVF4Lvj70eLSPFbuo/AIl6dggkk0cscwgbF765jelDaa52rRFaZGJyUVD
         l2w6rkiunDdVCe0yG5t9gs3jNYORHP6njKwIBEoFW2er7WI6nX4ok6NIGt/DqPLAlc
         GksMbiu/kTG37+RJxXbBK4n2c0N2PZZ3S7uV4AaGoxUP3ut++4/aBV2TKUWtvSgOw0
         rymKjGl4NQR36luXbxpKX83/ETkJ9mVbgKWmfSC9nNXXH+7has5hoPvvLSXxmGahIy
         FzVqlIIlE7UG4rVVmodaJWEKpsm8nBj+kFddrXcZCPq5xCbqfAV5/PdT0qtKQNbeL6
         8aznCOoltjvXg==
Date:   Mon, 3 Apr 2023 11:18:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        Vadim Fedorenko <vadfed@meta.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, poros <poros@redhat.com>,
        mschmidt <mschmidt@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "Olech, Milena" <milena.olech@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: Re: [PATCH RFC v6 2/6] dpll: Add DPLL framework base functions
Message-ID: <20230403111812.163b7d1d@kernel.org>
In-Reply-To: <ZBGOWQW+1JFzNsTY@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
        <20230312022807.278528-3-vadfed@meta.com>
        <ZA9Nbll8+xHt4ygd@nanopsycho>
        <2b749045-021e-d6c8-b265-972cfa892802@linux.dev>
        <ZBA8ofFfKigqZ6M7@nanopsycho>
        <DM6PR11MB4657120805D656A745EF724E9BBE9@DM6PR11MB4657.namprd11.prod.outlook.com>
        <ZBGOWQW+1JFzNsTY@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Mar 2023 10:22:33 +0100 Jiri Pirko wrote:
> So basically you say, you can have 2 approaches in app:
> 1)
> id = dpll_device_get_id("ice/c92d02a7129f4747/1")
> dpll_device_set(id, something);
> dpll_device_set(id, something);
> dpll_device_set(id, something);
> 2):
> dpll_device_set("ice/c92d02a7129f4747/1, something);
> dpll_device_set("ice/c92d02a7129f4747/1, something);
> dpll_device_set("ice/c92d02a7129f4747/1, something);
> 
> What is exactly benefit of the first one? Why to have 2 handles? Devlink
> is a nice example of 2) approach, no problem there.

IMHO for devlink the neatness of using the name came from the fact 
that the device name was meaningful. 

With the advent of auxbus that's no longer the case.

In fact it seems more than likely that changing the name to auxbus
will break FW update scripts. Maybe nobody has complained yet only
because prod adoption of these APIs is generally lacking :(

I agree that supporting both name and ID is pointless, user space can
translate between the two trivially all by itself. But I'd lean towards
deleting the name support not the ID support :(
