Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F5720E9C6
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgF2XxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 19:53:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:51878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728199AbgF2XxD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 19:53:03 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB643206B6;
        Mon, 29 Jun 2020 23:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593474782;
        bh=0hts5hkfIODfVk6Aqgc4C0uRB/bqKYKasMgsBj5UFH0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0/qaNP/tEkNOBAL2bOOmqIEaGH39aOkuBciMZ5PomXYvLou6yD8UN4KEDwN52ELpo
         2x8JczwKqmrVTzyeqYoVCZL97MkPJzC4GSdRDAFSPKn7eYgMfVHZCsQgMGI3wC3+3M
         2mMYVawRcxdWrrKf1yPsfBFGKzT8a3FmesYqxHVw=
Date:   Mon, 29 Jun 2020 16:53:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/8] bnxt_en: Add logical RSS indirection table
 structure.
Message-ID: <20200629165301.6adb5233@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1593412464-503-3-git-send-email-michael.chan@broadcom.com>
References: <1593412464-503-1-git-send-email-michael.chan@broadcom.com>
        <1593412464-503-3-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Jun 2020 02:34:18 -0400 Michael Chan wrote:
> +	bp->rss_indir_tbl_entries = entries;
> +	bp->rss_indir_tbl = kcalloc(entries, sizeof(*bp->rss_indir_tbl),
> +				    GFP_KERNEL);

nit: kmalloc_array() ? I think you init all elements below.

> +	if (!bp->rss_indir_tbl)
> +		return -ENOMEM;
> +	return 0;
> +}
> +
> +static void bnxt_set_dflt_rss_indir_tbl(struct bnxt *bp)
> +{
> +	u16 max_rings, max_entries, pad, i;
> +
> +	if (!bp->rx_nr_rings)
> +		return;
> +
> +	if (BNXT_CHIP_TYPE_NITRO_A0(bp))
> +		max_rings = bp->rx_nr_rings - 1;
> +	else
> +		max_rings = bp->rx_nr_rings;
> +
> +	if (bp->flags & BNXT_FLAG_CHIP_P5)
> +		max_entries = (max_rings + BNXT_RSS_TABLE_ENTRIES_P5 - 1) &
> +			      ~(BNXT_RSS_TABLE_ENTRIES_P5 - 1);
> +	else
> +		max_entries = HW_HASH_INDEX_SIZE;
> +
> +	for (i = 0; i < max_entries; i++)
> +		bp->rss_indir_tbl[i] = i % max_rings;

nit: ethtool_rxfh_indir_default()

> +	pad = bp->rss_indir_tbl_entries - max_entries;
> +	if (pad)
> +		memset(&bp->rss_indir_tbl[i], 0, pad * sizeof(u16));
