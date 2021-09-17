Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 134D6410126
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 00:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245257AbhIQWLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 18:11:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241373AbhIQWLH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 18:11:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D97D600AA;
        Fri, 17 Sep 2021 22:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631916584;
        bh=ZM7Na8U3vOF7yWD0hHYTsHYmKYrXSM2eJEAiYZBqg3o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=n5NV0edwutIgg6fIxfvpIdAUG+s7U28E6gj3LmYnaikmacVcRb4MldCL0+geWdKeE
         CSYO3k7WkUq7O5bTaNk1YRRL9g/Bjdt5hyu6XQr+Mh68syjCUBnBY9QQieQ+FA+cpX
         hi8DL8SrI+oCa9MtHzmDt1YZe7a3nGHhQAfRM2OX7szdhDfEHh0A87PZjZ4DVbHZyF
         FCiAMiwYC6JQ4VtbEAzxqZX9kpV70BDny17P0Er+1OoUVTaz7xbCLk+Xnq9mf+JzQ1
         fqvNfmcF4aFRX6uJYSx7XXmpSrijThEE9yAVkv/qtq96U3VyuesAXfHZSOKvO/bCia
         MyvmpRZ7jckvA==
Date:   Fri, 17 Sep 2021 17:09:42 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com,
        davem@davemloft.net, kuba@kernel.org, anthony.wong@canonical.com,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH net-next v5 0/3] r8169: Implement dynamic ASPM
 mechanism for recent 1.0/2.5Gbps Realtek NICs
Message-ID: <20210917220942.GA1748301@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916154417.664323-1-kai.heng.feng@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 16, 2021 at 11:44:14PM +0800, Kai-Heng Feng wrote:
> The purpose of the series is to get comments and reviews so we can merge
> and test the series in downstream kernel.
> 
> The latest Realtek vendor driver and its Windows driver implements a
> feature called "dynamic ASPM" which can improve performance on it's
> ethernet NICs.
> 
> Heiner Kallweit pointed out the potential root cause can be that the
> buffer is too small for its ASPM exit latency.

I looked at the lspci data in your bugzilla
(https://bugzilla.kernel.org/show_bug.cgi?id=214307).

L1.2 is enabled, which requires the Latency Tolerance Reporting
capability, which helps determine when the Link will be put in L1.2.
IIUC, these are analogous to the DevCap "Acceptable Latency" values.
Zero latency values indicate the device will be impacted by any delay
(PCIe r5.0, sec 6.18).

Linux does not currently program those values, so the values there
must have been set by the BIOS.  On the working AMD system, they're
set to 1048576ns, while on the broken Intel system, they're set to
3145728ns.

I don't really understand how these values should be computed, and I
think they depend on some electrical characteristics of the Link, so
I'm not sure it's *necessarily* a problem that they are different.
But a 3X difference does seem pretty large.

So I'm curious whether this is related to the problem.  Here are some
things we could try on the broken Intel system:

  - What happens if you disable ASPM L1.2 using
    /sys/devices/pci*/.../link/l1_2_aspm?

  - If that doesn't work, what happens if you also disable PCI-PM L1.2
    using /sys/devices/pci*/.../link/l1_2_pcipm?

  - If either of the above makes things work, then at least we know
    the problem is sensitive to L1.2.

  - Then what happens if you use setpci to set the LTR Latency
    registers to 0, then re-enable ASPM L1.2 and PCI-PM L1.2?  This
    should mean the Realtek device wants the best possible service and
    the Link probably won't spend much time in L1.2.

  - What happens if you set the LTR Latency registers to 0x1001
    (should be the same as on the AMD system)?
