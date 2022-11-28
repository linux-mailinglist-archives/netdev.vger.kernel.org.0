Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFDC663B601
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 00:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234740AbiK1XhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 18:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234749AbiK1XhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 18:37:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C993232BAC
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 15:37:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66F686126D
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 23:37:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DDFC433C1;
        Mon, 28 Nov 2022 23:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669678640;
        bh=AxJq3VPLxJhqvSuXtIXN/Ev5+2uyL1elEzhHks9Bgc0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nleS3AxdD+Cfi584xwLzOf4HgynDMyWuQ4Sx3AyaFgYFS2zJpFVWfkPZA0s2T6dTw
         Cqc3FITBF3OzdxRhXzpuP3f5anSO3IB+s/s2WzTPLS6Q1xQnB4gEYCxXghBFXx67vh
         n7OLKXaBUoK9rzw0snXK2SwdlwQJo6GFiGMVe/1sTYGnJ3X3R4yzL14TiW6PvVe3u8
         0Eh3NIrF6CFOFLQhmmijUJ2SunUcr7ibv1ACTNlgqX3iOygG5CRIrfPlnkJ+spb3ww
         8mVWYvBgQkl2pWmo0RlM6NZJYRv4lImE7ZhtCUv782gdLTOEgwbGTSpuwJqfh7JHzi
         A1DacbqHirdzw==
Date:   Mon, 28 Nov 2022 15:37:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shnelson@amd.com>
Cc:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, drivers@pensando.io
Subject: Re: [RFC PATCH net-next 08/19] pds_core: initial VF configuration
Message-ID: <20221128153719.2b6102cc@kernel.org>
In-Reply-To: <d24a9900-154f-ad3a-fef4-73a57f0cddb0@amd.com>
References: <20221118225656.48309-1-snelson@pensando.io>
        <20221118225656.48309-9-snelson@pensando.io>
        <20221128102828.09ed497a@kernel.org>
        <d24a9900-154f-ad3a-fef4-73a57f0cddb0@amd.com>
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

On Mon, 28 Nov 2022 14:25:56 -0800 Shannon Nelson wrote:
> On 11/28/22 10:28 AM, Jakub Kicinski wrote:
> > On Fri, 18 Nov 2022 14:56:45 -0800 Shannon Nelson wrote:  
> >> +     .ndo_set_vf_vlan        = pdsc_set_vf_vlan,
> >> +     .ndo_set_vf_mac         = pdsc_set_vf_mac,
> >> +     .ndo_set_vf_trust       = pdsc_set_vf_trust,
> >> +     .ndo_set_vf_rate        = pdsc_set_vf_rate,
> >> +     .ndo_set_vf_spoofchk    = pdsc_set_vf_spoofchk,
> >> +     .ndo_set_vf_link_state  = pdsc_set_vf_link_state,
> >> +     .ndo_get_vf_config      = pdsc_get_vf_config,
> >> +     .ndo_get_vf_stats       = pdsc_get_vf_stats,  
> > 
> > These are legacy, you're adding a fancy SmartNIC (or whatever your
> > marketing decided to call it) driver. Please don't use these at all.  
> 
> Since these are the existing APIs that I am aware of for doing this kind 
> of VF configuration, it seemed to be the right choice.  I'm not aware of 
> any other obvious solutions.  Do you have an alternate suggestion?

If this is a "SmartNIC" there should be alternative solution based on
representors for each of those callbacks, and the device should support
forwarding using proper netdev constructs like bridge, routing, or tc.

This has been our high level guidance for a few years now. It's quite
hard to move the ball forward since all major vendors have a single
driver for multiple generations of HW :(
