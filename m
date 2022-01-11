Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E5048B27B
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 17:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343712AbiAKQnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 11:43:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240793AbiAKQnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 11:43:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5421C06173F;
        Tue, 11 Jan 2022 08:43:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45960616D2;
        Tue, 11 Jan 2022 16:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD73C36AE3;
        Tue, 11 Jan 2022 16:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641919429;
        bh=cHXjZcgz4oXI5oV4+yqAsFRqFguV+F3REKKZkR3vyZ4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s+2hLtuyc3f05JBAKrY/E2ICK+lddoBEr3NZWK3QUkpQnYxYHaGQAsPPIt4J44G8F
         BHL2cLBjTwusBuGSp920XMromxO9IXfeN3Dir+LDMPEi3U3mnv1Y74v3rC49uKOGdW
         AfJEXwMRr4snfIQWSnCKYVpaVzUMK/S4bKCi2MH+sAyfajpCOS18VRGh9tFSkT5xIl
         VVKTqtqjW4czIxjfShseEB0I8sBf0I6WbGxwA75Ho2Kx5mG4GH+uBBmokiakm1oSXC
         UJQcj4FfVdKYeBzI+MyyBfLeo8i2GlzF5BRE+Ch2rEK/I5QXF65pfG5j7hs6VEvvIj
         63BkKi5OQb3Pg==
Date:   Tue, 11 Jan 2022 08:43:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Limonciello, Mario" <mario.limonciello@amd.com>
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Andrew Lunn <andrew@lunn.ch>, Oliver Neukum <oneukum@suse.com>,
        Aaron Ma <aaron.ma@canonical.com>, henning.schild@siemens.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, hayeswang@realtek.com, tiwai@suse.de
Subject: Re: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough
 address
Message-ID: <20220111084348.7e897af9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <3f258c23-c844-7b48-fffb-2fbf5d6d7475@amd.com>
References: <20220105151427.8373-1-aaron.ma@canonical.com>
        <YdXVoNFB/Asq6bc/@lunn.ch>
        <bb6d8bc4-abee-8536-ca5b-bac11d1ecd53@suse.com>
        <YdYbZne6pBZzxSxA@lunn.ch>
        <CAAd53p52uGFjbiuOWAA-1dN7mTqQ0KFe9PxWvPL+fjfQb9K5vQ@mail.gmail.com>
        <YdbuXbtc64+Knbhm@lunn.ch>
        <CAAd53p5YnQZ0fDiwwo-q3bNMVFTJSMLcdkUuH-7=OSaRrW954Q@mail.gmail.com>
        <20220106183145.54b057c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAAd53p7egh8G=fPMcua_FTHrA3HA6Dp85FqVhvcSbuO2y8Xz9A@mail.gmail.com>
        <20220110085110.3902b6d4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAAd53p5mSq_bZdsZ=-RweiVLgAYU5+=Uje7TmYtAbBzZ7XCPUA@mail.gmail.com>
        <ec2aaeb0-995e-0259-7eca-892d0c878e19@amd.com>
        <20220111082653.02050070@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <3f258c23-c844-7b48-fffb-2fbf5d6d7475@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Jan 2022 10:33:39 -0600 Limonciello, Mario wrote:
> If you end up having only your pass through MAC used for Windows and 
> UEFI your hoteling system might not work properly if your corporation 
> also supports employees to use Linux and this feature was removed from 
> the kernel.

Right, I think the utility of the feature is clear now. Let me clarify
what I was after - I was wondering which component is responsible for
the address inheritance in Windows or UEFI. Is it also hardcoded into
the realtek driver or is there a way to export the ACPI information to
the network management component?

Also knowing how those OSes handle the new docks which don't have
unique device IDs would obviously be great..
