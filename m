Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E037D52703B
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 11:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbiENJSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 05:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiENJSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 05:18:41 -0400
Received: from mxd2.seznam.cz (mxd2.seznam.cz [IPv6:2a02:598:2::210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9157A10B;
        Sat, 14 May 2022 02:18:35 -0700 (PDT)
Received: from email.seznam.cz
        by email-smtpc4b.ng.seznam.cz (email-smtpc4b.ng.seznam.cz [10.23.13.105])
        id 235a18fbc7f6cbc52287b995;
        Sat, 14 May 2022 11:18:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seznam.cz; s=beta;
        t=1652519896; bh=AfizNpjvoMPoHKW3iwxVG5iAuMNJm9Yhmt52FDD66iA=;
        h=Received:Date:From:To:Cc:Subject:Message-ID:References:
         MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
         X-szn-frgn:X-szn-frgc;
        b=PFc6By1n3wINAhyWOBOHgutcX2ubIhTofF/uZAQs5tOAAWcIyrZjZavv1QtIYQI8W
         gQ7PU3UjALhiHJtrJ8azD8ktFUwsIZd46Ky8Vhn0kZziEgzFtfmWcppS+ISCqQ+eiR
         EupogX5UpAzJJBzmnPw47N9Cyh0YKkj+fXZviV2o=
Received: from hopium (ip-89-176-234-80.net.upcbroadband.cz [89.176.234.80])
        by email-relay30.ng.seznam.cz (Seznam SMTPD 1.3.136) with ESMTP;
        Sat, 14 May 2022 11:18:10 +0200 (CEST)  
Date:   Sat, 14 May 2022 11:18:08 +0200
From:   Matej Vasilevski <matej.vasilevski@seznam.cz>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     devicetree@vger.kernel.org, linux-can@vger.kernel.org,
        pisa@cmp.felk.cvut.cz, ondrej.ille@gmail.com,
        netdev@vger.kernel.org, martin.jerabek01@gmail.com
Subject: Re: [RFC PATCH 1/3] can: ctucanfd: add HW timestamps to RX and error
 CAN frames
Message-ID: <20220514091741.GA203806@hopium>
References: <20220512232706.24575-1-matej.vasilevski@seznam.cz>
 <20220512232706.24575-2-matej.vasilevski@seznam.cz>
 <20220513114135.lgbda6armyiccj3o@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513114135.lgbda6armyiccj3o@pengutronix.de>
X-szn-frgn: <55922081-9227-4f02-9340-89abb6ab1c4d>
X-szn-frgc: <0>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marc,

thanks for your review!

I have only one comment regarding the initial timecounter value. Otherwise
my reply is mostly ACKs.

On Fri, May 13, 2022 at 01:41:35PM +0200, Marc Kleine-Budde wrote:
> Hello Matej,
> 
> thanks for our patch!
> 
> On 13.05.2022 01:27:05, Matej Vasilevski wrote:
> > This patch adds support for retrieving hardware timestamps to RX and
> > error CAN frames for platform devices. It uses timecounter and
> > cyclecounter structures, because the timestamping counter width depends
> > on the IP core implementation (it might not always be 64-bit).
> > To enable HW timestamps, you have to enable it in the kernel config
> > and provide the following properties in device tree:
> 
> Please no Kconfig option. There is a proper interface to enable/disable
> time stamps form the user space. IIRC it's an ioctl. But I think the
> overhead is neglectable here.

I have nothing substantial to say on this matter, the discussion should
continue in Pavel's thread.
I don't mind implementing the .ndo_eth_ioctl.
> 
> > - ts-used-bits
> 
> A property with "width" in the name seems to be more common. You
> probably have to add the "ctu" vendor prefix. BTW: the bindings document
> update should come before changing the driver.
> 

ACK, thanks for the naming suggestion.
Commit order will be fixed.

> > - add second clock phandle to 'clocks' property
> > - create 'clock-names' property and name the second clock 'ts_clk'
> > 
> > Alternatively, you can set property 'ts-frequency' directly with
> > the timestamping frequency, instead of setting second clock.
> 
> For now, please use a clock property only. If you need ACPI bindings add
> them later.
> 

ACK.

> > +config CAN_CTUCANFD_PLATFORM_ENABLE_HW_TIMESTAMPS
> > +	bool "CTU CAN-FD IP core platform device hardware timestamps"
> > +	depends on CAN_CTUCANFD_PLATFORM
> > +	default n
> > +	help
> > +	  Enables reading hardware timestamps from the IP core for platform
> > +	  devices by default. You will have to provide ts-bit-size and
> > +	  ts-frequency/timestaping clock in device tree for CTU CAN-FD IP cores,
> > +	  see device tree bindings for more details.
> 
> Please no Kconfig option, see above.
ACK

> > diff --git a/drivers/net/can/ctucanfd/Makefile b/drivers/net/can/ctucanfd/Makefile
> >  struct ctucan_priv {
> > @@ -51,6 +60,16 @@ struct ctucan_priv {
> >  	u32 rxfrm_first_word;
> >  
> >  	struct list_head peers_on_pdev;
> > +
> > +	struct cyclecounter cc;
> > +	struct timecounter tc;
> > +	struct delayed_work timestamp;
> > +
> > +	struct clk *timestamp_clk;
> 
> > +	u32 timestamp_freq;
> > +	u32 timestamp_bit_size;
> 
> These two are not needed. Fill in struct cyclecounter directly.
> 

ACK

> >  
> > +	if (priv->timestamp_enabled && (ctucan_timestamp_init(priv) < 0)) {
> 
> ctucan_timestamp_init() will always return 0

ACK. There are some remnants from last minute changes on the work delay
calculation code, I'll polish it.

> > +	if (priv->timestamp_enabled)
> > +		dev_info(dev, "Timestamping enabled with counter bit width %u, frequency %u, work delay in jiffies %u\n",
> > +			 priv->timestamp_bit_size, priv->timestamp_freq, priv->work_delay_jiffies);
> > +	else
> > +		dev_info(dev, "Timestamping is disabled\n");
> 
> This is probably a bit too loud. Make it _dbg()?
Yes, good idea.

> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> 
> With the SPDX-License-Identifier you can skip this.
ACK.

> 
> > + ******************************************************************************/
> > +
> > +#include "asm-generic/bitops/builtin-ffs.h"
> 
> Is linux/bitops.h not enough?

ACK.
bitops.h is enough, I've just completely forgot to clean up the headers.
I'll also delete dev_printk.h, it shouldn't be here.

> 
> > +#include "linux/dev_printk.h"
> > +#include <linux/clocksource.h>
> > +#include <linux/math64.h>
> > +#include <linux/timecounter.h>
> > +#include <linux/workqueue.h>
> 
> please sort alphabetically
ACK.

> > +int ctucan_calculate_and_set_work_delay(struct ctucan_priv *priv)
> > +{
> > +	u32 jiffies_order = fls(HZ);
> > +	u32 max_shift_left = 63 - jiffies_order;
> > +	s32 final_shift = (priv->timestamp_bit_size - 1) - max_shift_left;
> > +	u64 tmp;
> > +
> > +	if (!priv->timestamp_freq || !priv->timestamp_bit_size)
> > +		return -1;
> 
> please use proper error return values
ACK

> 
> > +
> > +	/* The formula is work_delay_jiffies = 2**(bit_size - 1) / ts_frequency * HZ
> > +	 * using (bit_size - 1) instead of full bit_size to read the counter
> > +	 * roughly twice per period
> > +	 */
> > +	tmp = div_u64((u64)HZ << max_shift_left, priv->timestamp_freq);
> > +
> > +	if (final_shift > 0)
> > +		priv->work_delay_jiffies = tmp << final_shift;
> > +	else
> > +		priv->work_delay_jiffies = tmp >> -final_shift;
> > +
> > +	if (priv->work_delay_jiffies == 0)
> > +		return -1;
> > +
> > +	if (priv->work_delay_jiffies > CTUCANFD_MAX_WORK_DELAY_SEC * HZ)
> > +		priv->work_delay_jiffies = CTUCANFD_MAX_WORK_DELAY_SEC * HZ;
> 
> use min() (or min_t() if needed)
ACK

> 
> > +	return 0;
> > +}
> > +
> > +void ctucan_skb_set_timestamp(struct ctucan_priv *priv, struct sk_buff *skb, u64 timestamp)
> 
> Can you make the priv pointer const?
Yes, will do.

> > +int ctucan_timestamp_init(struct ctucan_priv *priv)
> > +{
> > +	struct cyclecounter *cc = &priv->cc;
> > +
> > +	cc->read = ctucan_timestamp_read;
> > +	cc->mask = CYCLECOUNTER_MASK(priv->timestamp_bit_size);
> > +	cc->shift = 10;
> > +	cc->mult = clocksource_hz2mult(priv->timestamp_freq, cc->shift);
> 
> If you frequency and width is not known, it's probably better not to
> hard code the shift and use clocks_calc_mult_shift() instead:
> 
> | https://elixir.bootlin.com/linux/v5.17.7/source/kernel/time/clocksource.c#L47

Thanks for the hint, I'll look into it.
> 
> There's no need to do the above init on open(), especially in your case.
> I know the mcp251xfd does it this way....In your case, as you parse data
> from DT, it's better to do the parsing in probe and directly do all
> needed calculations and fill the struct cyclecounter there.
> 
> > +
> 
> The following code should stay here.
ACK

> > +	timecounter_init(&priv->tc, &priv->cc, 0);
> 
> You here set the offset of the HW clock to 1.1.1970. The mcp driver sets
> the offset to current time. I think it's convenient to have the current
> time here....What do you think.

I actually searched in the mailing list and read your conversation with
Vincent on timestamps starting from 0 or synced to current time.
https://lore.kernel.org/linux-can/CAMZ6RqL+n4tRy-B-W+fzW5B3QV6Bedrko57pU_0TE023Oxw_5w@mail.gmail.com/

Then I discussed it with Pavel Pisa and he requested to start from 0.
Reasons are that system time can change (NTP, daylight saving time,
user settings etc.), so when it starts from 0 it is clear that it is
"timestamp time".

Are there a lot of CAN drivers synced to system time? I think this would
be a good argument for syncing, to keep things nice and cohesive in
the CAN subsystem.

Overall I wouldn't want to block this patch over such a minutiae.

> > +
> > +	INIT_DELAYED_WORK(&priv->timestamp, ctucan_timestamp_work);
> > +	schedule_delayed_work(&priv->timestamp, priv->work_delay_jiffies);
> > +
> > +	return 0;
> 
> make it void - it cannot fail.
ACK


Thanks again for your review and insights. I hope to make the next patch
version much cleaner.

Kind regards,
Matej
