Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4228D66FE
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 18:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732195AbfJNQO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 12:14:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44954 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730028AbfJNQO4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 12:14:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UsqVXyHPAU7v8hHrPgEMdyC0T4BF6GqsFSSuUvMOd5c=; b=s0LzeoJPUuZbq5mb15AuS2oqYc
        nyiyEeFg0Al31FJq0BMQC17ex55ulpDvfLWfvaXUzauzXkrevyiwhqdde6szLoZrqYhh1NzosYn5D
        665QJRRMdnWx9IlicDNlhbgizTGWuxSlLp4ltxmtMhrb24QSxZO3HUSQjL2gS5UGrymI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iK2zj-0006D5-Rq; Mon, 14 Oct 2019 18:14:51 +0200
Date:   Mon, 14 Oct 2019 18:14:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>
Subject: Re: [PATCH v2 net-next 04/12] net: aquantia: add PTP rings
 infrastructure
Message-ID: <20191014161451.GM21165@lunn.ch>
References: <cover.1570531332.git.igor.russkikh@aquantia.com>
 <eea16e6e4fe987819dca72304b92b8b921c65286.1570531332.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eea16e6e4fe987819dca72304b92b8b921c65286.1570531332.git.igor.russkikh@aquantia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -978,7 +992,9 @@ void aq_nic_deinit(struct aq_nic_s *self)
>  		self->aq_vecs > i; ++i, aq_vec = self->aq_vec[i])
>  		aq_vec_deinit(aq_vec);
>  
> +	aq_ptp_ring_deinit(self);
>  	aq_ptp_unregister(self);
> +	aq_ptp_ring_free(self);
>  	aq_ptp_free(self);

Is this order safe? Seems like you should first unregister, and then
deinit?

