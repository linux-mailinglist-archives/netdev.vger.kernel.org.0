Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D643CA3AD
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 19:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbhGORQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 13:16:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231950AbhGORQq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 13:16:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37C48613DC;
        Thu, 15 Jul 2021 17:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626369233;
        bh=LCd49HWXy1jWbU+Ko+6zi8yExfbJ/VIy+k0XDmPhQ3M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=H1I8ENqvsSJ6+ZTKa+/ZHcLdnaPBI2NfbfDX8h829LHoBcoizROgLe5AD+TIEnlNJ
         pbLQgmEuknMGJ/kOI01SLTOOnYo5y871T2BXbz82qss45ayapjnMDYMd4Z13ZzptGY
         QhVGtNH8SzRWwFNVucUvPFqg0i+b/6VwpAFxV3kaI7GzBmTsvd2Wn/ZTeOqL/VOXAK
         wDzVGO0M4ArZDKmb/0fnpyLvkmm8djzfC18uhN9IBRoB3LWMTRR7HlNeyAFftuXqpe
         7TzG3PqU0eEA6MAi4Gr0zp2epSeRzWsPcRQpNqqBj9s6YVf5pcvAdq4sJaMgaqfpk1
         e5Ii0totcl19Q==
Date:   Thu, 15 Jul 2021 12:13:52 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "Billie Alsup (balsup)" <balsup@cisco.com>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Guohan Lu <lguohan@gmail.com>,
        "Madhava Reddy Siddareddygari (msiddare)" <msiddare@cisco.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sergey Miroshnichenko <s.miroshnichenko@yadro.com>
Subject: Re: [RFC][PATCH] PCI: Reserve address space for powered-off devices
 behind PCIe bridges
Message-ID: <20210715171352.GA1974727@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR11MB3527AEB1E4969C0833D1697ED9129@BYAPR11MB3527.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 15, 2021 at 04:52:26PM +0000, Billie Alsup (balsup) wrote:
> We are aware of how Cisco device specific this code is, and hadn't
> intended to upstream it.  This code was originally written for an
> older kernel version (4.8.28-WR9.0.0.26_cgl).  I am not the original
> author; I just ported it into various SONiC linux kernels.  We use
> ACPI with SONiC (although not on our non-SONiC products), so I
> thought I might be able to define such windows within the ACPI tree
> and have some generic code to read such configuration information
> from the ACPI tables,. However, initial attempts failed so I went
> with the existing approach.  I believe we did look at the hpmmiosize
> parameter, but iirc it applied to each bridge, rather than being a
> pool of address space to dynamically parcel out as necessary.

Right.  I mentioned "pci=resource_alignment=" because it claims to be
able to specify window sizes for specific bridges.  But I haven't
exercised that myself.

> There are multiple bridges involved in the hardware (there are 8
> hot-plug fabric cards, each with multiple PCI devices).  Devices on
> the card are in multiple power zones, so all devices are not
> immediately visible to the pci scanning code.  The top level bridge
> reserves close to 5G.  The 2nd level (towards the fabric cards)
> reserve 4.5G.  The 3rd level has 9 bridges each reserving 512M.  The
> 4th level reserves 384M (with a 512M alignment restriction iirc).
> The 5th level reserves 384M (again with an alignment restriction).
> That defines the bridge hierarchy visible at boot.  Things behind
> that 5th level are hot-plugged where there are two more bridge
> levels and 5 devices (1 requiring 2x64M blocks and 4 requiring
> 1x64M).
> 
> I'm not sure if the Cisco kernel team has revisited the hpmmiosize
> and resource_alignment parameters since this initial implementation.
> Reading the description of Sergey's patches, he seems to be
> approaching the same problem from a different direction.   It is
> unclear if such an approach is practical for our environment.   It
> would require updates to all of our SONiC drivers to support
> stopping/remapping/restarting, and it is unclear if that is
> acceptable.  It is certainly less preferable to pre-reserving the
> required space.  For our embedded product, we know exactly what
> devices will be plugged in, and allowing that to be pre-programmed
> into the PLX eeprom gives us the flexibility we need.  

If you know up front what devices are possible and how much space they
need, possibly your firmware could assign the bridge windows you need.
Linux generally does not change window assignments unless they are
broken.

Bjorn
