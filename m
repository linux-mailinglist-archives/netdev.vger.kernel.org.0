Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB15D6E110F
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 17:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbjDMP0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 11:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbjDMP0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 11:26:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B528AF07;
        Thu, 13 Apr 2023 08:26:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4AFB63FB0;
        Thu, 13 Apr 2023 15:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD3DC433EF;
        Thu, 13 Apr 2023 15:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681399565;
        bh=4rCPUSm6VmhEAgS4WfxEJhJ62K0DKaZE9EJ5KAwvmdQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jd9ta6EaUQ9qLfS1lMNL75WdiT1WmkRD9m05rCf9rsvx7P3WHEnu8sleYePix+5xf
         gO5e1USkgFCUx5s6wNuSWN4Uu/1RqlAhUvlns6ejB9ARJuvUlXgNkHlqv7nFVWgIYp
         hND/+vG+cDNF1atAl1aZys19unsvjEfjjVoVNlR4tEZSDwA0km+jEvGHsGrjmgfOTI
         yWR0Vx47ZDZngthMDuw5yGGGEz3oQ6nLSYCE72LhF6LySfRsDjT+JsjKUfIDU1NLvo
         PWbPCojqz9mKPVRpV8EmlUjLvMAKqEEFysfVpiAl16yr1HJyPeQD+7dRyWXO3UmxGk
         Iz0LnDZSaOW/A==
Date:   Thu, 13 Apr 2023 08:26:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Amit Cohen <amcohen@nvidia.com>, mlxsw@nvidia.com,
        linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH net-next 6/6] mlxsw: pci: Add support for new reset flow
Message-ID: <20230413082603.2550dd6f@kernel.org>
In-Reply-To: <ZDe5DrHY6JjlDpOY@shredder>
References: <ZCBOdunTNYsufhcn@shredder>
        <20230329160144.GA2967030@bhelgaas>
        <20230329111001.44a8c8e0.alex.williamson@redhat.com>
        <ZCVHtk/wqTAR4Ejd@shredder>
        <20230330124958.15a34c3d.alex.williamson@redhat.com>
        <ZDe5DrHY6JjlDpOY@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Apr 2023 11:10:54 +0300 Ido Schimmel wrote:
> I believe we are discussing three different issues:
> 
> 1. Reset by PCI core when driver is bound to the device.
> 2. Reset by PCI core when driver is not bound to the device.
> 3. Reset by the driver itself during probe / devlink reload.
> 
> These are my notes on each:
> 
> 1. In this case, the reset_prepare() and reset_done() handlers of the
> driver are invoked by the PCI core before and after the PCI reset.
> Without them, if the used PCI reset method indeed reset the entire
> device, then the driver and the device would be out of sync. I have
> implemented these handlers for the driver:
> https://github.com/idosch/linux/commit/28bc0dc06c01559c19331578bbba9f2b0460ab5d.patch
> 
> 2. In this case, the handlers are not available and we only need to
> ensure that the used PCI reset method reset the device. The method can
> be a generic method such as "pm" or "bus" (which are available in my
> case) or a "device_specific" method that is implemented in
> drivers/pci/quirks.c by accessing the configuration space of the device.
> 
> I need to check if one of the generic methods works for this device and
> if not, check with the PCI team what we can do about it.
> 
> 3. In this case, the driver already issues a reset via its command
> interface during probe / devlink reload to ensure it is working with a
> device in a clean state. The patch we are discussing merely adds another
> reset method. Instead of starting the reset when the command is issued,
> the reset will start after toggling the link on the downstream port.
> 
> To summarize, I would like to proceed as follows:
> 
> 1. Submit the following patch that implements the PCI reset handlers for
> the device:
> https://github.com/idosch/linux/commit/28bc0dc06c01559c19331578bbba9f2b0460ab5d.patch

I'm probably confused but does this mean that PCI reset would impact
the datapath? From the commit message it sounded like the new reset
is harder than the previous one.
