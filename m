Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C78C41CD94E
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 14:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729811AbgEKMFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 08:05:10 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:36053 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729591AbgEKMFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 08:05:09 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1589198708; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=Jmzs0E9+O1pVr2sYnBpw6y1FlvUw8+1YyjOY/kdYnfg=; b=Vv0khaGW9ocUPj51J11eIHVrmwREP5yHIcU3kRnsJHaTSNBVGzoDodsszAikYy7Ggw5oAvkr
 27+9sQ6RGOrBnyhViC2pv7/6IypTHZxdU9hH3eRayELi6uenpX7a5xoGBxg21anm5E1nDXc+
 0EJdKcoa1CN6eZdLKCiLxeqhzkE=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eb93f73.7fb15c6e5c00-smtp-out-n04;
 Mon, 11 May 2020 12:05:07 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 714F3C433BA; Mon, 11 May 2020 12:05:06 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 94199C433F2;
        Mon, 11 May 2020 12:05:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 94199C433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Maharaja Kennadyrajan <mkenna@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] ath10k: fix ath10k_pci struct layout
References: <20200509120707.188595-1-arnd@arndb.de>
        <20200509120707.188595-2-arnd@arndb.de>
Date:   Mon, 11 May 2020 15:05:01 +0300
In-Reply-To: <20200509120707.188595-2-arnd@arndb.de> (Arnd Bergmann's message
        of "Sat, 9 May 2020 14:06:33 +0200")
Message-ID: <87v9l24qz6.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> gcc-10 correctly points out a bug with a zero-length array in
> struct ath10k_pci:
>
> drivers/net/wireless/ath/ath10k/ahb.c: In function 'ath10k_ahb_remove':
> drivers/net/wireless/ath/ath10k/ahb.c:30:9: error: array subscript 0
> is outside the bounds of an interior zero-length array 'struct
> ath10k_ahb[0]' [-Werror=zero-length-bounds]
>    30 |  return &((struct ath10k_pci *)ar->drv_priv)->ahb[0];
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from drivers/net/wireless/ath/ath10k/ahb.c:13:
> drivers/net/wireless/ath/ath10k/pci.h:185:20: note: while referencing 'ahb'
>   185 |  struct ath10k_ahb ahb[0];
>       |                    ^~~
>
> The last addition to the struct ignored the comments and added
> new members behind the array that must remain last.
>
> Change it to a flexible-array member and move it last again to
> make it work correctly, prevent the same thing from happening
> again (all compilers warn about flexible-array members in the
> middle of a struct) and get it to build without warnings.

Very good find, thanks! This bug would cause all sort of strange memory
corruption issues.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
