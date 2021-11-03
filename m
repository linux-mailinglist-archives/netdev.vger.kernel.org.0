Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA8644418A
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 13:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbhKCMbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 08:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbhKCMbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 08:31:48 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85AEBC061714;
        Wed,  3 Nov 2021 05:29:12 -0700 (PDT)
Received: from smtp102.mailbox.org (smtp102.mailbox.org [80.241.60.233])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4HkmKf6CsxzQkBl;
        Wed,  3 Nov 2021 13:29:10 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Message-ID: <771f1f07-882b-2eeb-36fa-126c9b8d5fd8@v0yd.nl>
Date:   Wed, 3 Nov 2021 13:29:05 +0100
MIME-Version: 1.0
Subject: Re: [PATCH] mwifiex: Add quirk to disable deep sleep with certain
 hardware revision
Content-Language: en-US
From:   =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
References: <20211028073729.24408-1-verdre@v0yd.nl>
 <CA+ASDXOrad3b=b8+vwuF6m3+ZcigVaoJySpDXXZOnC3O8CJBSw@mail.gmail.com>
 <cc7432f4-824a-abe2-e304-5ba019ac8c89@v0yd.nl>
In-Reply-To: <cc7432f4-824a-abe2-e304-5ba019ac8c89@v0yd.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D22AC5AF
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also, just in case anyone at NXP is still following this thread, for the
sake of completeness here's a list of all the firmware bugs we've discovered
when investigating this wifi card:

- Firmware can crash after setting TX ring write pointer while ASPM L1 or
L1 substate is active (exact substate is platform dependent). Workaround
"mwifiex: Read a PCI register after writing the TX ring write pointer"

- Firmware sometimes doesn't wake up and send an interrupt after
reading/writing a PCI register. Workaround "mwifiex: Try waking the firmware
until we get an interrupt"

- Firmware doesn't properly implement PCIe LTR (appears to send a single
report during fw startup), making the system unable to enter deeper
powersaving states. Workaround "mwifiex: Add quirk resetting the PCI bridge
on MS Surface devices"

- On hardware revision 20 the card randomly wakes up from deep sleep, most
likely a hardware bug, the firmware should work around that. Workaround
"mwifiex: Add quirk to disable deep sleep with certain hardware revision"

- BTCOEX events from firmware are not sent consistently when BT gets
active/inactive and we end up throttling wifi speeds for no reason.
Workaround "Ignore BTCOEX events from the firmware"

- Firmwares BT LE active and passive scan feature is ignoring the "Filter
duplicates" property, leading to tons of USB interrupts from the card,
preventing the system from powersaving. No workaround except not pairing
any LE devices or disabling BT LE.
