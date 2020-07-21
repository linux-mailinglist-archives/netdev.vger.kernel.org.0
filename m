Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABC02287E1
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 20:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729233AbgGUSBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 14:01:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726763AbgGUSBL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 14:01:11 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C7A520717;
        Tue, 21 Jul 2020 18:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595354471;
        bh=6C65EMMScfj76CVd3bohyj9wEsKdDLtIOscJCA06/0Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sbEmijMiWIIaRu8Uv8bSVJAQu1ykQ/pHZZNFxNlUXXGgfxzIqcfIo6yX7zAQcIpkT
         U1llkTxzpNkJD70kJHPUTyoBJQTXaHRJ1aL7n3gybRNu0g4e31dmk0nZsss59PcDW4
         6p3AdlfIzw2ErgDlR3rTVJXBR8YfHVA8h7z5yH3o=
Date:   Tue, 21 Jul 2020 11:01:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Alice Michael <alice.michael@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Subject: Re: [net-next v4 06/15] iecm: Implement mailbox functionality
Message-ID: <20200721110108.428105d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200721003810.2770559-7-anthony.l.nguyen@intel.com>
References: <20200721003810.2770559-1-anthony.l.nguyen@intel.com>
        <20200721003810.2770559-7-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Jul 2020 17:38:01 -0700 Tony Nguyen wrote:
> @@ -30,7 +38,32 @@ static enum iecm_status iecm_ctlq_init_regs(struct iecm_hw *hw,
>  					    struct iecm_ctlq_info *cq,
>  					    bool is_rxq)
>  {
> -	/* stub */
> +	u32 reg = 0;
> +
> +	if (is_rxq)
> +		/* Update tail to post pre-allocated buffers for Rx queues */
> +		wr32(hw, cq->reg.tail, (u32)(cq->ring_size - 1));
> +	else
> +		wr32(hw, cq->reg.tail, 0);
> +
> +	/* For non-Mailbox control queues only TAIL need to be set */
> +	if (cq->q_id != -1)
> +		return 0;
> +
> +	/* Clear Head for both send or receive */
> +	wr32(hw, cq->reg.head, 0);
> +
> +	/* set starting point */
> +	wr32(hw, cq->reg.bal, IECM_LO_DWORD(cq->desc_ring.pa));
> +	wr32(hw, cq->reg.bah, IECM_HI_DWORD(cq->desc_ring.pa));
> +	wr32(hw, cq->reg.len, (cq->ring_size | cq->reg.len_ena_mask));
> +
> +	/* Check one register to verify that config was applied */
> +	reg = rd32(hw, cq->reg.bah);
> +	if (reg != IECM_HI_DWORD(cq->desc_ring.pa))
> +		return IECM_ERR_CTLQ_ERROR;

Please stop using your own error codes.

> +	return 0;
>  }
