Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E790618FB5E
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 18:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgCWRWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 13:22:05 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:42223 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727611AbgCWRWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 13:22:04 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1584984124; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=Sc6fmyDj78JCWjL0wfEO7IdRbQ+sKfyO82uVXKA2cDk=;
 b=fXcWlRzL1Yp8hVDRTdZu1hcVaG8IGkK+ddgpbZn/fpXjn1CFj1u4EBKb9bvheU0wGDU+yd7j
 h6fOihKkai698sFHP1li0UXwk51kUelukACxeLojJYLJVUFi8gtcOn+p87jGHEg2XlxGbP4E
 XepDi/rFeD1N18Ukx4a9GNkcir0=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e78f02a.7fd7e5908308-smtp-out-n04;
 Mon, 23 Mar 2020 17:21:46 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7CD8FC432C2; Mon, 23 Mar 2020 17:21:45 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9D4C9C44788;
        Mon, 23 Mar 2020 17:21:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9D4C9C44788
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] wl3501_cs: Replace zero-length array with
 flexible-array member
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200319230617.GA15035@embeddedor.com>
References: <20200319230617.GA15035@embeddedor.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200323172145.7CD8FC432C2@smtp.codeaurora.org>
Date:   Mon, 23 Mar 2020 17:21:45 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:
> 
> struct foo {
>         int stuff;
>         struct boo array[];
> };
> 
> By making use of the mechanism above, we will get a compiler warning
> in case the flexible array does not occur last in the structure, which
> will help us prevent some kind of undefined behavior bugs from being
> inadvertently introduced[3] to the codebase from now on.
> 
> Also, notice that, dynamic memory allocations won't be affected by
> this change:
> 
> "Flexible array members have incomplete type, and so the sizeof operator
> may not be applied. As a quirk of the original implementation of
> zero-length arrays, sizeof evaluates to zero."[1]
> 
> This issue was found with the help of Coccinelle.
> 
> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> [2] https://github.com/KSPP/linux/issues/21
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Patch applied to wireless-drivers-next.git, thanks.

53efdc9cb9e6 wl3501_cs: Replace zero-length array with flexible-array member

-- 
https://patchwork.kernel.org/patch/11448183/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
