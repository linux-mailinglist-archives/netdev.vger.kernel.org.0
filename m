Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA1448BDA0
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 04:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349244AbiALDYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 22:24:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60726 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349230AbiALDYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 22:24:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFCDDB81DA4
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 03:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D9BC36AE3;
        Wed, 12 Jan 2022 03:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641957880;
        bh=EByXX44j+lCFqgWFurFKNnAudZ5mFOkHOP4tQj1mDVY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vFCuWMkxMK+OCfBoArnoLSbYM6iAIhKbmmdTZ3ZikhIouMTNfY55FYffA2/vlq16M
         7Gb3B1GRB8fb896GxYgAlzmV+EAI99KU0ITMXXWaddfMXJyxKUEvcy7vtf9PnQ5IKt
         RhJwEFga8kT0GZr1MPNpfttRXZhxh812Y46ZIa647ShKOM184cYkXySe6eTt21Dqvk
         PV2yVenjUVZrWEqwecg8lg7BKHZaJDi/ttcNEqTYp5c7ZKDZnWf21AXjO5cz8zIrvB
         7Nk7BQq5QZYkMo8qPxjno3Y/VCQ6vZ6fk/aWfNIasDjg/Ofa2245f+fhGamRaiVicM
         KeSZKZgGM3KIg==
Date:   Tue, 11 Jan 2022 19:24:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>
Subject: Re: [PATCH net 1/7] net: axienet: Reset core before accessing MAC
 and wait for core ready
Message-ID: <20220111192439.44fb795e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <b66ac3d0a3c544ca082eb5c8d25c72dc1ce8f451.camel@calian.com>
References: <20220111211358.2699350-1-robert.hancock@calian.com>
        <20220111211358.2699350-2-robert.hancock@calian.com>
        <b66ac3d0a3c544ca082eb5c8d25c72dc1ce8f451.camel@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jan 2022 00:30:33 +0000 Robert Hancock wrote:
> On Tue, 2022-01-11 at 15:13 -0600, Robert Hancock wrote:
> > In some cases where the Xilinx Ethernet core was used in 1000Base-X or
> > SGMII modes, which use the internal PCS/PMA PHY, and the MGT
> > transceiver clock source for the PCS was not running at the time the
> > FPGA logic was loaded, the core would come up in a state where the
> > PCS could not be found on the MDIO bus. To fix this, the Ethernet core
> > (including the PCS) should be reset after enabling the clocks, prior to
> > attempting to access the PCS using of_mdio_find_device.
> > 
> > Also, when resetting the device, wait for the PhyRstCmplt bit to be set
> > in the interrupt status register before continuing initialization, to
> > ensure that the core is actually ready. The MgtRdy bit could also be
> > waited for, but unfortunately when using 7-series devices, the bit does
> > not appear to work as documented (it seems to behave as some sort of
> > link state indication and not just an indication the transceiver is
> > ready) so it can't really be relied on.

Shouldn't these be two separate fixes?
