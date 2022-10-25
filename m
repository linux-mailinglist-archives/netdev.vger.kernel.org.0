Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C619D60C815
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 11:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbiJYJaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 05:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbiJYJaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 05:30:12 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DE413EA8
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 02:28:27 -0700 (PDT)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1onGEU-0001Aa-1O; Tue, 25 Oct 2022 11:28:26 +0200
Message-ID: <a4732045-a8bf-cf81-6faa-0e99cabe2f4a@pengutronix.de>
Date:   Tue, 25 Oct 2022 11:28:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: Re: [BUG] use-after-free after removing UDC with USB Ethernet gadget
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Peter Chen <peter.chen@kernel.org>,
        Felipe Balbi <balbi@kernel.org>, johannes.berg@intel.com,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <ALSI@bang-olufsen.dk>
References: <fd36057a-e8d9-38a3-4116-db3f674ea5af@pengutronix.de>
 <Y1eahQ66OcpsECNf@kroah.com>
Content-Language: en-US
In-Reply-To: <Y1eahQ66OcpsECNf@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Greg,

On 25.10.22 10:12, Greg KH wrote:
> On Tue, Oct 25, 2022 at 08:54:58AM +0200, Ahmad Fatoum wrote:
>> Hi everybody,
>>
>> I am running v6.0.2 and can reliably trigger a use-after-free by allocating
>> a USB gadget, binding it to the chipidea UDC and the removing the UDC.
> 
> How do you remove the UDC?

I originally saw this while doing reboot -f on the device. The imx_usb driver's
shutdown handler is equivalent to the remove handler and that removes the UDC.

It could also be triggered with:

  echo ci_hdrc.0 > /sys/class/udc/ci_hdrc.0/device/driver/unbind

>> The network interface is not removed, but the chipidea SoC glue driver will
>> remove the platform_device it had allocated in the probe, which is apparently
>> the parent of the network device. When rtnl_fill_ifinfo runs, it will access the
>> device parent's name for IFLA_PARENT_DEV_NAME, which is now freed memory.
> 
> The gadget removal logic is almost non-existant for most of the function
> code.  See Lee's patch to try to fix up the f_hid.c driver last week as
> one example.  I imagine they all have this same issue as no one has ever
> tried the "remove the gadget device from the running Linux system"
> before as it was not an expected use case.

I see.

FTR: https://lore.kernel.org/all/20221017112737.230772-1-lee@kernel.org/
 
> Is this now an expected use case of the kernel?  If so, patches are
> welcome to address this in all gadget drivers.

I don't really care for unbinding via sysfs. I want to avoid the
use-after-free on reboot/shutdown. See the last splat in my original mail.

Cheers,
Ahmad


> 
> thanks,
> 
> greg k-h
> 


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
