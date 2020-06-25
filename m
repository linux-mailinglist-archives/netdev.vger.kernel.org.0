Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C37420A876
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 00:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406240AbgFYW54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 18:57:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404772AbgFYW54 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 18:57:56 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B95D720707;
        Thu, 25 Jun 2020 22:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593125875;
        bh=jqQwF1e3VL/j8Auj4cTsXujplbd+uUrwbDl1Ke26LBQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BJHMIA0kK2osUkOGYDpYnpP0UmYt8Hvt8xYsUUaJViYB6EFFE4i5VMRy031i/zqKq
         +CuYezadwLiN5Gey9Vjid9rc7E7Y6iSyDcaZ0wrRwI9cXie08pYhHDm1y1hDGQu3TC
         62I+CFCPs76bf80QUJiCCkjG/sZo3BzZJeklDeZk=
Date:   Thu, 25 Jun 2020 15:57:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net] ionic: update the queue count on open
Message-ID: <20200625155754.0f9abd7a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200625201215.57833-1-snelson@pensando.io>
References: <20200625201215.57833-1-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Jun 2020 13:12:15 -0700 Shannon Nelson wrote:
> Let the network stack know the real number of queues that
> we are using.
> 
> Fixes: 49d3b493673a ("ionic: disable the queues on link down")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  drivers/net/ethernet/pensando/ionic/ionic_lif.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> index aaa00edd9d5b..62858c7afae0 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> @@ -1673,6 +1673,9 @@ int ionic_open(struct net_device *netdev)
>  	if (err)
>  		goto err_out;
>  
> +	netif_set_real_num_tx_queues(netdev, lif->nxqs);
> +	netif_set_real_num_rx_queues(netdev, lif->nxqs);

These calls can fail.
