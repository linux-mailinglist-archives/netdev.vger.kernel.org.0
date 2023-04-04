Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4754D6D69EB
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 19:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235710AbjDDRJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 13:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235609AbjDDRJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 13:09:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAEC4C7;
        Tue,  4 Apr 2023 10:09:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16B3B63773;
        Tue,  4 Apr 2023 17:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF4AC433EF;
        Tue,  4 Apr 2023 17:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680628194;
        bh=IK2aCtlyClHSVX99J78ji0/3Kc8IkYOR0+e5e+EQq78=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=mjj5gN61RWvx3kW5BWospMkZcjO4aXYE6MfG53S9AmWfQyUuUSxSUIv4JTuZQPVC6
         EIHzT14n1+NADzeeF1IpjZoYiX69W9D9R/mJDsBeuw7C5mo108RL/VfOh0CyNf4p6v
         5xqAGutCYR6U6D64ChpMiTbg36lDwMCHWuOG7tohRURPS/KpwaXDfoD0B2nKGgUu07
         iME1EHpbAriJV0fbYU9lnEfWg3wTpaOIz/fU6xOqsvOyXC4tnkrSJT/chG3Wwf/9ll
         anmzBdavCLnQNeq8zJOTBtNNOtp8ElVHpt0DojmIGL9GRJOsNeozAk/R0bhRtExqZ9
         PhkiUtuRXoXEQ==
Date:   Tue, 4 Apr 2023 12:09:52 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Ben Greear <greearb@candelatech.com>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        bjorn@helgaas.com, LKML <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Stefan Roese <sr@denx.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bharat Kumar Gogada <bharat.kumar.gogada@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Yao Hongbo <yaohongbo@linux.alibaba.com>,
        Naveen Naidu <naveennaidu479@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        Gregory Greenman <gregory.greenman@intel.com>,
        Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 5.4 182/389] PCI/portdrv: Dont disable AER reporting in
 get_port_device_capability()
