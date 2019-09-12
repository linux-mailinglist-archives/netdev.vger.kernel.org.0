Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9F75B08CB
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 08:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbfILGXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 02:23:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:37638 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725765AbfILGXE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 02:23:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B5252AD14;
        Thu, 12 Sep 2019 06:23:01 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 0F4F4E0083; Thu, 12 Sep 2019 08:23:01 +0200 (CEST)
Date:   Thu, 12 Sep 2019 08:23:01 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Huazhong Tan <tanhuazhong@huawei.com>, davem@davemloft.net,
        linux-kernel@vger.kernel.org, salil.mehta@huawei.com,
        yisen.zhuang@huawei.com, linuxarm@huawei.com,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH V2 net-next 1/7] net: hns3: add ethtool_ops.set_channels
 support for HNS3 VF driver
Message-ID: <20190912062301.GE24779@unicorn.suse.cz>
References: <1568169639-43658-1-git-send-email-tanhuazhong@huawei.com>
 <1568169639-43658-2-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1568169639-43658-2-git-send-email-tanhuazhong@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 10:40:33AM +0800, Huazhong Tan wrote:
> From: Guangbin Huang <huangguangbin2@huawei.com>
> 
> This patch adds ethtool_ops.set_channels support for HNS3 VF driver,
> and updates related TQP information and RSS information, to support
> modification of VF TQP number, and uses current rss_size instead of
> max_rss_size to initialize RSS.
> 
> Also, fixes a format error in hclgevf_get_rss().
> 
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  1 +
>  .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 83 ++++++++++++++++++++--
>  2 files changed, 79 insertions(+), 5 deletions(-)
> 
...
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
> index 594cae8..e3090b3 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
...
> +static void hclgevf_update_rss_size(struct hnae3_handle *handle,
> +				    u32 new_tqps_num)
> +{
> +	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
> +	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
> +	u16 max_rss_size;
> +
> +	kinfo->req_rss_size = new_tqps_num;
> +
> +	max_rss_size = min_t(u16, hdev->rss_size_max,
> +			     hdev->num_tqps / kinfo->num_tc);
> +
> +	/* Use the user's configuration when it is not larger than
> +	 * max_rss_size, otherwise, use the maximum specification value.
> +	 */
> +	if (kinfo->req_rss_size != kinfo->rss_size && kinfo->req_rss_size &&
> +	    kinfo->req_rss_size <= max_rss_size)
> +		kinfo->rss_size = kinfo->req_rss_size;
> +	else if (kinfo->rss_size > max_rss_size ||
> +		 (!kinfo->req_rss_size && kinfo->rss_size < max_rss_size))
> +		kinfo->rss_size = max_rss_size;

I don't think requested channel count can be larger than max_rss_size
here. In ethtool_set_channels(), we check that requested channel counts
do not exceed maximum channel counts as reported by ->get_channels().
And hclgevf_get_max_channels() cannot return more than max_rss_size.

> +
> +	kinfo->num_tqps = kinfo->num_tc * kinfo->rss_size;
> +}
> +
> +static int hclgevf_set_channels(struct hnae3_handle *handle, u32 new_tqps_num,
> +				bool rxfh_configured)
> +{
> +	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
> +	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
> +	u16 cur_rss_size = kinfo->rss_size;
> +	u16 cur_tqps = kinfo->num_tqps;
> +	u32 *rss_indir;
> +	unsigned int i;
> +	int ret;
> +
> +	hclgevf_update_rss_size(handle, new_tqps_num);
> +
> +	ret = hclgevf_set_rss_tc_mode(hdev, kinfo->rss_size);
> +	if (ret)
> +		return ret;
> +
> +	/* RSS indirection table has been configuared by user */
> +	if (rxfh_configured)
> +		goto out;
> +
> +	/* Reinitializes the rss indirect table according to the new RSS size */
> +	rss_indir = kcalloc(HCLGEVF_RSS_IND_TBL_SIZE, sizeof(u32), GFP_KERNEL);
> +	if (!rss_indir)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < HCLGEVF_RSS_IND_TBL_SIZE; i++)
> +		rss_indir[i] = i % kinfo->rss_size;
> +
> +	ret = hclgevf_set_rss(handle, rss_indir, NULL, 0);
> +	if (ret)
> +		dev_err(&hdev->pdev->dev, "set rss indir table fail, ret=%d\n",
> +			ret);
> +
> +	kfree(rss_indir);
> +
> +out:
> +	if (!ret)
> +		dev_info(&hdev->pdev->dev,
> +			 "Channels changed, rss_size from %u to %u, tqps from %u to %u",
> +			 cur_rss_size, kinfo->rss_size,
> +			 cur_tqps, kinfo->rss_size * kinfo->num_tc);
> +
> +	return ret;
> +}

IIRC David asked you not to issue this log message in v1 review.

Michal Kubecek
