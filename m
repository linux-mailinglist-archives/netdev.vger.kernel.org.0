Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 890FEDDCFF
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 08:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbfJTGSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 02:18:34 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:57224 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfJTGSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 02:18:33 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 72B4560D52; Sun, 20 Oct 2019 06:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571552312;
        bh=Q9+5wS+TPeabeVxkWEkwzYGbJK3BhjhTAvD4VfK2Chk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=cZyW+1CM1NSGdUdRiMHlW/UPWIxx6ztSzBtxDOyfspPDcTZfmSoiZYIbRiX2fHEJj
         OLim2yl9MdMpAH4lcghYnJTGxWAToWu581MCwL2q3fjs+sGdKzkTusGJ6jaDmBFgzm
         zbxo0CDloNezzQ7aYiCtJ6yw+sgmUrcoJf77PvJ0=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DF74860BFA;
        Sun, 20 Oct 2019 06:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571552311;
        bh=Q9+5wS+TPeabeVxkWEkwzYGbJK3BhjhTAvD4VfK2Chk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=JxHoOUp4Q9gSTQgs9tH2kkjOaSSubWWLbaH8cCYPTXO9YuV4+Ufihal/9Z9xyigPI
         jqxbhn2kG/C29pQSvE9jt9Hh6cRiql/eCJeEJm5YZbqCxaGHzqct33nzpLUrGuCHQ2
         ALfqhVG5MJyIWl2e1V9xkHTSr/jcgcnG6WR8PUhU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DF74860BFA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Laura Abbott <labbott@redhat.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicolas Waisman <nico@semmle.com>
Subject: Re: [PATCH v2] rtlwifi: Fix potential overflow on P2P code
References: <20191018114321.13131-1-labbott@redhat.com>
        <871rv9xb2l.fsf@kamboji.qca.qualcomm.com>
        <51b732bf-4575-d7d1-daff-ec1c2171a303@redhat.com>
Date:   Sun, 20 Oct 2019 09:18:26 +0300
In-Reply-To: <51b732bf-4575-d7d1-daff-ec1c2171a303@redhat.com> (Laura Abbott's
        message of "Sat, 19 Oct 2019 15:02:47 -0400")
Message-ID: <878spgvt1p.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Laura Abbott <labbott@redhat.com> writes:

> On 10/19/19 6:51 AM, Kalle Valo wrote:
>> Laura Abbott <labbott@redhat.com> writes:
>>
>>> Nicolas Waisman noticed that even though noa_len is checked for
>>> a compatible length it's still possible to overrun the buffers
>>> of p2pinfo since there's no check on the upper bound of noa_num.
>>> Bound noa_num against P2P_MAX_NOA_NUM.
>>>
>>> Reported-by: Nicolas Waisman <nico@semmle.com>
>>> Signed-off-by: Laura Abbott <labbott@redhat.com>
>>> ---
>>> v2: Use P2P_MAX_NOA_NUM instead of erroring out.
>>> ---
>>>   drivers/net/wireless/realtek/rtlwifi/ps.c | 6 ++++++
>>>   1 file changed, 6 insertions(+)
>>>
>>> diff --git a/drivers/net/wireless/realtek/rtlwifi/ps.c b/drivers/net/wireless/realtek/rtlwifi/ps.c
>>> index 70f04c2f5b17..fff8dda14023 100644
>>> --- a/drivers/net/wireless/realtek/rtlwifi/ps.c
>>> +++ b/drivers/net/wireless/realtek/rtlwifi/ps.c
>>> @@ -754,6 +754,9 @@ static void rtl_p2p_noa_ie(struct ieee80211_hw *hw, void *data,
>>>   				return;
>>>   			} else {
>>>   				noa_num = (noa_len - 2) / 13;
>>> +				if (noa_num > P2P_MAX_NOA_NUM)
>>> +					noa_num = P2P_MAX_NOA_NUM;
>>> +
>>>   			}
>>>   			noa_index = ie[3];
>>>   			if (rtlpriv->psc.p2p_ps_info.p2p_ps_mode ==
>>> @@ -848,6 +851,9 @@ static void rtl_p2p_action_ie(struct ieee80211_hw *hw, void *data,
>>>   				return;
>>>   			} else {
>>>   				noa_num = (noa_len - 2) / 13;
>>> +				if (noa_num > P2P_MAX_NOA_NUM)
>>> +					noa_num = P2P_MAX_NOA_NUM;
>>
>> IMHO using min() would be cleaner, but I'm fine with this as well. Up to
>> you.
>>
>
> I believe the intention is to re-write this anyway so I'd prefer to
> just get this in given the uptick this issue seems to have gotten.

Ok, I'll queue this to v5.4.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
