Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A1C39C778
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 12:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhFEKjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 06:39:10 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:4369 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhFEKjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 06:39:09 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Fxwvw0DlVz68tl;
        Sat,  5 Jun 2021 18:33:32 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 18:37:19 +0800
Received: from [10.67.102.67] (10.67.102.67) by dggemi759-chm.china.huawei.com
 (10.1.198.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sat, 5 Jun
 2021 18:37:18 +0800
Subject: Re: [RESEND net-next 1/2] net: hns3: add support for PTP
To:     Richard Cochran <richardcochran@gmail.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>
References: <1622602664-20274-1-git-send-email-huangguangbin2@huawei.com>
 <1622602664-20274-2-git-send-email-huangguangbin2@huawei.com>
 <20210603132237.GC6216@hoboy.vegasvil.org>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <a60de68c-ca2e-05e9-2770-a4d3ecb589ae@huawei.com>
Date:   Sat, 5 Jun 2021 18:37:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20210603132237.GC6216@hoboy.vegasvil.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/6/3 21:22, Richard Cochran wrote:
> On Wed, Jun 02, 2021 at 10:57:43AM +0800, Guangbin Huang wrote:
> 
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
>> new file mode 100644
>> index 000000000000..b133b5984584
>> --- /dev/null
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
>> @@ -0,0 +1,520 @@
>> +// SPDX-License-Identifier: GPL-2.0+
>> +// Copyright (c) 2021 Hisilicon Limited.
>> +
>> +#include <linux/skbuff.h>
>> +#include "hclge_main.h"
>> +#include "hnae3.h"
>> +
>> +static int hclge_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
>> +{
>> +	struct hclge_dev *hdev = hclge_ptp_get_hdev(ptp);
>> +	u64 adj_val, adj_base, diff;
>> +	bool is_neg = false;
>> +	u32 quo, numerator;
>> +
>> +	if (ppb < 0) {
>> +		ppb = -ppb;
>> +		is_neg = true;
>> +	}
>> +
>> +	adj_base = HCLGE_PTP_CYCLE_ADJ_BASE * HCLGE_PTP_CYCLE_ADJ_UNIT;
>> +	adj_val = adj_base * ppb;
>> +	diff = div_u64(adj_val, 1000000000ULL);
>> +
>> +	if (is_neg)
>> +		adj_val = adj_base - diff;
>> +	else
>> +		adj_val = adj_base + diff;
>> +
>> +	/* This clock cycle is defined by three part: quotient, numerator
>> +	 * and denominator. For example, 2.5ns, the quotient is 2,
>> +	 * denominator is fixed to HCLGE_PTP_CYCLE_ADJ_UNIT, and numerator
>> +	 * is 0.5 * HCLGE_PTP_CYCLE_ADJ_UNIT.
>> +	 */
>> +	quo = div_u64_rem(adj_val, HCLGE_PTP_CYCLE_ADJ_UNIT, &numerator);
>> +	writel(quo, hdev->ptp->io_base + HCLGE_PTP_CYCLE_QUO_REG);
>> +	writel(numerator, hdev->ptp->io_base + HCLGE_PTP_CYCLE_NUM_REG);
>> +	writel(HCLGE_PTP_CYCLE_ADJ_UNIT,
>> +	       hdev->ptp->io_base + HCLGE_PTP_CYCLE_DEN_REG);
>> +	writel(HCLGE_PTP_CYCLE_ADJ_EN,
>> +	       hdev->ptp->io_base + HCLGE_PTP_CYCLE_CFG_REG);
> 
> Need mutex or spinlock to protest against concurrent access.
> 
Ok, thank you. Is it better to add mutex or spinlock in the public place, like ptp_clock_adjtime()?
Then there's no need to add mutex or spinlock in all the drives.


>> +
>> +	return 0;
>> +}
>> +
>> +bool hclge_ptp_set_tx_info(struct hnae3_handle *handle, struct sk_buff *skb)
>> +{
>> +	struct hclge_vport *vport = hclge_get_vport(handle);
>> +	struct hclge_dev *hdev = vport->back;
>> +	struct hclge_ptp *ptp = hdev->ptp;
>> +
>> +	if (!test_bit(HCLGE_PTP_FLAG_TX_EN, &ptp->flags) ||
>> +	    test_and_set_bit(HCLGE_STATE_PTP_TX_HANDLING, &hdev->state)) {
>> +		ptp->tx_skipped++;
>> +		return false;
>> +	}
>> +
>> +	ptp->tx_start = jiffies;
>> +	ptp->tx_skb = skb_get(skb);
>> +	ptp->tx_cnt++;
>> +
>> +	return true;
>> +}
>> +
>> +void hclge_ptp_clean_tx_hwts(struct hclge_dev *hdev)
>> +{
>> +	struct sk_buff *skb = hdev->ptp->tx_skb;
>> +	struct skb_shared_hwtstamps hwts;
>> +	u32 hi, lo;
>> +	u64 ns;
>> +
>> +	ns = readl(hdev->ptp->io_base + HCLGE_PTP_TX_TS_NSEC_REG) &
>> +	     HCLGE_PTP_TX_TS_NSEC_MASK;
>> +	lo = readl(hdev->ptp->io_base + HCLGE_PTP_TX_TS_SEC_L_REG);
>> +	hi = readl(hdev->ptp->io_base + HCLGE_PTP_TX_TS_SEC_H_REG) &
>> +	     HCLGE_PTP_TX_TS_SEC_H_MASK;
>> +	hdev->ptp->last_tx_seqid = readl(hdev->ptp->io_base +
>> +		HCLGE_PTP_TX_TS_SEQID_REG);
>> +
>> +	if (skb) {
>> +		hdev->ptp->tx_skb = NULL;
>> +		hdev->ptp->tx_cleaned++;
>> +
>> +		ns += (((u64)hi) << 32 | lo) * NSEC_PER_SEC;
>> +		hwts.hwtstamp = ns_to_ktime(ns);
>> +		skb_tstamp_tx(skb, &hwts);
>> +		dev_kfree_skb_any(skb);
>> +	}
>> +
>> +	clear_bit(HCLGE_STATE_PTP_TX_HANDLING, &hdev->state);
>> +}
>> +
>> +void hclge_ptp_get_rx_hwts(struct hnae3_handle *handle, struct sk_buff *skb,
>> +			   u32 nsec, u32 sec)
>> +{
>> +	struct hclge_vport *vport = hclge_get_vport(handle);
>> +	struct hclge_dev *hdev = vport->back;
>> +	u64 ns = nsec;
>> +	u32 sec_h;
>> +
>> +	if (!test_bit(HCLGE_PTP_FLAG_RX_EN, &hdev->ptp->flags))
>> +		return;
>> +
>> +	/* Since the BD does not have enough space for the higher 16 bits of
>> +	 * second, and this part will not change frequently, so read it
>> +	 * from register.
>> +	 */
>> +	sec_h = readl(hdev->ptp->io_base + HCLGE_PTP_CUR_TIME_SEC_H_REG);
> 
> Need mutex or spinlock to protest against concurrent acces. >
Same above.

>> +	ns += (((u64)sec_h) << HCLGE_PTP_SEC_H_OFFSET | sec) * NSEC_PER_SEC;
>> +	skb_hwtstamps(skb)->hwtstamp = ns_to_ktime(ns);
>> +	hdev->ptp->last_rx = jiffies;
>> +	hdev->ptp->rx_cnt++;
>> +}
>> +
>> +static int hclge_ptp_gettimex(struct ptp_clock_info *ptp, struct timespec64 *ts,
>> +			      struct ptp_system_timestamp *sts)
>> +{
>> +	struct hclge_dev *hdev = hclge_ptp_get_hdev(ptp);
>> +	u32 hi, lo;
>> +	u64 ns;
>> +
>> +	ns = readl(hdev->ptp->io_base + HCLGE_PTP_CUR_TIME_NSEC_REG);
>> +	hi = readl(hdev->ptp->io_base + HCLGE_PTP_CUR_TIME_SEC_H_REG);
>> +	lo = readl(hdev->ptp->io_base + HCLGE_PTP_CUR_TIME_SEC_L_REG);
> 
> Need mutex or spinlock to protest against concurrent access.
> 
Same above.

>> +	ns += (((u64)hi) << HCLGE_PTP_SEC_H_OFFSET | lo) * NSEC_PER_SEC;
>> +	*ts = ns_to_timespec64(ns);
>> +
>> +	return 0;
>> +}
>> +
>> +static int hclge_ptp_settime(struct ptp_clock_info *ptp,
>> +			     const struct timespec64 *ts)
>> +{
>> +	struct hclge_dev *hdev = hclge_ptp_get_hdev(ptp);
>> +
>> +	writel(ts->tv_nsec, hdev->ptp->io_base + HCLGE_PTP_TIME_NSEC_REG);
>> +	writel(ts->tv_sec >> HCLGE_PTP_SEC_H_OFFSET,
>> +	       hdev->ptp->io_base + HCLGE_PTP_TIME_SEC_H_REG);
>> +	writel(ts->tv_sec & HCLGE_PTP_SEC_L_MASK,
>> +	       hdev->ptp->io_base + HCLGE_PTP_TIME_SEC_L_REG);
>> +	/* synchronize the time of phc */
>> +	writel(HCLGE_PTP_TIME_SYNC_EN,
>> +	       hdev->ptp->io_base + HCLGE_PTP_TIME_SYNC_REG);
> 
> Need mutex or spinlock to protest against concurrent access.
> 
Same above.

>> +	return 0;
>> +}
>> +
>> +static int hclge_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
>> +{
>> +	struct hclge_dev *hdev = hclge_ptp_get_hdev(ptp);
>> +	bool is_neg = false;
>> +	u32 adj_val = 0;
>> +
>> +	if (delta < 0) {
>> +		adj_val |= HCLGE_PTP_TIME_NSEC_NEG;
>> +		delta = -delta;
>> +		is_neg = true;
>> +	}
>> +
>> +	if (delta > HCLGE_PTP_TIME_NSEC_MASK) {
>> +		struct timespec64 ts;
>> +		s64 ns;
>> +
>> +		hclge_ptp_gettimex(ptp, &ts, NULL);
>> +		ns = timespec64_to_ns(&ts);
>> +		ns = is_neg ? ns - delta : ns + delta;
>> +		ts = ns_to_timespec64(ns);
>> +		return hclge_ptp_settime(ptp, &ts);
>> +	}
>> +
>> +	adj_val |= delta & HCLGE_PTP_TIME_NSEC_MASK;
>> +	writel(adj_val, hdev->ptp->io_base + HCLGE_PTP_TIME_NSEC_REG);
>> +	writel(HCLGE_PTP_TIME_ADJ_EN,
>> +	       hdev->ptp->io_base + HCLGE_PTP_TIME_ADJ_REG);
> 
> Need mutex or spinlock to protest against concurrent access.
> 
Same above.

>> +
>> +	return 0;
>> +}
> 
> Thanks,
> Richard
> 
> .
> 
