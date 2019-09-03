Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 431C3A6A4B
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 15:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbfICNp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 09:45:57 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55756 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727624AbfICNp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 09:45:57 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 03455607C3; Tue,  3 Sep 2019 13:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567518356;
        bh=8MtYQPJtCCG1I+6U/438W5qf6/QsXnNCsuIDqRRNfbY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=A+gZ6QEsC/ll3TPk4tjHG99YrINSuJC/UJ84PVmIW4OOEiKN4Epr6jJqt+dKSuWds
         zu4G++k5YCmr2T8j+OTSw7ADNZYhk6d2qNLL436HDlsps7vmqNuWH7Y0J/ZlxLOUIu
         XRyil3F9BjnV2Ukv/Mpsg1F5U2m/EIMZPRR17BXU=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A761E602A9;
        Tue,  3 Sep 2019 13:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567518355;
        bh=8MtYQPJtCCG1I+6U/438W5qf6/QsXnNCsuIDqRRNfbY=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=j7w/Kur1P/Zm59AjGDGKckWzdgryME7rOH//1nD3YM240//d5I36GBWnCq9XIHqPv
         AJSKhX2FUyLwXs7PHkMK5yz/aIkrZKOo1kx4PKuqpS0yPptd6VsH8jBmxrUmlIh+4R
         bx5eE0rKMCujLoVxyaRr88JFHGxly7SmoJBD172Q=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A761E602A9
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] zd1211rw: zd_usb: Use struct_size() helper
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190830185716.GA10044@embeddedor>
References: <20190830185716.GA10044@embeddedor>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190903134556.03455607C3@smtp.codeaurora.org>
Date:   Tue,  3 Sep 2019 13:45:56 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> One of the more common cases of allocation size calculations is finding
> the size of a structure that has a zero-sized array at the end, along
> with memory for some number of elements for that array. For example:
> 
> struct usb_int_regs {
> 	...
>         struct reg_data regs[0];
> } __packed;
> 
> Make use of the struct_size() helper instead of an open-coded version
> in order to avoid any potential type mistakes.
> 
> So, replace the following function:
> 
> static int usb_int_regs_length(unsigned int count)
> {
>        return sizeof(struct usb_int_regs) + count * sizeof(struct reg_data);
> }
> 
> with:
> 
> struct_size(regs, regs, count)
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Patch applied to wireless-drivers-next.git, thanks.

84b0b6635247 zd1211rw: zd_usb: Use struct_size() helper

-- 
https://patchwork.kernel.org/patch/11124457/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

