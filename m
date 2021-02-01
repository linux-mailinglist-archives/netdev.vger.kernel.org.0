Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA6F30B211
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 22:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbhBAV0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 16:26:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:52642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229680AbhBAV0k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 16:26:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46CFF64E31;
        Mon,  1 Feb 2021 21:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612214760;
        bh=J5TM4R41MpNe4ISkH09rg9a3/MJ/JCeNIH6/Zf2mVgA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RevoFLoIgzXWiMDgS59EBjCTkp7kONnISazwtrVcgTbHVQwx/FuU2jRsdRvHvtuOf
         VCHwxijhoy0nZ2QV5BNsXVUg7wlGdpjQQDLQ/1D/R93iGah7ipevlXi+vSBIxVgqxf
         rD3daeDjL/NKp/5XgFTASUG6+wA+5D1ez1bMjDp8XmnrxfASsMbrprD4aZdV/qaXnY
         ACuKiQWK0MWhxTweepePzdVGvbNp7CiM5yC7Mdz3S+IrJ1s3Yxprs48PC9KV5j8H05
         HZQ0piTBR7qaD6ayj+Hkpzjao7wjXzwBJXuDukOapp2hvh+jFZ+/HFzOp9HtSy3cW5
         vxgiVtLV7k3+Q==
Date:   Mon, 1 Feb 2021 14:25:57 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com, kuba@kernel.org,
        huangdaode@huawei.com, linuxarm@openeuler.org,
        Guangbin Huang <huangguangbin2@huawei.com>
Subject: Re: [PATCH V2 net-next 2/2] net: hns3: add debugfs support for tm
 nodes, priority and qset info
Message-ID: <20210201212557.GA3126741@localhost>
References: <1611834696-56207-1-git-send-email-tanhuazhong@huawei.com>
 <1611834696-56207-3-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611834696-56207-3-git-send-email-tanhuazhong@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 07:51:36PM +0800, Huazhong Tan wrote:
> From: Guangbin Huang <huangguangbin2@huawei.com>
> 
> In order to query tm info of nodes, priority and qset
> for debugging, adds three debugfs files tm_nodes,
> tm_priority and tm_qset in newly created tm directory.
> 
> Unlike previous debugfs commands, these three files
> just support read ops, so they only support to use cat
> command to dump their info.
> 
> The new tm file style is acccording to suggestion from
> Jakub Kicinski's opinion as link https://lkml.org/lkml/2020/9/29/2101.
> 
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   8 ++
>  drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  55 +++++++-
>  .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 153 +++++++++++++++++++++
>  .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   1 +
>  .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   2 +
>  5 files changed, 218 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
> index a7daf6d..fe09cf6 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
> +++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
> @@ -465,6 +465,8 @@ struct hnae3_ae_dev {
>   *   Delete clsflower rule
>   * cls_flower_active
>   *   Check if any cls flower rule exist
> + * dbg_read_cmd
> + *   Execute debugfs read command.
>   */
>  struct hnae3_ae_ops {
>  	int (*init_ae_dev)(struct hnae3_ae_dev *ae_dev);
> @@ -620,6 +622,8 @@ struct hnae3_ae_ops {
>  	int (*add_arfs_entry)(struct hnae3_handle *handle, u16 queue_id,
>  			      u16 flow_id, struct flow_keys *fkeys);
>  	int (*dbg_run_cmd)(struct hnae3_handle *handle, const char *cmd_buf);
> +	int (*dbg_read_cmd)(struct hnae3_handle *handle, const char *cmd_buf,
> +			    char *buf, int len);
>  	pci_ers_result_t (*handle_hw_ras_error)(struct hnae3_ae_dev *ae_dev);
>  	bool (*get_hw_reset_stat)(struct hnae3_handle *handle);
>  	bool (*ae_dev_resetting)(struct hnae3_handle *handle);
> @@ -777,6 +781,10 @@ struct hnae3_handle {
>  #define hnae3_get_bit(origin, shift) \
>  	hnae3_get_field((origin), (0x1 << (shift)), (shift))
>  
> +#define HNAE3_DBG_TM_NODES		"tm_nodes"
> +#define HNAE3_DBG_TM_PRI		"tm_priority"
> +#define HNAE3_DBG_TM_QSET		"tm_qset"
> +
>  int hnae3_register_ae_dev(struct hnae3_ae_dev *ae_dev);
>  void hnae3_unregister_ae_dev(struct hnae3_ae_dev *ae_dev);
>  
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
> index 9d4e9c0..6978304 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
> @@ -7,7 +7,7 @@
>  #include "hnae3.h"
>  #include "hns3_enet.h"
>  
> -#define HNS3_DBG_READ_LEN 256
> +#define HNS3_DBG_READ_LEN 65536
>  #define HNS3_DBG_WRITE_LEN 1024
>  
>  static struct dentry *hns3_dbgfs_root;
> @@ -484,6 +484,42 @@ static ssize_t hns3_dbg_cmd_write(struct file *filp, const char __user *buffer,
>  	return count;
>  }
>  
> +static ssize_t hns3_dbg_read(struct file *filp, char __user *buffer,
> +			     size_t count, loff_t *ppos)
> +{
> +	struct hnae3_handle *handle = filp->private_data;
> +	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
> +	struct hns3_nic_priv *priv = handle->priv;
> +	char *cmd_buf, *read_buf;
> +	ssize_t size = 0;
> +	int ret = 0;
> +
> +	if (!filp->f_path.dentry->d_iname)
> +		return -EINVAL;

Clang warns this check is pointless:

drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c:497:28: warning:
address of array 'filp->f_path.dentry->d_iname' will always evaluate to
'true' [-Wpointer-bool-conversion]
        if (!filp->f_path.dentry->d_iname)
            ~~~~~~~~~~~~~~~~~~~~~~^~~~~~~
1 warning generated.

Was it intended to be something else or can it just be removed?

> +	read_buf = kzalloc(HNS3_DBG_READ_LEN, GFP_KERNEL);
> +	if (!read_buf)
> +		return -ENOMEM;
> +
> +	cmd_buf = filp->f_path.dentry->d_iname;
> +
> +	if (ops->dbg_read_cmd)
> +		ret = ops->dbg_read_cmd(handle, cmd_buf, read_buf,
> +					HNS3_DBG_READ_LEN);
> +
> +	if (ret) {
> +		dev_info(priv->dev, "unknown command\n");
> +		goto out;
> +	}
> +
> +	size = simple_read_from_buffer(buffer, count, ppos, read_buf,
> +				       strlen(read_buf));
> +
> +out:
> +	kfree(read_buf);
> +	return size;
> +}

Cheers,
Nathan
