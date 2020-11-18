Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B4A2B8641
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 22:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgKRVEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 16:04:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:6174 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbgKRVEA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 16:04:00 -0500
IronPort-SDR: fyi/16dQM6yUcL6g0IraIosGok/vAxYm0qtgAW0DzslYESv5Ncximqo95f477SpzlZKZj28jea
 9MBrdVqLq2KA==
X-IronPort-AV: E=McAfee;i="6000,8403,9809"; a="167676673"
X-IronPort-AV: E=Sophos;i="5.77,488,1596524400"; 
   d="scan'208";a="167676673"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 13:03:59 -0800
IronPort-SDR: YgJlDS1vGrzQgUrbmr30qNtGrh2aic+9Cz3O/q5JFbpDqs6OQb4tly74Q5eOND4dwPEKYpEC8x
 KbF/NmXfl22A==
X-IronPort-AV: E=Sophos;i="5.77,488,1596524400"; 
   d="scan'208";a="534483998"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.69.244]) ([10.212.69.244])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 13:03:59 -0800
Subject: Re: [PATCH net-next v2 3/3] ptp: ptp_ines: use new PTP_MSGTYPE_*
 define(s)
To:     Christian Eggers <ceggers@arri.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
References: <20201118162203.24293-1-ceggers@arri.de>
 <20201118162203.24293-4-ceggers@arri.de>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <5809d8e0-4848-004c-1551-691cd8bfbd67@intel.com>
Date:   Wed, 18 Nov 2020 13:03:56 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201118162203.24293-4-ceggers@arri.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/18/2020 8:22 AM, Christian Eggers wrote:
> Remove driver internal defines for this.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Cc: Richard Cochran <richardcochran@gmail.com>
> Cc: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>  drivers/ptp/ptp_ines.c | 19 +++++++------------
>  1 file changed, 7 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/ptp/ptp_ines.c b/drivers/ptp/ptp_ines.c
> index 4700ffbdfced..6c7c2843ba0b 100644
> --- a/drivers/ptp/ptp_ines.c
> +++ b/drivers/ptp/ptp_ines.c
> @@ -108,11 +108,6 @@ MODULE_LICENSE("GPL");
>  #define MESSAGE_TYPE_P_DELAY_RESP	3
>  #define MESSAGE_TYPE_DELAY_REQ		4
>  
> -#define SYNC				0x0
> -#define DELAY_REQ			0x1
> -#define PDELAY_REQ			0x2
> -#define PDELAY_RESP			0x3
> -
>  static LIST_HEAD(ines_clocks);
>  static DEFINE_MUTEX(ines_clocks_lock);
>  
> @@ -683,9 +678,9 @@ static bool is_sync_pdelay_resp(struct sk_buff *skb, int type)
>  
>  	msgtype = ptp_get_msgtype(hdr, type);
>  
> -	switch ((msgtype & 0xf)) {
> -	case SYNC:
> -	case PDELAY_RESP:
> +	switch (msgtype) {
> +	case PTP_MSGTYPE_SYNC:
> +	case PTP_MSGTYPE_PDELAY_RESP:

This has a functional change of no longer discarding the higher bits of
msgtype. While this may be correct, I think it should at least be called
out as to why in the commit message.

>  		return true;
>  	default:
>  		return false;
> @@ -696,13 +691,13 @@ static u8 tag_to_msgtype(u8 tag)
>  {
>  	switch (tag) {
>  	case MESSAGE_TYPE_SYNC:
> -		return SYNC;
> +		return PTP_MSGTYPE_SYNC;
>  	case MESSAGE_TYPE_P_DELAY_REQ:
> -		return PDELAY_REQ;
> +		return PTP_MSGTYPE_PDELAY_REQ;
>  	case MESSAGE_TYPE_P_DELAY_RESP:
> -		return PDELAY_RESP;
> +		return PTP_MSGTYPE_PDELAY_RESP;
>  	case MESSAGE_TYPE_DELAY_REQ:
> -		return DELAY_REQ;
> +		return PTP_MSGTYPE_DELAY_REQ;
>  	}
>  	return 0xf;
>  }
> 
