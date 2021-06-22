Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1B73B08CF
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 17:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbhFVP1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 11:27:03 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:55658 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232261AbhFVP0y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 11:26:54 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624375479; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=QBiR2dvj4W5lDYRv8mZ1n6ge+cEkkiiBArMH1RJ+mC4=;
 b=xT/M6ILkLzT9O3SEkb/PUDAFabI2sqcUBDJ0C5LFz94qxRxEW8ADl6eBIzSSeb68y17+yvNh
 Ozt2jH/lmS0cpZBSttgXm16Z7h2HjAghF+TS2I3n/aGwGlbl7eZHVu47zFvbmeHSmk3zmkcz
 Z3cYsDGRQlyu2cyxC3ln7tNmdwg=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 60d2009b32b73d6b28258ae8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 22 Jun 2021 15:24:11
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 74439C43460; Tue, 22 Jun 2021 15:24:10 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 46588C43460;
        Tue, 22 Jun 2021 15:24:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 46588C43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] mwl8k: Avoid memcpy() over-reading of mcs.rx_mask
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210617041431.2168953-1-keescook@chromium.org>
References: <20210617041431.2168953-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Kees Cook <keescook@chromium.org>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Romain Perier <romain.perier@gmail.com>,
        Allen Pais <allen.lkml@gmail.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        wengjianfeng <wengjianfeng@yulong.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210622152410.74439C43460@smtp.codeaurora.org>
Date:   Tue, 22 Jun 2021 15:24:10 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> wrote:

> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally reading across neighboring array fields. Use the
> sub-structure address directly.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Patch applied to wireless-drivers-next.git, thanks.

3f26f7665c5d mwl8k: Avoid memcpy() over-reading of mcs.rx_mask

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210617041431.2168953-1-keescook@chromium.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

