Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D0B218E71
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 19:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgGHRk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 13:40:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725937AbgGHRk7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 13:40:59 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F739206DF;
        Wed,  8 Jul 2020 17:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594230058;
        bh=+ha4aoU38rdk7m+9M0M8vGUsGhCnMJrYFJLmOiO/rLQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VB3Pkb1y7i8S/KUc9L4nCtIpXHhPBabN0IQlLmbrVPXsUuLsrMhUs4x8FiZbdNyRP
         TW69q4B9LWmH+GjFklE2YF1VgqIcfHWPaPcMN5UQElNXjOtWU9pel/IBo7kR0+E8SG
         dZHZ7L9rAgxq55799h5yc+y27A08fKmIf34oiKOs=
Date:   Wed, 8 Jul 2020 10:40:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     sundeep.lkml@gmail.com
Cc:     davem@davemloft.net, richardcochran@gmail.com,
        netdev@vger.kernel.org, sgoutham@marvell.com,
        Aleksey Makarov <amakarov@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: Re: [PATCH v2 net-next 3/3] octeontx2-pf: Add support for PTP clock
Message-ID: <20200708104056.1ed85daf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1594227018-4913-4-git-send-email-sundeep.lkml@gmail.com>
References: <1594227018-4913-1-git-send-email-sundeep.lkml@gmail.com>
        <1594227018-4913-4-git-send-email-sundeep.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  8 Jul 2020 22:20:18 +0530 sundeep.lkml@gmail.com wrote:
> From: Aleksey Makarov <amakarov@marvell.com>
> 
> This patch adds PTP clock and uses it in Octeontx2
> network device. PTP clock uses mailbox calls to
> access the hardware counter on the RVU side.
> 
> Co-developed-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Aleksey Makarov <amakarov@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>

Please address the new sparse warnings as well:

drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c:130:42: warning: cast to restricted __be64

> +static inline void otx2_set_rxtstamp(struct otx2_nic *pfvf,
> +				     struct sk_buff *skb, void *data)
> +{

Please don't use static inline in C files, compiler will know which
static functions to inline, and static inline covers up unused code.

> +	u64 tsns;
> +	int err;
> +
> +	if (!(pfvf->flags & OTX2_FLAG_RX_TSTAMP_ENABLED))
> +		return;
> +
> +	/* The first 8 bytes is the timestamp */
> +	err = otx2_ptp_tstamp2time(pfvf, be64_to_cpu(*(u64 *)data), &tsns);
> +	if (err)
> +		return;
> +
> +	skb_hwtstamps(skb)->hwtstamp = ns_to_ktime(tsns);
> +}
