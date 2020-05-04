Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB5A1C38A4
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 13:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728644AbgEDLyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 07:54:40 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:55391 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726445AbgEDLyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 07:54:39 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588593279; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=r4Vq94vENugKRBMOinIfOx4dU8whdhitU1epPdspy+o=; b=VwQkIGQdzFVT7HyC50lnPN4zR054L9ifaJ9da5GTHVLI+TDaX37BmM5yOPjIlwZb7doN0Np2
 Y9zVxHfER2euf8Zz3WtUyB/JMdenVyvVqHzWGnoL5t0/e7EfPNt3PrTYH3L5xdDpy41PfREi
 z53VdemrSdgP84jTGmpgMLug4fQ=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eb0026c.7f3182a63d50-smtp-out-n04;
 Mon, 04 May 2020 11:54:20 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3D9F2C433CB; Mon,  4 May 2020 11:54:19 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7EF2AC433D2;
        Mon,  4 May 2020 11:54:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7EF2AC433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Michal Kazior <michal.kazior@tieto.com>,
        Maharaja Kennadyrajan <mkenna@codeaurora.org>,
        Wen Gong <wgong@codeaurora.org>,
        Erik Stromdahl <erik.stromdahl@gmail.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 04/15] ath10k: fix gcc-10 zero-length-bounds warnings
References: <20200430213101.135134-1-arnd@arndb.de>
        <20200430213101.135134-5-arnd@arndb.de>
        <49831bca-b9cf-4b9a-1a60-f4289e9c83c0@embeddedor.com>
Date:   Mon, 04 May 2020 14:54:13 +0300
In-Reply-To: <49831bca-b9cf-4b9a-1a60-f4289e9c83c0@embeddedor.com> (Gustavo A.
        R. Silva's message of "Thu, 30 Apr 2020 16:45:32 -0500")
Message-ID: <87368flxui.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> writes:

> Hi Arnd,
>
> On 4/30/20 16:30, Arnd Bergmann wrote:
>> gcc-10 started warning about out-of-bounds access for zero-length
>> arrays:
>> 
>> In file included from drivers/net/wireless/ath/ath10k/core.h:18,
>>                  from drivers/net/wireless/ath/ath10k/htt_rx.c:8:
>> drivers/net/wireless/ath/ath10k/htt_rx.c: In function 'ath10k_htt_rx_tx_fetch_ind':
>> drivers/net/wireless/ath/ath10k/htt.h:1683:17: warning: array subscript 65535 is outside the bounds of an interior zero-length array 'struct htt_tx_fetch_record[0]' [-Wzero-length-bounds]
>>  1683 |  return (void *)&ind->records[le16_to_cpu(ind->num_records)];
>>       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/net/wireless/ath/ath10k/htt.h:1676:29: note: while referencing 'records'
>>  1676 |  struct htt_tx_fetch_record records[0];
>>       |                             ^~~~~~~
>> 
>> The structure was already converted to have a flexible-array member in
>> the past, but there are two zero-length members in the end and only
>> one of them can be a flexible-array member.
>> 
>> Swap the two around to avoid the warning, as 'resp_ids' is not accessed
>> in a way that causes a warning.
>> 
>> Fixes: 3ba225b506a2 ("treewide: Replace zero-length array with flexible-array member")
>> Fixes: 22e6b3bc5d96 ("ath10k: add new htt definitions")
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>>  drivers/net/wireless/ath/ath10k/htt.h | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
>> index e7096a73c6ca..7621f0a3dc77 100644
>> --- a/drivers/net/wireless/ath/ath10k/htt.h
>> +++ b/drivers/net/wireless/ath/ath10k/htt.h
>> @@ -1673,8 +1673,8 @@ struct htt_tx_fetch_ind {
>>  	__le32 token;
>>  	__le16 num_resp_ids;
>>  	__le16 num_records;
>> -	struct htt_tx_fetch_record records[0];
>> -	__le32 resp_ids[]; /* ath10k_htt_get_tx_fetch_ind_resp_ids() */
>> +	__le32 resp_ids[0]; /* ath10k_htt_get_tx_fetch_ind_resp_ids() */
>> +	struct htt_tx_fetch_record records[];
>>  } __packed;
>>  
>>  static inline void *
>> 
>
> The treewide patch is an experimental change and, as this change only applies
> to my -next tree, I will carry this patch in it, so other people don't have
> to worry about this at all.

Gustavo, why do you have ath10k patches in your tree? I prefer that
ath10k patches go through my ath.git tree so that they are reviewed and
tested.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
