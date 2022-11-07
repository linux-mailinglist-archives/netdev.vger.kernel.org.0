Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7FE61F43C
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 14:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbiKGNXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 08:23:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbiKGNXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 08:23:43 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F75DBE;
        Mon,  7 Nov 2022 05:23:41 -0800 (PST)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 59A2984DC3;
        Mon,  7 Nov 2022 14:23:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1667827419;
        bh=19vCZvvBbxjS3Fq5qZKJPYVrjmqsYj9fRLwd0evsl/g=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=t/en2HQ36AFkVbax2zWG1g+Ktci1IA8vh7Eah9tgsZ3dAo7P9kFVUpLBuIPuyhfvq
         S/JjG1DtPErLkOeSyah+5FLHB8FpqJxcYAupa/BzMufmxx+cLZH2vDUqZQ5ZqhodEU
         3blshWZyR9BM7hA1gMUHsYqr/ujIvtRxxUXGYOdNnmAySU8uhYY6mDXcrU6f2FJ40R
         J8vW3w/eCEYiZaiQ0oBpzb4jGb4Wwuwp2ITlFLnPAJZZMKKKraYEdeGqV81o+KhUBr
         BKJIbfvnt4kg6eCVrk+jUD87Q3TLuRnBfmzNINheIFK8pMPtpsAPFbrfCxUw3Ls0gS
         uKw+aSfnsX2QA==
Message-ID: <7a3b6d5c-1d73-1d31-434f-00703c250dd6@denx.de>
Date:   Mon, 7 Nov 2022 14:23:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v5] wifi: rsi: Fix handling of 802.3 EAPOL frames sent via
 control port
Content-Language: en-US
To:     Kalle Valo <kvalo@kernel.org>
Cc:     linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Angus Ainslie <angus@akkea.ca>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Martin Kepplinger <martink@posteo.de>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org
References: <20221104163339.227432-1-marex@denx.de>
 <87o7tjszyg.fsf@kernel.org>
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <87o7tjszyg.fsf@kernel.org>
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

On 11/7/22 13:37, Kalle Valo wrote:
> Marek Vasut <marex@denx.de> writes:
> 
>> When using wpa_supplicant v2.10, this driver is no longer able to
>> associate with any AP and fails in the EAPOL 4-way handshake while
>> sending the 2/4 message to the AP. The problem is not present in
>> wpa_supplicant v2.9 or older. The problem stems from HostAP commit
>> 144314eaa ("wpa_supplicant: Send EAPOL frames over nl80211 where available")
>> which changes the way EAPOL frames are sent, from them being send
>> at L2 frames to them being sent via nl80211 control port.
>>
>> An EAPOL frame sent as L2 frame is passed to the WiFi driver with
>> skb->protocol ETH_P_PAE, while EAPOL frame sent via nl80211 control
>> port has skb->protocol set to ETH_P_802_3 . The later happens in
>> ieee80211_tx_control_port(), where the EAPOL frame is encapsulated
>> into 802.3 frame.
>>
>> The rsi_91x driver handles ETH_P_PAE EAPOL frames as high-priority
>> frames and sends them via highest-priority transmit queue, while
>> the ETH_P_802_3 frames are sent as regular frames. The EAPOL 4-way
>> handshake frames must be sent as highest-priority, otherwise the
>> 4-way handshake times out.
>>
>> Therefore, to fix this problem, inspect the skb control flags and
>> if flag IEEE80211_TX_CTRL_PORT_CTRL_PROTO is set, assume this is
>> an EAPOL frame and transmit the frame via high-priority queue just
>> like other ETH_P_PAE frames.
>>
>> Fixes: 0eb42586cf87 ("rsi: data packet descriptor enhancements")
>> Signed-off-by: Marek Vasut <marex@denx.de>
>> ---
>> NOTE: I am really unsure about the method of finding out the exact
>>        place of ethernet header in the encapsulated packet and then
>>        extracting the ethertype from it. Is there maybe some sort of
>>        helper function for that purpose ?
>> ---
>> V2: - Turn the duplicated code into common function
>> V3: - Simplify the TX EAPOL detection (Johannes)
>> V4: - Drop the double !!() from test
>>      - Update commit message
>> V5: - Inline the rsi_is_tx_eapol() again, undoes V2 change completely
> 
> BTW did you test this on a real device?

Yes, SDIO RS9116 on next-20221104 and 5.10.153 .

What prompts this question ?
