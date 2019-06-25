Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 342B55227A
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 07:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbfFYFB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 01:01:57 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33310 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbfFYFB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 01:01:56 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 537F1607C3; Tue, 25 Jun 2019 05:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561438915;
        bh=PYSVFsYD906wuBTaXTXdPKGq8NsAALiOxgY+Au40ARU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=FCARxGJBajaSZTu3+OBj3emU6nH9LvG5xCNaOGu4X6ZJQVoCS/J8+Dhb8Mv+u5QhH
         juYjlThcutzO0vG3LaFdLVlf17af2sOag5bITqpOKjDHW58kagZEai5jHEuj7vQLKG
         aNRya34KoG9Jnv/7QkIsjZoO+VuS60pxll04KKpA=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6AD1E607C3;
        Tue, 25 Jun 2019 05:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561438913;
        bh=PYSVFsYD906wuBTaXTXdPKGq8NsAALiOxgY+Au40ARU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=T27y3uNOCVoIg5VxoIZ5+rhDXCXWV/z+uooN1S12Y75tbqFBHEK6qB53yPMwpll5u
         o57ZuJhsSKZEBU4exBapjf7DZ4POUxGUjjZmOqdNSNRHSDwQZtbGUh1sPOBnsWKmB2
         tJi1y0owyFuVbWGLc0Q48Nyg/tBMhFqG+zhrYQBQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6AD1E607C3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] qtnfmac: Use struct_size() in kzalloc()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190607191745.GA19120@embeddedor>
References: <20190607191745.GA19120@embeddedor>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Igor Mitsyanko <imitsyanko@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190625050155.537F1607C3@smtp.codeaurora.org>
Date:   Tue, 25 Jun 2019 05:01:55 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> One of the more common cases of allocation size calculations is finding
> the size of a structure that has a zero-sized array at the end, along
> with memory for some number of elements for that array. For example:
> 
> struct ieee80211_regdomain {
> 	...
>         struct ieee80211_reg_rule reg_rules[];
> };
> 
> instance = kzalloc(sizeof(*mac->rd) +
>                           sizeof(struct ieee80211_reg_rule) *
>                           count, GFP_KERNEL);
> 
> Instead of leaving these open-coded and prone to type mistakes, we can
> now use the new struct_size() helper:
> 
> instance = kzalloc(struct_size(instance, reg_rules, count), GFP_KERNEL);
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Reviewed-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

Patch applied to wireless-drivers-next.git, thanks.

9a1ace64ca3b qtnfmac: Use struct_size() in kzalloc()

-- 
https://patchwork.kernel.org/patch/10982675/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

