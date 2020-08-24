Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A673A250A2E
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 22:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgHXUlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 16:41:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgHXUlj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 16:41:39 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CB7F205CB;
        Mon, 24 Aug 2020 20:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598301698;
        bh=3MVU6dykVXd1bh/XcoDz0tvi8vaav2fyEaHK1r2cImI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ij8Atb2w4urUbpkuv0qt+RKLgFBmyGUwyaITVkqZKXqXUrpK/wUfUsvf808t6a6r9
         WfVxttjSk4va3XfN75LuU5wax9BcGr5Y74iejX0dwN+kEB4OkY/acCSKO1O70Pue5M
         R0NU7XkheI+hyosJWWc8UpZnN0MhLoEN49ydGMhY=
Date:   Mon, 24 Aug 2020 13:41:36 -0700
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
Subject: Re: [net-next v5 08/15] iecm: Implement vector allocation
Message-ID: <20200824134136.7ceabe06@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200824173306.3178343-9-anthony.l.nguyen@intel.com>
References: <20200824173306.3178343-1-anthony.l.nguyen@intel.com>
        <20200824173306.3178343-9-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Aug 2020 10:32:59 -0700 Tony Nguyen wrote:
>  static void iecm_mb_intr_rel_irq(struct iecm_adapter *adapter)
>  {
> -	/* stub */
> +	int irq_num;
> +
> +	irq_num = adapter->msix_entries[0].vector;
> +	synchronize_irq(irq_num);

I don't think you need to sync irq before freeing it.

> +	free_irq(irq_num, adapter);


>  static int iecm_mb_intr_init(struct iecm_adapter *adapter)
>  {
> -	/* stub */
> +	int err = 0;
> +
> +	iecm_get_mb_vec_id(adapter);
> +	adapter->dev_ops.reg_ops.mb_intr_reg_init(adapter);
> +	adapter->irq_mb_handler = iecm_mb_intr_clean;
> +	err = iecm_mb_intr_req_irq(adapter);
> +	return err;

return iecm_mb_intr_req_irq(adapter);

>  static void iecm_vport_intr_rel_irq(struct iecm_vport *vport)
>  {
> -	/* stub */
> +	struct iecm_adapter *adapter = vport->adapter;
> +	int vector;
> +
> +	for (vector = 0; vector < vport->num_q_vectors; vector++) {
> +		struct iecm_q_vector *q_vector = &vport->q_vectors[vector];
> +		int irq_num, vidx;
> +
> +		/* free only the IRQs that were actually requested */
> +		if (!q_vector)
> +			continue;
> +
> +		vidx = vector + vport->q_vector_base;
> +		irq_num = adapter->msix_entries[vidx].vector;
> +
> +		/* clear the affinity_mask in the IRQ descriptor */
> +		irq_set_affinity_hint(irq_num, NULL);
> +		synchronize_irq(irq_num);

here as well

> +		free_irq(irq_num, q_vector);
> +	}
>  }

>  void iecm_vport_intr_dis_irq_all(struct iecm_vport *vport)
>  {
> -	/* stub */
> +	struct iecm_q_vector *q_vector = vport->q_vectors;
> +	struct iecm_hw *hw = &vport->adapter->hw;
> +	int q_idx;
> +
> +	for (q_idx = 0; q_idx < vport->num_q_vectors; q_idx++)
> +		writel_relaxed(0, hw->hw_addr +
> +				  q_vector[q_idx].intr_reg.dyn_ctl);

Why the use of _releaxed() here? is this performance-sensitive?
There is no barrier after, which makes this code fragile.

> @@ -1052,12 +1122,42 @@ void iecm_vport_intr_dis_irq_all(struct iecm_vport *vport)
>  static u32 iecm_vport_intr_buildreg_itr(struct iecm_q_vector *q_vector,
>  					const int type, u16 itr)
>  {
> -	/* stub */
> +	u32 itr_val;
> +
> +	itr &= IECM_ITR_MASK;
> +	/* Don't clear PBA because that can cause lost interrupts that
> +	 * came in while we were cleaning/polling
> +	 */
> +	itr_val = q_vector->intr_reg.dyn_ctl_intena_m |
> +		  (type << q_vector->intr_reg.dyn_ctl_itridx_s) |
> +		  (itr << (q_vector->intr_reg.dyn_ctl_intrvl_s - 1));
> +
> +	return itr_val;
>  }
