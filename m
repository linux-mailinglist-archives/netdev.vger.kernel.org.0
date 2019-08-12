Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 152D78A126
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 16:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbfHLOcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 10:32:16 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:43282 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbfHLOcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 10:32:16 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2B3EA61230; Mon, 12 Aug 2019 14:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565620335;
        bh=w8crrLL9haXBTnSHYdfkFARCnHukR+gTIrEu5wquuGI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=GhyXBLc6suy/Bz/jL9AvI/qRrs0Y9DpmC/nzQ3ZZZTpC2Gkmf5apwM8yZgqWoO7Qo
         ZkPK7OK3Ds9wZmJ2wzUzV7HYJWrFjmETmozIa0kBwN0RiqsY0j/wbZVVGJy4vW3yaY
         EgojsDtcfV8tI5os4hM3do19A79vqBCF5TX5QWgU=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B046360EA5;
        Mon, 12 Aug 2019 14:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565620333;
        bh=w8crrLL9haXBTnSHYdfkFARCnHukR+gTIrEu5wquuGI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=dipzXRcNxl5qADpUHOKhs9uV/1gy1uS40sOp5tXz1l5qYYOFBj0KDj1/hDpqEDD0M
         bktOchuFqm009dWS8jgoi0DtrbkKZ5POI3LHP7vi5QkA0hWHysAoh4WWlSI3uO56aq
         EMwAArS48E4AqRNq3BvAo1jV7tJWFLPag4Aw9280=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B046360EA5
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jes Sorensen <jes.sorensen@gmail.com>
Cc:     Chris Chiu <chiu@endlessm.com>, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com,
        Daniel Drake <drake@endlessm.com>
Subject: Re: [RFC PATCH v7] rtl8xxxu: Improve TX performance of RTL8723BU on rtl8xxxu driver
References: <20190805131452.13257-1-chiu@endlessm.com>
        <d0047834-957d-0cf3-5792-31faa5315ad1@gmail.com>
Date:   Mon, 12 Aug 2019 17:32:08 +0300
In-Reply-To: <d0047834-957d-0cf3-5792-31faa5315ad1@gmail.com> (Jes Sorensen's
        message of "Mon, 12 Aug 2019 09:38:51 -0400")
Message-ID: <87wofibgk7.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jes Sorensen <jes.sorensen@gmail.com> writes:

> On 8/5/19 9:14 AM, Chris Chiu wrote:
>> We have 3 laptops which connect the wifi by the same RTL8723BU.
>> The PCI VID/PID of the wifi chip is 10EC:B720 which is supported.
>> They have the same problem with the in-kernel rtl8xxxu driver, the
>> iperf (as a client to an ethernet-connected server) gets ~1Mbps.
>> Nevertheless, the signal strength is reported as around -40dBm,
>> which is quite good. From the wireshark capture, the tx rate for each
>> data and qos data packet is only 1Mbps. Compare to the Realtek driver
>> at https://github.com/lwfinger/rtl8723bu, the same iperf test gets
>> ~12Mbps or better. The signal strength is reported similarly around
>> -40dBm. That's why we want to improve.
>> 
>> After reading the source code of the rtl8xxxu driver and Realtek's, the
>> major difference is that Realtek's driver has a watchdog which will keep
>> monitoring the signal quality and updating the rate mask just like the
>> rtl8xxxu_gen2_update_rate_mask() does if signal quality changes.
>> And this kind of watchdog also exists in rtlwifi driver of some specific
>> chips, ex rtl8192ee, rtl8188ee, rtl8723ae, rtl8821ae...etc. They have
>> the same member function named dm_watchdog and will invoke the
>> corresponding dm_refresh_rate_adaptive_mask to adjust the tx rate
>> mask.
>> 
>> With this commit, the tx rate of each data and qos data packet will
>> be 39Mbps (MCS4) with the 0xF00000 as the tx rate mask. The 20th bit
>> to 23th bit means MCS4 to MCS7. It means that the firmware still picks
>> the lowest rate from the rate mask and explains why the tx rate of
>> data and qos data is always lowest 1Mbps because the default rate mask
>> passed is always 0xFFFFFFF ranges from the basic CCK rate, OFDM rate,
>> and MCS rate. However, with Realtek's driver, the tx rate observed from
>> wireshark under the same condition is almost 65Mbps or 72Mbps, which
>> indicating that rtl8xxxu could still be further improved.
>> 
>> Signed-off-by: Chris Chiu <chiu@endlessm.com>
>> Reviewed-by: Daniel Drake <drake@endlessm.com>
>> ---
>
> Looks good to me! Nice work! I am actually very curious if this will
> improve performance 8192eu as well.
>
> Ideally I'd like to figure out how to make host controlled rates work,
> but in all my experiments with that, I never really got it to work well.
>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@gmail.com>

This is marked as RFC so I'm not sure what's the plan. Should I apply
this?

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
