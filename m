Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8DA6280B4D
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 01:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733103AbgJAXXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 19:23:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727713AbgJAXXi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 19:23:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 501FF20706;
        Thu,  1 Oct 2020 23:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601594618;
        bh=Q2fBrvWt/4ewhM3DRKaD1eRMKPEjHWMU4p0kmjBQJFE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=v977ips7DmN88+uWeKBMu/hpAzq2OS8SBOCu+PZLeX3SMY8QGMlAnk7xZEEE5onEt
         p8hkMv9N3QOD8kDDueIlS8+HKzC6YPPWmN4oxWOMHdHuwzXdJ/ISalguvXoqxat7pD
         IM8Q3Q5LbyMCoidPL7H56jQzfXRHNCEJWVonuKB4=
Date:   Thu, 1 Oct 2020 16:23:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     saeed@kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: Re: [net V2 05/15] net/mlx5: Add retry mechanism to the command
 entry index allocation
Message-ID: <20201001162336.45f552b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201001195247.66636-6-saeed@kernel.org>
References: <20201001195247.66636-1-saeed@kernel.org>
        <20201001195247.66636-6-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  1 Oct 2020 12:52:37 -0700 saeed@kernel.org wrote:
> +static int cmd_alloc_index_retry(struct mlx5_cmd *cmd)
> +{
> +	unsigned long alloc_end = jiffies + msecs_to_jiffies(1000);
> +	int idx;
> +
> +retry:
> +	idx = cmd_alloc_index(cmd);
> +	if (idx < 0 && time_before(jiffies, alloc_end)) {
> +		/* Index allocation can fail on heavy load of commands. This is a temporary
> +		 * situation as the current command already holds the semaphore, meaning that
> +		 * another command completion is being handled and it is expected to release
> +		 * the entry index soon.
> +		 */
> +		cond_resched();
> +		goto retry;
> +	}
> +	return idx;
> +}

This looks excessive. At least add some cpu_relax(), or udelay()?
