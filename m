Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30FE7462979
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 02:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbhK3BMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 20:12:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37556 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhK3BMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 20:12:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1F21B80954
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 01:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8D6C53FAD;
        Tue, 30 Nov 2021 01:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638234565;
        bh=SePVTgAUt6LqUlYoTeeenroXk7RFyeAMoYX3Pl4kSio=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NL3Wa216BgKtalQ/qYcCYwe8NiCwymDrmislZU12tNwZs6hVHVRWEfJSF77Qo4XHj
         gpwjT+HJgMs6saZSKNDayo+ZDS+d6n4irttWvA4PqdILvOfZ4hv/f2upSju9y2jWiS
         mXANT/vCCJlFWOUq2eec1NN5YnxOz2lPTm3tF5psDVFU+8S+bCJgJafVIWZfmHYRCI
         KxdCjCYeufmII7om2fBiVsC4fFUE3d7FhHZrl1kqZlWGSXdvPjPi3YLUQYKgv7uvOI
         zrGRn4UTTgUiwPPbUCyODE7pRHwK5MSq2jiLtj1tvp2RbYs5NAQbTdWV4yTw4ftTOI
         0M4ANmtHSe7Lg==
Date:   Mon, 29 Nov 2021 17:09:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, mkubecek@suse.cz, pali@kernel.org,
        jacob.e.keller@intel.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 0/4] ethtool: Add ability to flash and
 query transceiver modules' firmware
Message-ID: <20211129170923.26d5fd42@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YaVnUeWtCo7Zxwdc@lunn.ch>
References: <20211127174530.3600237-1-idosch@idosch.org>
        <20211129093724.3b76ebff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YaVnUeWtCo7Zxwdc@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 00:50:41 +0100 Andrew Lunn wrote:
> On Mon, Nov 29, 2021 at 09:37:24AM -0800, Jakub Kicinski wrote:
> > On Sat, 27 Nov 2021 19:45:26 +0200 Ido Schimmel wrote:  
> > > This patchset extends the ethtool netlink API to allow user space to
> > > both flash transceiver modules' firmware and query the firmware
> > > information (e.g., version, state).
> > > 
> > > The main use case is CMIS compliant modules such as QSFP-DD. The CMIS
> > > standard specifies the interfaces used for both operations. See section
> > > 7.3.1 in revision 5.0 of the standard [1].
> > > 
> > > Despite the immediate use case being CMIS compliant modules, the user
> > > interface is kept generic enough to accommodate future use cases, if
> > > these arise.
> > > 
> > > The purpose of this RFC is to solicit feedback on both the proposed user
> > > interface and the device driver API which are described in detail in
> > > patches #1 and #3. The netdevsim patches are for RFC purposes only. The
> > > plan is to implement the CMIS functionality in common code (under lib/)
> > > so that it can be shared by MAC drivers that will pass function pointers
> > > to it in order to read and write from their modules EEPROM.
> > > 
> > > ethtool(8) patches can be found here [2].  
> > 
> > Immediate question I have is why not devlink. We purposefully moved 
> > FW flashing to devlink because I may take long, so doing it under
> > rtnl_lock is really bad. Other advantages exist (like flashing
> > non-Ethernet ports). Ethtool netlink already existed at the time.
> > 
> > I think device flashing may also benefit from the infra you're adding.  
> 
> The idea of asynchronous operations without holding RTNL is not that
> new. The cable test code does it, but clearly cable testing is likely
> network specific, unlike FW flashing.

Right, I missed this is async. Presumably since there is a plan for 
a common module the chance of bugs sneaking in will be somewhat lower,
but still flashing FW is flashing FW, would be great if we could align
with device FW flashing as done via devlink.
