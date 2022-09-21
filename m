Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 328655BF5E5
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 07:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiIUFbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 01:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiIUFbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 01:31:33 -0400
Received: from mail.tkos.co.il (mail.tkos.co.il [84.110.109.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1096EF0F
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 22:31:30 -0700 (PDT)
Received: from tarshish (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.tkos.co.il (Postfix) with ESMTPS id 0B3344403F9;
        Wed, 21 Sep 2022 08:29:55 +0300 (IDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tkos.co.il;
        s=default; t=1663738195;
        bh=nWriLCvWOVDnF3RIXTM3GNDfsmFfvTUUcL3X5u8FxhQ=;
        h=References:From:To:Cc:Subject:Date:In-reply-to:From;
        b=QsfvhEDYGzbuDtMqzEZUPk0DT+i1e0D5QKUo7r3P/aWdPRyTgTAG43ALzkCYJXA6V
         VfDIn0M9gbrqHbfERh4nChiVZl9EAd/47SASDO1V3XkaMjfhj2YZZXLYbw2bUt1NZr
         MNmqk7DUvaVl7QfxZU+x3++ivllkzXwwXG6BpqIGiKdVB3m+xfZj59BAO59Jf/Yq0x
         UQWffLDa+5V61Ld7maV/yki3aU4lAhxKf2/HUXmIR6WIvpu8A6k8ZA1m1bwIhsJSaF
         bdWB33GnOeQGdBYfExqwtKjutROygSpAdpKmSD7hZ0WZyJLtTtx+MfO3UbHYvXiQ4D
         fnQowMB7PoXSw==
References: <931ac53e9d6421f71f776190b2039abaa69f7d43.1663133795.git.baruch@tkos.co.il>
 <20220920081911.619ffeef@kernel.org>
 <Yyn2ppzcRtLwiArd@shell.armlinux.org.uk>
User-agent: mu4e 1.8.7; emacs 27.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v2] net: sfp: workaround GPIO input signals bounce
Date:   Wed, 21 Sep 2022 07:57:28 +0300
In-reply-to: <Yyn2ppzcRtLwiArd@shell.armlinux.org.uk>
Message-ID: <87pmfpjntc.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Tue, Sep 20 2022, Russell King (Oracle) wrote:
> On Tue, Sep 20, 2022 at 08:19:11AM -0700, Jakub Kicinski wrote:
>> On Wed, 14 Sep 2022 08:36:35 +0300 Baruch Siach wrote:
>> > From: Baruch Siach <baruch.siach@siklu.com>
>> > 
>> > Add a trivial debounce to avoid miss of state changes when there is no
>> > proper hardware debounce on the input signals. Otherwise a GPIO might
>> > randomly indicate high level when the signal is actually going down,
>> > and vice versa.
>> > 
>> > This fixes observed miss of link up event when LOS signal goes down on
>> > Armada 8040 based system with an optical SFP module.
>> > 
>> > Signed-off-by: Baruch Siach <baruch.siach@siklu.com>
>> > ---
>> > v2:
>> >   Skip delay in the polling case (RMK)
>> 
>> Is this acceptable now, Russell?
>
> I don't think so. The decision to poll is not just sfp->need_poll,
> we also do it when need_poll is false, but we need to use the soft
> state as well:
>
>         if (sfp->state_soft_mask & (SFP_F_LOS | SFP_F_TX_FAULT) &&
>             !sfp->need_poll)
>                 mod_delayed_work(system_wq, &sfp->poll, poll_jiffies);
>
> I think, if we're going to use this "simple" debounce, we need to
> add a flag to sfp_gpio_get_state() that indicates whether it's been
> called from an interrupt.
>
> However, even that isn't ideal, because if we poll, we get no
> debouncing.

Why would you need debouncing in the poll case? The next poll will give
you the updated state, isn't it?

> The unfortunate thing is, on the Macchiatobin (which I suspect is
> the platform that Baruch is addressing here) there are no pull-up
> resistors on the lines as required by the SFP MSA, so they tend to
> float around when not being actively driven. Debouncing will help
> to avoid some of the problems stemming from that, but ultimately
> some will still get through. The only true real is a hardware one
> which isn't going to happen.

The design of the hardware I am dealing with is based on the
Macchiatobin.  The pull-ups are indeed missing which caused us other
trouble as well (see the hack below). Though I would not expect pull-up
absence to affect the LOS signal high to low transition (link up).

commit 2e76b75d8623b016390126b54b4d4047b13dc085
Author: Baruch Siach <baruch@tkos.co.il>
Date:   Mon Apr 5 16:40:27 2021 +0300

    net: sfp: workaround missing Tx disable pull-up
    
    When Tx disable pull-up is missing the SFP module might not sense the
    transition from disable to enable. The signal just stays low.
    
    As a workaround assert Tx disable on probe.
    
    This only works when the SFP is plugged in when the sfp module probe.
    Hot plug of SFP module might not work.
    
    Signed-off-by: Baruch Siach <baruch@tkos.co.il>

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 73c2969f11a4..d41bbd617123 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -2327,6 +2327,9 @@ static int sfp_probe(struct platform_device *pdev)
 	 * since the network interface will not be up.
 	 */
 	sfp->state = sfp_get_state(sfp) | SFP_F_TX_DISABLE;
+	/* Siklu workaround: missing Tx disable pull-up. Force disable. */
+	if ((sfp->state & SFP_F_PRESENT) && sfp->gpio[GPIO_TX_DISABLE])
+		gpiod_direction_output(sfp->gpio[GPIO_TX_DISABLE], 1);
 
 	if (sfp->gpio[GPIO_RATE_SELECT] &&
 	    gpiod_get_value_cansleep(sfp->gpio[GPIO_RATE_SELECT]))

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
