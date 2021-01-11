Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7DBB2F1E82
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 20:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390676AbhAKTEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 14:04:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727052AbhAKTEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 14:04:48 -0500
Received: from ficht.host.rs.currently.online (ficht.host.rs.currently.online [IPv6:2a01:4f8:120:614b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E47C06179F;
        Mon, 11 Jan 2021 11:04:03 -0800 (PST)
Received: from carbon.srv.schuermann.io (carbon.srv.schuermann.io [IPv6:2a01:4f8:120:614b:2::1])
        by ficht.host.rs.currently.online (Postfix) with ESMTPS id 45A201FE03;
        Mon, 11 Jan 2021 19:03:58 +0000 (UTC)
From:   Leon Schuermann <leon@is.currently.online>
To:     kuba@kernel.org, oliver@neukum.org, davem@davemloft.net
Cc:     hayeswang@realtek.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, Leon Schuermann <leon@is.currently.online>
Subject: Re: [PATCH 1/1] r8152: Add Lenovo Powered USB-C Travel Hub
Date:   Mon, 11 Jan 2021 20:03:11 +0100
Message-Id: <20210111190312.12589-1-leon@is.currently.online>
In-Reply-To: <20210109144311.47760f7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210109144311.47760f7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:
> On Sat, 09 Jan 2021 10:39:27 +0100 Leon Schuermann wrote:
>> Jakub Kicinski <kuba@kernel.org> writes:
>> > On Fri,  8 Jan 2021 21:27:27 +0100 Leon Schuermann wrote:  
>> >> This USB-C Hub (17ef:721e) based on the Realtek RTL8153B chip used to
>> >> work with the cdc_ether driver.  
>> >
>> > When you say "used to work" do you mean there was a regression where
>> > the older kernels would work fine and newer don't? Or just "it works
>> > most of the time"?  
>> 
>> Sorry, I should've clarified that. "Used to work" is supposed to say
>> "the device used the generic cdc_ether driver", as in
>> 
>> [  +0.000004] usb 4-1.1: Product: Lenovo Powered Hub
>> [  +0.000003] usb 4-1.1: Manufacturer: Lenovo
>> [  +0.000002] usb 4-1.1: SerialNumber: xxxxxxxxx
>> [  +0.024803] cdc_ether 4-1.1:2.0 eth0: register 'cdc_ether' at
>>               usb-0000:2f:00.0-1.1, CDC Ethernet Device,
>>               xx:xx:xx:xx:xx:xx
>> 
>> I guess it did technically work correctly, except for the reported issue
>> when the host system suspends, which is fixed by using the dedicated
>> Realtek driver. As far as I know this hasn't been fixed before, so it's
>> not a regression.
>
> I see. In the last release cycle there were patches for allowing
> cdc_ether to drive RTL8153 devices when r8152 is not available. 
> I wanted to double check with you that nothing changed here,
> that's to say that the cdc_ether is not used even if r8152 is 
> built after an upgrade to 5.11-rc.

Thanks for the info, I didn't notice that. I can confirm that
`cdc_ether` (for this specific USB-C Hub) is used prior and after the
patches introducing r8153_ecm.

However, the r8153_ecm driver resolves the issue of my first patch,
being unable to use the device without r8152 available. To enable a
fallback onto this driver I added a second commit, because my device
uses a different VID/PID combination compared to the default Realtek
VID/PID on which the r8153_ecm currently matches.

I've tested the first commit standalone (r8152: Add Lenovo...), both
commits (r8153_ecm: Add Le...), as well as two vanilla kernel
versions, each with and without the r8152 driver available, with the
following results:

|                      | CONFIG_USB_RTL8152 | !(CONFIG_USB_RTL8152) |
|----------------------+--------------------+-----------------------|
| r8153_ecm: Add Le... | `r8152` used       | `r8153_ecm` used      |
| r8152: Add Lenovo... | `r8152` used       | No matching driver    |
| 5.11.0-rc3           | `cdc_ether` used   | `cdc_ether` used      |
| 5.10.3               | `cdc_ether` used   | `cdc_ether` used      |

Unfortunately, r8153_ecm has the same issue with regards to pause frames
during host system suspend as does cdc_ether and potentially requires
some special handling (if that is even possible in ECM mode). That is
outside of the scope of this patchset though.

Nonetheless, I do believe that the option of using r8152 if it is
available and falling back to r8153_ecm (applying both patches) is the
most appropriate, as it is unlikely to break anyone's hardware while
still fixing my issue.


I suppose that in theory, it might make sense to add all devices
listed as using the RTL8153 in cdc_ether.c to the products of
r8153_ecm, as none of them will currently work without r5182. I can't
test them though, so I'm not sure whether that's a good idea. This
patch therefore only resolves the issue for my specific USB-C Hub.


>> Should I update the commit message accordingly? Thanks!
>
> Yes please, otherwise backporters may be confused about how 
> to classify this change.

I've updated the commit message. Let me know what you think.

Thanks!

Leon

Leon Schuermann (2):
  r8152: Add Lenovo Powered USB-C Travel Hub
  r8153_ecm: Add Lenovo Powered USB-C Hub as a fallback of r8152

 drivers/net/usb/cdc_ether.c | 7 +++++++
 drivers/net/usb/r8152.c     | 1 +
 drivers/net/usb/r8153_ecm.c | 8 ++++++++
 3 files changed, 16 insertions(+)


base-commit: 7c53f6b671f4aba70ff15e1b05148b10d58c2837
-- 
2.29.2

