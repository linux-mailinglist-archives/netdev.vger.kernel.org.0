Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D33A063B6CB
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 01:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234594AbiK2Az2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 19:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233027AbiK2Az1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 19:55:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B659332BA7
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 16:55:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61141B80EAC
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:55:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88CAC433D6;
        Tue, 29 Nov 2022 00:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669683324;
        bh=2eXDHap6SIXXdRDroxA7iKsJrZVEgPbgelgvWkzA0UU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QcnbaLApgJAeShzGczsWiPIU5cF3J71mlDL5EzeJvRkuV57vhgm9CeFpehvi4s7w1
         2JgrZL3XQivGW0iL3/DHHw29K5CZuw3nx9jXRBXXhWND6CXeGFCm0iC1iu+pdZ66eN
         mxuiA7PWYapY8gM+/2bACVH8SdRkWXSgCp2P7pYW6kInUAUkLfU8mqJ3Yd/P0yNjk2
         rM5GEhkS9VmkoW70CZLftDKUfZteFpgA/C2RlmuUQ0IEMgS+LbH7QfnuOu4MWIQFve
         G9uB39dLOzu3u9bre4qRb4rRI+RR5ancdyjtrFQzS8eVSUB4TzkevCsBusK2chnkhj
         cRZRuL7QDWfiQ==
Date:   Mon, 28 Nov 2022 16:55:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shnelson@amd.com>
Cc:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, drivers@pensando.io
Subject: Re: [RFC PATCH net-next 08/19] pds_core: initial VF configuration
Message-ID: <20221128165522.62dcd7be@kernel.org>
In-Reply-To: <75072b2a-0b69-d519-4174-6d61d027f7d4@amd.com>
References: <20221118225656.48309-1-snelson@pensando.io>
        <20221118225656.48309-9-snelson@pensando.io>
        <20221128102828.09ed497a@kernel.org>
        <d24a9900-154f-ad3a-fef4-73a57f0cddb0@amd.com>
        <20221128153719.2b6102cc@kernel.org>
        <75072b2a-0b69-d519-4174-6d61d027f7d4@amd.com>
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

On Mon, 28 Nov 2022 16:37:45 -0800 Shannon Nelson wrote:
> > If this is a "SmartNIC" there should be alternative solution based on
> > representors for each of those callbacks, and the device should support
> > forwarding using proper netdev constructs like bridge, routing, or tc.
> > 
> > This has been our high level guidance for a few years now. It's quite
> > hard to move the ball forward since all major vendors have a single
> > driver for multiple generations of HW :(  
> 
> Absolutely, if the device presented to the host is a SmartNIC and has 
> these bridge and router capabilities, by all means it should use the 
> newer APIs, but that's not the case here.
> 
> In this case we are making devices available to baremetal platforms in a 
> cloud vendor setting where the majority of the network configuration is 
> controlled outside of the host machine's purview.  There is no bridging, 
> routing, or filtering control available to the baremetal client other 
> than the basic VF configurations.

Don't even start with the "our device is simple and only needs 
the legacy API" line of arguing :/

> The device model presented to the host is a simple PF with VFs, not a 
> SmartNIC, thus the pds_core driver sets up a simple PF netdev 
> "representor" for using the existing VF control API: easy to use, 
> everyone knows how to use it, keeps code simple.
> 
> I suppose we could have the PF create a representor netdev for each 
> individual VF to set mac address and read stats, but that seems 

Oh, so the "representor" you mention in the cover letter is for the PF?

> redundant, and as far as I know that still would be missing the other VF 
> controls.  Do we have alternate ways for the user to set things like 
> trust and spoofchk?

