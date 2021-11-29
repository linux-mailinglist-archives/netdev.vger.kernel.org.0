Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A793846189C
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378494AbhK2Ocb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:32:31 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:45504 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378482AbhK2OaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:30:24 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0759A1FCA1;
        Mon, 29 Nov 2021 14:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1638196025; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cESAjeUfglTUr7szSA+VXFGaNNk5Imodw6mQbhRwcqM=;
        b=zx3vTE0qA6M+ONAYdF7FCLvjoDWk+VMNCgaZsncED4xdQO/sIMhQeDkYOBlaK06cG6UkEk
        UkS8JtmJ894xxyDTuJQ1syZcibPMrhenFB1c7LqNgiSVfGrp2xnKgf6Qst+i55UnB3rRKu
        jJIBiKaJeVy8j3QA/hdrr0JExh07mrA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1638196025;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cESAjeUfglTUr7szSA+VXFGaNNk5Imodw6mQbhRwcqM=;
        b=uDhxL1whI+L4wdAZ1PjYZSPJtkv/t91T7LeLhmYRytCeathGoruMcPOGHrxBMxC0Loikat
        dQGmvaiIKfd3B8AQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 83A8F13B15;
        Mon, 29 Nov 2021 14:27:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id LoS7GjfjpGH5fwAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Mon, 29 Nov 2021 14:27:03 +0000
Subject: Re: [PATCH net-next 01/10] net: hns3: refactor reset_prepare_general
 retry statement
To:     Guangbin Huang <huangguangbin2@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, wangjie125@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lipeng321@huawei.com, chenhao288@hisilicon.com
References: <20211129140027.23036-1-huangguangbin2@huawei.com>
 <20211129140027.23036-2-huangguangbin2@huawei.com>
From:   Denis Kirjanov <dkirjanov@suse.de>
Message-ID: <b66ad578-ab66-a6a5-961f-278db6ebe1dc@suse.de>
Date:   Mon, 29 Nov 2021 17:27:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211129140027.23036-2-huangguangbin2@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: ru
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



11/29/21 5:00 PM, Guangbin Huang пишет:
> From: Jiaran Zhang <zhangjiaran@huawei.com>
> 
> Currently, the hclge_reset_prepare_general function uses the goto
> statement to jump upwards, which increases code complexity and makes
> the program structure difficult to understand. In addition, if
> reset_pending is set, retry_cnt cannot be increased. This may result
> in a failure to exit the retry or increase the number of retries.
> 
> Use the while statement instead to make the program easier to understand
> and solve the problem that the goto statement cannot be exited.
> 
> Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> ---
>   .../hisilicon/hns3/hns3pf/hclge_main.c        | 32 ++++++++-----------
>   .../hisilicon/hns3/hns3vf/hclgevf_main.c      | 32 ++++++++-----------
>   2 files changed, 28 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> index a0628d139149..5282f2632b3b 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> @@ -11589,24 +11589,20 @@ static void hclge_reset_prepare_general(struct hnae3_ae_dev *ae_dev,
>   	int retry_cnt = 0;
>   	int ret;
>   
> -retry:
> -	down(&hdev->reset_sem);
> -	set_bit(HCLGE_STATE_RST_HANDLING, &hdev->state);
> -	hdev->reset_type = rst_type;
> -	ret = hclge_reset_prepare(hdev);
> -	if (ret || hdev->reset_pending) {
> -		dev_err(&hdev->pdev->dev, "fail to prepare to reset, ret=%d\n",
> -			ret);
> -		if (hdev->reset_pending ||
> -		    retry_cnt++ < HCLGE_RESET_RETRY_CNT) {
> -			dev_err(&hdev->pdev->dev,
> -				"reset_pending:0x%lx, retry_cnt:%d\n",
> -				hdev->reset_pending, retry_cnt);
> -			clear_bit(HCLGE_STATE_RST_HANDLING, &hdev->state);
> -			up(&hdev->reset_sem);
> -			msleep(HCLGE_RESET_RETRY_WAIT_MS);
> -			goto retry;
> -		}
> +	while (retry_cnt++ < HCLGE_RESET_RETRY_CNT) {
> +		down(&hdev->reset_sem);
> +		set_bit(HCLGE_STATE_RST_HANDLING, &hdev->state);
> +		hdev->reset_type = rst_type;
> +		ret = hclge_reset_prepare(hdev);
> +		if (!ret && !hdev->reset_pending)
> +			break;
up(&hdev->reset_sem); ?
> +
> +		dev_err(&hdev->pdev->dev,
> +			"failed to prepare to reset, ret=%d, reset_pending:0x%lx, retry_cnt:%d\n",
> +			ret, hdev->reset_pending, retry_cnt);
> +		clear_bit(HCLGE_STATE_RST_HANDLING, &hdev->state);
> +		up(&hdev->reset_sem);
> +		msleep(HCLGE_RESET_RETRY_WAIT_MS);
>   	}
>   
>   	/* disable misc vector before reset done */
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
> index 3f29062eaf2e..0568cc31d391 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
> @@ -2166,24 +2166,20 @@ static void hclgevf_reset_prepare_general(struct hnae3_ae_dev *ae_dev,
>   	int retry_cnt = 0;
>   	int ret;
>   
> -retry:
> -	down(&hdev->reset_sem);
> -	set_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state);
> -	hdev->reset_type = rst_type;
> -	ret = hclgevf_reset_prepare(hdev);
> -	if (ret) {
> -		dev_err(&hdev->pdev->dev, "fail to prepare to reset, ret=%d\n",
> -			ret);
> -		if (hdev->reset_pending ||
> -		    retry_cnt++ < HCLGEVF_RESET_RETRY_CNT) {
> -			dev_err(&hdev->pdev->dev,
> -				"reset_pending:0x%lx, retry_cnt:%d\n",
> -				hdev->reset_pending, retry_cnt);
> -			clear_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state);
> -			up(&hdev->reset_sem);
> -			msleep(HCLGEVF_RESET_RETRY_WAIT_MS);
> -			goto retry;
> -		}
> +	while (retry_cnt++ < HCLGEVF_RESET_RETRY_CNT) {
> +		down(&hdev->reset_sem);
> +		set_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state);
> +		hdev->reset_type = rst_type;
> +		ret = hclgevf_reset_prepare(hdev);
> +		if (!ret && !hdev->reset_pending)
> +			break;
same here
> +
> +		dev_err(&hdev->pdev->dev,
> +			"failed to prepare to reset, ret=%d, reset_pending:0x%lx, retry_cnt:%d\n",
> +			ret, hdev->reset_pending, retry_cnt);
> +		clear_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state);
> +		up(&hdev->reset_sem);
> +		msleep(HCLGEVF_RESET_RETRY_WAIT_MS);
>   	}
>   
>   	/* disable misc vector before reset done */
> 
