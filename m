Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5927E639C74
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 20:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiK0TCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 14:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiK0TCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 14:02:01 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34FE4CE2F
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 11:02:01 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 89B191D27;
        Sun, 27 Nov 2022 20:01:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1669575719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JYec5I6LTdrwoKnfsMAxxlkN0Id1B74/r4AtA62rL8E=;
        b=h5o/ZTbMdn2fP4wqn7CnmeQpboeMqgGEtSuZJPwpBLmdrpymb6Go9K2/9jyj66sQxC0J7F
        x93CGceJbIlgvqs/mMWG4IJ/F3aM697MhZa09jrqYBeDk24w8ZuMvgrxsPUPlz7hCRbd9y
        Iwu4foPigtD02xq6cnkPyPwNizPIXvvHktfeK/1f4TfIEpYOQ6OukSxWynZ9ns54TZCtN7
        YSh1huy6fnDC369gySk6ubP4QkflQqj82ziCmpV54lRz2wj6ORsNwgfCDp8uW4wybubWC8
        pqqkbADdP/GANlV6oF3DQqhgFTyZX6GmtCVoSe4w02o4gWhjkFJ3amme/jtcYg==
MIME-Version: 1.0
Date:   Sun, 27 Nov 2022 20:01:59 +0100
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org, Xu Liang <lxu@maxlinear.com>
Subject: Re: GPY215 PHY interrupt issue
In-Reply-To: <Y4DcoTmU3nWqMHIp@lunn.ch>
References: <fd1352e543c9d815a7a327653baacda7@walle.cc>
 <Y4DcoTmU3nWqMHIp@lunn.ch>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <c0e09154ee5e62c677d798f68ca7e537@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-11-25 16:17, schrieb Andrew Lunn:
> On Fri, Nov 25, 2022 at 03:44:08PM +0100, Michael Walle wrote:
>> Hi,
>> 
>> I've been debugging an issue with spurious interrupts and it turns out
>> the GYP215 (possibly also other MaxLinear PHYs) has a problem with the
>> link down interrupt. Although the datasheet mentions (and which common
>> sense) a read of the interrupt status register will deassert the
>> interrupt line, the PHY doesn't deassert it right away. There is a
>> variable delay between reading the status register and the deassertion
>> of the interrupt line. This only happens on a link down event. The
>> actual delay depends on the firmware revision and is also somehow
>> random. With FW 7.71 (on a GPY215B) I've meassured around 40us with
>> FW 7.118 (GPY215B) it's about 2ms.
> 
> So you get 2ms of interrupt storm?

Yes.

> Does the interrupt status bit clear
> immediately, or does that clear only once the interrupt line itself
> has cleared? I'm assuming it clears immediately, otherwise you would
> add a polling loop.

Yeah, the register clears after it's read (i.e. the second read returns
zero). And yes 2ms

>> It also varies from link down to
>> link down. The issue is also present in the new GPY215C revision.
>> MaxLinear confirmed the issue and is currently working on a firmware
>> fix. But it seems that the issue cannot really be resolved. At best,
>> the delay can be minimized. If there will be a fix, this is then
>> only for a GPY215C and a new firmware version.
>> 
>> Does anyone have an idea of a viable software workaround?
> 
> Looking at the datasheet for the GPY215, the interrupt line is also
> GPIO 14. Could you flip it into a GPIO, force it inactive, and sleep
> to 2ms? Or even turn it into an input and see if you can read its
> state and poll it until it clears?

Nice idea. Let me try that. First obstacle is that it doesn't seem
to be documented how to do that. The vendor PHY API has some
ALTSEL and gpio functions, though.

-michael
