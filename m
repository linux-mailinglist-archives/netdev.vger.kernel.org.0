Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8A13B0409
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 14:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbhFVMSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 08:18:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231284AbhFVMSd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 08:18:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57FAB6102A;
        Tue, 22 Jun 2021 12:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624364177;
        bh=+1Rkx2AAU1YZ/8Gjwnoz/KiMvPiJz7+wwcQW0aqUNWo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cEGaL8JTXU3ctEAiperZ9lZeOp/wOU3ZtQvKctfSXN43kZHbPq3R52h9iGd9DroYp
         KgJzb5wKbShoiqaLLHmt+mdf5Gq+u8MoRB6kMJb3JfGbaiHnezNvQ6my6p+FmabgNb
         W2cl6p2wLihMg/CoWvGceTBsLXRWYSVcPMrEWzSBoGqP+N9ji4++cCRycLcWMpbnS9
         x4hiTfQsAHGipi0homI19GJjFVDaOMHxUpz5+3j0vkS40YIcVHmSL0gRPOBBRUBZxR
         oso31RilcZvjQU7ZgpaxbslP89rbMHavToQP1tFo7kJRdPCHaiSld8UEqSWxRJIvWX
         2Q+HPXmXI1I/Q==
Date:   Tue, 22 Jun 2021 13:16:11 +0100
From:   Will Deacon <will@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, catalin.marinas@arm.com,
        maz@kernel.org, mark.rutland@arm.com, dbrazdil@google.com,
        qperret@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        lipeng321@huawei.com, peterz@infradead.org
Subject: Re: [PATCH net-next 2/3] net: hns3: add support for TX push mode
Message-ID: <20210622121611.GB30757@willie-the-truck>
References: <1624360271-17525-1-git-send-email-huangguangbin2@huawei.com>
 <1624360271-17525-3-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1624360271-17525-3-git-send-email-huangguangbin2@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 07:11:10PM +0800, Guangbin Huang wrote:
> From: Huazhong Tan <tanhuazhong@huawei.com>
> 
> For the device that supports the TX push capability, the BD can
> be directly copied to the device memory. However, due to hardware
> restrictions, the push mode can be used only when there are no
> more than two BDs, otherwise, the doorbell mode based on device
> memory is used.
> 
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 83 ++++++++++++++++++++--
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  6 ++
>  drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  2 +
>  .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |  2 +
>  .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 11 ++-
>  .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  8 +++
>  .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |  2 +
>  .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 11 ++-
>  .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  8 +++
>  10 files changed, 126 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
> index 0b202f4def83..3979d5d2e842 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
> +++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
> @@ -163,6 +163,7 @@ struct hnae3_handle;
>  
>  struct hnae3_queue {
>  	void __iomem *io_base;
> +	void __iomem *mem_base;
>  	struct hnae3_ae_algo *ae_algo;
>  	struct hnae3_handle *handle;
>  	int tqp_index;		/* index in a handle */
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> index cdb5f14fb6bc..8649bd8e1b57 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> @@ -2002,9 +2002,77 @@ static int hns3_fill_skb_to_desc(struct hns3_enet_ring *ring,
>  	return bd_num;
>  }
>  
> +static void hns3_tx_push_bd(struct hns3_enet_ring *ring, int num)
> +{
> +#define HNS3_BYTES_PER_64BIT		8
> +
> +	struct hns3_desc desc[HNS3_MAX_PUSH_BD_NUM] = {};
> +	int offset = 0;
> +
> +	/* make sure everything is visible to device before
> +	 * excuting tx push or updating doorbell
> +	 */
> +	dma_wmb();
> +
> +	do {
> +		int idx = (ring->next_to_use - num + ring->desc_num) %
> +			  ring->desc_num;
> +
> +		u64_stats_update_begin(&ring->syncp);
> +		ring->stats.tx_push++;
> +		u64_stats_update_end(&ring->syncp);
> +		memcpy(&desc[offset], &ring->desc[idx],
> +		       sizeof(struct hns3_desc));
> +		offset++;
> +	} while (--num);
> +
> +	__iowrite64_copy(ring->tqp->mem_base, desc,
> +			 (sizeof(struct hns3_desc) * HNS3_MAX_PUSH_BD_NUM) /
> +			 HNS3_BYTES_PER_64BIT);
> +
> +#if defined(CONFIG_ARM64)
> +	dgh();
> +#endif

It looks a bit weird putting this at the end of the function, given that
it's supposed to do something to a pair of accesses. Please can you explain
what it's doing, and also provide some numbers to show that it's worthwhile
(given that it's a performance hint not a correctness thing afaict).

> +}
> +
> +static void hns3_tx_mem_doorbell(struct hns3_enet_ring *ring)
> +{
> +#define HNS3_MEM_DOORBELL_OFFSET	64
> +
> +	__le64 bd_num = cpu_to_le64((u64)ring->pending_buf);
> +
> +	/* make sure everything is visible to device before
> +	 * excuting tx push or updating doorbell
> +	 */
> +	dma_wmb();
> +
> +	__iowrite64_copy(ring->tqp->mem_base + HNS3_MEM_DOORBELL_OFFSET,
> +			 &bd_num, 1);
> +	u64_stats_update_begin(&ring->syncp);
> +	ring->stats.tx_mem_doorbell += ring->pending_buf;
> +	u64_stats_update_end(&ring->syncp);
> +
> +#if defined(CONFIG_ARM64)
> +	dgh();
> +#endif

Same here.

Thanks,

Will
