Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D7E3F3A2F
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 12:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234137AbhHUKSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 06:18:43 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:26464 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233358AbhHUKSm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Aug 2021 06:18:42 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1629541083; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=UpM1DyTEkig259V+pL57ps65feNkTSUqUFyxt1prq3Y=; b=dycITJdaFNTz/HvKFWl5e9rx2vFuE6onbdmoFncCW0p0sXvOAAFz6eEQxNvwH722nCSvBavE
 uR5hhlg5oHyHRJi/lWwuZcyJE81XTlGKKngQtEmoxdXeuaagFqL0sG5up+VfKhwZRmBBd8tf
 wupo3Uq1jGiw+qOBlHRmcmFexww=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 6120d2c989fbdf3ffed16f85 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 21 Aug 2021 10:17:45
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1D71BC43460; Sat, 21 Aug 2021 10:17:45 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1ED37C4338F;
        Sat, 21 Aug 2021 10:17:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 1ED37C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        dri-devel@lists.freedesktop.org, linux-staging@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 45/63] ath11k: Use memset_startat() for clearing queue descriptors
References: <20210818060533.3569517-1-keescook@chromium.org>
        <20210818060533.3569517-46-keescook@chromium.org>
        <87eeapbmhi.fsf@tynnyri.adurom.net> <202108190923.30FD4FC6E@keescook>
Date:   Sat, 21 Aug 2021 13:17:36 +0300
In-Reply-To: <202108190923.30FD4FC6E@keescook> (Kees Cook's message of "Thu,
        19 Aug 2021 09:25:01 -0700")
Message-ID: <87pmu7t83j.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> On Thu, Aug 19, 2021 at 04:19:37PM +0300, Kalle Valo wrote:
>> Kees Cook <keescook@chromium.org> writes:
>> 
>> > In preparation for FORTIFY_SOURCE performing compile-time and run-time
>> > field bounds checking for memset(), avoid intentionally writing across
>> > neighboring fields.
>> >
>> > Use memset_startat() so memset() doesn't get confused about writing
>> > beyond the destination member that is intended to be the starting point
>> > of zeroing through the end of the struct. Additionally split up a later
>> > field-spanning memset() so that memset() can reason about the size.
>> >
>> > Cc: Kalle Valo <kvalo@codeaurora.org>
>> > Cc: "David S. Miller" <davem@davemloft.net>
>> > Cc: Jakub Kicinski <kuba@kernel.org>
>> > Cc: ath11k@lists.infradead.org
>> > Cc: linux-wireless@vger.kernel.org
>> > Cc: netdev@vger.kernel.org
>> > Signed-off-by: Kees Cook <keescook@chromium.org>
>> 
>> To avoid conflicts I prefer taking this via my ath tree.
>
> The memset helpers are introduced as part of this series, so that makes
> things more difficult. Do you want me to create a branch with the
> helpers that you can merge?

Is this patch really worth the extra complexity? Why can't I apply this
ath11k patch after the helpers have landed Linus' tree? That would be
very simple.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
