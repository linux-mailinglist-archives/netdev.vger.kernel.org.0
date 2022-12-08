Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD2DE647194
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 15:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiLHOXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 09:23:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbiLHOWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 09:22:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0539F950CF;
        Thu,  8 Dec 2022 06:21:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C285B8240C;
        Thu,  8 Dec 2022 14:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6BCCC433D7;
        Thu,  8 Dec 2022 14:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670509284;
        bh=np8jYI/VKmUFiySM5QA6XkNRELjkC4uz0yzj/atxGbc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=pBsbW2fJkrzZ1mbPFY9dAWNrUEWM9mqh4a5WJdUU3yiGPGlnSSMIYDO1GzSyIQRhb
         u0DVDTUjnraW1Xxn0qkhAeqsxP31t55injNiYmq2ur6Of4caRZ3ta1Zsz4tKc70dnE
         CXNtYagA+noyFQKW82NsA7aBfe5AMSkXiGs4iEIf63kUna8ZrDTNNV4pGfZLRQHM54
         fHY9FkGB9diZs6kCeaF5YdaZ7IZ6jOUVRE6EIBV1170tiUKXP5auyNvqnAAYDe9gQO
         nqlwIXqDbO7TyCyypsOGOlw5iOBIHXSxwKV1JJGnK3r7mhClHv75tDWQbY7IsmlRgx
         jxZiNWECrZ37A==
From:   Kalle Valo <kvalo@kernel.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-wireless@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Johannes Berg <johannes@sipsolutions.net>,
        Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>, Po-Hao Huang <phhuang@realtek.com>,
        Viktor Petrenko <g0000ga@gmail.com>
Subject: Re: [PATCH v4 08/11] wifi: rtw88: Add rtw8821cu chipset support
References: <20221129100754.2753237-1-s.hauer@pengutronix.de>
        <20221129100754.2753237-9-s.hauer@pengutronix.de>
        <20221129081753.087b7a35@kernel.org>
        <d2113f20-d547-ce16-ff7f-2d1286321014@lwfinger.net>
Date:   Thu, 08 Dec 2022 16:21:16 +0200
In-Reply-To: <d2113f20-d547-ce16-ff7f-2d1286321014@lwfinger.net> (Larry
        Finger's message of "Tue, 29 Nov 2022 10:59:46 -0600")
Message-ID: <87tu260yeb.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 11/29/22 10:17, Jakub Kicinski wrote:
>> On Tue, 29 Nov 2022 11:07:51 +0100 Sascha Hauer wrote:
>>> +config RTW88_8821CU
>>> +	tristate "Realtek 8821CU USB wireless network adapter"
>>> +	depends on USB
>>> +	select RTW88_CORE
>>> +	select RTW88_USB
>>> +	select RTW88_8821C
>>> +	help
>>> +	  Select this option will enable support for 8821CU chipset
>>> +
>>> +	  802.11ac USB wireless network adapter
>>
>> Those kconfig knobs add so little code, why not combine them all into
>> one? No point bothering the user with 4 different questions with amount
>> to almost nothing.
>
> I see only one knob there, name RTW88_8821CU. The other configuration
> variables select parts of the code that are shared with other drivers
> such as RTW88_8821CE and these parts must be there.

I just test compiled these patches and we have four new questions:

  Realtek 8822BU USB wireless network adapter (RTW88_8822BU) [N/m/?] (NEW) m
  Realtek 8822CU USB wireless network adapter (RTW88_8822CU) [N/m/?] (NEW) m
  Realtek 8723DU USB wireless network adapter (RTW88_8723DU) [N/m/?] (NEW) m
  Realtek 8821CU USB wireless network adapter (RTW88_8821CU) [N/m/?] (NEW) 

To me this looks too fine grained. Does it really make sense, for
example, to enable RTW88_8822BU but not RTW88_8822CU? Would just having
RTW88_USB containing all USB devices be more sensible? And the same for
PCI, and if we have in the future, SDIO devices.

But like discussed earlier, to keep things simple let's handle that
separately from this patchset.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
