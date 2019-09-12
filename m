Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8DEAB0A1D
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 10:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730226AbfILIVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 04:21:14 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:60670 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730033AbfILIU7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 04:20:59 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id CADD68FD58E36A7835F6;
        Thu, 12 Sep 2019 16:20:54 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Thu, 12 Sep 2019
 16:20:47 +0800
Subject: Re: [PATCH V2 net-next 1/7] net: hns3: add ethtool_ops.set_channels
 support for HNS3 VF driver
To:     Michal Kubecek <mkubecek@suse.cz>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>
References: <1568169639-43658-1-git-send-email-tanhuazhong@huawei.com>
 <1568169639-43658-2-git-send-email-tanhuazhong@huawei.com>
 <20190912062301.GE24779@unicorn.suse.cz>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <8d51697c-703e-09f2-74e1-c83a31b5f52f@huawei.com>
Date:   Thu, 12 Sep 2019 16:20:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20190912062301.GE24779@unicorn.suse.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Michal

On 2019/9/12 14:23, Michal Kubecek wrote:
> On Wed, Sep 11, 2019 at 10:40:33AM +0800, Huazhong Tan wrote:
>> From: Guangbin Huang <huangguangbin2@huawei.com>
>>
>> This patch adds ethtool_ops.set_channels support for HNS3 VF driver,
>> and updates related TQP information and RSS information, to support
>> modification of VF TQP number, and uses current rss_size instead of
>> max_rss_size to initialize RSS.
>>
>> Also, fixes a format error in hclgevf_get_rss().
>>
>> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
>> ---
>>   drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  1 +
>>   .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 83 ++++++++++++++++++++--
>>   2 files changed, 79 insertions(+), 5 deletions(-)
>>
> ...
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
>> index 594cae8..e3090b3 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
> ...
>> +static void hclgevf_update_rss_size(struct hnae3_handle *handle,
>> +				    u32 new_tqps_num)
>> +{
>> +	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
>> +	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
>> +	u16 max_rss_size;
>> +
>> +	kinfo->req_rss_size = new_tqps_num;
>> +
>> +	max_rss_size = min_t(u16, hdev->rss_size_max,
>> +			     hdev->num_tqps / kinfo->num_tc);
>> +
>> +	/* Use the user's configuration when it is not larger than
>> +	 * max_rss_size, otherwise, use the maximum specification value.
>> +	 */
>> +	if (kinfo->req_rss_size != kinfo->rss_size && kinfo->req_rss_size &&
>> +	    kinfo->req_rss_size <= max_rss_size)
>> +		kinfo->rss_size = kinfo->req_rss_size;
>> +	else if (kinfo->rss_size > max_rss_size ||
>> +		 (!kinfo->req_rss_size && kinfo->rss_size < max_rss_size))
>> +		kinfo->rss_size = max_rss_size;
> 
> I don't think requested channel count can be larger than max_rss_size
> here. In ethtool_set_channels(), we check that requested channel counts
> do not exceed maximum channel counts as reported by ->get_channels().
> And hclgevf_get_max_channels() cannot return more than max_rss_size.
> 

When we can modify the TC number (which PF has already supported, VF may 
implement in the future) using lldptool or tc cmd, 
hclgevf_update_rss_size will be called to update the rss information, 
which may also change max_rss_size,  so we will use max_rss_size instead 
if the kinfo->rss_size configured using ethtool is bigger than max_rss_size.

>> +
>> +	kinfo->num_tqps = kinfo->num_tc * kinfo->rss_size;
>> +}
>> +
>> +static int hclgevf_set_channels(struct hnae3_handle *handle, u32 new_tqps_num,
>> +				bool rxfh_configured)
>> +{
>> +	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
>> +	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
>> +	u16 cur_rss_size = kinfo->rss_size;
>> +	u16 cur_tqps = kinfo->num_tqps;
>> +	u32 *rss_indir;
>> +	unsigned int i;
>> +	int ret;
>> +
>> +	hclgevf_update_rss_size(handle, new_tqps_num);
>> +
>> +	ret = hclgevf_set_rss_tc_mode(hdev, kinfo->rss_size);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* RSS indirection table has been configuared by user */
>> +	if (rxfh_configured)
>> +		goto out;
>> +
>> +	/* Reinitializes the rss indirect table according to the new RSS size */
>> +	rss_indir = kcalloc(HCLGEVF_RSS_IND_TBL_SIZE, sizeof(u32), GFP_KERNEL);
>> +	if (!rss_indir)
>> +		return -ENOMEM;
>> +
>> +	for (i = 0; i < HCLGEVF_RSS_IND_TBL_SIZE; i++)
>> +		rss_indir[i] = i % kinfo->rss_size;
>> +
>> +	ret = hclgevf_set_rss(handle, rss_indir, NULL, 0);
>> +	if (ret)
>> +		dev_err(&hdev->pdev->dev, "set rss indir table fail, ret=%d\n",
>> +			ret);
>> +
>> +	kfree(rss_indir);
>> +
>> +out:
>> +	if (!ret)
>> +		dev_info(&hdev->pdev->dev,
>> +			 "Channels changed, rss_size from %u to %u, tqps from %u to %u",
>> +			 cur_rss_size, kinfo->rss_size,
>> +			 cur_tqps, kinfo->rss_size * kinfo->num_tc);
>> +
>> +	return ret;
>> +}
> 
> IIRC David asked you not to issue this log message in v1 review.
> 
> Michal Kubecek
> 

Sorry for missing this log.

Thanks.

> .
> 

