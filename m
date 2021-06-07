Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAFB639DD57
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 15:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbhFGNM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 09:12:58 -0400
Received: from mail.2ds.eu ([159.69.24.75]:39706 "EHLO mail.2ds.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230207AbhFGNM6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 09:12:58 -0400
Received: by mail.2ds.eu (Postfix, from userid 119)
        id 66DD7C4A1B; Mon,  7 Jun 2021 13:11:06 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on cloud-db-1
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.2
Received: from [192.168.1.168] (91-133-69-233.stat.cablelink.at [91.133.69.233])
        (Authenticated sender: admin@2ds.eu)
        by mail.2ds.eu (Postfix) with ESMTPSA id F1706C4A0B
        for <netdev@vger.kernel.org>; Mon,  7 Jun 2021 13:11:05 +0000 (UTC)
Message-ID: <5b08afe02cb0baa7ae3e19fd0bc9d1cbe9ea89c9.camel@2ds.eu>
Subject: Load on RTL8168g/8111g stalls network for multiple seconds
From:   Johannes =?ISO-8859-1?Q?Brandst=E4tter?= <jbrandst@2ds.eu>
To:     netdev@vger.kernel.org
Date:   Mon, 07 Jun 2021 15:11:05 +0200
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

just the other day I wanted to set up a bridge between an external 2.5G
RTL8156 USB Ethernet adapter (using r8152) and the built in dual
RTL8168g/8111g Ethernet chip (using r8169).
I compiled the kernel as of 5.13.0-rc4 because of the r8125 supporting
the RTL8156.
This was done using the Debian kernel config of 5.10.0-4 as a base and
left the rest as default.

So this setup was working the way I wanted it to, but unfortunately
when running iperf3 against the machine it would rather quickly stall
all communications on the internal RTL8168g.
I was still able to communicate fine over the external RTL8156 link
with the machine.
Even without the generated network load, it would occasionally become
stalled.

The only information I could really gather were that the rx_missed
counter was going up, and this kernel message some time after the stall
was happening:

[81853.129107] r8169 0000:02:00.0 enp2s0: rtl_rxtx_empty_cond == 0
(loop: 42, delay: 100).

Which has apparently to do with the wait for an empty fifo within the
r8169 driver.

Until that the machine (an UP² board) using the RTL8168g ran without
any issues for multiple years in different configurations.
Only bridging immediately showed the issue when given enough network
load.

After many hours of trying out different things, nothing of which
showed any difference whatsoever, I tried to replace the internal
RTL8168g with an additional external USB Ethernet adapter which I had
laying around, having a RTL8153 inside.

Once the RTL8168g was removed and the RTL8153 added to the bridge, I
was unable to reproduce the issue.
Of course I'd rather like to make use of the two internal Ethernet
ports if I somehow can.

So is there anything I could try to do?

I'm eyeing with a regression test next on the kernel's r8168 driver.
Though this is without me knowing if there ever was a working version.
As this is a rather large task, with only limited time I wanted to seek
out some help before I go down that route.

Maybe you could point me into the right direction, as to what to try
next.

Thanks and best regards,
Johannes

