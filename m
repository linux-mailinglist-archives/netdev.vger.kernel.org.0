Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0699844A64A
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 06:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239592AbhKIF3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 00:29:40 -0500
Received: from mga07.intel.com ([134.134.136.100]:20273 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236593AbhKIF3j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 00:29:39 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10162"; a="295819953"
X-IronPort-AV: E=Sophos;i="5.87,219,1631602800"; 
   d="scan'208";a="295819953"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 21:26:53 -0800
X-IronPort-AV: E=Sophos;i="5.87,219,1631602800"; 
   d="scan'208";a="533569381"
Received: from rmarti10-mobl1.amr.corp.intel.com (HELO [10.212.187.241]) ([10.212.187.241])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 21:26:53 -0800
Message-ID: <27811a97-6368-dab2-5163-cbd0169b8666@linux.intel.com>
Date:   Mon, 8 Nov 2021 21:26:37 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH v2 00/14] net: wwan: t7xx: PCIe driver for MediaTek M.2
 modem
Content-Language: en-US
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        mika.westerberg@linux.intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        suresh.nagaraj@intel.com
References: <20211101035635.26999-1-ricardo.martinez@linux.intel.com>
 <CAHNKnsSW15BXq7WXmyG7SrrNA+Rqp_bKVneVNrpegJvDrh688Q@mail.gmail.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <CAHNKnsSW15BXq7WXmyG7SrrNA+Rqp_bKVneVNrpegJvDrh688Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/6/2021 11:10 AM, Sergey Ryazanov wrote:
> Hello Ricardo,
> 
> On Mon, Nov 1, 2021 at 6:57 AM Ricardo Martinez
> <ricardo.martinez@linux.intel.com> wrote:
...
> Nice work! The driver generally looks good for me. But at the same
> time the driver looks a bit raw, needs some style and functionality
> improvements, and a lot of cleanup. Please find general thoughts below
> and per-patch comments.
Thanks for the feedback Sergey, we will work on it.

> 
> A one nitpick that is common for the entire series. Please consider
> using a common prefix for all driver function names (e.g. t7xx_) to
> make them more specific. This should improve the code readability.
> Thus, any reader will know for sure that the called functions belong
> to the driver, and not to a generic kernel API. E.g. use the
> t7xx_cldma_hw_init() name for the  CLDMA initialization function
> instead of the too generic cldma_hw_init() name, etc.
Does this apply to static functions as well?

> 
> Interestingly, that you are using the common 't7xx_' prefix for all
> driver file names. This is Ok, but it does not add to the specifics as
> all driver files are already located in a common directory with the
> specific name. But function names at the same time lack a common
> prefix.
> 
> Another common drawback is that the driver should break as soon as two
> modems are connected simultaneously. This should happen due to the use
> of multiple _global_ variables that keeps pointers to a modem runtime
> state. Out of curiosity, did you test the driver with two or more
> modems connected simultaneously?
We haven't tested such configurations, we are focusing on platforms with one single modem.

> 
> Next, the driver entirely lacks the multibyte field endians handling.
> Looks like it will be unable to run on a big-endians CPU. To fix this,
> it is needed to find all the structures that are passed to the modem
> and replace the multibyte fields of types u16/u32 with __le16/__le32.
> Then examine all the field accesses and use
> cpu_to_le{16,32}()/le{16,32}_to_cpu() to update/read field contents.
> As soon as you change the types to __le16/__le32, sparse (a static
> analyzing utility) will warn you about every unsafe field access. Just
> build your kernel with make C=1.
> 
> Ricardo, please consider submitting at the next iteration a patch
> series with the driver that will be cleaned from debug stuff and
> questionable optimizations. Just a bare minimum functional: AT/MBIM
> control ports and network interface for data communications. This will
> cut the code in half. What will greatly facilitate the reviewing
> process. And then extend the driver functionality with follow up
> patches.
> 
> --
> Sergey
> 
