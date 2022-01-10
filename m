Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82838489DE1
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 17:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237765AbiAJQvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 11:51:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52324 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237724AbiAJQvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 11:51:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3309A61336;
        Mon, 10 Jan 2022 16:51:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C238C36AE5;
        Mon, 10 Jan 2022 16:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641833472;
        bh=TAFt1eT6lxjDGclCuz//kQq/hpv+xG4P7ZsziFTQfjg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dgQqzxvgO1B2odiJdvWN8BZEOVsvx3cpbgSlGPzheue2md9vWQ6SW47Q7W/6JcJ91
         A+We3FtsTkW4t++3awKSp6x1E4BWl+MtPS8bW7pRigND2GZlbW2hKJSQXgNvbr+BLe
         nZnwEUyWaP/344SeGayiIAumbHyT62uaPtGGTmzbkPwm/vn+K7afGezi6q0LKAO0oI
         qS4ZDu59Z52XockD0IukS44iH64BL6AR6GSRyldxEXQj6hiWT7MXRFTRhlnVu/BU2b
         BmFsIaC/IFqaAimlm2Hx49Fs1FOBTX0DPzIKu/18lraoQycFjImxZWxqZqBKvWFHD9
         OjtZP45pH2GQg==
Date:   Mon, 10 Jan 2022 08:51:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Oliver Neukum <oneukum@suse.com>,
        Aaron Ma <aaron.ma@canonical.com>, henning.schild@siemens.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, hayeswang@realtek.com, tiwai@suse.de
Subject: Re: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough
 address
Message-ID: <20220110085110.3902b6d4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAAd53p7egh8G=fPMcua_FTHrA3HA6Dp85FqVhvcSbuO2y8Xz9A@mail.gmail.com>
References: <20220105151427.8373-1-aaron.ma@canonical.com>
        <YdXVoNFB/Asq6bc/@lunn.ch>
        <bb6d8bc4-abee-8536-ca5b-bac11d1ecd53@suse.com>
        <YdYbZne6pBZzxSxA@lunn.ch>
        <CAAd53p52uGFjbiuOWAA-1dN7mTqQ0KFe9PxWvPL+fjfQb9K5vQ@mail.gmail.com>
        <YdbuXbtc64+Knbhm@lunn.ch>
        <CAAd53p5YnQZ0fDiwwo-q3bNMVFTJSMLcdkUuH-7=OSaRrW954Q@mail.gmail.com>
        <20220106183145.54b057c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAAd53p7egh8G=fPMcua_FTHrA3HA6Dp85FqVhvcSbuO2y8Xz9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Jan 2022 11:32:16 +0800 Kai-Heng Feng wrote:
> > > I don't think it's a good idea. On my laptop,
> > > systemd-udev-settle.service can add extra 5~10 seconds boot time
> > > delay.
> > > Furthermore, the external NIC in question is in a USB/Thunderbolt
> > > dock, it can present pre-boot, or it can be hotplugged at any time.  
> >
> > IIUC our guess is that this feature used for NAC and IEEE 802.1X.
> > In that case someone is already provisioning certificates to all
> > the machines, and must provide a config for all its interfaces.
> > It should be pretty simple to also put the right MAC address override
> > in the NetworkManager/systemd-networkd/whatever config, no?  
> 
> If that's really the case, why do major OEMs came up with MAC
> pass-through? Stupid may it be, I don't think it's a solution looking
> for problem.

I don't know. Maybe due to a limitation in Windows? Maybe it's hard to
do in network manager, too, and we're not seeing something. Or perhaps
simply because they want to convince corporations to buy their
unreasonably expensive docks.

What I do know is that we need to gain a good understanding of the
motivation before we push any more of such magic into the kernel.

I may be able to do some testing myself after the Omicron surge is over
in the US.
