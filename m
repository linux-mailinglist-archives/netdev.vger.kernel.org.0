Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05DCCAF1B5
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 21:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfIJTKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 15:10:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38858 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725797AbfIJTKe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 15:10:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uHJsS7vyUh6LJRH0vWfRY7/KnHHTVhD4AwjLkdvjaSA=; b=OcI+tWt+hc3iFlMEuY/9j0HJo/
        jH+dJy3ruJRrgs9i6dxN+ZVwOJi+iNX9TUHFZDCD5An4CyVdPgHzMfVq+Hf4ibbm68bhALJ5/lkaf
        jaVSMUFjI4m+ctr52zriJy38B6XgFdcPoS68Er1oXtdNnYGPuTcTjQGTex25fhegEtTM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i7lX3-0003Yw-79; Tue, 10 Sep 2019 21:10:29 +0200
Date:   Tue, 10 Sep 2019 21:10:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>
Subject: Re: [PATCH net-next 01/11] net: aquantia: PTP skeleton declarations
 and callbacks
Message-ID: <20190910191029.GE9761@lunn.ch>
References: <cover.1568034880.git.igor.russkikh@aquantia.com>
 <cf60b1d3d797d0666a4828fcf5e521e0bd73f8d4.1568034880.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf60b1d3d797d0666a4828fcf5e521e0bd73f8d4.1568034880.git.igor.russkikh@aquantia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 09, 2019 at 01:38:38PM +0000, Igor Russkikh wrote:
> From: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>

Hi Igor, et al.

> @@ -331,6 +332,10 @@ int aq_nic_init(struct aq_nic_s *self)
>  		self->aq_vecs > i; ++i, aq_vec = self->aq_vec[i])
>  		aq_vec_init(aq_vec, self->aq_hw_ops, self->aq_hw);

> +int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int idx_vec)
> +{
> +	struct hw_atl_utils_mbox mbox;
> +	struct ptp_clock *clock;
> +	struct aq_ptp_s *self;

I find the use of self in this code quite confusing. It does not
appear to have a clear meaning. It can be a aq_ring_s, aq_nic_c,
aq_hw_s, aq_vec_s.

Looking at this code i always have to figure out what self is. Could
you not just use struct aq_ptp_s aq_ptp consistently in the code?

> +	int err = 0;
> +
> +	hw_atl_utils_mpi_read_stats(aq_nic->aq_hw, &mbox);
> +
> +	if (!(mbox.info.caps_ex & BIT(CAPS_EX_PHY_PTP_EN))) {
> +		aq_nic->aq_ptp = NULL;
> +		return 0;
> +	}
> +
> +	self = kzalloc(sizeof(*self), GFP_KERNEL);

Using devm_kzalloc() will make your clean up easier.

> +void aq_ptp_free(struct aq_nic_s *aq_nic)
> +{
> +	struct aq_ptp_s *self = aq_nic->aq_ptp;
> +
> +	if (!self)
> +		return;
> +
> +	kfree(self);

kfree() is happy to take a NULL pointer. But this could all go away
with devm_kzalloc().

     Andrew
