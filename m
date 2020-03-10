Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D45F180AB3
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 22:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbgCJVna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 17:43:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbgCJVna (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 17:43:30 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14CF0222C3;
        Tue, 10 Mar 2020 21:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583876610;
        bh=iVb2LBCsUsyqQHh+N+r4Po2yvH5gLioOt+91WbB8XdA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dyaiEdO3Td7KDaxNElHlMuFpIw9g5cjg6svsAokTRwFJiZWLLvQp48uha1ZvlNjfb
         HmgAsfAT/qJFmaE7raWG3AFv9XBfL0x8XTpTq+IUmCzb1VqEfUUmU4OXqcrD7xoQOP
         qXnKnNo3x1vLOMTC3I8YtOYO8B1/GbVsXmOvUdOs=
Date:   Tue, 10 Mar 2020 14:43:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH net-next 2/6] octeontx2-pf: Handle VF function level
 reset
Message-ID: <20200310144328.0db53c68@kicinski-fedora-PC1C0HJN>
In-Reply-To: <1583866045-7129-3-git-send-email-sunil.kovvuri@gmail.com>
References: <1583866045-7129-1-git-send-email-sunil.kovvuri@gmail.com>
        <1583866045-7129-3-git-send-email-sunil.kovvuri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Mar 2020 00:17:21 +0530 sunil.kovvuri@gmail.com wrote:
> +static int otx2_pf_flr_init(struct otx2_nic *pf, int num_vfs)
> +{
> +	int vf;
> +
> +	pf->flr_wq = alloc_workqueue("otx2_pf_flr_wq", WQ_UNBOUND | WQ_HIGHPRI
> +				     | WQ_MEM_RECLAIM, 1);

Are you sure WQ_MEM_RECLAIM is necessary? AFAIU sending FLRs is not part
of memory reclaim, and therefore this flag isn't needed?

> +	if (!pf->flr_wq)
> +		return -ENOMEM;
> +
> +	pf->flr_wrk = devm_kcalloc(pf->dev, num_vfs,
> +				   sizeof(struct flr_work), GFP_KERNEL);

Since SR-IOV can be enabled and disabled multiple times you should free
this memory explicitly when it's disabled. Otherwise the driver will
hold onto it until remove.

> +	if (!pf->flr_wrk) {
> +		destroy_workqueue(pf->flr_wq);
> +		return -ENOMEM;
> +	}
> +
> +	for (vf = 0; vf < num_vfs; vf++) {
> +		pf->flr_wrk[vf].pf = pf;
> +		INIT_WORK(&pf->flr_wrk[vf].work, otx2_flr_handler);
> +	}
> +
> +	return 0;
> +}
