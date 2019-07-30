Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01B737A80F
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 14:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730255AbfG3MSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 08:18:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:50590 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726363AbfG3MSb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 08:18:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A53A2AD1E;
        Tue, 30 Jul 2019 12:18:29 +0000 (UTC)
Date:   Tue, 30 Jul 2019 14:18:27 +0200
From:   Jean Delvare <jdelvare@suse.de>
To:     Felix Fietkau <nbd@nbd.name>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNl?= =?UTF-8?B?bg==?= 
        <toke@redhat.com>, Johannes Berg <johannes.berg@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: NETIF_F_LLTX breaks iwlwifi
Message-ID: <20190730141827.25fc4136@endymion>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Felix, Toke, Johannes,

After updating to kernel 5.2, I started losing wireless network on my
workstation a few minutes after boot. I could restart the network
service to get it back, but it would go away again a few minutes later.
No error message logged, but somehow the network traffic was no long
being processed.

My hardware is:

05:00.0 Network controller [0280]: Intel Corporation Wireless 8265 / 8275 [8086:24fd] (rev 78)

This is an Intel 8265 PCIe WiFI adapter by Gigabyte, model GC-WB867D-I,
which worked flawlessly for me until then.

I bisected it down to:

commit 8dbb000ee73be2c05e34756739ce308885312a29 (refs/bisect/bad)
Author: Felix Fietkau
Date:   Sat Mar 16 18:06:34 2019 +0100

    mac80211: set NETIF_F_LLTX when using intermediate tx queues

So whatever the commit message says, it is apparently not safe to run
TX handlers on multiple CPUs in parallel for this specific driver /
device.

Unless someone has an immediate explanation as to why it broke the
iwlwifi driver and the actual bug is in iwlwifi and it can be fixed
quickly and easily there, I would suggest that the above commit is
reverted for the time being, as apparently it wasn't fixing anything
but was just a performance optimization.

I am available to do any amount of tests or debugging, given the
guidance.

Thanks,
-- 
Jean Delvare
SUSE L3 Support
