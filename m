Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9444630D0
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 11:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbhK3KSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 05:18:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbhK3KSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 05:18:40 -0500
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A34F6C061574;
        Tue, 30 Nov 2021 02:15:21 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4J3J4l0hhwzQlXs;
        Tue, 30 Nov 2021 11:15:19 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Message-ID: <6da022c5-5ee5-b8b8-9642-bd0edf6240fa@v0yd.nl>
Date:   Tue, 30 Nov 2021 11:15:11 +0100
MIME-Version: 1.0
Subject: Re: [PATCH] mwifiex: Ignore BTCOEX events from the 88W8897 firmware
Content-Language: en-US
To:     Bjorn Helgaas <helgaas@kernel.org>
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
References: <20211129233824.GA2703817@bhelgaas>
From:   =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>
In-Reply-To: <20211129233824.GA2703817@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.11.21 00:38, Bjorn Helgaas wrote:
> On Mon, Nov 29, 2021 at 05:32:11PM -0600, Bjorn Helgaas wrote:
>> On Wed, Nov 03, 2021 at 09:58:27PM +0100, Jonas Dreßler wrote:
>>> The firmware of the 88W8897 PCIe+USB card sends those events very
>>> unreliably, sometimes bluetooth together with 2.4ghz-wifi is used and no
>>> COEX event comes in, and sometimes bluetooth is disabled but the
>>> coexistance mode doesn't get disabled.
>>
>> s/sends those events/sends BTCOEX events/ so it reads well without the
>> subject.
>>
>> s/coexistance/coexistence/
>>
>> Is BTCOEX a standard Bluetooth thing?  Is there a spec reference that
>> could be useful here?  I've never seen those specs, so this is just
>> curiosity.  I did download the "Bluetooth Core Spec v5.3", which does
>> have a "Wireless Coexistence Signaling and Interfaces" chapter, but
>> "BTCOEX" doesn't appear in that doc.
>>
>>> This means we sometimes end up capping the rx/tx window size while
>>> bluetooth is not enabled anymore, artifically limiting wifi speeds even
>>> though bluetooth is not being used.
>>
>> s/artifically/artificially/
>>
>>> Since we can't fix the firmware, let's just ignore those events on the
>>> 88W8897 device. From some Wireshark capture sessions it seems that the
>>> Windows driver also doesn't change the rx/tx window sizes when bluetooth
>>> gets enabled or disabled, so this is fairly consistent with the Windows
>>> driver.
> 
> I hadn't read far enough to see that the patch was already applied,
> sorry for the noise :)
> 
No problem, in case you still want to know about BTCOEX:

 From what I've seen that's not something defined in any standards, but
it's usually the name of the (sometimes patented) tricks every manufacturer
has to make wifi and bt (which are both on the 2.4ghz band) behave well
together.

In almost every wifi driver you'll find functionality named
btcoex/coexist/coexistence. The way it usually works is that the card
sends an event to the kernel driver (in our case that event is called
BTCOEX), and then the driver decides which quirks to apply to make wifi
more interference-resistant (here's where the patents come in because
some of those quirks are quite tricky, see for example
https://patents.google.com/patent/US9226102B1/en).

Now with our Marvell card the firmware is buggy and sends those events
so unreliably (the card "forgets" to inform us that the BT connection
has ended) that we're better off ignoring them.
