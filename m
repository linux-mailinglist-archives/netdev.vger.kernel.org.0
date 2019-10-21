Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 984BBDE65C
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 10:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbfJUI30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 04:29:26 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:45200 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727471AbfJUI30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 04:29:26 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E9CBE60790; Mon, 21 Oct 2019 08:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571646565;
        bh=lEYF4JRB9NiiBUTl4iJbN9bqjIYPYN8SKd3G8bvgP1A=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=EN18lOlF5rMt2tBxNGzHoEuiVJouK0G0y10D4MtuTk7FcSbKhwScBfUFhBuT9dFEN
         S06BM8G6x/CrsSKZnmg5ix6DxjchcXogpCTxsjjiwmFH9Yh4sOeJo6+9riNeKY0U+j
         KbA8qAvmj7zl0JZ8HMb4vYnv/ypiRW1NAu0ttyG8=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7399C60610;
        Mon, 21 Oct 2019 08:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571646564;
        bh=lEYF4JRB9NiiBUTl4iJbN9bqjIYPYN8SKd3G8bvgP1A=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=YX/zFkIGiPbhVwhwNeiAFuWkFBqgEvdmW1achZW7fpR3+R9mLM/uNODeoA3wOSt8T
         8le/c4sDJnY437Wi6DnrQsG2KXI+NPcOuX5qip74GvaRamCyOa53bJ8SldE8846Q8y
         3Y4g6NAbxHfKQHkhgskPzIkRs6vbWoV3OhQpWiRc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7399C60610
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Chris Chiu <chiu@endlessm.com>
Cc:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>
Subject: Re: [PATCH v2] rtl8xxxu: fix RTL8723BU connection failure issue after warm reboot
References: <20191016015408.11091-1-chiu@endlessm.com>
        <CAB4CAwen5y7Z4GU7YgpVafyGexxaMDLzrZ949t9p+LiZ9TxAPA@mail.gmail.com>
        <CAB4CAwcW5JGtZQy+=vugx5rRYMycWoCSSdDc6nwhunqTtqoQaA@mail.gmail.com>
Date:   Mon, 21 Oct 2019 11:29:19 +0300
In-Reply-To: <CAB4CAwcW5JGtZQy+=vugx5rRYMycWoCSSdDc6nwhunqTtqoQaA@mail.gmail.com>
        (Chris Chiu's message of "Mon, 21 Oct 2019 10:26:48 +0800")
Message-ID: <874l02wlgg.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chris Chiu <chiu@endlessm.com> writes:

> On Thu, Oct 17, 2019 at 10:26 AM Chris Chiu <chiu@endlessm.com> wrote:
>>
>> On Wed, Oct 16, 2019 at 9:54 AM Chris Chiu <chiu@endlessm.com> wrote:
>> >
>> > The RTL8723BU has problems connecting to AP after each warm reboot.
>> > Sometimes it returns no scan result, and in most cases, it fails
>> > the authentication for unknown reason. However, it works totally
>> > fine after cold reboot.
>> >
>> > Compare the value of register SYS_CR and SYS_CLK_MAC_CLK_ENABLE
>> > for cold reboot and warm reboot, the registers imply that the MAC
>> > is already powered and thus some procedures are skipped during
>> > driver initialization. Double checked the vendor driver, it reads
>> > the SYS_CR and SYS_CLK_MAC_CLK_ENABLE also but doesn't skip any
>> > during initialization based on them. This commit only tells the
>> > RTL8723BU to do full initialization without checking MAC status.
>> >
>> > Signed-off-by: Chris Chiu <chiu@endlessm.com>
>> Signed-off-by: Jes Sorensen <Jes.Sorensen@gmail.com>
>>
>> Sorry, I forgot to add Jes.
>>
>> Chris
>> > ---
>> >
>> > Note:
>> >   v2: fix typo of commit message
>> >
>> >
>
> Gentle ping. Cheers.

To reduce email please avoid pinging like this, it has been only five
days since you submitted this version and this is not a 24/7 service. I
have documented how you can follow the status from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#checking_state_of_patches_from_patchwork

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
