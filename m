Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54D3C6BC647
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 07:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjCPGr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 02:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjCPGrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 02:47:24 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7CF2DE67;
        Wed, 15 Mar 2023 23:47:19 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pchOK-0003ay-LW; Thu, 16 Mar 2023 07:47:12 +0100
Message-ID: <abbcc89b-008b-64ae-ed77-20607f9356a8@leemhuis.info>
Date:   Thu, 16 Mar 2023 07:47:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US, de-DE
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
To:     Hector Martin <marcan@marcan.st>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        petr.bahula@artisys.aero,
        Linux kernel regressions list <regressions@lists.linux.dev>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
Subject: [regression] Bug 217204 - ASIX AX88179 does not work in 6.X kernel
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1678949240;dbba4793;
X-HE-SMSGID: 1pchOK-0003ay-LW
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Thorsten here, the Linux kernel's regression tracker.

I noticed a regression report in bugzilla.kernel.org; Hector, apparently
it's caused by a commit of yours.

As many (most?) kernel developer don't keep an eye on bugzilla, I
decided to forward it by mail. Quoting from
https://bugzilla.kernel.org/show_bug.cgi?id=217204 :

>  petr.bahula@artisys.aero 2023-03-15 16:04:49 UTC
> 
> After update from kernel 5.15.80 to 6.1.12 the USB ETH card ASIX AX88179 which is in USB-C dock is not accessible as eth1.
> 
> **!!! IMPORTANT !!!
> If the HW is booted with good kernel and then rebooted (without losing power) to bad kernel, it will still work. Only if it is booted with bad kernel from cold state (total no power) then it will not work.**
> 
> ```
> Bisecting: 2 revisions left to test after this (roughly 2 steps)
> [a41b17ff9dacd22f5f118ee53d82da0f3e52d5e3] dccp: put dccp_qpolicy_full() and dccp_qpolicy_push() in the same lock
> Bisecting: 0 revisions left to test after this (roughly 1 step)
> [f56530dcdb0684406661ac9f1accf48319d07600] net: usb: make USB_RTL8153_ECM non user configurable
> c67cc4315a8e605ec875bd3a1210a549e3562ddc is the first bad commit
> commit c67cc4315a8e605ec875bd3a1210a549e3562ddc
> Author: Hector Martin <marcan@marcan.st>
> Date:   Sun Jul 31 16:22:09 2022 +0900
> 
>     net: usb: ax88179_178a: Bind only to vendor-specific interface
>     
>     The Anker PowerExpand USB-C to Gigabit Ethernet adapter uses this
>     chipset, but exposes CDC Ethernet configurations as well as the
>     vendor specific one. This driver tries to bind by PID:VID
>     unconditionally and ends up picking up the CDC configuration, which
>     is supposed to be handled by the class driver. To make things even
>     more confusing, it sees both of the CDC class interfaces and tries
>     to bind twice, resulting in two broken Ethernet devices.
>     
>     Change all the ID matches to specifically match the vendor-specific
>     interface. By default the device comes up in CDC mode and is bound by
>     that driver (which works fine); users may switch it to the vendor
>     interface using sysfs to set bConfigurationValue, at which point the
>     device actually goes through a reconnect cycle and comes back as a
>     vendor specific only device, and then this driver binds and works too.
>     
>     The affected device uses VID/PID 0b95:1790, but we might as well change
>     all of them for good measure, since there is no good reason for this
>     driver to bind to standard CDC Ethernet interfaces.
>     
>     v3: Added VID/PID info to commit message
>     
>     Signed-off-by: Hector Martin <marcan@marcan.st>
>     Link: https://lore.kernel.org/r/20220731072209.45504-1-marcan@marcan.st
>     Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> 
>  drivers/net/usb/ax88179_178a.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> ```
> 
> I've reverted changes made in the c67cc4315a8e605ec875bd3a1210a549e3562ddc commit and gentoo-sources-6.1.12 works correctly now.
> 
> Patch which I use for new kernels now:
> ```
> pet@petkub ~ $  cat /etc/portage/patches/sys-kernel/gentoo-sources/ASIX_AX88179.patch 
> --- a/drivers/net/usb/ax88179_178a.c    2022-12-11 23:15:18.000000000 +0100
> +++ b/drivers/net/usb/ax88179_178a.c    2023-02-23 10:04:47.534060336 +0100
> @@ -1844,7 +1844,8 @@
>  static const struct usb_device_id products[] = {
>  {
>         /* ASIX AX88179 10/100/1000 */
> -       USB_DEVICE_AND_INTERFACE_INFO(0x0b95, 0x1790, 0xff, 0xff, 0),
> +       /*USB_DEVICE_AND_INTERFACE_INFO(0x0b95, 0x1790, 0xff, 0xff, 0),*/
> +       USB_DEVICE(0x0b95, 0x1790),
>         .driver_info = (unsigned long)&ax88179_info,
>  }, {
>         /* ASIX AX88178A 10/100/1000 */
> ```
> 
> See also: https://bugs.gentoo.org/895720

See the ticket for more details.


[TLDR for the rest of this mail: I'm adding this report to the list of
tracked Linux kernel regressions; the text you find below is based on a
few templates paragraphs you might have encountered already in similar
form.]

BTW, let me use this mail to also add the report to the list of tracked
regressions to ensure it's doesn't fall through the cracks:

#regzbot introduced: c67cc4315a8e6
https://bugzilla.kernel.org/show_bug.cgi?id=217204
#regzbot title: net: drivers(usb): ASIX AX88179 stopped working
#regzbot ignore-activity

This isn't a regression? This issue or a fix for it are already
discussed somewhere else? It was fixed already? You want to clarify when
the regression started to happen? Or point out I got the title or
something else totally wrong? Then just reply and tell me -- ideally
while also telling regzbot about it, as explained by the page listed in
the footer of this mail.

Developers: When fixing the issue, remember to add 'Link:' tags pointing
to the report (e.g. the buzgzilla ticket and maybe this mail as well, if
this thread sees some discussion). See page linked in footer for details.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.
