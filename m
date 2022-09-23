Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADE945E7CBC
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 16:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbiIWOTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 10:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbiIWOTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 10:19:15 -0400
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761B1128A3B;
        Fri, 23 Sep 2022 07:19:14 -0700 (PDT)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 9AB9A8317B;
        Fri, 23 Sep 2022 16:19:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1663942752;
        bh=+RotZuS4WwpidmKoXwBn3WTjHkBeMhRa7hl1zuEk9T4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=abkL8O1usF33toQc0mqTtXNtpazu9Xbomu+m5dp+OxXwtm6CkH+v2HRgFSVT9yPf0
         SQ5S6SGhjGOL3AS09clP1UC/mWM2nyfO9npq18i2lVHuXX/kZzk0zk/AGFlRDCYR9L
         6N4NoMa4Nge4v8sqI9WDe0uhLzR+v71xU4Btv9cofWORCAF6b6T665U05T8nKJkp6G
         bmbaLPADfj/TiKj2pLY56YgJdmosa21USP0Wi9Ew0NpYvlNBaWtu4sff1Et3QNZohw
         rBThewq1wtz//CFsPu7MUZAqeTf0QqVqvyglbrfQP8L3wqr6OtvTfJHJ6l/Jmr4msO
         8zQGMCESzy7ww==
Message-ID: <d5f38a5c-8073-6e34-54f0-a11d2347b2c1@denx.de>
Date:   Fri, 23 Sep 2022 16:19:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] wifi: rsi: Fix handling of 802.3 EAPOL frames sent via
 control port
Content-Language: en-US
To:     "Fuzzey, Martin" <martin.fuzzey@flowbird.group>
Cc:     linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Angus Ainslie <angus@akkea.ca>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Martin Kepplinger <martink@posteo.de>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org
References: <20220922203240.108623-1-marex@denx.de>
 <CANh8QzxfznS3jB8OgwRAp68wGcTDctzvBSeaXQH2bPicOSyyYA@mail.gmail.com>
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <CANh8QzxfznS3jB8OgwRAp68wGcTDctzvBSeaXQH2bPicOSyyYA@mail.gmail.com>
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

On 9/23/22 09:11, Fuzzey, Martin wrote:
> Hi Marek,

Hi,

> On Thu, 22 Sept 2022 at 22:33, Marek Vasut <marex@denx.de> wrote:
>>
>> When using wpa_supplicant v2.10, this driver is no longer able to
>> associate with any AP and fails in the EAPOL 4-way handshake while
>> sending the 2/4 message to the AP. The problem is not present in
>> wpa_supplicant v2.9 or older. The problem stems from HostAP commit
>> 144314eaa ("wpa_supplicant: Send EAPOL frames over nl80211 where available")
>> which changes the way EAPOL frames are sent, from them being send
>> at L2 frames to them being sent via nl80211 control port.
> ...
>> Therefore, to fix this problem, inspect the ETH_P_802_3 frames in
>> the rsi_91x driver, check the ethertype of the encapsulated frame,
>> and in case it is ETH_P_PAE, transmit the frame via high-priority
>> queue just like other ETH_P_PAE frames.
>>
> 
>> diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
>> index 0f3a80f66b61c..d76c9dc99cafa 100644
>> --- a/drivers/net/wireless/rsi/rsi_91x_core.c
>> +++ b/drivers/net/wireless/rsi/rsi_91x_core.c
>> +
>>                  if (skb->protocol == cpu_to_be16(ETH_P_PAE)) {
>> +                       tx_eapol = true;
>> +               } else if (skb->protocol == cpu_to_be16(ETH_P_802_3)) {
>> +                       hdr_len = ieee80211_get_hdrlen_from_skb(skb) +
>> +                                 sizeof(rfc1042_header) - ETH_HLEN + 2;
>> +                       eth_hdr = (struct ethhdr *)(skb->data + hdr_len);
>> +                       if (eth_hdr->h_proto == cpu_to_be16(ETH_P_PAE))
>> +                               tx_eapol = true;
>> +               }
>> +
>> diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
>> index c61f83a7333b6..d43754fff287d 100644
>> @@ -168,6 +171,16 @@ int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
>> +       if (skb->protocol == cpu_to_be16(ETH_P_PAE)) {
>> +               tx_eapol = true;
>> +       } else if (skb->protocol == cpu_to_be16(ETH_P_802_3)) {
>> +               hdr_len = ieee80211_get_hdrlen_from_skb(skb) +
>> +                         sizeof(rfc1042_header) - ETH_HLEN + 2;
>> +               eth_hdr = (struct ethhdr *)(skb->data + hdr_len);
>> +               if (eth_hdr->h_proto == cpu_to_be16(ETH_P_PAE))
>> +                       tx_eapol = true;
>> +       }
>> +
> 
> It looks like the same logic is being duplicated twice. Maybe create a
> helper function for it, something like bool rsi_is_eapol(struct
> sk_buff *skb) ?

Sure, I'll do that in V2.

Currently I am looking for input whether this reaching into an 8023 
packet to see if it is EAPOL one is even the right approach:
"
NOTE: I am really unsure about the method of finding out the exact
       place of ethernet header in the encapsulated packet and then
       extracting the ethertype from it. Is there maybe some sort of
       helper function for that purpose ?
"

> Also I think it would be good to tag this for stable.

There is a Fixes tag:
"
Fixes: 0eb42586cf876 ("rsi: data packet descriptor enhancements")
"
