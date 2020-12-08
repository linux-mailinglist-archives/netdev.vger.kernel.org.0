Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDC72D2D39
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 15:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbgLHO3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 09:29:50 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:16770 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729139AbgLHO3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 09:29:50 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607437765; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=zEvZi81D/4nYKy0YNFoi1kytUzUR27z2/wK1lWEelI0=; b=tVVmGznjreqqgnSjjvnbWzq9sqqo/k3TRRd8kAXRg5HSJXZJfwsn1RxyluaikEnrEKNZxf70
 ZjeveouzYUVZaX18o9JEur5EHll/ZwilIROWybPY2ooeojAEqM/fXOXj3JzDHoOPIaWcmJKr
 hWvJF8hTeDa6dvVSDS3NrQqnqWk=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-west-2.postgun.com with SMTP id
 5fcf8dab9077141e62bb3aa8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 08 Dec 2020 14:28:59
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D17E6C433C6; Tue,  8 Dec 2020 14:28:58 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F123FC433C6;
        Tue,  8 Dec 2020 14:28:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F123FC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Xiaohui Zhang <ruc_zhangxiaohui@163.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mwifiex: Fix possible buffer overflows in mwifiex_uap_bss_param_prepare
References: <20201208113607.24967-1-ruc_zhangxiaohui@163.com>
Date:   Tue, 08 Dec 2020 16:28:53 +0200
In-Reply-To: <20201208113607.24967-1-ruc_zhangxiaohui@163.com> (Xiaohui
        Zhang's message of "Tue, 8 Dec 2020 19:36:07 +0800")
Message-ID: <87blf4e5i2.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xiaohui Zhang <ruc_zhangxiaohui@163.com> writes:

> From: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
>
> mwifiex_uap_bss_param_prepare() calls memcpy() without checking
> the destination size may trigger a buffer overflower,
> which a local user could use to cause denial of service or the
> execution of arbitrary code.
> Fix it by putting the length check before calling memcpy().
>
> Signed-off-by: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/uap_cmd.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
> index b48a85d79..fb937c7ee 100644
> --- a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
> +++ b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
> @@ -496,13 +496,16 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
>  	struct mwifiex_ie_types_wmmcap *wmm_cap;
>  	struct mwifiex_uap_bss_param *bss_cfg = cmd_buf;
>  	int i;
> +	int ssid_size;
>  	u16 cmd_size = *param_size;
>  
>  	if (bss_cfg->ssid.ssid_len) {
>  		ssid = (struct host_cmd_tlv_ssid *)tlv;
>  		ssid->header.type = cpu_to_le16(TLV_TYPE_UAP_SSID);
>  		ssid->header.len = cpu_to_le16((u16)bss_cfg->ssid.ssid_len);
> -		memcpy(ssid->ssid, bss_cfg->ssid.ssid, bss_cfg->ssid.ssid_len);
> +		ssid_size = bss_cfg->ssid.ssid_len > strlen(ssid->ssid) ?
> +				strlen(ssid->ssid) : bss_cfg->ssid.ssid_len;
> +		memcpy(ssid->ssid, bss_cfg->ssid.ssid, ssid_size);

I think using min_t() is cleaner. Then you would not need to add a
temporary variable.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
