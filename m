Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B93E26E81F2
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 21:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbjDSTeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 15:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbjDSTeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 15:34:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F044C37;
        Wed, 19 Apr 2023 12:34:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 946B66387D;
        Wed, 19 Apr 2023 19:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B016FC433EF;
        Wed, 19 Apr 2023 19:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681932874;
        bh=D8f2TK4KWlcGU0rkl/iLAMhKKliIy6rzA32Y1nAl+Rk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=NyPtwHK/o+953FXF80P3Pc4FIIuW0dkMPH7jJbtaLTelB6xJLBWliqw567+XMeMq4
         YJ4LIAJ0EzJRlSlb2oI3Vr/n6Usxv99DY+d46DnX+IYWjFmXbBj0hYISrraT3usMzl
         0AB21BnLyt9l+IzFaVHLqPLYZa4PaWO68BI4ExYCOx/ooEbW+0Cjtj00WjHS1rqiaI
         lvElsNiiQeejDdh0rbulj9gY3fqeJP4EgvH9dPGQA0+CuLsHGbKu7MdqtU2oCsyACr
         peo3WnLOlnyMtU/LtfsaTL2XXJhF/uZsoWu/gJ/PLQIjfaY3r3i2qeQGGfxDsdSdFg
         nIdgdnoC+wywQ==
Date:   Wed, 19 Apr 2023 14:34:32 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Rob Herring <robh@kernel.org>,
        Donald Hunter <donald.hunter@gmail.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: Re: [BUG] net, pci: 6.3-rc1-4 hangs during boot on PowerEdge R620
 with igb
Message-ID: <20230419193432.GA220432@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZDawIXBd7gcA8DCk@smile.fi.intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 04:20:33PM +0300, Andy Shevchenko wrote:
> On Tue, Apr 11, 2023 at 02:02:03PM -0500, Rob Herring wrote:
> > On Tue, Apr 11, 2023 at 7:53 AM Donald Hunter <donald.hunter@gmail.com> wrote:
> > > Bjorn Helgaas <helgaas@kernel.org> writes:
> > > > On Mon, Apr 10, 2023 at 04:10:54PM +0100, Donald Hunter wrote:
> > > >> On Sun, 2 Apr 2023 at 23:55, Bjorn Helgaas <helgaas@kernel.org> wrote:
> > > >> > On Sat, Apr 01, 2023 at 01:52:25PM +0100, Donald Hunter wrote:
> > > >> > > On Fri, 31 Mar 2023 at 20:42, Bjorn Helgaas <helgaas@kernel.org> wrote:
> > > >> > > >
> > > >> > > > I assume this igb NIC (07:00.0) must be built-in (not a plug-in card)
> > > >> > > > because it apparently has an ACPI firmware node, and there's something
> > > >> > > > we don't expect about its status?
> > > >> > >
> > > >> > > Yes they are built-in, to my knowledge.
> > > >> > >
> > > >> > > > Hopefully Rob will look at this.  If I were looking, I would be
> > > >> > > > interested in acpidump to see what's in the DSDT.
> > > >> > >
> > > >> > > I can get an acpidump. Is there a preferred way to share the files, or just
> > > >> > > an email attachment?
> > > >> >
> > > >> > I think by default acpidump produces ASCII that can be directly
> > > >> > included in email.  http://vger.kernel.org/majordomo-info.html says
> > > >> > 100K is the limit for vger mailing lists.  Or you could open a report
> > > >> > at https://bugzilla.kernel.org and attach it there, maybe along with a
> > > >> > complete dmesg log and "sudo lspci -vv" output.
> > > >>
> > > >> Apologies for the delay, I was unable to access the machine while travelling.
> > > >>
> > > >> https://bugzilla.kernel.org/show_bug.cgi?id=217317
> > > >
> > > > Thanks for that!  Can you boot a kernel with 6fffbc7ae137 reverted
> > > > with this in the kernel parameters:
> > > >
> > > >   dyndbg="file drivers/acpi/* +p"
> > > >
> > > > and collect the entire dmesg log?
> > >
> > > Added to the bugzilla report.
> > 
> > Rafael, Andy, Any ideas why fwnode_device_is_available() would return
> > false for a built-in PCI device with a ACPI device entry? The only
> > thing I see in the log is it looks like the parent PCI bridge/bus
> > doesn't have ACPI device entry (based on "[    0.913389] pci_bus
> > 0000:07: No ACPI support"). For DT, if the parent doesn't have a node,
> > then the child can't. Not sure on ACPI.
> 
> Thanks for the Cc'ing. I haven't checked anything yet, but from the above it
> sounds like a BIOS issue. If PCI has no ACPI companion tree, then why the heck
> one of the devices has the entry? I'm not even sure this is allowed by ACPI
> specification, but as I said, I just solely used the above mail.

ACPI r6.5, sec 6.3.7, about _STA says:

  - Bit [0] - Set if the device is present.
  - Bit [1] - Set if the device is enabled and decoding its resources.
  - Bit [3] - Set if the device is functioning properly (cleared if
    device failed its diagnostics).

  ...

  If a device is present on an enumerable bus, then _STA must not
  return 0. In that case, bit[0] must be set and if the status of the
  device can be determined through a bus-specific enumeration and
  discovery mechanism, it must be reflected by the values of bit[1]
  and bit[3], even though the OSPM is not required to take them into
  account.

Since PCI *is* an enumerable bus, I don't think we can use _STA to
decide whether a PCI device is present.

We can use _STA to decide whether a host bridge is present, of course,
but that doesn't help here because the host bridge in question is
PNP0A08:00 that leads to [bus 00-3d], and it is present.

I don't know exactly what path led to the igb issue, but I don't think
we need to figure that out.  I think we just need to avoid the use of
_STA in fwnode_device_is_available().

6fffbc7ae137 ("PCI: Honor firmware's device disabled status") appeared
in v6.3-rc1, so I think we need to revert or fix it before v6.3, which
will probably be tagged Sunday (and I'll be on vacation
Friday-Monday).

Bjorn
