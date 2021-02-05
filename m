Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236B8310FCB
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 19:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbhBEQj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 11:39:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40542 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233798AbhBEQhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 11:37:31 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1l85hG-0006bj-Ty; Fri, 05 Feb 2021 18:19:10 +0000
Subject: Re: Potential invalid ~ operator in net/mac80211/cfg.c
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <4bb65f2f-48f9-7d9c-ab2e-15596f15a4d8@canonical.com>
 <15f435a791b0c4b853c8c6b284042c7057d6efaf.camel@sipsolutions.net>
From:   Colin Ian King <colin.king@canonical.com>
Message-ID: <1383c6f1-1317-daed-ecc7-e5cc3f309c41@canonical.com>
Date:   Fri, 5 Feb 2021 18:19:10 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <15f435a791b0c4b853c8c6b284042c7057d6efaf.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/02/2021 18:05, Johannes Berg wrote:
> Hi Colin,
> 
>> while working through a backlog of older static analysis reports from
>> Coverity
> 
> So ... yeah. Every time I look at Coverity (not frequently, I must
> admit) I see the same thing, and get confused.
> 
>> I found an interesting use of the ~ operator that looks
>> incorrect to me in function ieee80211_set_bitrate_mask():
>>
>>                 for (j = 0; j < IEEE80211_HT_MCS_MASK_LEN; j++) {
>>                         if (~sdata->rc_rateidx_mcs_mask[i][j]) {
>>                                 sdata->rc_has_mcs_mask[i] = true;
>>                                 break;
>>                         }
>>                 }
>>
>>                 for (j = 0; j < NL80211_VHT_NSS_MAX; j++) {
>>                         if (~sdata->rc_rateidx_vht_mcs_mask[i][j]) {
>>                                 sdata->rc_has_vht_mcs_mask[i] = true;
>>                                 break;
>>                         }
>>                 }
>>
>> For the ~ operator in both if stanzas, Coverity reports:
>>
>> Logical vs. bitwise operator (CONSTANT_EXPRESSION_RESULT)
>> logical_vs_bitwise:
>>
>> ~sdata->rc_rateidx_mcs_mask[i][j] is always 1/true regardless of the
>> values of its operand. This occurs as the logical operand of if.
>>     Did you intend to use ! rather than ~?
>>
>> I've checked the results of this and it does seem that ~ is incorrect
>> and always returns true for the if expression. So it probably should be
>> !, but I'm not sure if I'm missing something deeper here and wondering
>> why this has always worked.
> 
> But is it really always true?
> 
> I _think_ it was intended to check that it's not 0xffffffff or
> something?
> 
> https://lore.kernel.org/linux-wireless/516C0C7F.3000204@openwrt.org/
> 
> But maybe that isn't actually quite right due to integer promotion?
> OTOH, that's a u8, so it should do the ~ in u8 space, and then compare
> to 0 also?

rc_rateidx_vht_mcs_mask is a u64, so I think the expression could be
expressed as:

if ((uint16_t)~sdata->rc_rateidx_mcs_mask[i][j]) ..

this is only true if all the 16 bits in the mask are 0xffff

> 
> johannes
> 

