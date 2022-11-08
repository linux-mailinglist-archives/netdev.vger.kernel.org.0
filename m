Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF19F621CB1
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 20:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiKHTIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 14:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiKHTIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 14:08:10 -0500
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81328CE5A
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 11:08:08 -0800 (PST)
Received: from submission (posteo.de [185.67.36.169]) 
        by mout02.posteo.de (Postfix) with ESMTPS id 223B1240108
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 20:08:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
        t=1667934487; bh=AesJj0aCIMx2MWDCrj3cOaIGPv8nxtJuQkyvGc0O42Y=;
        h=Date:From:Subject:To:Cc:From;
        b=OiGMjQ2V9GFTUEnE06Zd+6HxP8M9+yLOARoPLwBN7j0pYwdggUHalYlIzDAbTwQbr
         TGHV2ClF5tbIrprmfSGgQwyZK4dJzcNYutQZ+YhLcZ/JeeGs44f/PVBQaS2XGLOSsF
         +87l/MtOn7RBAwkKoRcvG+yA7276DFouqMzcCoxnes/lzd903zqaGLIt/SeiBbq8D8
         QU9i9c33wVnbEbb1OKI4bZaaYfbqAVpOr7EeRTe2yKARjmK7QjNCY0fP1occEfAhc0
         bfez5i7UWZ8K4JIRpBVYJhepi5bQSME0941jzsPX1Ll7Dp6pQoaHaSUTBASX0QgbTn
         6bPGIT9bnp+aw==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4N6Hg905gbz6tnC;
        Tue,  8 Nov 2022 20:08:04 +0100 (CET)
Message-ID: <ea8f2b55-3871-8ba6-b545-d3c73a7508cc@posteo.net>
Date:   Tue,  8 Nov 2022 19:07:25 +0000
MIME-Version: 1.0
From:   Lukas Magel <lukas.magel@posteo.net>
Subject: Re: [PATCH net-next 0/14] pull-request: can-next 2022-10-31
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de
References: <20221031154406.259857-1-mkl@pengutronix.de>
 <20221031202714.1eada551@kernel.org> <Y2CpRfuto8wFrXX+@kroah.com>
Content-Language: en-US
In-Reply-To: <Y2CpRfuto8wFrXX+@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.11.22 06:06, Greg Kroah-Hartman wrote:
> On Mon, Oct 31, 2022 at 08:27:14PM -0700, Jakub Kicinski wrote:
>> On Mon, 31 Oct 2022 16:43:52 +0100 Marc Kleine-Budde wrote:
>>> The first 7 patches are by Stephane Grosjean and Lukas Magel and
>>> target the peak_usb driver. Support for flashing a user defined device
>>> ID via the ethtool flash interface is added. A read only sysfs
>> nit: ethtool eeprom set != ethtool flash
>>
>>> attribute for that value is added to distinguish between devices via
>>> udev.
>> So the user can write an arbitrary u32 value into flash which then
>> persistently pops up in sysfs across reboots (as a custom attribute
>> called "user_devid")?
>>
>> I don't know.. the whole thing strikes me as odd. Greg do you have any
>> feelings about such.. solutions?
>>
>> patches 5 and 6 here:
>> https://lore.kernel.org/all/20221031154406.259857-1-mkl@pengutronix.de/
I now realize that I didn't do a sufficient job at describing the purpose of the
device ID in the patches (which I am working on improving at the moment). In
contrast to other devices (such as the ones from ETAS), at least the PCAN USB-FD
devices do not export an iSerial attribute at USB level, which makes it hard to
distinguish them if you are using multiple with the same product ID. The user
device ID is a freely configurable identifier (basically an arbitrary u8 / u32
value like you said) that can be set individually for each CAN channel of any
PEAK device and can serve as a replacement for the missing serial number. This
use case is also explicitly stated in the Windows API manual for the PEAK
devices (see page 11 in [1]). The patch series implements write support for the
value via ethtool and exports it readonly as a sysfs attribute for udev matching.
> Device-specific attributes should be in the device-specific directory,
> not burried in a class directory somewhere that is generic like this one
> is.
>
> Why isn't this an attribute of the usb device instead?

Each CAN channel of a PEAK device can have its own device ID, meaning that there
is a potential one-to-n mapping between USB device and device IDs. I can see how
the name might appear confusing in that regard, we chose it to be consistent
with the API description put out by PEAK (also see [1]).

> And there's no need to reorder the .h file includes in patch 06 while
> you are adding a sysfs entry, that should be a separate commit, right?
I have split this into a separate commit.
> Also, the line:
>
> +	.attrs	= (struct attribute **)peak_usb_sysfs_attrs,
>
> Is odd, there should never be a need to cast anything like this if you
> are doing things properly.
I have removed the const modifier from the struct as well as the cast.
> So this still needs work, sorry.
>
> thanks,
>
> greg k-h
>
Please let me know if you require further changes to the patch series or want
the attribute to be renamed.

Regards,


Lukas

[1] See PCAN-Parameter_Documentation.pdf in
https://www.peak-system.com/fileadmin/media/files/pcan-basic.zip
