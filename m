Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982713631C0
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 20:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236877AbhDQSDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 14:03:40 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:56526 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236785AbhDQSDe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Apr 2021 14:03:34 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1618682587; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=77ncJEjRfMK0yVYGlnmMGSY/bUO7A8hdb0Dlgldpm4s=;
 b=jm6ahmR23Y83gVu5OnxT9YFyHNm7c3i37z6KiuE9cYOoCm8u/eO0QZ8C0Rns9nGIRWLCqIbB
 EgiJc5sGhLT454+ehSporeaoeGhGNF8g2+v/Lz9I5f+FBjdhFPNRQ5ub7fu8A9DMZ/+C/pnY
 +PNM7xjyA8lib8in7rJTruhvjNk=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 607b22cde0e9c9a6b6cc6ed1 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 17 Apr 2021 18:02:53
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AEB97C4338A; Sat, 17 Apr 2021 18:02:53 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F0C74C433D3;
        Sat, 17 Apr 2021 18:02:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F0C74C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net-next] airo: work around stack usage warning
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210323131634.2669455-1-arnd@kernel.org>
References: <20210323131634.2669455-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Lee Jones <lee.jones@linaro.org>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Tom Rix <trix@redhat.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210417180253.AEB97C4338A@smtp.codeaurora.org>
Date:   Sat, 17 Apr 2021 18:02:53 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> gcc-11 with KASAN on 32-bit arm produces a warning about a function
> that needs a lot of stack space:
> 
> drivers/net/wireless/cisco/airo.c: In function 'setup_card.constprop':
> drivers/net/wireless/cisco/airo.c:3960:1: error: the frame size of 1512 bytes is larger than 1400 bytes [-Werror=frame-larger-than=]
> 
> Most of this is from a single large structure that could be dynamically
> allocated or moved into the per-device structure.  However, as the callers
> all seem to have a fairly well bounded call chain, the easiest change
> is to pull out the part of the function that needs the large variables
> into a separate function and mark that as noinline_for_stack. This does
> not reduce the total stack usage, but it gets rid of the warning and
> requires minimal changes otherwise.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied to wireless-drivers-next.git, thanks.

7909a590eba6 airo: work around stack usage warning

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210323131634.2669455-1-arnd@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

