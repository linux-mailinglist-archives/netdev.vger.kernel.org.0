Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E952313C1
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbgG1UUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:20:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728253AbgG1UUH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 16:20:07 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A51722065E;
        Tue, 28 Jul 2020 20:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595967606;
        bh=k9zXh7i8DOPwpD0IOwk9Oy85cdnolNmqBZ0c/u39Qxs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1zR9yO3zF+AgLKdDUH+Ypf9TpS9jKei6AefGFpZaxlEfQcrPLeSIEDMrzigcWyTGl
         gaAgB9TB0PHBSw5DMSguavV2SUWQzk+mSRyTEJQj2BA1qrqiSAQysFAIDVxX5gQk/G
         tk7/B2gqPumEkTwJ6TWhHVksvmaIVwR3usG2myy0=
Date:   Tue, 28 Jul 2020 13:20:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: Re: [net V2 07/11] net/mlx5: Verify Hardware supports requested ptp
 function on a given pin
Message-ID: <20200728132005.0e9356a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200728195935.155604-8-saeedm@mellanox.com>
References: <20200728195935.155604-1-saeedm@mellanox.com>
        <20200728195935.155604-8-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jul 2020 12:59:31 -0700 Saeed Mahameed wrote:
>  static int mlx5_ptp_verify(struct ptp_clock_info *ptp, unsigned int pin,
>  			   enum ptp_pin_function func, unsigned int chan)
>  {
> -	return (func == PTP_PF_PHYSYNC) ? -EOPNOTSUPP : 0;
> +	struct mlx5_clock *clock = container_of(ptp, struct mlx5_clock,
> +						ptp_info);
> +
> +	switch (func) {
> +	case PTP_PF_NONE:
> +		return 0;
> +	case PTP_PF_EXTTS:
> +		return !(clock->pps_info.pin_caps[pin] &
> +			 MLX5_MTPPS_REG_CAP_PIN_X_MODE_SUPPORT_PPS_IN);
> +	case PTP_PF_PEROUT:
> +		return !(clock->pps_info.pin_caps[pin] &
> +			 MLX5_MTPPS_REG_CAP_PIN_X_MODE_SUPPORT_PPS_OUT);
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return -EOPNOTSUPP;

nit: entirely unnecessary return statement
