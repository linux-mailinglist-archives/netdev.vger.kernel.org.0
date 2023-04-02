Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A71776D37AB
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 13:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbjDBLae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 07:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjDBLac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 07:30:32 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C5ECA26;
        Sun,  2 Apr 2023 04:30:31 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pivum-0005xd-ER; Sun, 02 Apr 2023 13:30:28 +0200
Message-ID: <8ab36d80-8417-628f-9f51-e75eaf6b1a51@leemhuis.info>
Date:   Sun, 2 Apr 2023 13:30:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v3 1/3] wifi: rtw88: Move register access from
 rtw_bf_assoc() outside the RCU
Content-Language: en-US, de-DE
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-wireless@vger.kernel.org, tony0620emma@gmail.com,
        kvalo@kernel.org, pkshih@realtek.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux kernel regressions list <regressions@lists.linux.dev>
References: <20230108211324.442823-1-martin.blumenstingl@googlemail.com>
 <20230108211324.442823-2-martin.blumenstingl@googlemail.com>
 <20230331125906.GF15436@pengutronix.de>
From:   "Linux regression tracking #adding (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <20230331125906.GF15436@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1680435031;642136e3;
X-HE-SMSGID: 1pivum-0005xd-ER
X-Spam-Status: No, score=-2.4 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[CCing the regression list, as it should be in the loop for regressions:
https://docs.kernel.org/admin-guide/reporting-regressions.html]

On 31.03.23 14:59, Sascha Hauer wrote:
> On Sun, Jan 08, 2023 at 10:13:22PM +0100, Martin Blumenstingl wrote:
>> USB and (upcoming) SDIO support may sleep in the read/write handlers.
>> Shrink the RCU critical section so it only cover the call to
>> ieee80211_find_sta() and finding the ic_vht_cap/vht_cap based on the
>> found station. This moves the chip's BFEE configuration outside the
>> rcu_read_lock section and thus prevent "scheduling while atomic" or
>> "Voluntary context switch within RCU read-side critical section!"
>> warnings when accessing the registers using an SDIO card (which is
>> where this issue has been spotted in the real world - but it also
>> affects USB cards).
> 
> Unfortunately this introduces a regression on my RTW8821CU chip. With
> this it constantly looses connection to the AP and reconnects shortly
> after:

Thanks for the report. To be sure the issue doesn't fall through the
cracks unnoticed, I'm adding it to regzbot, the Linux kernel regression
tracking bot:

#regzbot ^introduced c7eca79def44
#regzbot title net: wifi: rtw88: RTW8821CU constantly looses connection
to the AP and reconnects shortly after
#regzbot ignore-activity

This isn't a regression? This issue or a fix for it are already
discussed somewhere else? It was fixed already? You want to clarify when
the regression started to happen? Or point out I got the title or
something else totally wrong? Then just reply and tell me -- ideally
while also telling regzbot about it, as explained by the page listed in
the footer of this mail.

Developers: When fixing the issue, remember to add 'Link:' tags pointing
to the report (the parent of this mail). See page linked in footer for
details.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
That page also explains what to do if mails like this annoy you.

