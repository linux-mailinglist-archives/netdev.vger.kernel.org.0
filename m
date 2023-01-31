Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7A6683855
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 22:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbjAaVIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 16:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbjAaVH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 16:07:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8F0DBDA
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 13:07:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0492B81ED9
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 21:07:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A98C433EF;
        Tue, 31 Jan 2023 21:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675199274;
        bh=Y83ujA6j8/4GvzewW6taFZhnxv3vGaf3WkAwCR1hAc0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JjEB7MW+rKN9Cot+Ur3g6p2YSVXd9U2wRkjhkNz34S5RjcKV4N4gXS9kfRmoX5mhA
         z7caZ5YFvHia0PMKwM0xwpBjD74O5O1dRvXVtPlmtyLZcIuuOkvav59ltD3s1iSr+7
         W3/W0UbgGfZsVHkKefy81sJioBqHozVOvVsxPttZew6Y/0ZoyhCzOVhDq44R2boFxi
         WAS1Hlb0FbBqATv6xWiPiJsqZiOM8pliIUx/yO6fLkpfYl/G3mJik0Z4cxqIRIQDqK
         ZpawwJ0+/KfUIeoUKyScKhLh7iFSTK6Cjo2UK7SZdlAj5QjCsDW6xK60Z4NkX/5twf
         MKMj3gA38+Yqw==
Date:   Tue, 31 Jan 2023 13:07:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Michael Walle <michael@walle.cc>, Andrew Lunn <andrew@lunn.ch>,
        Jiri Pirko <jiri@resnulli.us>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        <netdev@vger.kernel.org>
Subject: Re: PHY firmware update method
Message-ID: <20230131130753.32e0e5ba@kernel.org>
In-Reply-To: <7106dccd-4f3d-17a1-0897-604a1025a937@intel.com>
References: <YzQ96z73MneBIfvZ@lunn.ch>
        <YzVDZ4qrBnANEUpm@nanopsycho>
        <YzWPXcf8kXrd73PC@lunn.ch>
        <20220929071209.77b9d6ce@kernel.org>
        <YzWxV/eqD2UF8GHt@lunn.ch>
        <Yzan3ZgAw3ImHfeK@nanopsycho>
        <Yzbi335GQGbGLL4k@lunn.ch>
        <ced75f7f596a146b58b87dd2d6bad210@walle.cc>
        <Y9BCrtlXXGO5WOKN@lunn.ch>
        <7bd02bf6880a092b64a0c27d3715f5b6@walle.cc>
        <Y9lB0MmgyCZxnk3N@shell.armlinux.org.uk>
        <20230131104122.20c143a2@kernel.org>
        <7106dccd-4f3d-17a1-0897-604a1025a937@intel.com>
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

On Tue, 31 Jan 2023 11:56:26 -0800 Jacob Keller wrote:
> On 1/31/2023 10:41 AM, Jakub Kicinski wrote:
> > FWIW we had a concept of "FW load policy" in devlink but IDK if it
> > addresses the concern sufficiently. For mlxsw IIRC the load policy
> > "from disk" means "flash the device if loaded FW is older".  
> 
> My initial interpretation of this parameter was that "LOAD_DISK" implied
> the device could choose to load the firmware from disk but didn't
> necessarily overwrite what was stored in the flash permanently.
> 
> Your interpretation also makes sense on a second review, but I'm not
> sure what "driver" would mean in this context? I guess "whichever driver
> prefers?"

Ah, you're right, I dismembered. Looking at the code 'driver' means
flash to the latest supported by the driver. 'flash' means use what's
there.

For the NFP IIRC 'driver' meant load whichever is newer (but don't
write to flash if disk was newer, just load to sram).

> The parameter does seem like a suitable place to allow admin to specify
> the policy.
