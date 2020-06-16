Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BF41FAACB
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 10:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgFPILk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 04:11:40 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:13013 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgFPILi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jun 2020 04:11:38 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1592295097; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=9+bNEyX9TKpnegMA6tNmg75S3hpqEiep0k8ONIAoA/c=;
 b=d507kzRQ7yNPW8R2pY9LbY0cFPyZ1CdtOP6sj7+ncdvodJLlqWqlkpLc7Amb3a3zSD0sEokI
 9H/xtSRhgH1WTeYrkJvwh8bnd9i7NCf41Sb0x5S853ViGfkBQ9MQovwfCe2AX7hm2Hj2ZpPL
 Z+zSKKOEKSoVLHW4ZjAzCklh4SE=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n14.prod.us-west-2.postgun.com with SMTP id
 5ee87eb64c9690533a166edf (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 16 Jun 2020 08:11:34
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 84720C4339C; Tue, 16 Jun 2020 08:11:34 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3F846C433C8;
        Tue, 16 Jun 2020 08:11:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3F846C433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Wait until copy complete is actually done before
 completing
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200609082015.1.Ife398994e5a0a6830e4d4a16306ef36e0144e7ba@changeid>
References: <20200609082015.1.Ife398994e5a0a6830e4d4a16306ef36e0144e7ba@changeid>
To:     Douglas Anderson <dianders@chromium.org>
Cc:     kuabhs@google.com, pillair@codeaurora.org,
        saiprakash.ranjan@codeaurora.org, linux-arm-msm@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath10k@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200616081134.84720C4339C@smtp.codeaurora.org>
Date:   Tue, 16 Jun 2020 08:11:34 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Douglas Anderson <dianders@chromium.org> wrote:

> On wcn3990 we have "per_ce_irq = true".  That makes the
> ath10k_ce_interrupt_summary() function always return 0xfff. The
> ath10k_ce_per_engine_service_any() function will see this and think
> that _all_ copy engines have an interrupt.  Without checking, the
> ath10k_ce_per_engine_service() assumes that if it's called that the
> "copy complete" (cc) interrupt fired.  This combination seems bad.
> 
> Let's add a check to make sure that the "copy complete" interrupt
> actually fired in ath10k_ce_per_engine_service().
> 
> This might fix a hard-to-reproduce failure where it appears that the
> copy complete handlers run before the copy is really complete.
> Specifically a symptom was that we were seeing this on a Qualcomm
> sc7180 board:
>   arm-smmu 15000000.iommu: Unhandled context fault:
>   fsr=0x402, iova=0x7fdd45780, fsynr=0x30003, cbfrsynra=0xc1, cb=10
> 
> Even on platforms that don't have wcn3990 this still seems like it
> would be a sane thing to do.  Specifically the current IRQ handler
> comments indicate that there might be other misc interrupt sources
> firing that need to be cleared.  If one of those sources was the one
> that caused the IRQ handler to be called it would also be important to
> double-check that the interrupt we cared about actually fired.
> 
> Tested-on: WCN3990 SNOC WLAN.HL.3.2.2-00490-QCAHLSWMTPL-1
> 
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

8f9ed93d09a9 ath10k: Wait until copy complete is actually done before completing

-- 
https://patchwork.kernel.org/patch/11595887/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

