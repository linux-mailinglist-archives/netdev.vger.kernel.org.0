Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2C9ADD83F
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 12:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbfJSK5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 06:57:37 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:42394 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfJSK5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 06:57:36 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D757A606CF; Sat, 19 Oct 2019 10:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571482655;
        bh=aYZd/cghVL2W+HJ0ZYNQn833hzPO4HLVBhItoH8kWDU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=iy5dV/SGhsCwiYzkH47D3rKdWGicnl0PZ/CkFef8RUFMtX4H84ExWWIqy6Zff3ooK
         jjnQJ5YtM1TinxnZZuc/oXUDc6qH9Oe78WeiThYIcCZY9MHp/qwJ4kG64XR7nBDX7g
         18ChSAmP/f/nUzyUlAd/ZLp0wRnMqvrUS9XxCYV8=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 64E7B602FE;
        Sat, 19 Oct 2019 10:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571482655;
        bh=aYZd/cghVL2W+HJ0ZYNQn833hzPO4HLVBhItoH8kWDU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=iy5dV/SGhsCwiYzkH47D3rKdWGicnl0PZ/CkFef8RUFMtX4H84ExWWIqy6Zff3ooK
         jjnQJ5YtM1TinxnZZuc/oXUDc6qH9Oe78WeiThYIcCZY9MHp/qwJ4kG64XR7nBDX7g
         18ChSAmP/f/nUzyUlAd/ZLp0wRnMqvrUS9XxCYV8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 64E7B602FE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Pkshih <pkshih@realtek.com>
Cc:     "labbott\@redhat.com" <labbott@redhat.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nico\@semmle.com" <nico@semmle.com>
Subject: Re: [PATCH v2] rtlwifi: Fix potential overflow on P2P code
References: <20191018114321.13131-1-labbott@redhat.com>
        <1571402142.1994.6.camel@realtek.com>
Date:   Sat, 19 Oct 2019 13:57:31 +0300
In-Reply-To: <1571402142.1994.6.camel@realtek.com> (pkshih@realtek.com's
        message of "Fri, 18 Oct 2019 12:35:43 +0000")
Message-ID: <87wod1vw84.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pkshih <pkshih@realtek.com> writes:

> On Fri, 2019-10-18 at 07:43 -0400, Laura Abbott wrote:
>> Nicolas Waisman noticed that even though noa_len is checked for
>> a compatible length it's still possible to overrun the buffers
>> of p2pinfo since there's no check on the upper bound of noa_num.
>> Bound noa_num against P2P_MAX_NOA_NUM.
>> 
>> Reported-by: Nicolas Waisman <nico@semmle.com>
>> Signed-off-by: Laura Abbott <labbott@redhat.com>
>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>
> and Please CC to stable
> Cc: Stable <stable@vger.kernel.org> # 4.4+
>
> ---
>
> Hi Kalle,
>
> This bug was existing since v3.10, and directory of wireless drivers were
> moved at v4.4. Do I need send another patch to fix this issue for longterm
> kernel v3.16.75?

Yeah, I think you need to send a separate patch to the stable list
(after this commit is in Linus' tree).

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
