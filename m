Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805E143BC10
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 23:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239423AbhJZVK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 17:10:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239420AbhJZVKZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 17:10:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6A5660E76;
        Tue, 26 Oct 2021 21:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635282481;
        bh=RtpCLCh9GYTO8x2QZSVnujj/TsQugEdea5o2gvbJyTg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HA/ZgG/UVk7UHx66zqT6T9wIAW0mKWsDnF19YuVzxOqVZ0e6jd5HrQYFq+Oqmd1td
         5l+46F7K1JTon4ymrhsvoKVdqrZPKNU1bpV+bfYyziAaephKDuwhqFoL2StLADMb1t
         dTcwZBk1jZOhiNlfMoI7PLQ6cWzBPPQclV4/LqVlpwEU0sMckW/f5DijO0EbObT7R1
         JisHFf2IfryU3VG4WPrOCF5jn5cWaOQLjxf27YujKuuizCwR0OcOx14pejOiMPXxR+
         fDSS3NSKxg9+X8tEu0u3NQ8lNOtG/5DCNyqmTUWVw9HX8Z4eCx1NCVbzWc4JAwOx6h
         KlQyyHDu3zKHQ==
Date:   Tue, 26 Oct 2021 14:07:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Manish Chopra <manishc@marvell.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     <netdev@vger.kernel.org>, <stable@vger.kernel.org>,
        <aelior@marvell.com>, <skalluru@marvell.com>,
        <malin1024@gmail.com>, <smalin@marvell.com>,
        <okulkarni@marvell.com>, <njavali@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 1/2] bnx2x: Utilize firmware 7.13.20.0
Message-ID: <20211026140759.77dd8818@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211026193717.2657-1-manishc@marvell.com>
References: <20211026193717.2657-1-manishc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Oct 2021 12:37:16 -0700 Manish Chopra wrote:
> Commit 0050dcf3e848 ("bnx2x: Add FW 7.13.20.0") added a new .bin
> firmware file to linux-firmware.git tree. This new firmware addresses
> few important issues and enhancements as mentioned below -
> 
> - Support direct invalidation of FP HSI Ver per function ID, required for
>   invalidating FP HSI Ver prior to each VF start, as there is no VF start
> - BRB hardware block parity error detection support for the driver
> - Fix the FCOE underrun flow
> - Fix PSOD during FCoE BFS over the NIC ports after preboot driver
> 
> This patch incorporates this new firmware 7.13.20.0 in bnx2x driver.

How is this expected to work? Your drivers seems to select a very
specific FW version:

	/* Check FW version */
	offset = be32_to_cpu(fw_hdr->fw_version.offset);
	fw_ver = firmware->data + offset;
	if ((fw_ver[0] != BCM_5710_FW_MAJOR_VERSION) ||
	    (fw_ver[1] != BCM_5710_FW_MINOR_VERSION) ||
	    (fw_ver[2] != BCM_5710_FW_REVISION_VERSION) ||
	    (fw_ver[3] != BCM_5710_FW_ENGINEERING_VERSION)) {
		BNX2X_ERR("Bad FW version:%d.%d.%d.%d. Should be %d.%d.%d.%d\n",
		       fw_ver[0], fw_ver[1], fw_ver[2], fw_ver[3],
		       BCM_5710_FW_MAJOR_VERSION,
		       BCM_5710_FW_MINOR_VERSION,
		       BCM_5710_FW_REVISION_VERSION,
		       BCM_5710_FW_ENGINEERING_VERSION);
		return -EINVAL;
	}

so this change has a dependency on user updating their /lib/firmware.

Is it really okay to break the systems for people who do not have that
FW version with a stable backport?

Greg, do you have general guidance for this or is it subsystem by subsystem?
