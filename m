Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF7E6D28C5
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 21:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbjCaTmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 15:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjCaTmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 15:42:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428202031B;
        Fri, 31 Mar 2023 12:42:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D499362B67;
        Fri, 31 Mar 2023 19:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA064C433EF;
        Fri, 31 Mar 2023 19:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680291771;
        bh=+VZN0j3v/ylWV/uoCISfmTaQaNwAwDVklUS1334gqp8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=X37wnkcGseQvwKvC9anGAwFulTmpLpWtEh3o8C7yzNyO2iUEAFwl3NyMap9h7wKQr
         W3q0eufOfEux5WkncQgZQhtTbXzcv6e+QawkRfRQvythmdqv4JIuqu6tUQtwjm77cc
         4U+KbQZbIHNh36/Oz4vmPQWbHg16wMsvY3aJhUQNk5LR1dW9nNg8FSVz2JOmPt/t6e
         RKFTIl8dPN74ojkMqnT1n3O51Wku4iBtfHKPpM8UZX31lU1wJPFzNVcHfdvNud5Pp9
         oJy0VZLOh/dJqjSh5X2N/aCqXXek5uDTvcYMEF5y9TRIGP4tbrzC05lhfbwyb+Vh8Y
         PsH/qKcEHWgcw==
Date:   Fri, 31 Mar 2023 14:42:49 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Donald Hunter <donald.hunter@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: Re: [BUG] net, pci: 6.3-rc1-4 hangs during boot on PowerEdge R620
 with igb
Message-ID: <20230331194249.GA3247600@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2fs9lgndw.fsf@gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks a lot for the report and for all the work you did to bisect and
identify the commit.

On Fri, Mar 31, 2023 at 12:40:11PM +0100, Donald Hunter wrote:
> The 6.3-rc1 and later release candidates are hanging during boot on our
> Dell PowerEdge R620 servers with Intel I350 nics (igb).
> 
> After bisecting from v6.2 to v6.3-rc1, I isolated the problem to:
> 
> [6fffbc7ae1373e10b989afe23a9eeb9c49fe15c3] PCI: Honor firmware's device
> disabled status
> 
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 1779582fb500..b1d80c1d7a69 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1841,6 +1841,8 @@ int pci_setup_device(struct pci_dev *dev)
>  
>         pci_set_of_node(dev);
>         pci_set_acpi_fwnode(dev);
> +       if (dev->dev.fwnode && !fwnode_device_is_available(dev->dev.fwnode))
> +               return -ENODEV;
>  
>         pci_dev_assign_slot(dev);

I assume this igb NIC (07:00.0) must be built-in (not a plug-in card)
because it apparently has an ACPI firmware node, and there's something
we don't expect about its status?

Hopefully Rob will look at this.  If I were looking, I would be
interested in acpidump to see what's in the DSDT.

Bjorn
