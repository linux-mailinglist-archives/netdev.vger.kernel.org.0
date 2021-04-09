Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0044E359100
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 02:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233085AbhDIAlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 20:41:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60892 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbhDIAli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 20:41:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 4C7D24D249441;
        Thu,  8 Apr 2021 17:41:26 -0700 (PDT)
Date:   Thu, 08 Apr 2021 17:41:22 -0700 (PDT)
Message-Id: <20210408.174122.1793350393067698495.davem@davemloft.net>
To:     decui@microsoft.com
Cc:     kuba@kernel.org, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, liuwe@microsoft.com,
        netdev@vger.kernel.org, leon@kernel.org, andrew@lunn.ch,
        bernd@petrovitsch.priv.at, rdunlap@infradead.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v3 net-next] net: mana: Add a driver for Microsoft
 Azure Network Adapter (MANA)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <MW2PR2101MB0892B82CBCF2450D4A82DD50BF739@MW2PR2101MB0892.namprd21.prod.outlook.com>
References: <20210408225840.26304-1-decui@microsoft.com>
        <20210408.164618.597563844564989065.davem@davemloft.net>
        <MW2PR2101MB0892B82CBCF2450D4A82DD50BF739@MW2PR2101MB0892.namprd21.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 08 Apr 2021 17:41:26 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>
Date: Fri, 9 Apr 2021 00:24:51 +0000

>> From: David Miller <davem@davemloft.net>
>> Sent: Thursday, April 8, 2021 4:46 PM
>> ...
>> > +struct gdma_msg_hdr {
>> > +	u32 hdr_type;
>> > +	u32 msg_type;
>> > +	u16 msg_version;
>> > +	u16 hwc_msg_id;
>> > +	u32 msg_size;
>> > +} __packed;
>> > +
>> > +struct gdma_dev_id {
>> > +	union {
>> > +		struct {
>> > +			u16 type;
>> > +			u16 instance;
>> > +		};
>> > +
>> > +		u32 as_uint32;
>> > +	};
>> > +} __packed;
>> 
>> Please don't  use __packed unless absolutely necessary.  It generates
>> suboptimal code (byte at a time
>> accesses etc.) and for many of these you don't even need it.
> 
> In the driver code, all the structs/unions marked by __packed are used to
> talk with the hardware, so I think __packed is necessary here?

It actually isan't in many cases, check with and without the __packed directive
and see if anything chasnges.

> Do you think if it's better if we remove all the __packed, and add
> static_assert(sizeof(struct XXX) == YYY) instead? e.g.
> 
> @@ -105,7 +105,8 @@ struct gdma_msg_hdr {
>         u16 msg_version;
>         u16 hwc_msg_id;
>         u32 msg_size;
> -} __packed;
> +};
> +static_assert(sizeof(struct gdma_msg_hdr) == 16);

This won't make sure the structure member offsets are what you expect.

I think you'll have to go through the structures one-by-one by hand to
figure out which ones really require the __packed attribute and which do not.

Thank you.