Message-ID: <20230404170952.GA3559293@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ff1397e-1d78-bc59-f577-e69024c4c4f3@candelatech.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 03:31:40PM -0700, Ben Greear wrote:
> On 3/31/23 15:06, Bjorn Helgaas wrote:
> > [+cc iwlwifi folks]
> > 
> > Re: 8795e182b02d ("PCI/portdrv: Don't disable AER reporting in
> > get_port_device_capability()")
> > 
> > On Wed, Mar 29, 2023 at 04:17:29PM -0700, Ben Greear wrote:
> > > On 8/30/22 3:16 PM, Ben Greear wrote:
> > > ...
> > 
> > > I notice this patch appears to be in 6.2.6 kernel, and my kernel logs are
> > > full of spam and system is unstable.  Possibly the unstable part is related
> > > to something else, but the log spam is definitely extreme.
> > > 
> > > These systems are fairly stable on 5.19-ish kernels without the patch in
> > > question.
> > 
> > Hmmm, I was going to thank you for the report, but looking closer, I
> > see that you reported this last August [1] and we *should* have
> > pursued it with the iwlwifi folks or figured out what the PCI core is
> > doing wrong, but I totally dropped the ball.  Sorry about that.
> > 
> > To make sure we're all on the same page, we're talking about
> > 8795e182b02d ("PCI/portdrv: Don't disable AER reporting in
> > get_port_device_capability()") [2],
> > which is present in v6.0 and later [3] but not v5.19.16 [4].
> 
> Yes, though I manually tried reverting that patch, and problem
> persisted, so maybe some secondary patch still enables whatever
> causes the issue.
> 
> Booting with pci=noaer 'fixes' the problem for me, that is what I am
> running currently.
> 
> > > Here is sample of the spam:
> > > 
> > > [ 1675.547023] pcieport 0000:03:02.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
> > > [ 1675.556851] pcieport 0000:03:02.0:   device [10b5:8619] error status/mask=00100000/00000000
> > > [ 1675.563904] pcieport 0000:03:02.0:    [20] UnsupReq               (First)
> > > [ 1675.569398] pcieport 0000:03:02.0: AER:   TLP Header: 34000000 05001f10 00000000 88c888c8
> > > [ 1675.576296] iwlwifi 0000:05:00.0: AER: can't recover (no error_detected callback)
> > 
> > The TLP header says this is an LTR message from 05:00.0.  Apparently
> > the bridge above 05:00.0 is 03:02.0, which logged an Unsupported
> > Request error for the message, probably because 03:02.0 doesn't have
> > LTR enabled.

> Here is lspci, and please note that I am using a pcie -> 12x m.2
> adapter board, which is not common in the world.  Possibly it is
> causing some of the problems with the AER logic (though, it is
> stable in 5.19 and lower.  And a similar system with 2 of these
> adapter boards filled with 24 mtk7922 radios does not show the AER
> warnings or instability problems so far.)
> 
> The lspci below is from a system with 12 ax210 radios, I have
> another with 24, it shows similar problems.

Interesting config.  Somebody is definitely doing something wrong.
LTR is enabled at 00:1c.0 (which is fine), not supported and disabled
at 02:00.0 and 03:02.0 (also fine), but *enabled* at 05:00.0, which is
absolutely not fine because 03:02.0 won't know what to do with the LTR
messages and would log the AER errors you're seeing.

> 00:1c.0 PCI bridge: Intel Corporation 100 Series/C230 Series Chipset Family PCI Express Root Port #1 (rev f1) (prog-if 00 [Normal decode])
> 	Bus: primary=00, secondary=02, subordinate=0f, sec-latency=0
> 		DevCap2: Completion Timeout: Range ABC, TimeoutDis+, LTR+, OBFF Not Supported ARIFwd+
> 			 AtomicOpsCap: Routing- 32bit- 64bit- 128bitCAS-
> 		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, OBFF Disabled ARIFwd-

> 02:00.0 PCI bridge: PLX Technology, Inc. PEX 8619 16-lane, 16-Port PCI Express Gen 2 (5.0 GT/s) Switch with DMA (rev ba) (prog-if 00 [Normal decode])
> 	Bus: primary=02, secondary=03, subordinate=0f, sec-latency=0

> 		DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF Not Supported
> 			 AtomicOpsCap: Routing- 32bit- 64bit- 128bitCAS-
> 		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled

> 03:02.0 PCI bridge: PLX Technology, Inc. PEX 8619 16-lane, 16-Port PCI Express Gen 2 (5.0 GT/s) Switch with DMA (rev ba) (prog-if 00 [Normal decode])
> 	Bus: primary=03, secondary=05, subordinate=05, sec-latency=0

> 		DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF Not Supported ARIFwd+
> 			 AtomicOpsCap: Routing-
> 		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled ARIFwd-

> 05:00.0 Network controller: Intel Corporation Device 2725 (rev 1a)
> 		DevCap2: Completion Timeout: Range B, TimeoutDis+, LTR+, OBFF Via WAKE#
> 			 AtomicOpsCap: 32bit- 64bit- 128bitCAS-
> 		DevCtl2: Completion Timeout: 16ms to 55ms, TimeoutDis-, LTR+, OBFF Disabled
> 			 AtomicOpsCtl: ReqEn-

For 02:00.0 and 03:02.0, pci_configure_ltr() should bail out as soon
as it sees they don't support PCI_EXP_DEVCAP2_LTR, so they should
never have dev->ltr_path set.  And pci_configure_ltr() should not set
PCI_EXP_DEVCTL2_LTR_EN for 05:00.0 since bridge->ltr_path is not set
for 03:02.0.

Can you collect the dmesg log when booted with "pci=earlydump"?  I
wonder if BIOS could be enabling LTR on 05:00.0.

Bjorn
