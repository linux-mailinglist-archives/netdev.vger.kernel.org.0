Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85CEF39C733
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 11:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhFEJ6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 05:58:52 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:4483 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhFEJ6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 05:58:52 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Fxw2c09bmzYd7L;
        Sat,  5 Jun 2021 17:54:16 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 17:57:02 +0800
Received: from [10.67.102.67] (10.67.102.67) by dggemi759-chm.china.huawei.com
 (10.1.198.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sat, 5 Jun
 2021 17:57:02 +0800
Subject: Re: [RESEND net-next 1/2] net: hns3: add support for PTP
To:     Richard Cochran <richardcochran@gmail.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>
References: <1622602664-20274-1-git-send-email-huangguangbin2@huawei.com>
 <1622602664-20274-2-git-send-email-huangguangbin2@huawei.com>
 <20210603131846.GB6216@hoboy.vegasvil.org>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <9dd4b064-216d-7bef-2399-aa2b2b0d170f@huawei.com>
Date:   Sat, 5 Jun 2021 17:57:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20210603131846.GB6216@hoboy.vegasvil.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/6/3 21:18, Richard Cochran wrote:
> On Wed, Jun 02, 2021 at 10:57:43AM +0800, Guangbin Huang wrote:
> 
>> +static int hclge_ptp_create_clock(struct hclge_dev *hdev)
>> +{
>> +#define HCLGE_PTP_NAME_LEN	32
>> +
>> +	struct hclge_ptp *ptp;
>> +
>> +	ptp = devm_kzalloc(&hdev->pdev->dev, sizeof(*ptp), GFP_KERNEL);
>> +	if (!ptp)
>> +		return -ENOMEM;
>> +
>> +	ptp->hdev = hdev;
>> +	snprintf(ptp->info.name, HCLGE_PTP_NAME_LEN, "%s",
>> +		 HCLGE_DRIVER_NAME);
>> +	ptp->info.owner = THIS_MODULE;
>> +	ptp->info.max_adj = HCLGE_PTP_CYCLE_ADJ_MAX;
>> +	ptp->info.n_ext_ts = 0;
>> +	ptp->info.pps = 0;
>> +	ptp->info.adjfreq = hclge_ptp_adjfreq;
>> +	ptp->info.adjtime = hclge_ptp_adjtime;
>> +	ptp->info.gettimex64 = hclge_ptp_gettimex;
>> +	ptp->info.settime64 = hclge_ptp_settime;
>> +
>> +	ptp->info.n_alarm = 0;
>> +	ptp->clock = ptp_clock_register(&ptp->info, &hdev->pdev->dev);
>> +	if (IS_ERR(ptp->clock)) {
>> +		dev_err(&hdev->pdev->dev, "%d failed to register ptp clock, ret = %ld\n",
>> +			ptp->info.n_alarm, PTR_ERR(ptp->clock));
>> +		return PTR_ERR(ptp->clock);
>> +	}
> 
> You must handle the case where NULL is returned.
> 
>   * ptp_clock_register() - register a PTP hardware clock driver
>   *
>   * @info:   Structure describing the new clock.
>   * @parent: Pointer to the parent device of the new clock.
>   *
>   * Returns a valid pointer on success or PTR_ERR on failure.  If PHC
>   * support is missing at the configuration level, this function
>   * returns NULL, and drivers are expected to gracefully handle that
>   * case separately.
> 
Ok, thank you.


>> +
>> +	ptp->io_base = hdev->hw.io_base + HCLGE_PTP_REG_OFFSET;
>> +	ptp->ts_cfg.rx_filter = HWTSTAMP_FILTER_NONE;
>> +	ptp->ts_cfg.tx_type = HWTSTAMP_TX_OFF;
>> +	hdev->ptp = ptp;
>> +
>> +	return 0;
>> +}
> 
> Thanks,
> Richard
> .
> 
