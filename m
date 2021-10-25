Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E173143970C
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 15:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbhJYNHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 09:07:19 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:41752 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233433AbhJYNHS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 09:07:18 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635167096; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=kuLbeuqX9KK+/DlxCOlCZThwrFG8XXXwlh08K36ZZ5s=;
 b=if8G59GgoK4hUheKsPnWU/6uYhtWGiJD7uVhWyQNcpPWS4CSag/NQcHGsU8inF6UtudMBHZa
 bjDga0J8SPUN8D5A90OcUNqnamEUtBMISBUrmfLSZWtkQB0ks0qPVS4IT0YP3wMeu6UtM9Hf
 jwb1dAMLweW/r6qR/C2SyEIo9CM=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 6176ab53e29a872c21537b54 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 25 Oct 2021 13:04:19
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 283CBC4338F; Mon, 25 Oct 2021 13:04:19 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 864E6C4338F;
        Mon, 25 Oct 2021 13:04:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 864E6C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: fix invalid dma_addr_t token assignment
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20211014075153.3655910-1-arnd@kernel.org>
References: <20211014075153.3655910-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Alagu Sankar <alagusankar@silex-india.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Wen Gong <wgong@codeaurora.org>,
        Tamizh Chelvam <tamizhr@codeaurora.org>,
        Carl Huang <cjhuang@codeaurora.org>,
        Miaoqing Pan <miaoqing@codeaurora.org>,
        Ben Greear <greearb@candelatech.com>,
        Erik Stromdahl <erik.stromdahl@gmail.com>,
        Fabio Estevam <festevam@denx.de>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163516705229.3976.16508438608512725859.kvalo@codeaurora.org>
Date:   Mon, 25 Oct 2021 13:04:19 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> wrote:

> Using a kernel pointer in place of a dma_addr_t token can
> lead to undefined behavior if that makes it into cache
> management functions. The compiler caught one such attempt
> in a cast:
> 
> drivers/net/wireless/ath/ath10k/mac.c: In function 'ath10k_add_interface':
> drivers/net/wireless/ath/ath10k/mac.c:5586:47: error: cast from pointer to integer of different size [-Werror=pointer-to-int-cast]
>  5586 |                         arvif->beacon_paddr = (dma_addr_t)arvif->beacon_buf;
>       |                                               ^
> 
> Looking through how this gets used down the way, I'm fairly
> sure that beacon_paddr is never accessed again for ATH10K_DEV_TYPE_HL
> devices, and if it was accessed, that would be a bug.
> 
> Change the assignment to use a known-invalid address token
> instead, which avoids the warning and makes it easier to catch
> bugs if it does end up getting used.
> 
> Fixes: e263bdab9c0e ("ath10k: high latency fixes for beacon buffer")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

937e79c67740 ath10k: fix invalid dma_addr_t token assignment

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211014075153.3655910-1-arnd@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

