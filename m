Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 204422246D5
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 01:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgGQXOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 19:14:00 -0400
Received: from mga07.intel.com ([134.134.136.100]:61309 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbgGQXOA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 19:14:00 -0400
IronPort-SDR: TQ8ZymGUojkbdZmBriuBgkuRZ0RuytuGe4tNew4r8KuU23Zkk+THfHa4P0pUPIGc3uJy4gTisW
 jOnb6YGPw8OA==
X-IronPort-AV: E=McAfee;i="6000,8403,9685"; a="214392391"
X-IronPort-AV: E=Sophos;i="5.75,364,1589266800"; 
   d="scan'208";a="214392391"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2020 16:13:59 -0700
IronPort-SDR: ktumApWDNCNsE/vkzMBH4Tj2Sp4P/oHRybohAmeFYLjaNpm5de5ry59CYhYewoGVWj4w/XYgLa
 HKoq7/3Qbyng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,364,1589266800"; 
   d="scan'208";a="461015013"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.94.160]) ([10.212.94.160])
  by orsmga005.jf.intel.com with ESMTP; 17 Jul 2020 16:13:58 -0700
Subject: Re: [PATCH net-next 0/3] Document more PTP timestamping known quirks
To:     Vladimir Oltean <olteanv@gmail.com>,
        Sergey Organov <sorganov@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        richardcochran@gmail.com, linux-doc@vger.kernel.org
References: <20200717161027.1408240-1-olteanv@gmail.com>
 <87imelj14p.fsf@osv.gnss.ru> <20200717215719.nhuaak2xu4fwebqp@skbuf>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <ccabed4c-2b4c-05c6-650e-7783acfa50b3@intel.com>
Date:   Fri, 17 Jul 2020 16:13:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200717215719.nhuaak2xu4fwebqp@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/17/2020 2:57 PM, Vladimir Oltean wrote:
> On Sat, Jul 18, 2020 at 12:13:42AM +0300, Sergey Organov wrote:
>> Vladimir Oltean <olteanv@gmail.com> writes:
>>
>>> I've tried to collect and summarize the conclusions of these discussions:
>>> https://patchwork.ozlabs.org/project/netdev/patch/20200711120842.2631-1-sorganov@gmail.com/
>>> https://patchwork.ozlabs.org/project/netdev/patch/20200710113611.3398-5-kurt@linutronix.de/
>>> which were a bit surprising to me. Make sure they are present in the
>>> documentation.
>>
>> As one of participants of these discussions, I'm afraid I incline to
>> alternative approach to solving the issues current design has than the one
>> you advocate in these patch series.
>>
>> I believe its upper-level that should enforce common policies like
>> handling hw time stamping at outermost capable device, not random MAC
>> driver out there.
>>
>> I'd argue that it's then upper-level that should check PHY features, and
>> then do not bother MAC with ioctl() requests that MAC should not handle
>> in given configuration. This way, the checks for phy_has_hwtstamp()
>> won't be spread over multiple MAC drivers and will happily sit in the
>> upper-level ioctl() handler.
>>
>> In other words, I mean that it's approach taken in ethtool that I tend
>> to consider being the right one.
>>
>> Thanks,
>> -- Sergey
> 
> Concretely speaking, what are you going to do for
> skb_defer_tx_timestamp() and skb_defer_rx_timestamp()? Not to mention
> subtle bugs like SKBTX_IN_PROGRESS. If you don't address those, it's
> pointless to move the phy_has_hwtstamp() check to net/core/dev_ioctl.c.
> 
> The only way I see to fix the bug is to introduce a new netdev flag,
> NETIF_F_PHY_HWTSTAMP or something like that. Then I'd grep for all
> occurrences of phy_has_hwtstamp() in the kernel (which currently amount
> to a whopping 2 users, 3 with your FEC "fix"), and declare this
> netdevice flag in their list of features. Then, phy_has_hwtstamp() and
> phy_has_tsinfo() and what not can be moved to generic places (or at
> least, I think they can), and those places could proceed to advertise
> and enable PHY timestamping only if the MAC declared itself ready. But,
> it is a bit strange to introduce a netdev flag just to fix a bug, I
> think.
> 

This approach doesn't seem bad to me. We then document that
NETIF_F_PHY_HWTSTAMP should only set of the correct conditions are met.

> Thanks,
> -Vladimir
> 
