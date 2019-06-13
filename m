Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B09744683
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404349AbfFMQw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:52:27 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:18140 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730120AbfFMDRK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 23:17:10 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 527EFD4584B87ACC92FD;
        Thu, 13 Jun 2019 11:17:05 +0800 (CST)
Received: from [10.177.30.175] (10.177.30.175) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Thu, 13 Jun 2019 11:16:59 +0800
Subject: Re: [PATCH net-next v2 1/2] hinic: add rss support
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoshaokai@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>,
        <wulike1@huawei.com>
References: <20190611181234.4843-1-xuechaojing@huawei.com>
 <20190611181234.4843-2-xuechaojing@huawei.com>
 <20190612155603.4078ebb3@cakuba.netronome.com>
From:   xuechaojing <xuechaojing@huawei.com>
Message-ID: <2949b2f6-e975-f1f9-39a8-7633a34610e7@huawei.com>
Date:   Thu, 13 Jun 2019 11:16:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190612155603.4078ebb3@cakuba.netronome.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.30.175]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

UDP RSS is supported on hinic device, so we set udp rss type to 1.

Thanks for reviewing.

xue

дк 2019/6/13 6:56, Jakub Kicinski wrote:
> On Tue, 11 Jun 2019 18:12:33 +0000, Xue Chaojing wrote:
>> This patch adds rss support for the HINIC driver.
>>
>> Signed-off-by: Xue Chaojing <xuechaojing@huawei.com>
>> +static int hinic_rss_init(struct hinic_dev *nic_dev)
>> +{
>> +	u8 default_rss_key[HINIC_RSS_KEY_SIZE] = {
>> +			0x6d, 0x5a, 0x56, 0xda, 0x25, 0x5b, 0x0e, 0xc2,
>> +			0x41, 0x67, 0x25, 0x3d, 0x43, 0xa3, 0x8f, 0xb0,
>> +			0xd0, 0xca, 0x2b, 0xcb, 0xae, 0x7b, 0x30, 0xb4,
>> +			0x77, 0xcb, 0x2d, 0xa3, 0x80, 0x30, 0xf2, 0x0c,
>> +			0x6a, 0x42, 0xb7, 0x3b, 0xbe, 0xac, 0x01, 0xfa};
> netdev_rss_key_fill()
>
>> +	u32 indir_tbl[HINIC_RSS_INDIR_SIZE] = { 0 };
>> +	u8 tmpl_idx = nic_dev->rss_tmpl_idx;
>> +	int err, i;
>> +
>> +	for (i = 0; i < HINIC_RSS_INDIR_SIZE; i++)
>> +		indir_tbl[i] = (i / HINIC_RSS_INDIR_SIZE) * nic_dev->num_rss +
>> +				i % nic_dev->num_rss;
>> +
>> +	err = hinic_rss_set_template_tbl(nic_dev, tmpl_idx, default_rss_key);
>> +	if (err)
>> +		return err;
>> +
>> +	err = hinic_rss_set_indir_tbl(nic_dev, tmpl_idx, indir_tbl);
>> +	if (err)
>> +		return err;
>> +
>> +	err = hinic_set_rss_type(nic_dev, tmpl_idx, nic_dev->rss_type);
>> +	if (err)
>> +		return err;
>> +
>> +	err = hinic_rss_set_hash_engine(nic_dev, tmpl_idx,
>> +					nic_dev->rss_hash_engine);
>> +	if (err)
>> +		return err;
>> +
>> +	err = hinic_rss_cfg(nic_dev, 1, tmpl_idx);
>> +	if (err)
>> +		return err;
>> +
>> +	return 0;
>> +}
>> +
>> +static void hinic_rss_deinit(struct hinic_dev *nic_dev)
>> +{
>> +	hinic_rss_cfg(nic_dev, 0, nic_dev->rss_tmpl_idx);
>> +}
>> +
>> +static void hinic_init_rss_parameters(struct hinic_dev *nic_dev)
>> +{
>> +	nic_dev->rss_hash_engine = HINIC_RSS_HASH_ENGINE_TYPE_XOR;
>> +	nic_dev->rss_type.tcp_ipv6_ext = 1;
>> +	nic_dev->rss_type.ipv6_ext = 1;
>> +	nic_dev->rss_type.tcp_ipv6 = 1;
>> +	nic_dev->rss_type.ipv6 = 1;
>> +	nic_dev->rss_type.tcp_ipv4 = 1;
>> +	nic_dev->rss_type.ipv4 = 1;
>> +	nic_dev->rss_type.udp_ipv6 = 1;
>> +	nic_dev->rss_type.udp_ipv4 = 1;
> Usually UDP is disabled by default because fragmentation leads to
> reorders (NICs file all fragmented packets to queue 0 while other
> packets are distributed by RSS).
>
>> +}
>> +
>> +static void hinic_enable_rss(struct hinic_dev *nic_dev)
>> +{
>> +	struct net_device *netdev = nic_dev->netdev;
>> +	struct hinic_hwdev *hwdev = nic_dev->hwdev;
>> +	struct hinic_hwif *hwif = hwdev->hwif;
>> +	struct pci_dev *pdev = hwif->pdev;
>> +	int i, node, err = 0;
>> +	u16 num_cpus = 0;
>> +
>> +	nic_dev->max_qps = hinic_hwdev_max_num_qps(hwdev);
>> +	if (nic_dev->max_qps <= 1) {
>> +		nic_dev->flags &= ~HINIC_RSS_ENABLE;
>> +		nic_dev->rss_limit = nic_dev->max_qps;
>> +		nic_dev->num_qps = nic_dev->max_qps;
>> +		nic_dev->num_rss = nic_dev->max_qps;
>> +
>> +		return;
>> +	}
>> +
>> +	err = hinic_rss_template_alloc(nic_dev, &nic_dev->rss_tmpl_idx);
>> +	if (err) {
>> +		netif_err(nic_dev, drv, netdev,
>> +			  "Failed to alloc tmpl_idx for rss, can't enable rss for this function\n");
>> +		nic_dev->flags &= ~HINIC_RSS_ENABLE;
>> +		nic_dev->max_qps = 1;
>> +		nic_dev->rss_limit = nic_dev->max_qps;
>> +		nic_dev->num_qps = nic_dev->max_qps;
>> +		nic_dev->num_rss = nic_dev->max_qps;
>> +
>> +		return;
>> +	}
>> +
>> +	nic_dev->flags |= HINIC_RSS_ENABLE;
>> +
>> +	for (i = 0; i < num_online_cpus(); i++) {
>> +		node = cpu_to_node(i);
>> +		if (node == dev_to_node(&pdev->dev))
>> +			num_cpus++;
>> +	}
>> +
>> +	if (!num_cpus)
>> +		num_cpus = num_online_cpus();
>> +
>> +	nic_dev->num_qps = min_t(u16, nic_dev->max_qps, num_cpus);
> We generally use netif_get_num_default_rss_queues() for RX queues
> and num_online_cpus() for TX queues but I'm not sure you can do
> different counts, so it's probably fine.
> .
>
