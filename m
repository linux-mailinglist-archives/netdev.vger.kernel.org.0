Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A286F03FF
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 18:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390248AbfKERTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 12:19:22 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:43104 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388177AbfKERTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 12:19:22 -0500
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 21E6213C358;
        Tue,  5 Nov 2019 09:19:21 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 21E6213C358
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1572974361;
        bh=V8NJR7727iNB0uRPImQP0tHz/e9UqOWH40a21R0azV8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=anxDgG5kmOBLuJloing6yzi9LbtxzXQYpDKK0XrP67AxTrj8ubzPeNlR5tTNMDzCt
         IbBaU/HYUSFPP3eKE2wSsVTXmNApL4ZDVf0DIHueRsoC+4Efvw6ZkGHWOn/nlULJ9Q
         r/LKJCq93/fqCY303ZOPuUAfHSdCLRcw7RWN7+xE=
Subject: Re: [PATCH net-next] ath10k: fix RX of frames with broken FCS in
 monitor mode
To:     =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        ath10k@lists.infradead.org
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Linus_L=c3=bcssing?= <ll@simonwunderlich.de>
References: <20191105164932.11799-1-linus.luessing@c0d3.blue>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <927cea69-7afc-5c35-df8d-9813392e8928@candelatech.com>
Date:   Tue, 5 Nov 2019 09:19:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20191105164932.11799-1-linus.luessing@c0d3.blue>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/5/19 8:49 AM, Linus Lüssing wrote:
> From: Linus Lüssing <ll@simonwunderlich.de>
> 
> So far, frames were forwarded regardless of the FCS correctness leading
> to userspace applications listening on the monitor mode interface to
> receive potentially broken frames, even with the "fcsfail" flag unset.
> 
> By default, with the "fcsfail" flag of a monitor mode interface
> unset, frames with FCS errors should be dropped. With this patch, the
> fcsfail flag is taken into account correctly.
> 
> Cc: Simon Wunderlich <sw@simonwunderlich.de>
> Signed-off-by: Linus Lüssing <ll@simonwunderlich.de>
> ---
> This was tested on an Open Mesh A41 device, featuring a QCA4019. And
> with this firmware:
> 
> https://www.candelatech.com/downloads/ath10k-4019-10-4b/firmware-5-ct-full-community-12.bin-lede.011
> 
> But from looking at the code it seems that the vanilla ath10k has the
> same issue, therefore submitting it here.
> 
> Changelog RFC->v1:
> 
> * removed "ar->monitor" check
> * added a debug counter

Thanks for adding the counter.  Since it us u32, I doubt you need the spin lock
below?

--Ben

> +	if (!(ar->filter_flags & FIF_FCSFAIL) &&
> +	    status->flag & RX_FLAG_FAILED_FCS_CRC) {
> +		spin_lock_bh(&ar->data_lock);
> +		ar->stats.rx_crc_err_drop++;
> +		spin_unlock_bh(&ar->data_lock);
> +
> +		dev_kfree_skb_any(skb);
> +		return;
> +	}
> +
>   	ath10k_dbg(ar, ATH10K_DBG_DATA,
>   		   "rx skb %pK len %u peer %pM %s %s sn %u %s%s%s%s%s%s %srate_idx %u vht_nss %u freq %u band %u flag 0x%x fcs-err %i mic-err %i amsdu-more %i\n",
>   		   skb,
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

