Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F5943C96F
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 14:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239981AbhJ0MVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 08:21:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33448 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230420AbhJ0MVJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 08:21:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=udb9s9/cYXbcm69eAqcs913SY67o0SZViIAg9zwP/zg=; b=uWfDEfJ0HNrPazm9xfaSJLH8C5
        50GrenS10dQHmzvNw3AjeeC6WYFcA3dV0beuRKtflgwfgxY/EDq/KugUcsToGNkbgqFpojmFpe98f
        ZKAPwvN8vNHi3ACE6JPZwWWde3eH4UQ3o0abvFAdWow5BQJbXaRbjDzeqW0pW9RrGFfk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mfht6-00BtZR-8y; Wed, 27 Oct 2021 14:18:36 +0200
Date:   Wed, 27 Oct 2021 14:18:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ariel Elior <aelior@marvell.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Manish Chopra <manishc@marvell.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        Shai Malin <smalin@marvell.com>,
        Omkar Kulkarni <okulkarni@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>
Subject: Re: [EXT] Re: [PATCH net-next 1/2] bnx2x: Utilize firmware 7.13.20.0
Message-ID: <YXlDnCZIlVl1Etgs@lunn.ch>
References: <20211026193717.2657-1-manishc@marvell.com>
 <20211026140759.77dd8818@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR18MB465598CDD29377C300C3184CC4859@PH0PR18MB4655.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR18MB465598CDD29377C300C3184CC4859@PH0PR18MB4655.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > ----------------------------------------------------------------------
> > On Tue, 26 Oct 2021 12:37:16 -0700 Manish Chopra wrote:
> > > Commit 0050dcf3e848 ("bnx2x: Add FW 7.13.20.0") added a new .bin
> > > firmware file to linux-firmware.git tree. This new firmware addresses
> > > few important issues and enhancements as mentioned below -
> > >
> > > - Support direct invalidation of FP HSI Ver per function ID, required for
> > >   invalidating FP HSI Ver prior to each VF start, as there is no VF
> > > start
> > > - BRB hardware block parity error detection support for the driver
> > > - Fix the FCOE underrun flow
> > > - Fix PSOD during FCoE BFS over the NIC ports after preboot driver
> > >
> > > This patch incorporates this new firmware 7.13.20.0 in bnx2x driver.
> > 
> > How is this expected to work? Your drivers seems to select a very specific FW
> > version:
> > 
> > 	/* Check FW version */
> > 	offset = be32_to_cpu(fw_hdr->fw_version.offset);
> > 	fw_ver = firmware->data + offset;
> > 	if ((fw_ver[0] != BCM_5710_FW_MAJOR_VERSION) ||
> > 	    (fw_ver[1] != BCM_5710_FW_MINOR_VERSION) ||
> > 	    (fw_ver[2] != BCM_5710_FW_REVISION_VERSION) ||
> > 	    (fw_ver[3] != BCM_5710_FW_ENGINEERING_VERSION)) {
> > 		BNX2X_ERR("Bad FW version:%d.%d.%d.%d. Should be
> > %d.%d.%d.%d\n",
> > 		       fw_ver[0], fw_ver[1], fw_ver[2], fw_ver[3],
> > 		       BCM_5710_FW_MAJOR_VERSION,
> > 		       BCM_5710_FW_MINOR_VERSION,
> > 		       BCM_5710_FW_REVISION_VERSION,
> > 		       BCM_5710_FW_ENGINEERING_VERSION);
> > 		return -EINVAL;
> > 	}
> > 
> > so this change has a dependency on user updating their /lib/firmware.
> > 
> > Is it really okay to break the systems for people who do not have that FW
> > version with a stable backport?
> > 
> > Greg, do you have general guidance for this or is it subsystem by subsystem?

I have been pushing back on a similar change for the Marvell Prestera
driver, which also loads the firmware from /lib/firmware and they are
proposing to break the ABI to the firmware, and not support older
version.

I don't like this. As Jakub points out, you are going to break systems
which don't update the firmware and the kernel at the same time. I
really would prefer you support two versions of the firmware, and
detect what features it supports to runtime.

	Andrew
