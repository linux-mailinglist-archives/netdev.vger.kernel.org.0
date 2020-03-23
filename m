Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F04A18FAF8
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 18:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727630AbgCWRK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 13:10:58 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:45867 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727022AbgCWRK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 13:10:58 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1584983458; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=CzEwMos4Yyj1h7s0OSbR4yOAc3JC3hcUnO0IMzo1qok=; b=CgE+nh/40KFCL3ip5KU5azGAMDzOs2BujYSlluk9o355fXZrvKbOz4NOlIZKN2ybC8JlSaGo
 5G4ihLuBJXjfPKFI+rSekr4fsukmhz9RxDlYYXKG/2NvQFkNq6JzEHTJxhQQmKF2fTiJBuCR
 GL6EQrBemmyAADWu/tA7hDoMeFU=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e78ed94.7f6ccb263ea0-smtp-out-n05;
 Mon, 23 Mar 2020 17:10:44 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id F056AC433BA; Mon, 23 Mar 2020 17:10:43 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 04585C433D2;
        Mon, 23 Mar 2020 17:10:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 04585C433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: drivers/net/wireless spring cleaning
References: <20200225012008.GA4309@embeddedor>
        <20200225183247.GW11244@42.do-not-panic.com>
Date:   Mon, 23 Mar 2020 19:10:39 +0200
In-Reply-To: <20200225183247.GW11244@42.do-not-panic.com> (Luis Chamberlain's
        message of "Tue, 25 Feb 2020 18:32:48 +0000")
Message-ID: <87ftdzq9o0.fsf_-_@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(changing the subject)

Luis Chamberlain <mcgrof@kernel.org> writes:

> On Mon, Feb 24, 2020 at 07:20:08PM -0600, Gustavo A. R. Silva wrote:
>> The current codebase makes use of the zero-length array language
>> extension to the C90 standard, but the preferred mechanism to declare
>> variable-length types such as these ones is a flexible array member[1][2],
>> introduced in C99:
>> 
>> struct foo {
>>         int stuff;
>>         struct boo array[];
>> };
>> 
>> By making use of the mechanism above, we will get a compiler warning
>> in case the flexible array does not occur last in the structure, which
>> will help us prevent some kind of undefined behavior bugs from being
>> inadvertently introduced[3] to the codebase from now on.
>> 
>> Also, notice that, dynamic memory allocations won't be affected by
>> this change:
>> 
>> "Flexible array members have incomplete type, and so the sizeof operator
>> may not be applied. As a quirk of the original implementation of
>> zero-length arrays, sizeof evaluates to zero."[1]
>> 
>> This issue was found with the help of Coccinelle.
>> 
>> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
>> [2] https://github.com/KSPP/linux/issues/21
>> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
>> 
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>
> I'd rather we just remove this driver completely, as it has a
> replacement upstream p54, and remained upstream just for a theoretical
> period of time someone was not able to use p54 anymore. I'll follow up
> with a removal of the driver.

Yeah, please do.

I wonder if we should do other spring cleanup as well and remove drivers
like ray_cs and wl3501, I have not seen any activity on those for years.
Also rndis_wlan would be other candidate for removal.

Anyone know if these drivers are used or if they even work anymore?

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
