Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8F60DA304
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 03:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395436AbfJQBYs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 16 Oct 2019 21:24:48 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:48123 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389094AbfJQBYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 21:24:48 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x9H1OSdP000991, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x9H1OSdP000991
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Oct 2019 09:24:28 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Thu, 17 Oct
 2019 09:24:27 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Laura Abbott <labbott@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicolas Waisman <nico@semmle.com>
Subject: RE: [PATCH] rtlwifi: Fix potential overflow on P2P code
Thread-Topic: [PATCH] rtlwifi: Fix potential overflow on P2P code
Thread-Index: AQHVhGRS0Eb+pvqKg0iKoQwx5Knt06deCEZw
Date:   Thu, 17 Oct 2019 01:24:26 +0000
Message-ID: <5B2DA6FDDF928F4E855344EE0A5C39D1D5C84368@RTITMBSVM04.realtek.com.tw>
References: <20191016205716.2843-1-labbott@redhat.com>
In-Reply-To: <20191016205716.2843-1-labbott@redhat.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.95]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-owner@vger.kernel.org] On Behalf
> Of Laura Abbott
> Sent: Thursday, October 17, 2019 4:57 AM
> To: Pkshih; Kalle Valo
> Cc: Laura Abbott; David S. Miller; linux-wireless@vger.kernel.org; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; Nicolas Waisman
> Subject: [PATCH] rtlwifi: Fix potential overflow on P2P code
> 
> Nicolas Waisman noticed that even though noa_len is checked for
> a compatible length it's still possible to overrun the buffers
> of p2pinfo since there's no check on the upper bound of noa_num.
> Bounds check noa_num against P2P_MAX_NOA_NUM.
> 
> Reported-by: Nicolas Waisman <nico@semmle.com>
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---
> Compile tested only as this was reported to the security list.
> ---
>  drivers/net/wireless/realtek/rtlwifi/ps.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/ps.c b/drivers/net/wireless/realtek/rtlwifi/ps.c
> index 70f04c2f5b17..c5cff598383d 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/ps.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/ps.c
> @@ -754,6 +754,13 @@ static void rtl_p2p_noa_ie(struct ieee80211_hw *hw, void *data,
>  				return;
>  			} else {
>  				noa_num = (noa_len - 2) / 13;
> +				if (noa_num > P2P_MAX_NOA_NUM) {
> +					RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
> +						 "P2P notice of absence: invalid noa_num.%d\n",
> +						 noa_num);
> +					return;

As the discussion at <security@kernel.org>, I think it'd be better to use
the min between noa_num and P2P_MAX_NOA_NUM, and fall through the code instead
of return. Because ignore all NoA isn't better than apply two of them.


> +				}
> +
>  			}
>  			noa_index = ie[3];
>  			if (rtlpriv->psc.p2p_ps_info.p2p_ps_mode ==
> @@ -848,6 +855,13 @@ static void rtl_p2p_action_ie(struct ieee80211_hw *hw, void *data,
>  				return;
>  			} else {
>  				noa_num = (noa_len - 2) / 13;
> +				if (noa_num > P2P_MAX_NOA_NUM) {
> +					RT_TRACE(rtlpriv, COMP_FW, DBG_LOUD,
> +						 "P2P notice of absence: invalid noa_len.%d\n",
> +						 noa_len);
> +					return;
> +
> +				}
>  			}
>  			noa_index = ie[3];
>  			if (rtlpriv->psc.p2p_ps_info.p2p_ps_mode ==
> --
> 2.21.0

