Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94D943CF693
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 11:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234021AbhGTIW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 04:22:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235161AbhGTIUc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 04:20:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D52406120C;
        Tue, 20 Jul 2021 09:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626771670;
        bh=cEWTm9YElVqn8nrIlxzmOQzY6oCucu2zcNTrBI2Bl2I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c9zJzvfj+LsWiPi831HHwuE17z7U88ZZWYVlvT4/Y5onLd33B9zz0/wvNb+h67KS3
         qp5PkapU5StnG9QMY3qt1hj/Qwp/s03ulXzAO31jcGPZdg7Y3tDCsJnxwA05fnb5AP
         DgwW6IHxjn83nEEvn81wc+Ja9H9slvP+RC59y3y5bqZWgMeG7LLtTBesDpTCS2Sp0x
         HGju946QDPSpRViMKc57zXS7Gmk95S8ro6FUqxJ7a71K5K/reprhb6VhAe5nWM6sqI
         4GrOCQbMdnuNHrceu8pTc8hwG9rMw6kai0P4ybOs92ikoBRfkUYtQDubMKwzAj0liQ
         reVf8XgitRtlg==
Date:   Tue, 20 Jul 2021 12:01:06 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Yufeng Mo <moyufeng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        shenjian15@huawei.com, lipeng321@huawei.com,
        yisen.zhuang@huawei.com, linyunsheng@huawei.com,
        zhangjiaran@huawei.com, huangguangbin2@huawei.com,
        chenhao288@hisilicon.com, salil.mehta@huawei.com,
        linuxarm@huawei.com, linuxarm@openeuler.org
Subject: Re: [PATCH RFC] net: hns3: add a module parameter wq_unbound
Message-ID: <YPaQ0qW+uIToEM6c@unreal>
References: <1626770097-56989-1-git-send-email-moyufeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1626770097-56989-1-git-send-email-moyufeng@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 04:34:57PM +0800, Yufeng Mo wrote:
> To meet the requirements of different scenarios, the WQ_UNBOUND
> flag of the workqueue is transferred as a module parameter. Users
> can flexibly configure the usage mode as required.
> 
> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 10 +++++++++-
>  drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 10 +++++++++-
>  2 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> index dd3354a..9816592 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> @@ -76,6 +76,10 @@ static struct hnae3_ae_algo ae_algo;
>  
>  static struct workqueue_struct *hclge_wq;
>  
> +static unsigned int wq_unbound;
> +module_param(wq_unbound, uint, 0400);
> +MODULE_PARM_DESC(wq_unbound, "Specifies WQ_UNBOUND flag for the workqueue, non-zero value takes effect");

Nice, but no. We don't like module parameters for such a basic thing.
Somehow all other NIC drivers in the world works without it and hns3
will success too.

Thanks

> +
>  static const struct pci_device_id ae_algo_pci_tbl[] = {
>  	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_GE), 0},
>  	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_25GE), 0},
> @@ -12936,7 +12940,11 @@ static int hclge_init(void)
>  {
>  	pr_info("%s is initializing\n", HCLGE_NAME);
>  
> -	hclge_wq = alloc_workqueue("%s", 0, 0, HCLGE_NAME);
> +	if (wq_unbound)
> +		hclge_wq = alloc_workqueue("%s", WQ_UNBOUND, 0, HCLGE_NAME);
> +	else
> +		hclge_wq = alloc_workqueue("%s", 0, 0, HCLGE_NAME);
> +
>  	if (!hclge_wq) {
>  		pr_err("%s: failed to create workqueue\n", HCLGE_NAME);
>  		return -ENOMEM;
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
> index 52eaf82..85f6772 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
> @@ -21,6 +21,10 @@ static struct hnae3_ae_algo ae_algovf;
>  
>  static struct workqueue_struct *hclgevf_wq;
>  
> +static unsigned int wq_unbound;
> +module_param(wq_unbound, uint, 0400);
> +MODULE_PARM_DESC(wq_unbound, "Specifies WQ_UNBOUND flag for the workqueue, non-zero value takes effect");
> +
>  static const struct pci_device_id ae_algovf_pci_tbl[] = {
>  	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_VF), 0},
>  	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_RDMA_DCB_PFC_VF),
> @@ -3855,7 +3859,11 @@ static int hclgevf_init(void)
>  {
>  	pr_info("%s is initializing\n", HCLGEVF_NAME);
>  
> -	hclgevf_wq = alloc_workqueue("%s", 0, 0, HCLGEVF_NAME);
> +	if (wq_unbound)
> +		hclgevf_wq = alloc_workqueue("%s", WQ_UNBOUND, 0, HCLGEVF_NAME);
> +	else
> +		hclgevf_wq = alloc_workqueue("%s", 0, 0, HCLGEVF_NAME);
> +
>  	if (!hclgevf_wq) {
>  		pr_err("%s: failed to create workqueue\n", HCLGEVF_NAME);
>  		return -ENOMEM;
> -- 
> 2.8.1
> 
