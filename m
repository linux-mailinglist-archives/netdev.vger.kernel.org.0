Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42F6F448036
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 14:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239911AbhKHN0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 08:26:04 -0500
Received: from m43-7.mailgun.net ([69.72.43.7]:46082 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238237AbhKHN0D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 08:26:03 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1636377799; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=DTMcPm/cwueMdFfAR9AcyxZ7qa7HBwR1hmM6DH/liIg=;
 b=LzafViFWjyPrgMB86/SN1l+gNCrcZ4oW+0lWPp0R9AFm1g5elhFZH0sAqSm4KAWCvJpRt3al
 e5XJLk6uUmIcp3It4dXoouSDpUB2I221Yhb/uJMJC0fGtpNEG+/jZUSwTzH+xDE85lKX9Qds
 WcxgBtj1OzERxuuxkt/s0lbaKCE=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 618924b88037be265194a6db (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 08 Nov 2021 13:23:04
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1E8D7C43616; Mon,  8 Nov 2021 13:23:04 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DA455C4338F;
        Mon,  8 Nov 2021 13:23:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org DA455C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 1/2] wcn36xx: populate band before determining rate on
 RX
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20211104010548.1107405-2-benl@squareup.com>
References: <20211104010548.1107405-2-benl@squareup.com>
To:     Benjamin Li <benl@squareup.com>
Cc:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        linux-arm-msm@vger.kernel.org, Benjamin Li <benl@squareup.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163637777872.12783.16534592377924140432.kvalo@codeaurora.org>
Date:   Mon,  8 Nov 2021 13:23:04 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Benjamin Li <benl@squareup.com> wrote:

> status.band is used in determination of status.rate -- for 5GHz on legacy
> rates there is a linear shift between the BD descriptor's rate field and
> the wcn36xx driver's rate table (wcn_5ghz_rates).
> 
> We have a special clause to populate status.band for hardware scan offload
> frames. However, this block occurs after status.rate is already populated.
> Correctly handle this dependency by moving the band block before the rate
> block.
> 
> This patch addresses kernel warnings & missing scan results for 5GHz APs
> that send their beacons/probe responses at the higher four legacy rates
> (24-54 Mbps), when using hardware scan offload:
> 
>   ------------[ cut here ]------------
>   WARNING: CPU: 0 PID: 0 at net/mac80211/rx.c:4532 ieee80211_rx_napi+0x744/0x8d8
>   Modules linked in: wcn36xx [...]
>   CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W         4.19.107-g73909fa #1
>   Hardware name: Square, Inc. T2 (all variants) (DT)
>   Call trace:
>   dump_backtrace+0x0/0x148
>   show_stack+0x14/0x1c
>   dump_stack+0xb8/0xf0
>   __warn+0x2ac/0x2d8
>   warn_slowpath_null+0x44/0x54
>   ieee80211_rx_napi+0x744/0x8d8
>   ieee80211_tasklet_handler+0xa4/0xe0
>   tasklet_action_common+0xe0/0x118
>   tasklet_action+0x20/0x28
>   __do_softirq+0x108/0x1ec
>   irq_exit+0xd4/0xd8
>   __handle_domain_irq+0x84/0xbc
>   gic_handle_irq+0x4c/0xb8
>   el1_irq+0xe8/0x190
>   lpm_cpuidle_enter+0x220/0x260
>   cpuidle_enter_state+0x114/0x1c0
>   cpuidle_enter+0x34/0x48
>   do_idle+0x150/0x268
>   cpu_startup_entry+0x20/0x24
>   rest_init+0xd4/0xe0
>   start_kernel+0x398/0x430
>   ---[ end trace ae28cb759352b403 ]---
> 
> Fixes: 8a27ca394782 ("wcn36xx: Correct band/freq reporting on RX")
> Signed-off-by: Benjamin Li <benl@squareup.com>
> Tested-by: Loic Poulain <loic.poulain@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

c9c5608fafe4 wcn36xx: populate band before determining rate on RX
cfdf6b19e750 wcn36xx: fix RX BD rate mapping for 5GHz legacy rates

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211104010548.1107405-2-benl@squareup.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

