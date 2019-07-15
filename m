Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B77776868E
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 11:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729667AbfGOJom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 05:44:42 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41482 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729413AbfGOJol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 05:44:41 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4B0166049C; Mon, 15 Jul 2019 09:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563183880;
        bh=ogNfDzJGeCchNe8Cj5MSCueMmkdzlA9bajadZwl42gg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=WAVY+C9TLJZMiN4AxK19JddN/m8rBExJZ7kmfX90j6JcvPXD8ILrQC9gekhclHf3X
         BMyzf5Nk7lXra4iWjIqvG2f2Lz1GG/LeVX0VwMGvGPA789E2zLsxS7bKBtNwJlUc1O
         Ezt1fjkRrtkZEIUu4r8QylxIo2UjTjNBxMcYYliY=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 124296049C;
        Mon, 15 Jul 2019 09:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563183879;
        bh=ogNfDzJGeCchNe8Cj5MSCueMmkdzlA9bajadZwl42gg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=PINET64BOpNC1lwjrFMaoBGTtCsE3gP3joRwqkgtvCJGY9hHuiNwzzhRZDME6AW/V
         oY3AJ6i8ftdmCRgl3UlLTKeiIeKQLxuHbwKYrHq/oW9Ab4WnJ+fPTeVoHvS6h6+V9f
         Nf4aHZro33Q5X+ImkDUtsvNj/+MFYj6HNjM3ODPA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 124296049C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Miaoqing Pan <miaoqing@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rakesh Pillai <pillair@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>,
        Balaji Pothunoori <bpothuno@codeaurora.org>,
        Wen Gong <wgong@codeaurora.org>,
        Pradeep kumar Chitrapu <pradeepc@codeaurora.org>,
        Sriram R <srirrama@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] ath10k: work around uninitialized vht_pfr variable
References: <20190708125050.3689133-1-arnd@arndb.de>
Date:   Mon, 15 Jul 2019 12:44:33 +0300
In-Reply-To: <20190708125050.3689133-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Mon, 8 Jul 2019 14:50:06 +0200")
Message-ID: <87v9w3pr7i.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> As clang points out, the vht_pfr is assigned to a struct member
> without being initialized in one case:
>
> drivers/net/wireless/ath/ath10k/mac.c:7528:7: error: variable 'vht_pfr' is used uninitialized whenever 'if' condition
>       is false [-Werror,-Wsometimes-uninitialized]
>                 if (!ath10k_mac_can_set_bitrate_mask(ar, band, mask,
>                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/ath/ath10k/mac.c:7551:20: note: uninitialized use occurs here
>                 arvif->vht_pfr = vht_pfr;
>                                  ^~~~~~~
> drivers/net/wireless/ath/ath10k/mac.c:7528:3: note: remove the 'if' if its condition is always true
>                 if (!ath10k_mac_can_set_bitrate_mask(ar, band, mask,
>                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/ath/ath10k/mac.c:7483:12: note: initialize the variable 'vht_pfr' to silence this warning
>         u8 vht_pfr;
>
> Add an explicit but probably incorrect initialization here.
> I suspect we want a better fix here, but chose this approach to
> illustrate the issue.
>
> Fixes: 8b97b055dc9d ("ath10k: fix failure to set multiple fixed rate")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

I'll queue this for v5.3.

-- 
Kalle Valo
