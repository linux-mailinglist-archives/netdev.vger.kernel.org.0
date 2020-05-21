Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111331DD9CD
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 00:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730192AbgEUWAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 18:00:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729370AbgEUWAN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 18:00:13 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 708F9207F9;
        Thu, 21 May 2020 22:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590098413;
        bh=c4wz06IRUcdH79Q2Z23WGaghf6ZumKJ4+D1oEgF0ncw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T+Fp2NoR91Z2J8wL49fIwyZO9WyTQ7RmPYP/PsQznIOG/BSNJKBReZ7Z3ZqzM7+P3
         Y11w8NrR4Ox3MdQXVjPCOh66/NWGbJ0ZHcUZnqSrDtf6YUZz14rxPEB6Ttiv8o6T7V
         mV5lsXsv2QrlUTSA8W2T3XVw6ovENkwzMAq9QIPI=
Date:   Thu, 21 May 2020 15:00:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <akiyano@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: Re: [PATCH V1 net-next 05/15] net: ena: add prints to failed
 commands
Message-ID: <20200521150010.0c9c9dc5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1590088114-381-6-git-send-email-akiyano@amazon.com>
References: <1590088114-381-1-git-send-email-akiyano@amazon.com>
        <1590088114-381-6-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 May 2020 22:08:24 +0300 akiyano@amazon.com wrote:
> diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_com.c b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
> index a014f514c069..f0b90e1551a3 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_eth_com.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
> @@ -175,8 +175,10 @@ static int ena_com_close_bounce_buffer(struct ena_com_io_sq *io_sq)
>  	if (pkt_ctrl->idx) {
>  		rc = ena_com_write_bounce_buffer_to_dev(io_sq,
>  							pkt_ctrl->curr_bounce_buf);
> -		if (unlikely(rc))
> +		if (unlikely(rc)) {
> +			pr_err("failed to write bounce buffer to device\n");

Could you use dev_err() or even better netdev_err() to give users an
idea which device is misbehaving?

>  			return rc;
> +		}
>  
>  		pkt_ctrl->curr_bounce_buf =
>  			ena_com_get_next_bounce_buffer(&io_sq->bounce_buf_ctrl);

