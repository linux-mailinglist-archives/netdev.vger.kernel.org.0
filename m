Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4EA6DCBC
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 09:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbfD2HTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 03:19:05 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:46150 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727306AbfD2HTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 03:19:05 -0400
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3T7BApm016465;
        Mon, 29 Apr 2019 09:18:44 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=STMicroelectronics;
 bh=TykFYt9jpvTCwyKhyahs+89NrVvncrSmdvgdWwwYztk=;
 b=vpsxKVmdKayCtuheOa+LEhE9Hcpk7rlGwuMKQum+17xVVfQrvFfnO40kzSgCbA84AUwH
 L7SlOnCyZSO6lBJafRag5na2endexM3rAmXLyb+9FX1d3/Fp0Y9LXo9tCgLKmZbSVRiD
 JT3SIbLns4QyIg4IOxlefXJLcmjxlB5f+iIuKr0rglt2G9yRqur/OkXoVTvkPSgQyhbr
 nXHarlN5rFyPXEdrmmZlVsBlRfprzHc3Jfi16QGK6iYtvca8BiWCw3G/k3EuUN/JVPqV
 z2bZZIRjM0do9BmEnoL/IwY57OVi9H2q1HSY/7I0/7YQtbPw3yU/IcvISF0I/ju5oi/m KQ== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2s5u5d0g7p-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 29 Apr 2019 09:18:44 +0200
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 9757B31;
        Mon, 29 Apr 2019 07:18:43 +0000 (GMT)
Received: from Webmail-eu.st.com (sfhdag3node2.st.com [10.75.127.8])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 357AD122C;
        Mon, 29 Apr 2019 07:18:43 +0000 (GMT)
Received: from [10.48.0.204] (10.75.127.51) by SFHDAG3NODE2.st.com
 (10.75.127.8) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Mon, 29 Apr
 2019 09:18:43 +0200
Subject: Re: [PATCH 2/6] net: stmmac: fix csr_clk can't be zero issue
To:     Biao Huang <biao.huang@mediatek.com>,
        Jose Abreu <joabreu@synopsys.com>, <davem@davemloft.net>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <yt.shen@mediatek.com>,
        <jianguo.zhang@mediatek.com>
References: <1556433009-25759-1-git-send-email-biao.huang@mediatek.com>
 <1556433009-25759-3-git-send-email-biao.huang@mediatek.com>
From:   Alexandre Torgue <alexandre.torgue@st.com>
Message-ID: <24f4b268-aa7f-e1f7-59fc-2bc163eb8277@st.com>
Date:   Mon, 29 Apr 2019 09:18:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1556433009-25759-3-git-send-email-biao.huang@mediatek.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.75.127.51]
X-ClientProxiedBy: SFHDAG4NODE1.st.com (10.75.127.10) To SFHDAG3NODE2.st.com
 (10.75.127.8)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-29_04:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

On 4/28/19 8:30 AM, Biao Huang wrote:
> The specific clk_csr value can be zero, and
> stmmac_clk is necessary for MDC clock which can be set dynamically.
> So, change the condition from plat->clk_csr to plat->stmmac_clk to
> fix clk_csr can't be zero issue.
> 
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> ---
>   drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 818ad88..9e89b94 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -4376,7 +4376,7 @@ int stmmac_dvr_probe(struct device *device,
>   	 * set the MDC clock dynamically according to the csr actual
>   	 * clock input.
>   	 */
> -	if (!priv->plat->clk_csr)
> +	if (priv->plat->stmmac_clk)
>   		stmmac_clk_csr_set(priv);
>   	else
>   		priv->clk_csr = priv->plat->clk_csr;
> 

So, as soon as stmmac_clk will be declared, it is no longer possible to 
fix a CSR through the device tree ?
