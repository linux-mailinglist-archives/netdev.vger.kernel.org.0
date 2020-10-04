Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67ED282BDD
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 18:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgJDQ72 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 4 Oct 2020 12:59:28 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:41121 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgJDQ71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 12:59:27 -0400
Received: from marcel-macpro.fritz.box (p4fefc7f4.dip0.t-ipconnect.de [79.239.199.244])
        by mail.holtmann.org (Postfix) with ESMTPSA id 077F1CED16;
        Sun,  4 Oct 2020 19:06:25 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH] Revert "Bluetooth: Update resolving list when updating
 whitelist"
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20201004105124.GA2429@kroah.com>
Date:   Sun, 4 Oct 2020 18:59:24 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Sathish Narsimman <sathish.narasimman@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <3F7BDD50-DEA3-4CB0-A9A0-69E7EE2923D5@holtmann.org>
References: <20201003135449.GA2691@kroah.com>
 <A1C95238-CBCB-4FD4-B46D-A62AED0C77E5@holtmann.org>
 <20201003160713.GA1512229@kroah.com>
 <AABC2831-4E88-41A2-8A20-1BFC88895686@holtmann.org>
 <20201004105124.GA2429@kroah.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

>>>>> This reverts commit 0eee35bdfa3b472cc986ecc6ad76293fdcda59e2 as it
>>>>> breaks all bluetooth connections on my machine.
>>>>> 
>>>>> Cc: Marcel Holtmann <marcel@holtmann.org>
>>>>> Cc: Sathish Narsimman <sathish.narasimman@intel.com>
>>>>> Fixes: 0eee35bdfa3b ("Bluetooth: Update resolving list when updating whitelist")
>>>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>>> ---
>>>>> net/bluetooth/hci_request.c | 41 ++-----------------------------------
>>>>> 1 file changed, 2 insertions(+), 39 deletions(-)
>>>>> 
>>>>> This has been bugging me for since 5.9-rc1, when all bluetooth devices
>>>>> stopped working on my desktop system.  I finally got the time to do
>>>>> bisection today, and it came down to this patch.  Reverting it on top of
>>>>> 5.9-rc7 restored bluetooth devices and now my input devices properly
>>>>> work.
>>>>> 
>>>>> As it's almost 5.9-final, any chance this can be merged now to fix the
>>>>> issue?
>>>> 
>>>> can you be specific what breaks since our guys and I also think the
>>>> ChromeOS guys have been testing these series of patches heavily.
>>> 
>>> My bluetooth trackball does not connect at all.  With this reverted, it
>>> all "just works".
>>> 
>>> Same I think for a Bluetooth headset, can check that again if you really
>>> need me to, but the trackball is reliable here.
>>> 
>>>> When you run btmon does it indicate any errors?
>>> 
>>> How do I run it and where are the errors displayed?
>> 
>> you can do btmon -w trace.log and just let it run like tcdpump.
> 
> Ok, attached.
> 
> The device is not connecting, and then I open the gnome bluetooth dialog
> and it scans for devices in the area, but does not connect to my
> existing devices at all.
> 
> Any ideas?

the trace file is from -rc7 or from -rc7 with this patch reverted?

I asked, because I see no hint that anything goes wrong. However I have a suspicion if you bisected it to this patch.

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index e0269192f2e5..94c0daa9f28d 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -732,7 +732,7 @@ static int add_to_white_list(struct hci_request *req,
                return -1;
 
        /* White list can not be used with RPAs */
-       if (!allow_rpa && !use_ll_privacy(hdev) &&
+       if (!allow_rpa &&
            hci_find_irk_by_addr(hdev, &params->addr, params->addr_type)) {
                return -1;
        }
@@ -812,7 +812,7 @@ static u8 update_white_list(struct hci_request *req)
                }
 
                /* White list can not be used with RPAs */
-               if (!allow_rpa && !use_ll_privacy(hdev) &&
+               if (!allow_rpa &&
                    hci_find_irk_by_addr(hdev, &b->bdaddr, b->bdaddr_type)) {
                        return 0x00;
                }


If you just do the above, does thing work for you again?

My suspicion is that the use_ll_privacy check is the wrong one here. It only checks if hardware feature is available, not if it is also enabled.

Regards

Marcel

