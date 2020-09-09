Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 831F526335B
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 19:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730633AbgIIRCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 13:02:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728363AbgIIPuO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 11:50:14 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60D802078E;
        Wed,  9 Sep 2020 15:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599666614;
        bh=6U/Z1wCvHSwUz/RwTs9h9VrlQQnCLRNr2JqtiTKJ+v0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kB8Ss9OxWzllPVBIOQv47glIzJ134aP6DgZqK3itLUmn3AG1QXEgmhd70XqA6dz97
         xiSr0WBrwoCQ4jNbQBOcPdnKCJ6yGwfHe/CVo5MHvR7lYkT/2YISUFEcIBbG31h9Rn
         +T+xvFH10ZUQHd2U49zluHUAojuC4Cp/ZzCbxBdE=
Date:   Wed, 9 Sep 2020 08:50:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <sameehj@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>,
        Shay Agroskin <shayagr@amazon.com>
Subject: Re: [PATCH V3 net-next 4/4] net: ena: xdp: add queue counters for
 xdp actions
Message-ID: <20200909085011.7af75de0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200909064627.30104-5-sameehj@amazon.com>
References: <20200909064627.30104-1-sameehj@amazon.com>
        <20200909064627.30104-5-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Sep 2020 06:46:27 +0000 sameehj@amazon.com wrote:
> @@ -374,17 +375,31 @@ static int ena_xdp_execute(struct ena_ring *rx_ring,
>  
>  	verdict = bpf_prog_run_xdp(xdp_prog, xdp);
>  
> -	if (verdict == XDP_TX)
> +	if (verdict == XDP_TX) {
>  		ena_xdp_xmit_buff(rx_ring->netdev,
> -				  xdp,
> -				  rx_ring->qid + rx_ring->adapter->num_io_queues,
> -				  rx_info);
> -	else if (unlikely(verdict == XDP_ABORTED))
> +				xdp,
> +				rx_ring->qid + rx_ring->adapter->num_io_queues,
> +				rx_info);

You broke the alignment here, for no reason.

Otherwise the series looks good.
