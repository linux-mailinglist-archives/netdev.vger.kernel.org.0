Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0FE1EF3F3
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 11:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgFEJVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 05:21:14 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:29903 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbgFEJVN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 05:21:13 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1591348873; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=kOyRDD2wM/7haweFJ6NAJPQaW5V0bTz8j0qf/YEB3F8=; b=HqGFVS1AUe44Da/YEPtpi7YBWhIkIX43NJBSPKAahB0Uelg+SEaCzQIeSx8OIzeOm9m3rIb2
 3NoEOYh5uITm5iaItOZmN0LawMYixNo8UBDJSGyu3zdrjCVIhREyfc9AatU0pQU/ajmaTOle
 SCH/b3F3rpNSUsV+rUPTWcTBLME=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 5eda0e7e27386861266429f6 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 05 Jun 2020 09:21:02
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 54699C433B2; Fri,  5 Jun 2020 09:21:01 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0979DC433C6;
        Fri,  5 Jun 2020 09:20:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0979DC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>, x86@kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mm@kvack.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 03/10] b43: Remove uninitialized_var() usage
References: <20200603233203.1695403-1-keescook@chromium.org>
        <20200603233203.1695403-4-keescook@chromium.org>
Date:   Fri, 05 Jun 2020 12:20:55 +0300
In-Reply-To: <20200603233203.1695403-4-keescook@chromium.org> (Kees Cook's
        message of "Wed, 3 Jun 2020 16:31:56 -0700")
Message-ID: <87d06dg96w.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> Using uninitialized_var() is dangerous as it papers over real bugs[1]
> (or can in the future), and suppresses unrelated compiler warnings (e.g.
> "unused variable"). If the compiler thinks it is uninitialized, either
> simply initialize the variable or make compiler changes. As a precursor
> to removing[2] this[3] macro[4], just initialize this variable to NULL,
> and make the (unreachable!) code do a conditional test.
>
> [1] https://lore.kernel.org/lkml/20200603174714.192027-1-glider@google.com/
> [2] https://lore.kernel.org/lkml/CA+55aFw+Vbj0i=1TGqCR5vQkCzWJ0QxK6CernOU6eedsudAixw@mail.gmail.com/
> [3] https://lore.kernel.org/lkml/CA+55aFwgbgqhbp1fkxvRKEpzyR5J8n1vKT1VZdz9knmPuXhOeg@mail.gmail.com/
> [4] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=yVJu65TpLgN_ybYNv0VEOKA@mail.gmail.com/
>
> Signed-off-by: Kees Cook <keescook@chromium.org>

[...]

> @@ -4256,9 +4256,13 @@ static void b43_nphy_tx_gain_table_upload(struct b43_wldev *dev)
>  			pga_gain = (table[i] >> 24) & 0xf;
>  			pad_gain = (table[i] >> 19) & 0x1f;
>  			if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ)
> -				rfpwr_offset = rf_pwr_offset_table[pad_gain];
> +				rfpwr_offset = rf_pwr_offset_table
> +						? rf_pwr_offset_table[pad_gain]
> +						: 0;
>  			else
> -				rfpwr_offset = rf_pwr_offset_table[pga_gain];
> +				rfpwr_offset = rf_pwr_offset_table
> +						? rf_pwr_offset_table[pga_gain]
> +						: 0;

To me this is ugly, isn't there a better way to fix this?

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
