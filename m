Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8452E6D2AE6
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 00:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbjCaWGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 18:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbjCaWGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 18:06:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4870120619;
        Fri, 31 Mar 2023 15:06:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE963B8326D;
        Fri, 31 Mar 2023 22:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6514CC433EF;
        Fri, 31 Mar 2023 22:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680300392;
        bh=KDwb7fsPK92TjAEvcMkgy5oGXqF/5crJUrOmoCb1hGg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=DrkfUMZEdL6QXbLjIa3FesA4KT10pvoubz+MJ5JNG3zqmmKrqCJDxlsBQzbDKqbUI
         ll0J9u3Cg1tN8yvtGpwXmLPNY+u1kwEmZ0Uxcg5v1pesVLcZpNEKIiqgTXhKqv2deg
         pR+bhQ9FS5SM0ELO+JrghoDYwKfkwD9Ycd+TpcxKpOIWFNaxiaVhTR36YraLQdUZSX
         SZkgWy4RtOjZ7AceevQirL7ZOq1nfCEQfg0pZzSbb/kazQiELMMoR1kS9FGQfhlw+O
         Jp9ICZ59qZaju3KXgG7Pj4n3pFMoMONzyn+Az13HvYmacNh9/S++OPC+PK8TIsgYKT
         FPHMaINrjhtaA==
Date:   Fri, 31 Mar 2023 17:06:30 -0500
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
Message-ID: <20230331220630.GA3151299@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9dfa04c4-e0cc-f265-5935-254f43db931b@candelatech.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+cc iwlwifi folks]

Re: 8795e182b02d ("PCI/portdrv: Don't disable AER reporting in
get_port_device_capability()")

On Wed, Mar 29, 2023 at 04:17:29PM -0700, Ben Greear wrote:
> On 8/30/22 3:16 PM, Ben Greear wrote:
> ...

> I notice this patch appears to be in 6.2.6 kernel, and my kernel logs are
> full of spam and system is unstable.  Possibly the unstable part is related
> to something else, but the log spam is definitely extreme.
> 
> These systems are fairly stable on 5.19-ish kernels without the patch in
> question.

Hmmm, I was going to thank you for the report, but looking closer, I
see that you reported this last August [1] and we *should* have
pursued it with the iwlwifi folks or figured out what the PCI core is
doing wrong, but I totally dropped the ball.  Sorry about that.

To make sure we're all on the same page, we're talking about
8795e182b02d ("PCI/portdrv: Don't disable AER reporting in
get_port_device_capability()") [2],
which is present in v6.0 and later [3] but not v5.19.16 [4].

> Here is sample of the spam:
> 
> [ 1675.547023] pcieport 0000:03:02.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
> [ 1675.556851] pcieport 0000:03:02.0:   device [10b5:8619] error status/mask=00100000/00000000
> [ 1675.563904] pcieport 0000:03:02.0:    [20] UnsupReq               (First)
> [ 1675.569398] pcieport 0000:03:02.0: AER:   TLP Header: 34000000 05001f10 00000000 88c888c8
> [ 1675.576296] iwlwifi 0000:05:00.0: AER: can't recover (no error_detected callback)

The TLP header says this is an LTR message from 05:00.0.  Apparently
the bridge above 05:00.0 is 03:02.0, which logged an Unsupported
Request error for the message, probably because 03:02.0 doesn't have
LTR enabled.

Can you collect the output of "sudo lspci -vv"?  Does this happen even
before loading the iwlwifi driver?  I assume there are no hotplug
events before this happens?

The PCI core enables LTR during enumeration for every device for which
LTR is supported and enabled along the entire path up to a Root Port.
If it does that wrong, you might see errors even before loading
iwlwifi.

I see that iwlwifi *reads* PCI_EXP_DEVCTL2_LTR_EN in
iwl_pcie_apm_config(), which should be safe.  I don't see any writes,
but the iwlwifi experts should know more about this.  There are a
couple paths that do this, which looks somehow related:

  __iwl_mvm_mac_start
    iwl_mvm_up
      iwl_mvm_config_ltr
        if (trans->ltr_enabled)
          iwl_mvm_send_cmd_pdu(mvm, LTR_CONFIG, ...)

Bjorn

[1] https://lore.kernel.org/all/47b775c5-57fa-5edf-b59e-8a9041ffbee7@candelatech.com/#t
[2] https://git.kernel.org/linus/8795e182b02d
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/pci/pcie/portdrv_core.c?id=v6.0#n223
[4] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/drivers/pci/pcie/portdrv_core.c?id=v5.19.16#n223
