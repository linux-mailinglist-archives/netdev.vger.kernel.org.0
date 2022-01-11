Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF19E48B213
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 17:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241083AbiAKQ06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 11:26:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343701AbiAKQ05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 11:26:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB544C06173F;
        Tue, 11 Jan 2022 08:26:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14981B81C07;
        Tue, 11 Jan 2022 16:26:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9E1C36AE3;
        Tue, 11 Jan 2022 16:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641918414;
        bh=tvQqwYMR7Yb6jrhiayk56/5LTZ7BBAUYeKPzFd54WeQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PBh3nTF+FdZp/SkP3LpVowJSSOWZ3pEFzZ7MEBDA/niSyx6JFCn6UtcsCUeAzzsKV
         laHnGKZ/B232079frpTMNvPZ5aUYN1XwV0p9pKXKP0W9FcLoPEyCuWcRQaAiigYwbl
         U8g9Cu7B8sfGrq05tWiyvOUZKFumDnbko7Xb9jGnwac0pk+PMj1eo22NQhEOxBaO2x
         FmSs8VnW/6XxPiNoXiYWtsP9lpE+I6Q4THTn6f5LTFHFgIQz+MdK0T0jS54Lj4kWdv
         clUaZ6SJCf4BVgWJ07wLK99S2/e/TlW6ON6LI0Z+HiDNlapMLZspU3yWcEtjhc+kfT
         jGffs7qK1VJaQ==
Date:   Tue, 11 Jan 2022 08:26:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Limonciello, Mario" <mario.limonciello@amd.com>
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Andrew Lunn <andrew@lunn.ch>, Oliver Neukum <oneukum@suse.com>,
        Aaron Ma <aaron.ma@canonical.com>, henning.schild@siemens.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, hayeswang@realtek.com, tiwai@suse.de
Subject: Re: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough
 address
Message-ID: <20220111082653.02050070@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <ec2aaeb0-995e-0259-7eca-892d0c878e19@amd.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Jan 2022 08:57:39 -0600 Limonciello, Mario wrote:
> The important thing to remember is that many of these machines *don't*
> have in-built network controller and rely upon a USB-c network adapter.
> 
> I recall a few reasons.
> 
> 1) Consistency with the UEFI network stack and dual booting Windows when 
> using the machine.  IOW 1 DHCP lease to one network controller, not one OS.
> 
> 2) A (small) part of an onion that is network security.  It allows 
> administrators to allow-list or block-list controllers.
> 
> The example I recall hearing is someone has their laptop stolen and 
> notifies I/T.  I/T removes the MAC address of the pass through address
> from the allow-list and now that laptop can't use any hotel cubes for 
> accessing network resources.
> 
> 3) Resource planning and management of hoteling resources.
> 
> For example allow facilities to monitor whether users are reserving and 
> using the hoteling cubes they reserved.

Interesting, I haven't thought about use case (3).

Do you know how this is implemented on other platforms?
