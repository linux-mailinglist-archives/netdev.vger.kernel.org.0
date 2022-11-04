Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73130619C9B
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 17:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbiKDQJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 12:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiKDQJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 12:09:53 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9D94730B;
        Fri,  4 Nov 2022 09:09:52 -0700 (PDT)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 9745D806F4;
        Fri,  4 Nov 2022 17:09:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1667578190;
        bh=b/TZ9KPtAsv5iGV9pnB4CCAXT4pqWPk7Y30tNUj3NA8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ta35BkRsmt2SKYIV9tyAPQfnsaefH75qgjtMiz2+2hPnTfCWvVCxP/kLEI6WXj3QI
         wh71DzYw8ie0QD6lmJfbG/iU8+3ETdjaKB8IQml4o4JvvEEdxOu8BWt7BGYrsQA3Jk
         Cb3+bK7+tw4DeNUEbd5vDCBOBtYkwIFj8HSLI6j8VuU2lmMrhpVTa7Tru0MII2Fe4G
         JFHBMXq/4kwyVGpDOmjchOIpwnBsLCgq+iIBYUET29TN+TFbANNaCPiW3GXc2YPCTj
         +unQai3+jz4XZ4HoNidSaUC+BuTukIcYQlNK89xDbQyscnTvR2C0NImYIMekbPvNry
         w3Tjx1PziNWrg==
Message-ID: <a3ef782d-9c85-d752-52b5-589d5e1f1bd5@denx.de>
Date:   Fri, 4 Nov 2022 17:09:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v3] wifi: rsi: Fix handling of 802.3 EAPOL frames sent via
 control port
Content-Language: en-US
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc:     Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Angus Ainslie <angus@akkea.ca>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Martin Kepplinger <martink@posteo.de>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org
References: <20221104155841.213387-1-marex@denx.de>
 <cf7da8e9a135fee1a9ac0e8f768a2a13bbba058d.camel@sipsolutions.net>
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <cf7da8e9a135fee1a9ac0e8f768a2a13bbba058d.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/4/22 17:01, Johannes Berg wrote:
> On Fri, 2022-11-04 at 16:58 +0100, Marek Vasut wrote:
>>
>> Therefore, to fix this problem, inspect the ETH_P_802_3 frames in
>> the rsi_91x driver, check the ethertype of the encapsulated frame,
>> and in case it is ETH_P_PAE, transmit the frame via high-priority
>> queue just like other ETH_P_PAE frames.
> 
> This part seems wrong now.

OK

>> +bool rsi_is_tx_eapol(struct sk_buff *skb)
>> +{
>> +	return !!(IEEE80211_SKB_CB(skb)->control.flags &
>> +		  IEEE80211_TX_CTRL_PORT_CTRL_PROTO);
>> +}
> 
> For how trivial this is now, maybe make it an inline? Feels fairly
> pointless to have it as an out-of-line function to call in another file
> when it's a simple bit check.

In V2 it was suggested I deduplicate this into a separate function, 
since the test is done in multiple places. I would like to keep it 
deduplicated.

> You can also drop the !! since the return value is bool.

OK
