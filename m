Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF1F51874F8
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 22:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732750AbgCPVoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 17:44:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732680AbgCPVoL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 17:44:11 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A22D520658;
        Mon, 16 Mar 2020 21:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584395051;
        bh=NtwqjS8GGcvbcY9Ssa14vTtHWgHuCBV/WCBMZ4YR4IA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r7WeHGQsE7RVfM+72tFbyL6xz0Y0jLiOi9pViKrBD/9r+8Ta6YjhiE6L47w5XiDc7
         PGwW967AqtPQbmrhNpQgRAMG7qz4ucMFQSsVuW3vHiYhB2NfpK7hfImh/wXoasrunc
         eylvR9uRJvMF9U5nDtsgGyzDi3P1mnxqkGkBhY1Q=
Date:   Mon, 16 Mar 2020 14:44:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo bin <luobin9@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <aviad.krawczyk@huawei.com>,
        <luoxianjun@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <yin.yinshi@huawei.com>
Subject: Re: [PATCH net 1/6] hinic: fix process of long length skb without
 frags
Message-ID: <20200316144408.00797c6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200316005630.9817-2-luobin9@huawei.com>
References: <20200316005630.9817-1-luobin9@huawei.com>
        <20200316005630.9817-2-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Mar 2020 00:56:25 +0000 Luo bin wrote:
> -#define MIN_SKB_LEN                     17
> +#define MIN_SKB_LEN			17
> +#define HINIC_GSO_MAX_SIZE		65536

> +	if (unlikely(skb->len > HINIC_GSO_MAX_SIZE && nr_sges == 1)) {
> +		txq->txq_stats.frag_len_overflow++;
> +		goto skb_error;
> +	}

I don't think drivers should have to check this condition.

We have netdev->gso_max_size which should be initialized to 

include/linux/netdevice.h:#define GSO_MAX_SIZE          65536

in

net/core/dev.c: dev->gso_max_size = GSO_MAX_SIZE;

Please send a patch to pktgen to uphold the normal stack guarantees.