> +int aq_ptp_ring_init(struct aq_nic_s *aq_nic)
> +{
> +	struct aq_ptp_s *aq_ptp = aq_nic->aq_ptp;
> +	int err = 0;
> +
> +	if (!aq_ptp)
> +		return 0;
> +
> +	err = aq_ring_init(&aq_ptp->ptp_tx);
> +	if (err < 0)
> +		goto err_exit;
> +	err = aq_nic->aq_hw_ops->hw_ring_tx_init(aq_nic->aq_hw,
> +						 &aq_ptp->ptp_tx,
> +						 &aq_ptp->ptp_ring_param);
> +	if (err < 0)
> +		goto err_exit;
> +
> +	err = aq_ring_init(&aq_ptp->ptp_rx);
> +	if (err < 0)
> +		goto err_exit;
> +	err = aq_nic->aq_hw_ops->hw_ring_rx_init(aq_nic->aq_hw,
> +						 &aq_ptp->ptp_rx,
> +						 &aq_ptp->ptp_ring_param);
> +	if (err < 0)
> +		goto err_exit;
> +
> +	err = aq_ring_rx_fill(&aq_ptp->ptp_rx);
> +	if (err < 0)
> +		goto err_exit;
> +	err = aq_nic->aq_hw_ops->hw_ring_rx_fill(aq_nic->aq_hw,
> +						 &aq_ptp->ptp_rx,
> +						 0U);
> +	if (err < 0)
> +		goto err_exit;
> +
> +	err = aq_ring_init(&aq_ptp->hwts_rx);
> +	if (err < 0)
> +		goto err_exit;
> +	err = aq_nic->aq_hw_ops->hw_ring_rx_init(aq_nic->aq_hw,
> +						 &aq_ptp->hwts_rx,
> +						 &aq_ptp->ptp_ring_param);
> +
> +err_exit:
> +	return err;

Maybe there should be some undoing going on here. If you filled the rx
ring, do you need to empty it on error?

> +}
> +
> +int aq_ptp_ring_start(struct aq_nic_s *aq_nic)
> +{
> +	struct aq_ptp_s *aq_ptp = aq_nic->aq_ptp;
> +	int err = 0;
> +
> +	if (!aq_ptp)
> +		return 0;
> +
> +	err = aq_nic->aq_hw_ops->hw_ring_tx_start(aq_nic->aq_hw, &aq_ptp->ptp_tx);
> +	if (err < 0)
> +		goto err_exit;
> +
> +	err = aq_nic->aq_hw_ops->hw_ring_rx_start(aq_nic->aq_hw, &aq_ptp->ptp_rx);
> +	if (err < 0)
> +		goto err_exit;
> +
> +	err = aq_nic->aq_hw_ops->hw_ring_rx_start(aq_nic->aq_hw,
> +						  &aq_ptp->hwts_rx);
> +	if (err < 0)
> +		goto err_exit;
> +
> +err_exit:

Do you need to stop the rings which started, before the error
happened?

> +	return err;
> +}
> +
> +int aq_ptp_ring_alloc(struct aq_nic_s *aq_nic)
> +{
> +	struct aq_ptp_s *aq_ptp = aq_nic->aq_ptp;
> +	unsigned int tx_ring_idx, rx_ring_idx;
> +	struct aq_ring_s *hwts = 0;
> +	u32 tx_tc_mode, rx_tc_mode;
> +	struct aq_ring_s *ring;
> +	int err;
> +
> +	if (!aq_ptp)
> +		return 0;
> +
> +	/* Index must to be 8 (8 TCs) or 16 (4 TCs).
> +	 * It depends from Traffic Class mode.
> +	 */
> +	aq_nic->aq_hw_ops->hw_tx_tc_mode_get(aq_nic->aq_hw, &tx_tc_mode);
> +	if (tx_tc_mode == 0)
> +		tx_ring_idx = PTP_8TC_RING_IDX;
> +	else
> +		tx_ring_idx = PTP_4TC_RING_IDX;
> +
> +	ring = aq_ring_tx_alloc(&aq_ptp->ptp_tx, aq_nic,
> +				tx_ring_idx, &aq_nic->aq_nic_cfg);
> +	if (!ring) {
> +		err = -ENOMEM;
> +		goto err_exit_1;
> +	}
> +
> +	aq_nic->aq_hw_ops->hw_rx_tc_mode_get(aq_nic->aq_hw, &rx_tc_mode);
> +	if (rx_tc_mode == 0)
> +		rx_ring_idx = PTP_8TC_RING_IDX;
> +	else
> +		rx_ring_idx = PTP_4TC_RING_IDX;
> +
> +	ring = aq_ring_rx_alloc(&aq_ptp->ptp_rx, aq_nic,
> +				rx_ring_idx, &aq_nic->aq_nic_cfg);
> +	if (!ring) {
> +		err = -ENOMEM;
> +		goto err_exit_2;
> +	}
> +
> +	hwts = aq_ring_hwts_rx_alloc(&aq_ptp->hwts_rx, aq_nic, PTP_HWST_RING_IDX,
> +				     aq_nic->aq_nic_cfg.rxds,
> +				     aq_nic->aq_nic_cfg.aq_hw_caps->rxd_size);
> +	if (!hwts) {
> +		err = -ENOMEM;
> +		goto err_exit_3;
> +	}
> +
> +	err = aq_ptp_skb_ring_init(&aq_ptp->skb_ring, aq_nic->aq_nic_cfg.rxds);
> +	if (err != 0) {
> +		err = -ENOMEM;
> +		goto err_exit_4;
> +	}
> +
> +	return 0;
> +
> +err_exit_4:
> +	aq_ring_free(&aq_ptp->hwts_rx);
> +err_exit_3:
> +	aq_ring_free(&aq_ptp->ptp_rx);
> +err_exit_2:
> +	aq_ring_free(&aq_ptp->ptp_tx);
> +err_exit_1:
> +	return err;

Not very descriptive names. err_exit_hwts_rx, err_exit_ptp_rx, etc?

> +struct aq_ring_s *
> +aq_ring_hwts_rx_alloc(struct aq_ring_s *self, struct aq_nic_s *aq_nic,
> +		      unsigned int idx, unsigned int size, unsigned int dx_size)
> +{
> +	struct device *dev = aq_nic_get_dev(aq_nic);
> +	int err = 0;
> +	size_t sz = size * dx_size + AQ_CFG_RXDS_DEF;
> +
> +	memset(self, 0, sizeof(*self));
> +
> +	self->aq_nic = aq_nic;
> +	self->idx = idx;
> +	self->size = size;
> +	self->dx_size = dx_size;

More self. Why not ring? I suppose because the rest of this file is
using the unhelpful self?

> +
> +	self->dx_ring = dma_alloc_coherent(dev, sz, &self->dx_ring_pa,
> +					   GFP_KERNEL);
> +	if (!self->dx_ring) {
> +		err = -ENOMEM;
> +		goto err_exit;
> +	}
> +
> +err_exit:
> +	if (err < 0) {
> +		aq_ring_free(self);
> +		return NULL;

return ERR_PTR(err)?

> +	}
> +
> +	return self;

And this code structure seem odd. Why not.

+	self->dx_ring = dma_alloc_coherent(dev, sz, &self->dx_ring_pa,
+					   GFP_KERNEL);
+	if (!self->dx_ring) {
+		err = -ENOMEM;
+		goto err_exit;
+	}
+
+	return self;
+
+err_exit:
+	aq_ring_free(self);
+ 	return ERR_PTR(err)?
> +}

  Andrew
