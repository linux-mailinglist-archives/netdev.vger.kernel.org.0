Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 288A5261CAE
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 21:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732138AbgIHTYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 15:24:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731828AbgIHTYm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 15:24:42 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 372942076C;
        Tue,  8 Sep 2020 19:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599593082;
        bh=s1G+wahL5gwjzPd++4olxV+qOuN/K+4dc74YFzgXSkY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=w/oPCD72E2rqWVqCIomqr8tsQvMQp6B4rp/zBYZVB9IPaMmGKGtOgHOtRgy98cdJh
         dBkxb6PvWu9BNNg4qUAfrawNRAHIuoGoMy+K3BYuHjbCszMmdsXe5HO87/JcAw/JX2
         aORvg8Hj0E5smlKzYJz+dVfGWM7klO6kghV1IdQc=
Date:   Tue, 8 Sep 2020 12:24:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Awogbemila <awogbemila@google.com>
Cc:     netdev@vger.kernel.org, Kuo Zhao <kuozhao@google.com>,
        Yangchun Fu <yangchun@google.com>
Subject: Re: [PATCH net-next v3 5/9] gve: Add Gvnic stats AQ command and
 ethtool show/set-priv-flags.
Message-ID: <20200908122440.580c0a10@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200908183909.4156744-6-awogbemila@google.com>
References: <20200908183909.4156744-1-awogbemila@google.com>
        <20200908183909.4156744-6-awogbemila@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Sep 2020 11:39:05 -0700 David Awogbemila wrote:
> +	/* Only one priv flag exists: report-stats (BIT(0))*/
> +	if (flags & BIT(0))
> +		new_flags |= BIT(0);
> +	else
> +		new_flags &= ~(BIT(0));
> +	priv->ethtool_flags = new_flags;
> +	/* update the stats when user turns report-stats on */
> +	if (flags & BIT(0))
> +		gve_handle_report_stats(priv);
> +	/* zero off gve stats when report-stats turned off */
> +	if (!(flags & BIT(0)) && (ori_flags & BIT(0))) {
> +		int tx_stats_num = GVE_TX_STATS_REPORT_NUM *
> +			priv->tx_cfg.num_queues;
> +		int rx_stats_num = GVE_RX_STATS_REPORT_NUM *
> +			priv->rx_cfg.num_queues;
> +
> +		memset(priv->stats_report->stats, 0, (tx_stats_num + rx_stats_num) *
> +				   sizeof(struct stats));
> +	}

I don't understand why you don't cancel/start the timer when this flag
is changed. Why waste the CPU cycles on handling a useless timer?
