Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3891138E6
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 01:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbfLEAkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 19:40:18 -0500
Received: from mga01.intel.com ([192.55.52.88]:64838 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728011AbfLEAkR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 19:40:17 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Dec 2019 16:40:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,279,1571727600"; 
   d="scan'208";a="223447984"
Received: from allen-box.sh.intel.com (HELO [10.239.159.136]) ([10.239.159.136])
  by orsmga002.jf.intel.com with ESMTP; 04 Dec 2019 16:40:06 -0800
Cc:     baolu.lu@linux.intel.com, james.quinlan@broadcom.com,
        mbrugger@suse.com, f.fainelli@gmail.com, phil@raspberrypi.org,
        wahrenst@gmx.net, jeremy.linton@arm.com, linux-pci@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Robin Murphy <robin.murphy@arm.con>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        linux-clk@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rdma@vger.kernel.org, iommu@lists.linux-foundation.org,
        netdev@vger.kernel.org, kexec@lists.infradead.org,
        linux-nfs@vger.kernel.org
Subject: Re: [PATCH v4 7/8] linux/log2.h: Fix 64bit calculations in
 roundup/down_pow_two()
To:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        andrew.murray@arm.com, maz@kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        =?UTF-8?Q?Emilio_L=c3=b3pez?= <emilio@elopez.com.ar>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Moni Shoua <monis@mellanox.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Thomas Graf <tgraf@suug.ch>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <20191203114743.1294-1-nsaenzjulienne@suse.de>
 <20191203114743.1294-8-nsaenzjulienne@suse.de>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <1adefda1-5823-0028-b1c6-6b5dfedbdb13@linux.intel.com>
Date:   Thu, 5 Dec 2019 08:39:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191203114743.1294-8-nsaenzjulienne@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 12/3/19 7:47 PM, Nicolas Saenz Julienne wrote:
> Some users need to make sure their rounding function accepts and returns
> 64bit long variables regardless of the architecture. Sadly
> roundup/rounddown_pow_two() takes and returns unsigned longs. It turns
> out ilog2() already handles 32/64bit calculations properly, and being
> the building block to the round functions we can rework them as a
> wrapper around it.
> 
> Suggested-by: Robin Murphy <robin.murphy@arm.con>
> Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
> ---
>   drivers/clk/clk-divider.c                    |  8 ++--
>   drivers/clk/sunxi/clk-sunxi.c                |  2 +-
>   drivers/infiniband/hw/hfi1/chip.c            |  4 +-
>   drivers/infiniband/hw/hfi1/init.c            |  4 +-
>   drivers/infiniband/hw/mlx4/srq.c             |  2 +-
>   drivers/infiniband/hw/mthca/mthca_srq.c      |  2 +-
>   drivers/infiniband/sw/rxe/rxe_qp.c           |  4 +-
>   drivers/iommu/intel-iommu.c                  |  4 +-
>   drivers/iommu/intel-svm.c                    |  4 +-
>   drivers/iommu/intel_irq_remapping.c          |  2 +-

For changes in drivers/iommu/intel*.c,

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Best regards,
baolu

>   drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c |  4 +-
>   drivers/net/ethernet/marvell/sky2.c          |  2 +-
>   drivers/net/ethernet/rocker/rocker_hw.h      |  4 +-
>   drivers/net/ethernet/sfc/ef10.c              |  2 +-
>   drivers/net/ethernet/sfc/efx.h               |  2 +-
>   drivers/net/ethernet/sfc/falcon/efx.h        |  2 +-
>   drivers/pci/msi.c                            |  2 +-
>   include/linux/log2.h                         | 44 +++++---------------
>   kernel/kexec_core.c                          |  3 +-
>   lib/rhashtable.c                             |  2 +-
>   net/sunrpc/xprtrdma/verbs.c                  |  2 +-
>   21 files changed, 41 insertions(+), 64 deletions(-)
> 
> diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
> index 098b2b01f0af..ba947e4c8193 100644
> --- a/drivers/clk/clk-divider.c
> +++ b/drivers/clk/clk-divider.c
> @@ -222,7 +222,7 @@ static int _div_round_up(const struct clk_div_table *table,
>   	int div = DIV_ROUND_UP_ULL((u64)parent_rate, rate);
>   
>   	if (flags & CLK_DIVIDER_POWER_OF_TWO)
> -		div = __roundup_pow_of_two(div);
> +		div = roundup_pow_of_two(div);
>   	if (table)
>   		div = _round_up_table(table, div);
>   
> @@ -240,8 +240,8 @@ static int _div_round_closest(const struct clk_div_table *table,
>   	down = parent_rate / rate;
>   
>   	if (flags & CLK_DIVIDER_POWER_OF_TWO) {
> -		up = __roundup_pow_of_two(up);
> -		down = __rounddown_pow_of_two(down);
> +		up = roundup_pow_of_two(up);
> +		down = rounddown_pow_of_two(down);
>   	} else if (table) {
>   		up = _round_up_table(table, up);
>   		down = _round_down_table(table, down);
> @@ -278,7 +278,7 @@ static int _next_div(const struct clk_div_table *table, int div,
>   	div++;
>   
>   	if (flags & CLK_DIVIDER_POWER_OF_TWO)
> -		return __roundup_pow_of_two(div);
> +		return roundup_pow_of_two(div);
>   	if (table)
>   		return _round_up_table(table, div);
>   
> diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
> index 27201fd26e44..faec99dc09c0 100644
> --- a/drivers/clk/sunxi/clk-sunxi.c
> +++ b/drivers/clk/sunxi/clk-sunxi.c
> @@ -311,7 +311,7 @@ static void sun6i_get_ahb1_factors(struct factors_request *req)
>   
>   		calcm = DIV_ROUND_UP(div, 1 << calcp);
>   	} else {
> -		calcp = __roundup_pow_of_two(div);
> +		calcp = roundup_pow_of_two(div);
>   		calcp = calcp > 3 ? 3 : calcp;
>   	}
>   
> diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
> index 9b1fb84a3d45..96b1d343c32f 100644
> --- a/drivers/infiniband/hw/hfi1/chip.c
> +++ b/drivers/infiniband/hw/hfi1/chip.c
> @@ -14199,10 +14199,10 @@ static int qos_rmt_entries(struct hfi1_devdata *dd, unsigned int *mp,
>   			max_by_vl = krcvqs[i];
>   	if (max_by_vl > 32)
>   		goto no_qos;
> -	m = ilog2(__roundup_pow_of_two(max_by_vl));
> +	m = ilog2(roundup_pow_of_two(max_by_vl));
>   
>   	/* determine bits for vl */
> -	n = ilog2(__roundup_pow_of_two(num_vls));
> +	n = ilog2(roundup_pow_of_two(num_vls));
>   
>   	/* reject if too much is used */
>   	if ((m + n) > 7)
> diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
> index 26b792bb1027..838c789c7cce 100644
> --- a/drivers/infiniband/hw/hfi1/init.c
> +++ b/drivers/infiniband/hw/hfi1/init.c
> @@ -467,7 +467,7 @@ int hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, int numa,
>   		 * MTU supported.
>   		 */
>   		if (rcd->egrbufs.size < hfi1_max_mtu) {
> -			rcd->egrbufs.size = __roundup_pow_of_two(hfi1_max_mtu);
> +			rcd->egrbufs.size = roundup_pow_of_two(hfi1_max_mtu);
>   			hfi1_cdbg(PROC,
>   				  "ctxt%u: eager bufs size too small. Adjusting to %u\n",
>   				    rcd->ctxt, rcd->egrbufs.size);
> @@ -1959,7 +1959,7 @@ int hfi1_setup_eagerbufs(struct hfi1_ctxtdata *rcd)
>   	 * to satisfy the "multiple of 8 RcvArray entries" requirement.
>   	 */
>   	if (rcd->egrbufs.size <= (1 << 20))
> -		rcd->egrbufs.rcvtid_size = max((unsigned long)round_mtu,
> +		rcd->egrbufs.rcvtid_size = max((unsigned long long)round_mtu,
>   			rounddown_pow_of_two(rcd->egrbufs.size / 8));
>   
>   	while (alloced_bytes < rcd->egrbufs.size &&
> diff --git a/drivers/infiniband/hw/mlx4/srq.c b/drivers/infiniband/hw/mlx4/srq.c
> index 8dcf6e3d9ae2..7e685600a7b3 100644
> --- a/drivers/infiniband/hw/mlx4/srq.c
> +++ b/drivers/infiniband/hw/mlx4/srq.c
> @@ -96,7 +96,7 @@ int mlx4_ib_create_srq(struct ib_srq *ib_srq,
>   	srq->msrq.max    = roundup_pow_of_two(init_attr->attr.max_wr + 1);
>   	srq->msrq.max_gs = init_attr->attr.max_sge;
>   
> -	desc_size = max(32UL,
> +	desc_size = max(32ULL,
>   			roundup_pow_of_two(sizeof (struct mlx4_wqe_srq_next_seg) +
>   					   srq->msrq.max_gs *
>   					   sizeof (struct mlx4_wqe_data_seg)));
> diff --git a/drivers/infiniband/hw/mthca/mthca_srq.c b/drivers/infiniband/hw/mthca/mthca_srq.c
> index a85935ccce88..0c2e14b4142a 100644
> --- a/drivers/infiniband/hw/mthca/mthca_srq.c
> +++ b/drivers/infiniband/hw/mthca/mthca_srq.c
> @@ -225,7 +225,7 @@ int mthca_alloc_srq(struct mthca_dev *dev, struct mthca_pd *pd,
>   	else
>   		srq->max = srq->max + 1;
>   
> -	ds = max(64UL,
> +	ds = max(64ULL,
>   		 roundup_pow_of_two(sizeof (struct mthca_next_seg) +
>   				    srq->max_gs * sizeof (struct mthca_data_seg)));
>   
> diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
> index e2c6d1cedf41..040b707b0877 100644
> --- a/drivers/infiniband/sw/rxe/rxe_qp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_qp.c
> @@ -592,7 +592,7 @@ int rxe_qp_from_attr(struct rxe_qp *qp, struct ib_qp_attr *attr, int mask,
>   	int err;
>   
>   	if (mask & IB_QP_MAX_QP_RD_ATOMIC) {
> -		int max_rd_atomic = __roundup_pow_of_two(attr->max_rd_atomic);
> +		int max_rd_atomic = roundup_pow_of_two(attr->max_rd_atomic);
>   
>   		qp->attr.max_rd_atomic = max_rd_atomic;
>   		atomic_set(&qp->req.rd_atomic, max_rd_atomic);
> @@ -600,7 +600,7 @@ int rxe_qp_from_attr(struct rxe_qp *qp, struct ib_qp_attr *attr, int mask,
>   
>   	if (mask & IB_QP_MAX_DEST_RD_ATOMIC) {
>   		int max_dest_rd_atomic =
> -			__roundup_pow_of_two(attr->max_dest_rd_atomic);
> +			roundup_pow_of_two(attr->max_dest_rd_atomic);
>   
>   		qp->attr.max_dest_rd_atomic = max_dest_rd_atomic;
>   
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index 0c8d81f56a30..ce7c900bd666 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -1488,7 +1488,7 @@ static void iommu_flush_iotlb_psi(struct intel_iommu *iommu,
>   				  unsigned long pfn, unsigned int pages,
>   				  int ih, int map)
>   {
> -	unsigned int mask = ilog2(__roundup_pow_of_two(pages));
> +	unsigned int mask = ilog2(roundup_pow_of_two(pages));
>   	uint64_t addr = (uint64_t)pfn << VTD_PAGE_SHIFT;
>   	u16 did = domain->iommu_did[iommu->seq_id];
>   
> @@ -3390,7 +3390,7 @@ static unsigned long intel_alloc_iova(struct device *dev,
>   	/* Restrict dma_mask to the width that the iommu can handle */
>   	dma_mask = min_t(uint64_t, DOMAIN_MAX_ADDR(domain->gaw), dma_mask);
>   	/* Ensure we reserve the whole size-aligned region */
> -	nrpages = __roundup_pow_of_two(nrpages);
> +	nrpages = roundup_pow_of_two(nrpages);
>   
>   	if (!dmar_forcedac && dma_mask > DMA_BIT_MASK(32)) {
>   		/*
> diff --git a/drivers/iommu/intel-svm.c b/drivers/iommu/intel-svm.c
> index 9b159132405d..602caca3cd1a 100644
> --- a/drivers/iommu/intel-svm.c
> +++ b/drivers/iommu/intel-svm.c
> @@ -115,7 +115,7 @@ static void intel_flush_svm_range_dev (struct intel_svm *svm, struct intel_svm_d
>   			QI_EIOTLB_TYPE;
>   		desc.qw1 = 0;
>   	} else {
> -		int mask = ilog2(__roundup_pow_of_two(pages));
> +		int mask = ilog2(roundup_pow_of_two(pages));
>   
>   		desc.qw0 = QI_EIOTLB_PASID(svm->pasid) |
>   				QI_EIOTLB_DID(sdev->did) |
> @@ -142,7 +142,7 @@ static void intel_flush_svm_range_dev (struct intel_svm *svm, struct intel_svm_d
>   			 * for example, an "address" value of 0x12345f000 will
>   			 * flush from 0x123440000 to 0x12347ffff (256KiB). */
>   			unsigned long last = address + ((unsigned long)(pages - 1) << VTD_PAGE_SHIFT);
> -			unsigned long mask = __rounddown_pow_of_two(address ^ last);
> +			unsigned long mask = rounddown_pow_of_two(address ^ last);
>   
>   			desc.qw1 = QI_DEV_EIOTLB_ADDR((address & ~mask) |
>   					(mask - 1)) | QI_DEV_EIOTLB_SIZE;
> diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
> index 81e43c1df7ec..935657b2c661 100644
> --- a/drivers/iommu/intel_irq_remapping.c
> +++ b/drivers/iommu/intel_irq_remapping.c
> @@ -113,7 +113,7 @@ static int alloc_irte(struct intel_iommu *iommu,
>   		return -1;
>   
>   	if (count > 1) {
> -		count = __roundup_pow_of_two(count);
> +		count = roundup_pow_of_two(count);
>   		mask = ilog2(count);
>   	}
>   
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
> index 6a757dadb5f1..fd5b12c23eaa 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
> @@ -680,13 +680,13 @@ static int xgbe_set_ringparam(struct net_device *netdev,
>   		return -EINVAL;
>   	}
>   
> -	rx = __rounddown_pow_of_two(ringparam->rx_pending);
> +	rx = rounddown_pow_of_two(ringparam->rx_pending);
>   	if (rx != ringparam->rx_pending)
>   		netdev_notice(netdev,
>   			      "rx ring parameter rounded to power of two: %u\n",
>   			      rx);
>   
> -	tx = __rounddown_pow_of_two(ringparam->tx_pending);
> +	tx = rounddown_pow_of_two(ringparam->tx_pending);
>   	if (tx != ringparam->tx_pending)
>   		netdev_notice(netdev,
>   			      "tx ring parameter rounded to power of two: %u\n",
> diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
> index 5f56ee83e3b1..cc3a03b4a611 100644
> --- a/drivers/net/ethernet/marvell/sky2.c
> +++ b/drivers/net/ethernet/marvell/sky2.c
> @@ -4139,7 +4139,7 @@ static int sky2_set_coalesce(struct net_device *dev,
>    */
>   static unsigned long roundup_ring_size(unsigned long pending)
>   {
> -	return max(128ul, roundup_pow_of_two(pending+1));
> +	return max(128ull, roundup_pow_of_two(pending+1));
>   }
>   
>   static void sky2_get_ringparam(struct net_device *dev,
> diff --git a/drivers/net/ethernet/rocker/rocker_hw.h b/drivers/net/ethernet/rocker/rocker_hw.h
> index 59f1f8b690d2..d8de15509e2c 100644
> --- a/drivers/net/ethernet/rocker/rocker_hw.h
> +++ b/drivers/net/ethernet/rocker/rocker_hw.h
> @@ -88,8 +88,8 @@ enum rocker_dma_type {
>   };
>   
>   /* Rocker DMA ring size limits and default sizes */
> -#define ROCKER_DMA_SIZE_MIN		2ul
> -#define ROCKER_DMA_SIZE_MAX		65536ul
> +#define ROCKER_DMA_SIZE_MIN		2ull
> +#define ROCKER_DMA_SIZE_MAX		65536ull
>   #define ROCKER_DMA_CMD_DEFAULT_SIZE	32ul
>   #define ROCKER_DMA_EVENT_DEFAULT_SIZE	32ul
>   #define ROCKER_DMA_TX_DEFAULT_SIZE	64ul
> diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
> index 4d9bbccc6f89..4f4d9a5b3b75 100644
> --- a/drivers/net/ethernet/sfc/ef10.c
> +++ b/drivers/net/ethernet/sfc/ef10.c
> @@ -27,7 +27,7 @@ enum {
>   };
>   /* The maximum size of a shared RSS context */
>   /* TODO: this should really be from the mcdi protocol export */
> -#define EFX_EF10_MAX_SHARED_RSS_CONTEXT_SIZE 64UL
> +#define EFX_EF10_MAX_SHARED_RSS_CONTEXT_SIZE 64ULL
>   
>   /* The filter table(s) are managed by firmware and we have write-only
>    * access.  When removing filters we must identify them to the
> diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/efx.h
> index 2dd8d5002315..fea2add5860e 100644
> --- a/drivers/net/ethernet/sfc/efx.h
> +++ b/drivers/net/ethernet/sfc/efx.h
> @@ -52,7 +52,7 @@ void efx_schedule_slow_fill(struct efx_rx_queue *rx_queue);
>   
>   #define EFX_MAX_DMAQ_SIZE 4096UL
>   #define EFX_DEFAULT_DMAQ_SIZE 1024UL
> -#define EFX_MIN_DMAQ_SIZE 512UL
> +#define EFX_MIN_DMAQ_SIZE 512ULL
>   
>   #define EFX_MAX_EVQ_SIZE 16384UL
>   #define EFX_MIN_EVQ_SIZE 512UL
> diff --git a/drivers/net/ethernet/sfc/falcon/efx.h b/drivers/net/ethernet/sfc/falcon/efx.h
> index d3b4646545fa..0d16257156d6 100644
> --- a/drivers/net/ethernet/sfc/falcon/efx.h
> +++ b/drivers/net/ethernet/sfc/falcon/efx.h
> @@ -55,7 +55,7 @@ void ef4_schedule_slow_fill(struct ef4_rx_queue *rx_queue);
>   
>   #define EF4_MAX_DMAQ_SIZE 4096UL
>   #define EF4_DEFAULT_DMAQ_SIZE 1024UL
> -#define EF4_MIN_DMAQ_SIZE 512UL
> +#define EF4_MIN_DMAQ_SIZE 512ULL
>   
>   #define EF4_MAX_EVQ_SIZE 16384UL
>   #define EF4_MIN_EVQ_SIZE 512UL
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index c7709e49f0e4..f0391e88bc42 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -578,7 +578,7 @@ msi_setup_entry(struct pci_dev *dev, int nvec, struct irq_affinity *affd)
>   	entry->msi_attrib.maskbit	= !!(control & PCI_MSI_FLAGS_MASKBIT);
>   	entry->msi_attrib.default_irq	= dev->irq;	/* Save IOAPIC IRQ */
>   	entry->msi_attrib.multi_cap	= (control & PCI_MSI_FLAGS_QMASK) >> 1;
> -	entry->msi_attrib.multiple	= ilog2(__roundup_pow_of_two(nvec));
> +	entry->msi_attrib.multiple	= ilog2(roundup_pow_of_two(nvec));
>   
>   	if (control & PCI_MSI_FLAGS_64BIT)
>   		entry->mask_pos = dev->msi_cap + PCI_MSI_MASK_64;
> diff --git a/include/linux/log2.h b/include/linux/log2.h
> index 83a4a3ca3e8a..53a727303dac 100644
> --- a/include/linux/log2.h
> +++ b/include/linux/log2.h
> @@ -47,26 +47,6 @@ bool is_power_of_2(unsigned long n)
>   	return (n != 0 && ((n & (n - 1)) == 0));
>   }
>   
> -/**
> - * __roundup_pow_of_two() - round up to nearest power of two
> - * @n: value to round up
> - */
> -static inline __attribute__((const))
> -unsigned long __roundup_pow_of_two(unsigned long n)
> -{
> -	return 1UL << fls_long(n - 1);
> -}
> -
> -/**
> - * __rounddown_pow_of_two() - round down to nearest power of two
> - * @n: value to round down
> - */
> -static inline __attribute__((const))
> -unsigned long __rounddown_pow_of_two(unsigned long n)
> -{
> -	return 1UL << (fls_long(n) - 1);
> -}
> -
>   /**
>    * const_ilog2 - log base 2 of 32-bit or a 64-bit constant unsigned value
>    * @n: parameter
> @@ -170,14 +150,11 @@ unsigned long __rounddown_pow_of_two(unsigned long n)
>    * - the result is undefined when n == 0
>    * - this can be used to initialise global variables from constant data
>    */
> -#define roundup_pow_of_two(n)			\
> -(						\
> -	__builtin_constant_p(n) ? (		\
> -		(n == 1) ? 1 :			\
> -		(1UL << (ilog2((n) - 1) + 1))	\
> -				   ) :		\
> -	__roundup_pow_of_two(n)			\
> - )
> +#define roundup_pow_of_two(n)			  \
> +(						  \
> +	(__builtin_constant_p(n) && ((n) == 1)) ? \
> +	1 : (1ULL << (ilog2((n) - 1) + 1))        \
> +)
>   
>   /**
>    * rounddown_pow_of_two - round the given value down to nearest power of two
> @@ -187,12 +164,11 @@ unsigned long __rounddown_pow_of_two(unsigned long n)
>    * - the result is undefined when n == 0
>    * - this can be used to initialise global variables from constant data
>    */
> -#define rounddown_pow_of_two(n)			\
> -(						\
> -	__builtin_constant_p(n) ? (		\
> -		(1UL << ilog2(n))) :		\
> -	__rounddown_pow_of_two(n)		\
> - )
> +#define rounddown_pow_of_two(n)			  \
> +(						  \
> +	(__builtin_constant_p(n) && ((n) == 1)) ? \
> +	1 : (1ULL << (ilog2(n)))		  \
> +)
>   
>   static inline __attribute_const__
>   int __order_base_2(unsigned long n)
> diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
> index 15d70a90b50d..bb9efc6944a4 100644
> --- a/kernel/kexec_core.c
> +++ b/kernel/kexec_core.c
> @@ -1094,7 +1094,8 @@ static int __init crash_notes_memory_init(void)
>   	 * crash_notes is allocated inside one physical page.
>   	 */
>   	size = sizeof(note_buf_t);
> -	align = min(roundup_pow_of_two(sizeof(note_buf_t)), PAGE_SIZE);
> +	align = min(roundup_pow_of_two(sizeof(note_buf_t)),
> +		    (unsigned long long)PAGE_SIZE);
>   
>   	/*
>   	 * Break compile if size is bigger than PAGE_SIZE since crash_notes
> diff --git a/lib/rhashtable.c b/lib/rhashtable.c
> index bdb7e4cadf05..70908678c7a8 100644
> --- a/lib/rhashtable.c
> +++ b/lib/rhashtable.c
> @@ -950,7 +950,7 @@ static size_t rounded_hashtable_size(const struct rhashtable_params *params)
>   
>   	if (params->nelem_hint)
>   		retsize = max(roundup_pow_of_two(params->nelem_hint * 4 / 3),
> -			      (unsigned long)params->min_size);
> +			      (unsigned long long)params->min_size);
>   	else
>   		retsize = max(HASH_DEFAULT_SIZE,
>   			      (unsigned long)params->min_size);
> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
> index 77c7dd7f05e8..78fb8ccabddd 100644
> --- a/net/sunrpc/xprtrdma/verbs.c
> +++ b/net/sunrpc/xprtrdma/verbs.c
> @@ -1015,7 +1015,7 @@ struct rpcrdma_req *rpcrdma_req_create(struct rpcrdma_xprt *r_xprt, size_t size,
>   	maxhdrsize = rpcrdma_fixed_maxsz + 3 +
>   		     r_xprt->rx_ia.ri_max_segs * rpcrdma_readchunk_maxsz;
>   	maxhdrsize *= sizeof(__be32);
> -	rb = rpcrdma_regbuf_alloc(__roundup_pow_of_two(maxhdrsize),
> +	rb = rpcrdma_regbuf_alloc(roundup_pow_of_two(maxhdrsize),
>   				  DMA_TO_DEVICE, flags);
>   	if (!rb)
>   		goto out2;
> 
