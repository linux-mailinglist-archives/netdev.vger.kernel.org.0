Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5A5641D3C
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 14:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiLDNaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 08:30:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiLDNap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 08:30:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E50E11C37
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 05:30:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C33A160E73
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 13:30:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ADDEC433D6;
        Sun,  4 Dec 2022 13:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670160644;
        bh=tNFeOiRpJbGNVxiJtUYs/C9PHaNrmhyMg3MVWguG+F0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JwGft0OTjWkQKL1nixYblHJ9QICstTW/ZUwJhnoUDsE7r0xSCFnfM9KlnOfrrNjsH
         qqumoeQ1ZIty6UOWQUDJfWPDoz3UWaBKO3BUya/jNjnRoRkKz+NrKUSgHvg3sG4Zkj
         2E9Rwq3W38fSRfaB8zqjN+vkQDtXodONLvtP0ecPz/3Va+EW4rLW9YXZjZ4xfE4fyq
         pEn4MXX3EnbR4fA464YY5myImhH3Q1AlU3V1Ww0p8u05dDj7KY8ZTiXOU73DNO1jW8
         D534JuusUjHrjpsanTAYM1bZrdcVbqCivFkfs/d3EjuiAw0uFZYe3UNFr2nPVeMVaw
         jv6XGt5p4R7jA==
Date:   Sun, 4 Dec 2022 15:30:39 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: Re: [PATCH net-next 08/14] ice: protect init and calibrating fields
 with spinlock
Message-ID: <Y4yg/91T+r4+XdSd@unreal>
References: <20221130194330.3257836-1-anthony.l.nguyen@intel.com>
 <20221130194330.3257836-9-anthony.l.nguyen@intel.com>
 <Y4hxen0fOSVnXWbf@unreal>
 <ba949af0-7de6-ab12-6501-46a5af06001f@intel.com>
 <bb5d4351-af35-e40f-5c2c-031c83dd82c4@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb5d4351-af35-e40f-5c2c-031c83dd82c4@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 03:07:16PM -0800, Jacob Keller wrote:
> 
> 
> On 12/2/2022 10:36 AM, Jacob Keller wrote:
> > I am not sure what the best way to fix c) is. Perhaps an additional flag
> > of some sort which indicates that the timestamp thread function is
> > processing so that tear down can wait until after the interrupt function
> > completes. Once init is cleared, the function will stop re-executing,
> > but we need a way to wait until it has stopped. That method in tear down
> > can't hold the lock or else we'd potentially deadlock... Maybe an
> > additional "processing" flag which is set under lock only if the init
> > flag is set? and then cleared when the function exits. Then the tear
> > down can check and wait for the processing to be complete? Hmm.
> > 
> 
> For what its worth, I think this is an issue regardless of whether this
> series is applied, since the change from kthread to threaded IRQ was done a
> while ago.

Sorry, I can't say anything clear without deep dive into ice code. But this specific
patch is not correct.

Thanks
