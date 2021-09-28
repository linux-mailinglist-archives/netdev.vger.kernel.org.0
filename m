Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1722A41AD5D
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 12:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240237AbhI1K44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 06:56:56 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:20470 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240223AbhI1K4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 06:56:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1632826516; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=D+OE+2bP057AaZUh2ZBJbHsm1BvNBCz9ficS8dfx5KU=;
 b=Xyrb7Tse58evswzdQ9KR1nMKArpQnUxFtrdXSeEsCMmwSNn0wXIf+14fF4ZrD+YdBi7fVgKY
 Kf7jzBXM0Z1ZIFYOe9siNgogsroTsE5xzDLCkaQBlBsEV8JBxkFB40FUQlM3s9Nyxp6zYutW
 Al3ginegM93DVx3ZLGvkoq1AGck=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 6152f47d519bd8dcf01c06d9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 28 Sep 2021 10:54:53
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1656EC4360D; Tue, 28 Sep 2021 10:54:53 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E8DC3C4338F;
        Tue, 28 Sep 2021 10:54:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org E8DC3C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] ath11k: Replace one-element array with
 flexible-array
 member
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210823172159.GA25800@embeddedor>
References: <20210823172159.GA25800@embeddedor>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210928105453.1656EC4360D@smtp.codeaurora.org>
Date:   Tue, 28 Sep 2021 10:54:53 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:

> There is a regular need in the kernel to provide a way to declare having a
> dynamically sized set of trailing elements in a structure. Kernel code
> should always use "flexible array members"[1] for these cases. The older
> style of one-element or zero-length arrays should no longer be used[2].
> 
> Refactor the code a bit according to the use of a flexible-array member in
> struct scan_chan_list_params instead of a one-element array, and use the
> struct_size() helper.
> 
> Also, save 25 (too many) bytes that were being allocated:
> 
> $ pahole -C channel_param drivers/net/wireless/ath/ath11k/reg.o
> struct channel_param {
>         u8                         chan_id;              /*     0     1 */
>         u8                         pwr;                  /*     1     1 */
>         u32                        mhz;                  /*     2     4 */
> 
>         /* Bitfield combined with next fields */
> 
>         u32                        half_rate:1;          /*     4:16  4 */
>         u32                        quarter_rate:1;       /*     4:17  4 */
>         u32                        dfs_set:1;            /*     4:18  4 */
>         u32                        dfs_set_cfreq2:1;     /*     4:19  4 */
>         u32                        is_chan_passive:1;    /*     4:20  4 */
>         u32                        allow_ht:1;           /*     4:21  4 */
>         u32                        allow_vht:1;          /*     4:22  4 */
>         u32                        allow_he:1;           /*     4:23  4 */
>         u32                        set_agile:1;          /*     4:24  4 */
>         u32                        psc_channel:1;        /*     4:25  4 */
> 
>         /* XXX 6 bits hole, try to pack */
> 
>         u32                        phy_mode;             /*     8     4 */
>         u32                        cfreq1;               /*    12     4 */
>         u32                        cfreq2;               /*    16     4 */
>         char                       maxpower;             /*    20     1 */
>         char                       minpower;             /*    21     1 */
>         char                       maxregpower;          /*    22     1 */
>         u8                         antennamax;           /*    23     1 */
>         u8                         reg_class_id;         /*    24     1 */
> 
>         /* size: 25, cachelines: 1, members: 21 */
>         /* sum members: 23 */
>         /* sum bitfield members: 10 bits, bit holes: 1, sum bit holes: 6 bits */
>         /* last cacheline: 25 bytes */
> } __attribute__((__packed__));
> 
> as previously, sizeof(struct scan_chan_list_params) was 32 bytes:
> 
> $ pahole -C scan_chan_list_params drivers/net/wireless/ath/ath11k/reg.o
> struct scan_chan_list_params {
>         u32                        pdev_id;              /*     0     4 */
>         u16                        nallchans;            /*     4     2 */
>         struct channel_param       ch_param[1];          /*     6    25 */
> 
>         /* size: 32, cachelines: 1, members: 3 */
>         /* padding: 1 */
>         /* last cacheline: 32 bytes */
> };
> 
> and now with the flexible array transformation it is just 8 bytes:
> 
> $ pahole -C scan_chan_list_params drivers/net/wireless/ath/ath11k/reg.o
> struct scan_chan_list_params {
>         u32                        pdev_id;              /*     0     4 */
>         u16                        nallchans;            /*     4     2 */
>         struct channel_param       ch_param[];           /*     6     0 */
> 
>         /* size: 8, cachelines: 1, members: 3 */
>         /* padding: 2 */
>         /* last cacheline: 8 bytes */
> };
> 
> This helps with the ongoing efforts to globally enable -Warray-bounds and
> get us closer to being able to tighten the FORTIFY_SOURCE routines on
> memcpy().
> 
> This issue was found with the help of Coccinelle and audited and fixed,
> manually.
> 
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Link: https://github.com/KSPP/linux/issues/79
> Link: https://github.com/KSPP/linux/issues/109
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

b2549465cdea ath11k: Replace one-element array with flexible-array member

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210823172159.GA25800@embeddedor/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

