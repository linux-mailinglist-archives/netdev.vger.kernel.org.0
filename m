Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 621DF57A3C1
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 17:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239052AbiGSPzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 11:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239572AbiGSPzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 11:55:38 -0400
X-Greylist: delayed 598 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 19 Jul 2022 08:55:36 PDT
Received: from simonwunderlich.de (simonwunderlich.de [IPv6:2a01:4f8:c17:e8c0::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA6DCE1E;
        Tue, 19 Jul 2022 08:55:36 -0700 (PDT)
Received: from [IPV6:2003:c5:973c:81a8::792] (p200300C5973c81a80000000000000792.dip0.t-ipconnect.de [IPv6:2003:c5:973c:81a8::792])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 3F354FA86A;
        Tue, 19 Jul 2022 17:36:34 +0200 (CEST)
Message-ID: <31e87fa2-6fea-5fe2-ab80-6050da9af7ce@simonwunderlich.de>
Date:   Tue, 19 Jul 2022 17:36:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH] mac80211: Fix wrong channel bandwidths reported for
 aggregates
To:     Adrian Chadd <adrian@freebsd.org>,
        =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>,
        ath10k <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20220718222804.21708-1-linus.luessing@c0d3.blue>
 <CAJ-VmomaQ-ai7n5i8-8sXsgaih4vjjHXyw+JQESGMERgC8Qqdw@mail.gmail.com>
Content-Language: en-US
From:   =?UTF-8?Q?Linus_L=c3=bcssing?= <ll@simonwunderlich.de>
In-Reply-To: <CAJ-VmomaQ-ai7n5i8-8sXsgaih4vjjHXyw+JQESGMERgC8Qqdw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/07/2022 17:03, Adrian Chadd wrote:
> Hi!
> 
> It's not a hardware bug. Dating back to the original AR5416 11n chip,
> most flags aren't valid for subframes in an aggregate. Only the final
> frame has valid flags. This was explicitly covered internally way back
> when.

Ah, thanks for the clarification! I see it in the datasheet for the 
QCA9531, too, now. And thanks for the confirmation, that what we are 
doing so far is not correct for ath9k.

Words 0+2 are valid for all RX descriptors, 0+2+11 valid for the last RX 
descriptor of each packet and 0-11 for the last RX descriptor of an 
aggregate or last RX descriptor of a stand-alone packet. Or in other 
words, word 4, which contains the 20 vs. 40 MHz indicator, is invalid 
for any aggregate sub-frame other than the last one. I can rename that 
in the commit message.


Another approach that also came to my mind was introducing more explicit 
flags in cfg80211.h's "struct rate_info", like a RATE_INFO_BW_UNKNOWN in 
"enum rate_info_bw" and/or RATE_INFO_FLAGS_UNKNOWN in "enum 
rate_info_flags". And setting those flags in ath9k_cmn_process_rate().

The current approach is smaller though, as it simply uses the already 
existing flags. If anyone has any preferences, please let me know.

Regards, Linus
