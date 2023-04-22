Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5508D6EB888
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 12:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjDVKSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 06:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbjDVKSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 06:18:16 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9056B1FD6;
        Sat, 22 Apr 2023 03:18:08 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1682158685; bh=yqiaxdewJrN1/O7q8yubLYta1s4c/hqngkUF7U3apls=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=ohwAnfUVFQ6rIhKYei+EWGQuqNFD18sVNEM43Qdn4/7vF+eWx1RIyso7InCLDuira
         HLd2lRvqx4S/pfYE3adERhu4yk4GwCo0oeML+/363WG9c949KXTCrCQZm611tb3Zrs
         an59cJDKIYeH5WoYLaJxIkqAGz6UvV41SE50h6WLaO1KDPcMuRRDtVkBnoqgtM985n
         6GKNqvGPmKNDu/Z+3IbUx0WNpaCy0LHCdtOVVZvahII3k1gVMLs2r94IvUUgYkF2B/
         YGLGjCrWLjlfZoPyU2mAyEOZohPZiWMXOhH4wTM94jKEdUvLbe2dS72UNA4saOimGO
         iwqHAOj7TpoIA==
To:     Simon Horman <simon.horman@corigine.com>,
        Peter Seiderer <ps.report@gmx.net>
Cc:     linux-wireless@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W . Linville" <linville@tuxdriver.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gregg Wonderly <greggwonderly@seqtechllc.com>
Subject: Re: [PATCH v1] wifi: ath9k: fix AR9003 mac hardware hang check
 register offset calculation
In-Reply-To: <ZEOf7LXAkdLR0yFI@corigine.com>
References: <20230420204316.30475-1-ps.report@gmx.net>
 <ZEOf7LXAkdLR0yFI@corigine.com>
Date:   Sat, 22 Apr 2023 12:18:03 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87bkjgmd9g.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simon Horman <simon.horman@corigine.com> writes:

> On Thu, Apr 20, 2023 at 10:43:16PM +0200, Peter Seiderer wrote:
>> Fix ath9k_hw_verify_hang()/ar9003_hw_detect_mac_hang() register offset
>> calculation (do not overflow the shift for the second register/queues
>> above five, use the register layout described in the comments above
>> ath9k_hw_verify_hang() instead).
>> 
>> Fixes: 222e04830ff0 ("ath9k: Fix MAC HW hang check for AR9003")
>> 
>> Reported-by: Gregg Wonderly <greggwonderly@seqtechllc.com>
>> Link: https://lore.kernel.org/linux-wireless/E3A9C354-0CB7-420C-ADEF-F0177FB722F4@seqtechllc.com/
>> Signed-off-by: Peter Seiderer <ps.report@gmx.net>
>> ---
>> Notes:
>>   - tested with MikroTik R11e-5HnD/Atheros AR9300 Rev:4 (lspci: 168c:0033
>>     Qualcomm Atheros AR958x 802.11abgn Wireless Network Adapter (rev 01))
>>     card
>> ---
>>  drivers/net/wireless/ath/ath9k/ar9003_hw.c | 27 ++++++++++++++--------
>>  1 file changed, 18 insertions(+), 9 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
>> index 4f27a9fb1482..0ccf13a35fb4 100644
>> --- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
>> +++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
>> @@ -1099,17 +1099,22 @@ static bool ath9k_hw_verify_hang(struct ath_hw *ah, unsigned int queue)
>>  {
>>  	u32 dma_dbg_chain, dma_dbg_complete;
>>  	u8 dcu_chain_state, dcu_complete_state;
>> +	unsigned int dbg_reg, reg_offset;
>>  	int i;
>>  
>> -	for (i = 0; i < NUM_STATUS_READS; i++) {
>> -		if (queue < 6)
>> -			dma_dbg_chain = REG_READ(ah, AR_DMADBG_4);
>> -		else
>> -			dma_dbg_chain = REG_READ(ah, AR_DMADBG_5);
>> +	if (queue < 6) {
>> +		dbg_reg = AR_DMADBG_4;
>> +		reg_offset = i * 5;
>
> Hi Peter,
>
> unless my eyes are deceiving me, i is not initialised here.

Nice catch! Hmm, I wonder why my test compile didn't complain about
that? Or maybe it did and I overlooked it? Anyway, Kalle, I already
delegated this patch to you in patchwork, so please drop it and I'll try
to do better on reviewing the next one :)

-Toke
