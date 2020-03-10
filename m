Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDEE180AB2
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 22:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbgCJVnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 17:43:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbgCJVnX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 17:43:23 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59003222C4;
        Tue, 10 Mar 2020 21:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583876602;
        bh=ZSxllGalPFXci2pE4G9hHQK91ZwKsd5e1g5OTr4Is3k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RkYyhzwGbQS3gMh1uTwpG4HDD83x+lv2SZCMpKdIrc76pwtt2XUaKDFXKEKE0lBCa
         3b/0GsXBHp1ncYfsnuDzbDPZNcmuW36QslvnkUvKYzj+m3CYlATqvNFwFsOfBM2E4n
         I188umfiXA5aN9pcf4lzsc6h4QmI5MruF9dGhMh4=
Date:   Tue, 10 Mar 2020 14:43:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Tomasz Duszynski <tduszynski@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH net-next 3/6] octeontx2-vf: Virtual function driver
 dupport
Message-ID: <20200310144320.4f691cb6@kicinski-fedora-PC1C0HJN>
In-Reply-To: <1583866045-7129-4-git-send-email-sunil.kovvuri@gmail.com>
References: <1583866045-7129-1-git-send-email-sunil.kovvuri@gmail.com>
        <1583866045-7129-4-git-send-email-sunil.kovvuri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Mar 2020 00:17:22 +0530 sunil.kovvuri@gmail.com wrote:
> +#define DRV_NAME	"octeontx2-nicvf"
> +#define DRV_STRING	"Marvell OcteonTX2 NIC Virtual Function Driver"
> +#define DRV_VERSION	"1.0"

Please drop the driver version, kernel version should be used upstream.

> +
> +static const struct pci_device_id otx2_vf_id_table[] = {
> +	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_OCTEONTX2_RVU_AFVF) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_OCTEONTX2_RVU_VF) },
> +	{ }
> +};
> +
> +MODULE_AUTHOR("Marvell International Ltd.");

Only people can be authors, please put your name here or remove this.

> +MODULE_DESCRIPTION(DRV_STRING);
> +MODULE_LICENSE("GPL v2");
> +MODULE_VERSION(DRV_VERSION);
> +MODULE_DEVICE_TABLE(pci, otx2_vf_id_table);

> +static netdev_tx_t otx2vf_xmit(struct sk_buff *skb, struct net_device *netdev)
> +{
> +	struct otx2_nic *vf = netdev_priv(netdev);
> +	int qidx = skb_get_queue_mapping(skb);
> +	struct otx2_snd_queue *sq;
> +	struct netdev_queue *txq;
> +
> +	/* Check for minimum and maximum packet length */
> +	if (skb->len <= ETH_HLEN ||
> +	    (!skb_shinfo(skb)->gso_size && skb->len > vf->max_frs)) {

These should never happen (if they do we need to fix the stack, not
sprinkle all the drivers with checks like this).

> +		dev_kfree_skb(skb);
> +		return NETDEV_TX_OK;
> +	}
> +
> +	sq = &vf->qset.sq[qidx];
> +	txq = netdev_get_tx_queue(netdev, qidx);
> +
> +	if (!otx2_sq_append_skb(netdev, sq, skb, qidx)) {
> +		netif_tx_stop_queue(txq);
> +
> +		/* Check again, incase SQBs got freed up */
> +		smp_mb();
> +		if (((sq->num_sqbs - *sq->aura_fc_addr) * sq->sqe_per_sqb)
> +							> sq->sqe_thresh)
> +			netif_tx_wake_queue(txq);
> +
> +		return NETDEV_TX_BUSY;
> +	}
> +
> +	return NETDEV_TX_OK;
> +}

> +static void otx2vf_reset_task(struct work_struct *work)
> +{
> +	struct otx2_nic *vf = container_of(work, struct otx2_nic, reset_task);
> +
> +	if (!netif_running(vf->netdev))
> +		return;
> +
> +	otx2vf_stop(vf->netdev);
> +	vf->reset_count++;
> +	otx2vf_open(vf->netdev);

What's the locking around here? Can user call open/stop while this is
running?

> +	netif_trans_update(vf->netdev);
> +}

> +static int otx2vf_realloc_msix_vectors(struct otx2_nic *vf)
> +{
> +	struct otx2_hw *hw = &vf->hw;
> +	int num_vec, err;
> +
> +	num_vec = hw->nix_msixoff;
> +	num_vec += NIX_LF_CINT_VEC_START + hw->max_queues;
> +
> +	otx2vf_disable_mbox_intr(vf);
> +	pci_free_irq_vectors(hw->pdev);
> +	pci_free_irq_vectors(hw->pdev);

Why free IRQs twice?

> +	err = otx2vf_register_mbox_intr(vf, false);
> +	if (err)
> +		return err;

return otx2vf_re..
