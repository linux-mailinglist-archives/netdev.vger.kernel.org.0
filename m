Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79EDCE59B
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 17:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbfD2PAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 11:00:08 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:50630 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727554AbfD2PAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 11:00:08 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A0870605A2; Mon, 29 Apr 2019 15:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556550007;
        bh=mHup5k9ZCfKV1PfVTqHBaSY29GNx3PRyyBYmbRS7aLM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=j2LxU8F1qOs2OE4uBecjstZomV/A/s6CUFUHsIXfCBx2C5y/S61mnN4+Jp1AwuYRr
         tt+zfUL7EOc77bNtvdc4f4cKUFqHTPrtHrGpUEQ1K2T7f/gkNy3MSkDMiIAvj/VQCd
         S//SkXTGDVd86IlnKV4lndyjtzk2UIKGr4PmhQkk=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0A2026029B;
        Mon, 29 Apr 2019 15:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556550007;
        bh=mHup5k9ZCfKV1PfVTqHBaSY29GNx3PRyyBYmbRS7aLM=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=FwszScJIdz7W9jQ+gmXP8HU0oD6gCUmG2ms46O6G9ipFA6T8O6pjqL99Dp8Mmq1lQ
         CSu9ipLTl3kVeOCFgaAQuyFOWh3i+CoFunDEh2IGTjzqSD0ZH1J5/AikzVtLoIkSkR
         fd/vsJBhCNT4ShC6r58KvP1vIfV10vQ6pgCqwR08=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0A2026029B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wil6210: fix potential out-of-bounds read
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190415145646.GA16597@embeddedor>
References: <20190415145646.GA16597@embeddedor>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Maya Erez <merez@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190429150007.A0870605A2@smtp.codeaurora.org>
Date:   Mon, 29 Apr 2019 15:00:07 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> Notice that *rc* can evaluate to up to 5, include/linux/netdevice.h:
> 
> enum gro_result {
>         GRO_MERGED,
>         GRO_MERGED_FREE,
>         GRO_HELD,
>         GRO_NORMAL,
>         GRO_DROP,
>         GRO_CONSUMED,
> };
> typedef enum gro_result gro_result_t;
> 
> In case *rc* evaluates to 5, we end up having an out-of-bounds read
> at drivers/net/wireless/ath/wil6210/txrx.c:821:
> 
> 	wil_dbg_txrx(wil, "Rx complete %d bytes => %s\n",
> 		     len, gro_res_str[rc]);
> 
> Fix this by adding element "GRO_CONSUMED" to array gro_res_str.
> 
> Addresses-Coverity-ID: 1444666 ("Out-of-bounds read")
> Fixes: 194b482b5055 ("wil6210: Debug print GRO Rx result")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Reviewed-by: Maya Erez <merez@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

bfabdd699732 wil6210: fix potential out-of-bounds read

-- 
https://patchwork.kernel.org/patch/10901053/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

