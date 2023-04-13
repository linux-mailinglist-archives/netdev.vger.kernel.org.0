Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B69756E0B9F
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 12:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjDMKni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 06:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjDMKng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 06:43:36 -0400
X-Greylist: delayed 600 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 13 Apr 2023 03:43:34 PDT
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [176.9.242.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7270CE4A;
        Thu, 13 Apr 2023 03:43:33 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL Global TLS RSA4096 SHA256 2022 CA1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id 8CCC0100E4193;
        Thu, 13 Apr 2023 12:26:36 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 6BAD5382E3; Thu, 13 Apr 2023 12:26:36 +0200 (CEST)
Date:   Thu, 13 Apr 2023 12:26:36 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Amit Cohen <amcohen@nvidia.com>, mlxsw@nvidia.com,
        linux-pci@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH net-next 6/6] mlxsw: pci: Add support for new reset flow
Message-ID: <20230413102636.GA18500@wunner.de>
References: <ZCBOdunTNYsufhcn@shredder>
 <20230329160144.GA2967030@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329160144.GA2967030@bhelgaas>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 11:01:44AM -0500, Bjorn Helgaas wrote:
> On Sun, Mar 26, 2023 at 04:53:58PM +0300, Ido Schimmel wrote:
> > On Thu, Mar 23, 2023 at 11:51:15AM -0500, Bjorn Helgaas wrote:
> > > So the first question is why you don't simply use
> > > pci_reset_function(), since it is supposed to cause a reset and do all
> > > the necessary waiting for the device to be ready.

I agree, this driver should use one of the reset helpers provided
by the PCI core.

Not least because if the Downstream Port is hotplug-capable,
fiddling with the Link Disable bit behind the hotplug driver's back
will cause unbinding and rebinding of the device.

> > __pci_reset_function_locked() is another option, but it assumes the
> > device lock was already taken, which is correct during probe, but not
> > when reset is performed as part of devlink reload.

Just call pci_dev_lock() in the devlink reload code path.

> Hmmm, pci_pm_reset() puts the device in D3hot, then back to D0.  Spec
> says that results in "undefined internal Function state," which
> doesn't even sound like a guaranteed reset, but it's what we have, and
> in any case, it does not disable the link.

Per PCIe r6.0.1 sec 5.8, the device undergoes a Soft Reset when moving
from D3hot to D0 (unless the No_Soft_Reset bit is set in the Power
Management Control/Status Register, sec 7.5.2.2).

The driver can set the PCI_DEV_FLAGS_NO_PM_RESET flag if this reset method
doesn't have any effect (via quirk_no_pm_reset()).

We could also discuss moving pci_pm_reset after pci_reset_bus_function
in pci_reset_fn_methods[] if this reset method has little value on the
majority of devices.

Alternatively, if Secondary Bus Reset has the intended effect, the driver
could invoke that directly via pci_reset_bus().

> Spec (PCIe r6.0, sec 6.6.1) says "Disabling a Link causes Downstream
> components to undergo a hot reset."  That seems like it *could* be a
> general-purpose method of doing a reset, and I don't know why the PCI
> core doesn't support it.  Added Alex and Lukas in case they know.

Sounds reasonable to me.

Thanks,

Lukas
