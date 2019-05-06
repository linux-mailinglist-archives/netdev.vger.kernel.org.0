Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E50D914619
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 10:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfEFIWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 04:22:04 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:36496 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfEFIWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 04:22:03 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7533760770; Mon,  6 May 2019 08:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1557130923;
        bh=ZZzz+rr8wUgFTo9VKrB62hBLxoIXWzDCDWK5CKHD47c=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=AAysGIPa1wpc6nexIkzNVQsIm3FJQNLGxIoo1KXbNUTpTSZpOtbwu0oN2saJjHSd+
         qZFywZpj3gndNs47ou0IDwFRfjvs+bgnMjSW971xgygSVBWyX136wD5ryoTgquy+CM
         4uR9jH/xXRhLtKDog+NGIb0HgZpWfPKMykgma3Bw=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (37-136-65-53.rev.dnainternet.fi [37.136.65.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A7E8F60770;
        Mon,  6 May 2019 08:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1557130921;
        bh=ZZzz+rr8wUgFTo9VKrB62hBLxoIXWzDCDWK5CKHD47c=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=lSRn3hu5N/n0P+oGt6NqE4QpryoJ5SmalOwAxzaiMOn7s415F4X0ULqCUeiEucDQB
         ZP9RRennoLrtyU4NEqSfQyNGan1k7eXt9YkyBybcfHEkKRCzBmSEX3HYykvhpaO8M0
         L6WwHtMe3NiIGJCdB9OslHXkv7bTkdg0agGfiBzA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A7E8F60770
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     davem@davemloft.net, colin.king@canonical.com,
        yuehaibing@huawei.com, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wireless: b43: Avoid possible double calls to b43_one_core_detach()
References: <20190504091000.18665-1-baijiaju1990@gmail.com>
Date:   Mon, 06 May 2019 11:21:55 +0300
In-Reply-To: <20190504091000.18665-1-baijiaju1990@gmail.com> (Jia-Ju Bai's
        message of "Sat, 4 May 2019 17:10:00 +0800")
Message-ID: <874l68vvq4.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jia-Ju Bai <baijiaju1990@gmail.com> writes:

> In b43_request_firmware(), when ieee80211_register_hw() fails,
> b43_one_core_detach() is called. In b43_bcma_remove() and
> b43_ssb_remove(), b43_one_core_detach() is called again. In this case, 
> null-pointer dereferences and double-free problems can occur when 
> the driver is removed.
>
> To fix this bug, the call to b43_one_core_detach() in
> b43_request_firmware() is deleted.
>
> This bug is found by a runtime fuzzing tool named FIZZER written by us.
>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  drivers/net/wireless/broadcom/b43/main.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)

You can use just "b43:" as prefix, no need to have "net:" nor
"wireless:" in the title. I'll fix it this time, but please use correct
style in the future.

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#commit_title_is_wrong

-- 
Kalle Valo
