Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A07C0B4781
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 08:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391500AbfIQG3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 02:29:01 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40544 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726953AbfIQG3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 02:29:00 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 95899607C3; Tue, 17 Sep 2019 06:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568701739;
        bh=GVf/WW705jjMvbH9rH5ECMCN5gTCGj+tK6F//7PhjVQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Al/xUkzYoqyHHsIyb9hQl5CkPQFSWDVgCMSmhxp23TuIIUbMddqIKcta7ATjn+lyM
         fVixEHrd5ERXKURQFd1gawH9N+wwti0ZPLWAlfRUy1/9ol/OcKKnwUXZ32A20JnOlk
         mCwpgsvtLBABQ7cFEs29ROOCGGVVJ5cjIGo8f+gY=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 569B86032C;
        Tue, 17 Sep 2019 06:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568701739;
        bh=GVf/WW705jjMvbH9rH5ECMCN5gTCGj+tK6F//7PhjVQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Al/xUkzYoqyHHsIyb9hQl5CkPQFSWDVgCMSmhxp23TuIIUbMddqIKcta7ATjn+lyM
         fVixEHrd5ERXKURQFd1gawH9N+wwti0ZPLWAlfRUy1/9ol/OcKKnwUXZ32A20JnOlk
         mCwpgsvtLBABQ7cFEs29ROOCGGVVJ5cjIGo8f+gY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 569B86032C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Chris Chiu <chiu@endlessm.com>
Cc:     Jes Sorensen <jes.sorensen@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>,
        Daniel Drake <drake@endlessm.com>
Subject: Re: [RFC PATCH v7] rtl8xxxu: Improve TX performance of RTL8723BU on rtl8xxxu driver
References: <20190805131452.13257-1-chiu@endlessm.com>
        <d0047834-957d-0cf3-5792-31faa5315ad1@gmail.com>
        <87wofibgk7.fsf@kamboji.qca.qualcomm.com>
        <a3ac212d-b976-fb16-227f-3246a317c4a2@gmail.com>
        <CAB4CAweWoFuXPci5Re6sdN_kB0i4DkpsYxux+GAHyRHWhC+hhA@mail.gmail.com>
Date:   Tue, 17 Sep 2019 09:28:54 +0300
In-Reply-To: <CAB4CAweWoFuXPci5Re6sdN_kB0i4DkpsYxux+GAHyRHWhC+hhA@mail.gmail.com>
        (Chris Chiu's message of "Tue, 17 Sep 2019 09:48:32 +0800")
Message-ID: <87woe7bfmh.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chris Chiu <chiu@endlessm.com> writes:

> On Mon, Aug 12, 2019 at 11:21 PM Jes Sorensen <jes.sorensen@gmail.com> wrote:
>>
>> On 8/12/19 10:32 AM, Kalle Valo wrote:
>> >> Signed-off-by: Jes Sorensen <Jes.Sorensen@gmail.com>
>> >
>> > This is marked as RFC so I'm not sure what's the plan. Should I apply
>> > this?
>>
>> I think it's at a point where it's worth applying - I kinda wish I had
>> had time to test it, but I won't be near my stash of USB dongles for a
>> little while.
>>
>> Cheers,
>> Jes
>>
>
> Gentle ping. Any suggestions for the next step?

Please resubmit without the RFC label.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
