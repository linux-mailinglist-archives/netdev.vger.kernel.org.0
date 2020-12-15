Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9CF32DA4FE
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 01:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgLOAkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 19:40:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:33430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725806AbgLOAkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 19:40:47 -0500
Date:   Mon, 14 Dec 2020 18:40:04 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607992806;
        bh=vYzB5Bh2gjJmR+HAPUYeomnVTXQmhB/jJBx2y7DbXeo=;
        h=From:To:Cc:Subject:In-Reply-To:From;
        b=jQUvwXxYDu5SKP/A+dyoyRW29wX3IPVvnREKIErgNy6/qIXo0xiuPh8rgU+m8KLG4
         UWVqN6qXpxRzznGDBbh+3JBeGmE94kSgBPP0Dv6a1TZZb8pPu9y3Ifx7ZzXLnd2USd
         LkEyvCWm5TWIdi/Hj5kKweAB8GrnrZneVo7sbCuaiUo86LmlKfrHiZDdlPHzHcTA4j
         VNx2qMtwvXp8sH5MgK6u1ZjUGU11lLZW8rOkefVgwi+4maFkHTurVkGlrpeo4ZSAkk
         G1Cl9CEy01MXqdQpYMdo2jGWDb1lCZsV7e2Zkbe+LYBDt+SRflUv3rgBfEs60JbIe3
         +VfBXq4Zo0dhQ==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Ian Kumlien <ian.kumlien@gmail.com>
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        "Saheed O. Bolarinwa" <refactormyself@gmail.com>,
        Puranjay Mohan <puranjay12@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] PCI/ASPM: Use the path max in L1 ASPM latency check
Message-ID: <20201215004004.GA280628@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA85sZs8Li7+8BQWj0e+Qrxes1VF6K_Ukqrqgs1E3hHmaXqsbQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 11:56:31PM +0100, Ian Kumlien wrote:
> On Mon, Dec 14, 2020 at 8:19 PM Bjorn Helgaas <helgaas@kernel.org> wrote:

> > If you're interested, you could probably unload the Realtek drivers,
> > remove the devices, and set the PCI_EXP_LNKCTL_LD (Link Disable) bit
> > in 02:04.0, e.g.,
> >
> >   # RT=/sys/devices/pci0000:00/0000:00:01.2/0000:01:00.0/0000:02:04.0
> >   # echo 1 > $RT/0000:04:00.0/remove
> >   # echo 1 > $RT/0000:04:00.1/remove
> >   # echo 1 > $RT/0000:04:00.2/remove
> >   # echo 1 > $RT/0000:04:00.4/remove
> >   # echo 1 > $RT/0000:04:00.7/remove
> >   # setpci -s02:04.0 CAP_EXP+0x10.w=0x0010
> >
> > That should take 04:00.x out of the picture.
> 
> Didn't actually change the behaviour, I'm suspecting an errata for AMD pcie...
> 
> So did this, with unpatched kernel:
> [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> [  5]   0.00-1.00   sec  4.56 MBytes  38.2 Mbits/sec    0   67.9 KBytes
> [  5]   1.00-2.00   sec  4.47 MBytes  37.5 Mbits/sec    0   96.2 KBytes
> [  5]   2.00-3.00   sec  4.85 MBytes  40.7 Mbits/sec    0   50.9 KBytes
> [  5]   3.00-4.00   sec  4.23 MBytes  35.4 Mbits/sec    0   70.7 KBytes
> [  5]   4.00-5.00   sec  4.23 MBytes  35.4 Mbits/sec    0   48.1 KBytes
> [  5]   5.00-6.00   sec  4.23 MBytes  35.4 Mbits/sec    0   45.2 KBytes
> [  5]   6.00-7.00   sec  4.23 MBytes  35.4 Mbits/sec    0   36.8 KBytes
> [  5]   7.00-8.00   sec  3.98 MBytes  33.4 Mbits/sec    0   36.8 KBytes
> [  5]   8.00-9.00   sec  4.23 MBytes  35.4 Mbits/sec    0   36.8 KBytes
> [  5]   9.00-10.00  sec  4.23 MBytes  35.4 Mbits/sec    0   48.1 KBytes
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.00  sec  43.2 MBytes  36.2 Mbits/sec    0             sender
> [  5]   0.00-10.00  sec  42.7 MBytes  35.8 Mbits/sec                  receiver
> 
> and:
> echo 0 > /sys/devices/pci0000:00/0000:00:01.2/0000:01:00.0/link/l1_aspm

BTW, thanks a lot for testing out the "l1_aspm" sysfs file.  I'm very
pleased that it seems to be working as intended.

> and:
> [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> [  5]   0.00-1.00   sec   113 MBytes   951 Mbits/sec  153    772 KBytes
> [  5]   1.00-2.00   sec   109 MBytes   912 Mbits/sec  276    550 KBytes
> [  5]   2.00-3.00   sec   111 MBytes   933 Mbits/sec  123    625 KBytes
> [  5]   3.00-4.00   sec   111 MBytes   933 Mbits/sec   31    687 KBytes
> [  5]   4.00-5.00   sec   110 MBytes   923 Mbits/sec    0    679 KBytes
> [  5]   5.00-6.00   sec   110 MBytes   923 Mbits/sec  136    577 KBytes
> [  5]   6.00-7.00   sec   110 MBytes   923 Mbits/sec  214    645 KBytes
> [  5]   7.00-8.00   sec   110 MBytes   923 Mbits/sec   32    628 KBytes
> [  5]   8.00-9.00   sec   110 MBytes   923 Mbits/sec   81    537 KBytes
> [  5]   9.00-10.00  sec   110 MBytes   923 Mbits/sec   10    577 KBytes
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.00  sec  1.08 GBytes   927 Mbits/sec  1056             sender
> [  5]   0.00-10.00  sec  1.07 GBytes   923 Mbits/sec                  receiver
> 
> But this only confirms that the fix i experience is a side effect.
> 
> The original code is still wrong :)

What exactly is this machine?  Brand, model, config?  Maybe you could
add this and a dmesg log to the buzilla?  It seems like other people
should be seeing the same problem, so I'm hoping to grub around on the
web to see if there are similar reports involving these devices.

https://bugzilla.kernel.org/show_bug.cgi?id=209725

Here's one that is superficially similar:
https://linux-hardware.org/index.php?probe=e5f24075e5&log=lspci_all
in that it has a RP -- switch -- I211 path.  Interestingly, the switch
here advertises <64us L1 exit latency instead of the <32us latency
your switch advertises.  Of course, I can't tell if it's exactly the
same switch.

Bjorn
