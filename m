Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C46A6E9857
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 17:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbjDTPc4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 20 Apr 2023 11:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbjDTPcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 11:32:54 -0400
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DABB1736;
        Thu, 20 Apr 2023 08:32:53 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-94ea38c90ccso26376966b.1;
        Thu, 20 Apr 2023 08:32:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682004771; x=1684596771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mrbfS9qzAxsg7Mxmkhy5II3bga2P8KO4swtn5KuXyG0=;
        b=TlMP3bcXxxzTa1z+DfVAg1mqaQr7IS1hhd6hY9R6Vy2ecHTFd32yH+uhtupfN24fVn
         SBxV4gatEkhNO/kWqDBwBBS5AECalqhyjxqxinbNab1d6R0aKuxWOsSr6Y1zIzndxzAM
         ckypduQxnjB1r4esT2fFjpONh1VvuVziKOsXL2/zlApaUZPAKobEz95wo9NvhKVPPhW6
         XodA/CR9tyMFw3NDbV2LCnwtH43+E/orf9bL3NQyl4rdgDm/XHgs4ybNQ5PE8zFP+1y1
         VVXIWFnkmIqwP0IA5NgVJsfe6ZZ/dqzHuQZfF8Xgqo58wY5a876zlDrcBByr3hptBJmG
         7G1Q==
X-Gm-Message-State: AAQBX9eLrqcieB1LMurVwLKOObbk5Wu9CB9fO8TNikKDimnTJznkoFNM
        ko1K5lJCR0TdVrmqNxNmwKJ/1WHkLNvJdp7CRq0=
X-Google-Smtp-Source: AKy350Yp5p3Ap4k0cXbpLtdUdBH0oPAfDQGOUBN5Ag0FOx1IxezOJl4tNjCHJh/vRgVV5aucOQ/D3YCwgLgctxjR6+Q=
X-Received: by 2002:a17:906:54d:b0:94e:dbce:69fe with SMTP id
 k13-20020a170906054d00b0094edbce69femr1914715eja.2.1682004771101; Thu, 20 Apr
 2023 08:32:51 -0700 (PDT)
MIME-Version: 1.0
References: <ZDawIXBd7gcA8DCk@smile.fi.intel.com> <20230419193432.GA220432@bhelgaas>
In-Reply-To: <20230419193432.GA220432@bhelgaas>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 20 Apr 2023 17:32:39 +0200
Message-ID: <CAJZ5v0ir_SQgs=4_tdjbdrF0vnM5=6dQKw-Y=LxTyCAW2kZuhQ@mail.gmail.com>
Subject: Re: [BUG] net, pci: 6.3-rc1-4 hangs during boot on PowerEdge R620
 with igb
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rob Herring <robh@kernel.org>,
        Donald Hunter <donald.hunter@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 9:34 PM Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> On Wed, Apr 12, 2023 at 04:20:33PM +0300, Andy Shevchenko wrote:
> > On Tue, Apr 11, 2023 at 02:02:03PM -0500, Rob Herring wrote:
> > > On Tue, Apr 11, 2023 at 7:53 AM Donald Hunter <donald.hunter@gmail.com> wrote:
> > > > Bjorn Helgaas <helgaas@kernel.org> writes:
> > > > > On Mon, Apr 10, 2023 at 04:10:54PM +0100, Donald Hunter wrote:
> > > > >> On Sun, 2 Apr 2023 at 23:55, Bjorn Helgaas <helgaas@kernel.org> wrote:
> > > > >> > On Sat, Apr 01, 2023 at 01:52:25PM +0100, Donald Hunter wrote:
> > > > >> > > On Fri, 31 Mar 2023 at 20:42, Bjorn Helgaas <helgaas@kernel.org> wrote:
> > > > >> > > >
> > > > >> > > > I assume this igb NIC (07:00.0) must be built-in (not a plug-in card)
> > > > >> > > > because it apparently has an ACPI firmware node, and there's something
> > > > >> > > > we don't expect about its status?
> > > > >> > >
> > > > >> > > Yes they are built-in, to my knowledge.
> > > > >> > >
> > > > >> > > > Hopefully Rob will look at this.  If I were looking, I would be
> > > > >> > > > interested in acpidump to see what's in the DSDT.
> > > > >> > >
> > > > >> > > I can get an acpidump. Is there a preferred way to share the files, or just
> > > > >> > > an email attachment?
> > > > >> >
> > > > >> > I think by default acpidump produces ASCII that can be directly
> > > > >> > included in email.  http://vger.kernel.org/majordomo-info.html says
> > > > >> > 100K is the limit for vger mailing lists.  Or you could open a report
> > > > >> > at https://bugzilla.kernel.org and attach it there, maybe along with a
> > > > >> > complete dmesg log and "sudo lspci -vv" output.
> > > > >>
> > > > >> Apologies for the delay, I was unable to access the machine while travelling.
> > > > >>
> > > > >> https://bugzilla.kernel.org/show_bug.cgi?id=217317
> > > > >
> > > > > Thanks for that!  Can you boot a kernel with 6fffbc7ae137 reverted
> > > > > with this in the kernel parameters:
> > > > >
> > > > >   dyndbg="file drivers/acpi/* +p"
> > > > >
> > > > > and collect the entire dmesg log?
> > > >
> > > > Added to the bugzilla report.
> > >
> > > Rafael, Andy, Any ideas why fwnode_device_is_available() would return
> > > false for a built-in PCI device with a ACPI device entry? The only
> > > thing I see in the log is it looks like the parent PCI bridge/bus
> > > doesn't have ACPI device entry (based on "[    0.913389] pci_bus
> > > 0000:07: No ACPI support"). For DT, if the parent doesn't have a node,
> > > then the child can't. Not sure on ACPI.
> >
> > Thanks for the Cc'ing. I haven't checked anything yet, but from the above it
> > sounds like a BIOS issue. If PCI has no ACPI companion tree, then why the heck
> > one of the devices has the entry? I'm not even sure this is allowed by ACPI
> > specification, but as I said, I just solely used the above mail.
>
> ACPI r6.5, sec 6.3.7, about _STA says:
>
>   - Bit [0] - Set if the device is present.
>   - Bit [1] - Set if the device is enabled and decoding its resources.
>   - Bit [3] - Set if the device is functioning properly (cleared if
>     device failed its diagnostics).
>
>   ...
>
>   If a device is present on an enumerable bus, then _STA must not
>   return 0. In that case, bit[0] must be set and if the status of the
>   device can be determined through a bus-specific enumeration and
>   discovery mechanism, it must be reflected by the values of bit[1]
>   and bit[3], even though the OSPM is not required to take them into
>   account.
>
> Since PCI *is* an enumerable bus, I don't think we can use _STA to
> decide whether a PCI device is present.

You are right, _STA can't be used for that.

> We can use _STA to decide whether a host bridge is present, of course,
> but that doesn't help here because the host bridge in question is
> PNP0A08:00 that leads to [bus 00-3d], and it is present.
>
> I don't know exactly what path led to the igb issue, but I don't think
> we need to figure that out.  I think we just need to avoid the use of
> _STA in fwnode_device_is_available().

I agree.  It is incorrect.

> 6fffbc7ae137 ("PCI: Honor firmware's device disabled status") appeared
> in v6.3-rc1, so I think we need to revert or fix it before v6.3, which
> will probably be tagged Sunday (and I'll be on vacation
> Friday-Monday).

Yes, please revert this one ASAP.

Cheers,
Rafael
