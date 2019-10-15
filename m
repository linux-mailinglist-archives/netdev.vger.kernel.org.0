Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2BB5D76A3
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 14:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbfJOMfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 08:35:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45452 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726004AbfJOMfs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 08:35:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HAZn7gxZtM+r5KnlEycFVjC5obQj8ywJbiQdB1c8DQM=; b=rNeCSvy41CEAio5PEJqdRK8pyw
        ADI+7gngXZyAP16JK0vpHWvgcyoAJzSWN9Oz+Z1gjyegn/0ZhznrTDgw8drBrWWDbwiwXkZaLZsEI
        g5Yot0tucwYYBWzKW+pv8kNVHnLtgoDKROH+vZ/72rDE1hSzCXJ6dATF+E3TWsq8i1Ok=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iKM39-0000im-LZ; Tue, 15 Oct 2019 14:35:39 +0200
Date:   Tue, 15 Oct 2019 14:35:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Pavel Belous <Pavel.Belous@aquantia.com>
Subject: Re: [PATCH v2 net-next 11/12] net: aquantia: add support for PIN
 funcs
Message-ID: <20191015123539.GL19861@lunn.ch>
References: <cover.1570531332.git.igor.russkikh@aquantia.com>
 <0142dcd43c84ab7bc26076c3eb48d43e67d195cc.1570531332.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0142dcd43c84ab7bc26076c3eb48d43e67d195cc.1570531332.git.igor.russkikh@aquantia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 08, 2019 at 10:56:59AM +0000, Igor Russkikh wrote:
> From: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
> 
> Depending on FW configuration we can manage from 0 to 3 PINs for periodic output
> and from 0 to 1 ext ts PIN for getting TS for external event.
> 
> Ext TS PIN functionality is implemented via periodic timestamps polling
> directly from PHY, because right now there is now way to received
> PIN trigger interrupt from phy.

Hi Igor

Is that a hardware limitation? Is the PHY interrupt not connected at
all? Could future cards have the interrupt connected?

> +static int aq_ptp_hw_pin_conf(struct aq_nic_s *aq_nic, u32 pin_index, u64 start,
> +			      u64 period)
> +{
> +	if (period)
> +		netdev_info(aq_nic->ndev,
> +			    "Enable GPIO %d pulsing, start time %llu, period %u\n",
> +			    pin_index, start, (u32)period);
> +	else
> +		netdev_info(aq_nic->ndev,
> +			    "Disable GPIO %d pulsing, start time %llu, period %u\n",
> +			    pin_index, start, (u32)period);

_info is too high a log level. _dbg would be better..


> +
> +	/* Notify hardware of request to being sending pulses.
> +	 * If period is ZERO then pulsen is disabled.
> +	 */
> +	mutex_lock(&aq_nic->fwreq_mutex);
> +	aq_nic->aq_hw_ops->hw_gpio_pulse(aq_nic->aq_hw, pin_index,
> +					 start, (u32)period);
> +	mutex_unlock(&aq_nic->fwreq_mutex);
> +
> +	return 0;
> +}
> +
> +static int aq_ptp_perout_pin_configure(struct ptp_clock_info *ptp,
> +				       struct ptp_clock_request *rq, int on)
> +{
> +	struct aq_ptp_s *aq_ptp = container_of(ptp, struct aq_ptp_s, ptp_info);
> +	struct ptp_clock_time *t = &rq->perout.period;
> +	struct ptp_clock_time *s = &rq->perout.start;
> +	struct aq_nic_s *aq_nic = aq_ptp->aq_nic;
> +	u64 start, period;
> +	u32 pin_index = rq->perout.index;
> +
> +	/* verify the request channel is there */
> +	if (pin_index >= ptp->n_per_out)
> +		return -EINVAL;
> +
> +	/* we cannot support periods greater
> +	 * than 4 seconds due to reg limit
> +	 */
> +	if (t->sec > 4 || t->sec < 0)
> +		return -ERANGE;
> +
> +	/* convert to unsigned 64b ns,
> +	 * verify we can put it in a 32b register
> +	 */
> +	period = on ? t->sec * NSEC_PER_SEC + t->nsec : 0;
> +
> +	/* verify the value is in range supported by hardware */
> +	if (period > U32_MAX)
> +		return -ERANGE;

What is U32_MAX ns? Is it greater than 4 seconds?

     Andrew
