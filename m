Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9A3E3DF460
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 20:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238703AbhHCSLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 14:11:40 -0400
Received: from smtprelay0214.hostedemail.com ([216.40.44.214]:48354 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238708AbhHCSLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 14:11:36 -0400
Received: from omf13.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 03FE0180A5AE4;
        Tue,  3 Aug 2021 18:11:24 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf13.hostedemail.com (Postfix) with ESMTPA id 901B21124F6;
        Tue,  3 Aug 2021 18:11:22 +0000 (UTC)
Message-ID: <39b42c868d1aa01bb421733aac32f072dc85e393.camel@perches.com>
Subject: Re: [PATCH 3/3] rtlwifi: rtl8192de: fix array size limit in for-loop
From:   Joe Perches <joe@perches.com>
To:     Colin King <colin.king@canonical.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 03 Aug 2021 11:11:21 -0700
In-Reply-To: <20210803144949.79433-3-colin.king@canonical.com>
References: <20210803144949.79433-1-colin.king@canonical.com>
         <20210803144949.79433-3-colin.king@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 901B21124F6
X-Spam-Status: No, score=-0.81
X-Stat-Signature: f43mm98h5s78yd93cws6ugihst4azt4w
X-Rspamd-Server: rspamout02
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18QSI7hc6+5FTVBkzOo7iXdxLGDbZcQUPY=
X-HE-Tag: 1628014282-693020
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-08-03 at 15:49 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the size of the entire array is being used in a for-loop
> for the element count. While this works since the elements are u8
> sized, it is preferred to use ARRAY_SIZE to get the element count
> of the array.
[]
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
[]
> @@ -1366,7 +1366,7 @@ u8 rtl92d_get_rightchnlplace_for_iqk(u8 chnl)
>  	u8 place = chnl;
> 
>  	if (chnl > 14) {
> -		for (place = 14; place < sizeof(channel_all); place++) {
> +		for (place = 14; place < ARRAY_SIZE(channel_all); place++) {
>  			if (channel_all[place] == chnl)
>  				return place - 13;
>  		}

Thanks.

It seems a relatively common copy/paste use in rtlwifi

$ git grep -P -n 'for\b.*<\s*sizeof\s*\(\s*\w+\w*\)\s*;' drivers/net/wireless/realtek/rtlwifi/
drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c:893:               for (place = 14; place < sizeof(channel5g); place++) {
drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c:1368:              for (place = 14; place < sizeof(channel_all); place++) {
drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c:2430:      for (i = 0; i < sizeof(channel5g); i++)
drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c:2781:              for (place = 14; place < sizeof(channel_all); place++) {
drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c:2170:              for (place = 14; place < sizeof(channel_all); place++) {
drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:3610:              for (place = 14; place < sizeof(channel_all); place++)



