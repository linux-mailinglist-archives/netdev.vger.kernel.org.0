Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6341E3EBEEB
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 02:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235612AbhHNAF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 20:05:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235330AbhHNAF7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 20:05:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57359610F7;
        Sat, 14 Aug 2021 00:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628899531;
        bh=jXk6aA95swjM44SiyYy2HYIQ9PltgK0C1Bm1I/mNTlg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FOUcE/+KvhttuCV0kyjwZrTo5i2JE3pRYnhavgaIuUiMAuFftV3m7pCdevLBWLQaF
         ZkPlSiYvzNEaUchHDutTgjecgs7/tpESNwQr7AIQld297sWVjv7i5pjX28QbZB3Hxc
         l4CDURNXj75DMkdIgZROT0JuSdyk+fRdfw0YdVLI4DLDryC4eUkgujgpibPd1tRSjl
         36Ik3EmLXgSkRB3YsAs4KKyz0yddT+XAjUrXyStKbLuuzrYLRqPSFkWrH0Kld0SMat
         CU89TqH5cw+wuMvB1ZBK62nFQyHESOKELxF5cXQYZly7OVSKtVKtlAq6CPfO+S5QhY
         jFDRRpf5f4nfw==
Date:   Fri, 13 Aug 2021 17:05:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shai Malin <smalin@marvell.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <aelior@marvell.com>, <malin1024@gmail.com>
Subject: Re: [PATCH v2] qed: qed ll2 race condition fixes
Message-ID: <20210813170530.7a12984f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210812195313.7220-1-smalin@marvell.com>
References: <20210812195313.7220-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Aug 2021 22:53:13 +0300 Shai Malin wrote:
> Avoiding qed ll2 race condition and NULL pointer dereference as part
> of the remove and recovery flows.
> 
> Changes form V1:
> - Change (!p_rx->set_prod_addr).
> - qed_ll2.c checkpatch fixes.
> 
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_ll2.c | 38 +++++++++++++++++------
>  1 file changed, 29 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
> index 02a4610d9330..9a9f0c516c0c 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
> @@ -106,7 +106,7 @@ static int qed_ll2_alloc_buffer(struct qed_dev *cdev,
>  }
>  
>  static int qed_ll2_dealloc_buffer(struct qed_dev *cdev,
> -				 struct qed_ll2_buffer *buffer)
> +				  struct qed_ll2_buffer *buffer)
>  {
>  	spin_lock_bh(&cdev->ll2->lock);
>  

> @@ -670,11 +682,11 @@ static int qed_ll2_lb_rxq_handler(struct qed_hwfn *p_hwfn,
>  		p_pkt = list_first_entry(&p_rx->active_descq,
>  					 struct qed_ll2_rx_packet, list_entry);
>  
> -		if ((iscsi_ooo->ooo_opcode == TCP_EVENT_ADD_NEW_ISLE) ||
> -		    (iscsi_ooo->ooo_opcode == TCP_EVENT_ADD_ISLE_RIGHT) ||
> -		    (iscsi_ooo->ooo_opcode == TCP_EVENT_ADD_ISLE_LEFT) ||
> -		    (iscsi_ooo->ooo_opcode == TCP_EVENT_ADD_PEN) ||
> -		    (iscsi_ooo->ooo_opcode == TCP_EVENT_JOIN)) {
> +		if (iscsi_ooo->ooo_opcode == TCP_EVENT_ADD_NEW_ISLE ||
> +		    iscsi_ooo->ooo_opcode == TCP_EVENT_ADD_ISLE_RIGHT ||
> +		    iscsi_ooo->ooo_opcode == TCP_EVENT_ADD_ISLE_LEFT ||
> +		    iscsi_ooo->ooo_opcode == TCP_EVENT_ADD_PEN ||
> +		    iscsi_ooo->ooo_opcode == TCP_EVENT_JOIN) {
>  			if (!p_pkt) {
>  				DP_NOTICE(p_hwfn,
>  					  "LL2 OOO RX packet is not valid\n");

Sorry, I missed this before, please don't mix code clean up into
unrelated patches. Especially into fixes. Same goes for your other
patch (qed: Fix null-pointer dereference in qed_rdma_create_qp()).
