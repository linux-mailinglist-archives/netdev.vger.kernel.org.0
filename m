Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94881CB9F5
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 23:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgEHVi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 17:38:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:36096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbgEHVi1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 17:38:27 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3EA12051A;
        Fri,  8 May 2020 21:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588973907;
        bh=NGPmab+TOAuGKLM9Dsjvn0jTnDjYs90bOkftnR8jSxE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ophrLPLJdBxZA0intpGG24nD4qZGz88R/+8eAAm28U3PfogC4L4nXxtIT8zglh/jW
         YYBV2KA3JatpxWKZiHdcB8O9Ce++Xgh2bBhEUgB9lD8Athg93XoRBU79AB5WK3qSt9
         Ho4VrfFXlmtRjGxe4McugsZpBBpu0NufACzVtBSU=
Date:   Fri, 8 May 2020 14:38:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo bin <luobin9@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: Re: [PATCH net-next v1] hinic: add three net_device_ops of vf
Message-ID: <20200508143825.2938a6e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200507182119.20494-1-luobin9@huawei.com>
References: <20200507182119.20494-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 May 2020 18:21:19 +0000 Luo bin wrote:
> @@ -899,8 +920,18 @@ int hinic_init_cmdqs(struct hinic_cmdqs *cmdqs, struct hinic_hwif *hwif,
>  
>  	hinic_ceq_register_cb(&func_to_io->ceqs, HINIC_CEQ_CMDQ, cmdqs,
>  			      cmdq_ceq_handler);
> +
> +	err = hinic_set_cmdq_depth(hwdev, CMDQ_DEPTH);
> +	if (err) {
> +		dev_err(&hwif->pdev->dev, "Failed to set cmdq depth\n");
> +		goto err_set_cmdq_depth;
> +	}
> +
>  	return 0;
>  
> +err_set_cmdq_depth:
> +	hinic_ceq_unregister_cb(&func_to_io->ceqs, HINIC_CEQ_CMDQ);

Looking at code in hinic_free_cmdqs(), isn't this also missing:

	cmdq_type = HINIC_CMDQ_SYNC;
	for (; cmdq_type < HINIC_MAX_CMDQ_TYPES; cmdq_type++)
		free_cmdq(&cmdqs->cmdq[cmdq_type]);
?

>  err_cmdq_ctxt:
>  	hinic_wqs_cmdq_free(&cmdqs->cmdq_pages, cmdqs->saved_wqs,
>  			    HINIC_MAX_CMDQ_TYPES);
