Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7943920FCA0
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 21:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgF3TVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 15:21:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727107AbgF3TVL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 15:21:11 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A164D206C0;
        Tue, 30 Jun 2020 19:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593544870;
        bh=EEvZp9PYiQ66GS+T+v2SKKZDgdzJ6PHYaQ8bYWl4tXM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FGjmoggVIVn51a3zCPz1/+093z1hMRoJEedzpCn4mgDwfMl2mA7A8wDtiI691X4ST
         jwseNkF51qKR8/whq/CfGnOrL+n5TetJTSXRfgnPHV+TvUsKdEPxEIdZ5KHaXzyeKj
         b4s/fMfWUKk3VYjNZSDBTUNrf/yZ3txdI3CgWlNY=
Date:   Tue, 30 Jun 2020 12:21:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] dpaa2-eth: send a scatter-gather FD
 instead of realloc-ing
Message-ID: <20200630122108.03110c7d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200629103954.18021-2-ioana.ciornei@nxp.com>
References: <20200629103954.18021-1-ioana.ciornei@nxp.com>
        <20200629103954.18021-2-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Jun 2020 13:39:53 +0300 Ioana Ciornei wrote:
> +static void dpaa2_eth_sgt_cache_drain(struct dpaa2_eth_priv *priv)
> +{
> +	struct dpaa2_eth_sgt_cache *sgt_cache;
> +	u16 count;
> +	int k, i;
> +
> +	for_each_online_cpu(k) {

each _possible_ cpu, I think.

> +		sgt_cache = per_cpu_ptr(priv->sgt_cache, k);
> +		count = sgt_cache->count;
> +
> +		for (i = 0; i < count; i++)
> +			kfree(sgt_cache->buf[i]);
> +		sgt_cache->count = 0;
> +	}
> +}
