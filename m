Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1D842A97D
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 18:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhJLQgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhJLQgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 12:36:42 -0400
Received: from mx3.uni-regensburg.de (mx3.uni-regensburg.de [IPv6:2001:638:a05:137:165:0:4:4e79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E24C061570
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 09:34:40 -0700 (PDT)
Received: from mx3.uni-regensburg.de (localhost [127.0.0.1])
        by localhost (Postfix) with SMTP id F17076000057;
        Tue, 12 Oct 2021 18:34:37 +0200 (CEST)
Received: from smtp1.uni-regensburg.de (smtp1.uni-regensburg.de [194.94.157.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "smtp.uni-regensburg.de", Issuer "DFN-Verein Global Issuing CA" (not verified))
        by mx3.uni-regensburg.de (Postfix) with ESMTPS id D1C506000051;
        Tue, 12 Oct 2021 18:34:37 +0200 (CEST)
From:   "Andreas K. Huettel" <andreas.huettel@ur.de>
To:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Jakub Kicinski <kubakici@wp.pl>
Subject: Re: [EXT] Re: [Intel-wired-lan] Intel I350 regression 5.10 -> 5.14 ("The NVM Checksum Is Not Valid") [8086:1521]
Date:   Tue, 12 Oct 2021 18:34:35 +0200
Message-ID: <2801801.e9J7NaK4W3@kailua>
Organization: Universitaet Regensburg
In-Reply-To: <c75203e9-0ef4-20bd-87a5-ad0846863886@intel.com>
References: <1823864.tdWV9SEqCh@kailua> <2944777.ktpJ11cQ8Q@pinacolada> <c75203e9-0ef4-20bd-87a5-ad0846863886@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > The messages easily identifiable are:
> > 
> > huettel@pinacolada ~/tmp $ cat kernel-messages-5.10.59.txt |grep igb
> > Oct  5 15:11:18 dilfridge kernel: [    2.090675] igb: Intel(R) Gigabit Ethernet Network Driver
> > Oct  5 15:11:18 dilfridge kernel: [    2.090676] igb: Copyright (c) 2007-2014 Intel Corporation.
> > Oct  5 15:11:18 dilfridge kernel: [    2.090728] igb 0000:01:00.0: enabling device (0000 -> 0002)
> 
> This line is missing below, it indicates that the kernel couldn't or
> didn't power up the PCIe for some reason. We're looking for something
> like ACPI or PCI patches (possibly PCI-Power management) to be the
> culprit here.
> 

So I did a git bisect from linux-v5.10 (good) to linux-v5.14.11 (bad).

The result was:

dilfridge /usr/src/linux-git # git bisect bad
6381195ad7d06ef979528c7452f3ff93659f86b1 is the first bad commit
commit 6381195ad7d06ef979528c7452f3ff93659f86b1
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Mon May 24 17:26:16 2021 +0200

    ACPI: power: Rework turning off unused power resources
[...]

I tried naive reverting of this commit on top of 5.14.11. That applies nearly cleanly, 
and after a reboot the additional ethernet interfaces show up with their MAC in the
boot messages.

(Not knowing how safe that experiment was, I did not go further than single mode and
immediately rebooted into 5.10 afterwards.)

-- 
PD Dr. Andreas K. Huettel
Institute for Experimental and Applied Physics
University of Regensburg
93040 Regensburg
Germany

e-mail andreas.huettel@ur.de
http://www.akhuettel.de/
http://www.physik.uni-r.de/forschung/huettel/


