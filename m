Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2FD48BB69
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 00:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346814AbiAKX1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 18:27:20 -0500
Received: from mailout.easymail.ca ([64.68.200.34]:49580 "EHLO
        mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233873AbiAKX1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 18:27:19 -0500
X-Greylist: delayed 554 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Jan 2022 18:27:18 EST
Received: from localhost (localhost [127.0.0.1])
        by mailout.easymail.ca (Postfix) with ESMTP id C7921731A6;
        Tue, 11 Jan 2022 23:18:03 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at emo05-pco.easydns.vpn
Received: from mailout.easymail.ca ([127.0.0.1])
        by localhost (emo05-pco.easydns.vpn [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id T9wjiQLbkDR3; Tue, 11 Jan 2022 23:18:03 +0000 (UTC)
Received: from [10.90.1.74] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mailout.easymail.ca (Postfix) with ESMTPSA id BCA0B73191;
        Tue, 11 Jan 2022 23:18:02 +0000 (UTC)
Message-ID: <5cee9a36-b094-37a0-e961-d7404b3dafe2@gonehiking.org>
Date:   Tue, 11 Jan 2022 16:17:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Content-Language: en-US
To:     nbd@nbd.name, lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        shayne.chen@mediatek.com, sean.wang@mediatek.com, kvalo@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
From:   Khalid Aziz <khalid@gonehiking.org>
Subject: [Bug] mt7921e driver in 5.16 causes kernel panic
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am seeing an intermittent bug in mt7921e driver. When the driver module is loaded
and is being initialized, almost every other time it seems to write to some wild
memory location. This results in driver failing to initialize with message
"Timeout for driver own" and at the same time I start to see "Bad page state" messages
for random processes. Here is the relevant part of dmesg:

[OK] Found device SAMSUNG MZVLB1T0HBLR-000L7 6.
[OK ]Found device SAMSUNG MZVLB1T0HBLR-000L7 SYSTEM.
[OK] Listening on Load/Save RF Kill Switch Status /dev/rfkill Watch.
Starting Cryptography Setup for nvme8n1p6_crypt...
[  5.687489] mt7921e 0000:03:00.0: ASIC revision: 79610010
Starting File System Check on /dev/disk/by-uuid/CCSA-8086...
Please enter passphrase for disk SAMSUNG MZVLB1T0HBLR-000L7 (nvme8n1p6_crypt) on /home
[  7.798962] mt7921e 0000:03:00.0: Timeout for driver own
[  8.874863] mt7921e 0000:03:00.0: Timeout for driver own
[  8.876266] BUG: Bad page state in process systemd-udevd  pfn:123848
[  8.877953] BUG: Bad page state in process napi/phy8-8194  pfn:10a4a8
[  9.958899] mt7921e 0000:03:00.0: Timeout for driver own
[  9.961595] BUG: Bad page state in process systemd-udevd  pfn:1037e8
[ 11.843129] mt7921e 0000:03:00.0: Timeout for driver own
[ 11.845823] BUG: Bad page state in process systemd-udevd  pfn:104380
[ 12.126922] mt7921e 0000:03:00.0: Timeout for driver own
[ 12.128788] BUG: Bad page state in process systemd-udevd  pfn:10a050
[ 13.287898] mt7921e 0000:03:00.0: Timeout for driver own
[ 14.287827] mt7921e 0000:03:00.0: Timeout for driver own
[ 14.288968] BUG: Bad page state in process systemd-udevd  pfn:109f51
[ 14.298599] BUG: Bad page state in process systemd-udevd  pfn:105f60
[ 14.292162] BUG: Bad page state in process systemd-udevd  pfn:10ac07
[ 15.372501] mt7921e 0000:03:00.0: Timeout for driver own
[ 16.454773] mt7921e 0000:03:00.0: Timeout for driver own
[ 16.456238] BUG: Bad page state in process systemd-udevd pfn:1a0c00
[ 16.515869) mt7921e 0000:03:00.0: hardware init failed

These "Bad page state" messages continue until kernel finally panics with a page
fault in a seemingly random place:

[  17.544222] BUG: Bad page state in process apparmor_parser  pfn:1116f8
[  OK  ] Finished Create Volatile Files and Directories
          Starting Network Name Resolution...
          Starting Network Time Synchronization...
          Starting Update UTMP about System Boot/Shutdown...
[  17.677144] BUG: unable to handle page fault for address: 0000396eb08090ec
[  17.680395] #PF: supervisor read access in kernel mode
[  17.681086] #PF: error code(0x0000) - not-present page
[  17.681086] PGD 0 P4D 0
[  17.681006] Opps: 0000 [#1] PREEMPT SMP NOPTI
[  17.681006] CPU: 8 PID: 63 Con: ksoftirgd/8 Tainted: G  B  W        5.16.0 #3
[  17.681606] Hardware name: LENOVO 20XF004WUS/20XF004WUS, BIOS R1NET44W (1.14) 11/08/2821

Rest of the kernel stack trace is in form of a picture which I can send if it helps. Kernel
is compiled from git tag "v5.16". Details of mediatek controller:

$ lspci -v -s 03:00.0
03:00.0 Network controller: MEDIATEK Corp. Device 7961
	Subsystem: Lenovo Device e0bc
	Physical Slot: 0
	Flags: bus master, fast devsel, latency 0, IRQ 85, IOMMU group 11
	Memory at 870200000 (64-bit, prefetchable) [size=1M]
	Memory at 870300000 (64-bit, prefetchable) [size=16K]
	Memory at 870304000 (64-bit, prefetchable) [size=4K]
	Capabilities: [80] Express Endpoint, MSI 00
	Capabilities: [e0] MSI: Enable+ Count=1/32 Maskable+ 64bit+
	Capabilities: [f8] Power Management version 3
	Capabilities: [100] Vendor Specific Information: ID=1556 Rev=1 Len=008 <?>
	Capabilities: [108] Latency Tolerance Reporting
	Capabilities: [110] L1 PM Substates
	Capabilities: [200] Advanced Error Reporting
	Kernel driver in use: mt7921e
	Kernel modules: mt7921e

This is an intermittent problem and I did not see this with 5.16-rc6 kernel.
Please let me know if you need more information.

Thanks,
Khalid

