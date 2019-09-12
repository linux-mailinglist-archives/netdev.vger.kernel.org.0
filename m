Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89529B0DF8
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 13:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731146AbfILLhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 07:37:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56474 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730268AbfILLhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 07:37:55 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5C7F3142387A4;
        Thu, 12 Sep 2019 04:37:54 -0700 (PDT)
Date:   Thu, 12 Sep 2019 13:37:53 +0200 (CEST)
Message-Id: <20190912.133753.1473374980190418320.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        richardcochran@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 3/7] net: dsa: sja1105: Switch to hardware
 operations for PTP
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CA+h21hoBQ=4pSCgwcYWErA7k7BQ02LMun_qZ476-bB4eY6RjjQ@mail.gmail.com>
References: <20190910013501.3262-4-olteanv@gmail.com>
        <20190912.121203.1106283271122334199.davem@davemloft.net>
        <CA+h21hoBQ=4pSCgwcYWErA7k7BQ02LMun_qZ476-bB4eY6RjjQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Sep 2019 04:37:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Thu, 12 Sep 2019 11:17:11 +0100

> Hi Dave,
> 
> On 12/09/2019, David Miller <davem@davemloft.net> wrote:
>> From: Vladimir Oltean <olteanv@gmail.com>
>> Date: Tue, 10 Sep 2019 04:34:57 +0300
>>
>>>  static int sja1105_ptp_adjfine(struct ptp_clock_info *ptp, long
>>> scaled_ppm)
>>>  {
>>>  	struct sja1105_private *priv = ptp_to_sja1105(ptp);
>>> +	const struct sja1105_regs *regs = priv->info->regs;
>>>  	s64 clkrate;
>>> +	int rc;
>>  ..
>>> -static int sja1105_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
>>> -{
>>> -	struct sja1105_private *priv = ptp_to_sja1105(ptp);
>>> +	rc = sja1105_spi_send_int(priv, SPI_WRITE, regs->ptpclkrate,
>>> +				  &clkrate, 4);
>>
>> You're sending an arbitrary 4 bytes of a 64-bit value.  This works on little
>> endian
>> but will not on big endian.
>>
>> Please properly copy this clkrate into a "u32" variable and pass that into
>> sja1105_spi_send_int().
>>
>> It also seems to suggest that you want to use abs() to perform that weird
>> centering around 1 << 31 calculation.
>>
>> Thank you.
>>
> 
> It looks 'wrong' but it isn't. The driver uses the 'packing' framework
> (lib/packing.c) which is endian-agnostic (converts between CPU and
> peripheral endianness) and operates on u64 as the CPU word size. On
> the contrary, u32 would not work with the 'packing' API in its current
> form, but I don't see yet any reasons to extend it (packing64,
> packing32 etc).

That's extremely unintuitive and makes auditing patches next to impossible.
