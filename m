Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36BB11876F4
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 01:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733113AbgCQAdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 20:33:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50242 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733031AbgCQAdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 20:33:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C8CF1157967E5;
        Mon, 16 Mar 2020 17:33:30 -0700 (PDT)
Date:   Mon, 16 Mar 2020 17:33:30 -0700 (PDT)
Message-Id: <20200316.173330.2197524619383790235.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     luobin9@huawei.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, aviad.krawczyk@huawei.com,
        luoxianjun@huawei.com, cloud.wangxiaoyun@huawei.com,
        yin.yinshi@huawei.com
Subject: Re: [PATCH net 1/6] hinic: fix process of long length skb without
 frags
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200316144408.00797c6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200316005630.9817-1-luobin9@huawei.com>
        <20200316005630.9817-2-luobin9@huawei.com>
        <20200316144408.00797c6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Mar 2020 17:33:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Mon, 16 Mar 2020 14:44:08 -0700

> On Mon, 16 Mar 2020 00:56:25 +0000 Luo bin wrote:
>> -#define MIN_SKB_LEN                     17
>> +#define MIN_SKB_LEN			17
>> +#define HINIC_GSO_MAX_SIZE		65536
> 
>> +	if (unlikely(skb->len > HINIC_GSO_MAX_SIZE && nr_sges == 1)) {
>> +		txq->txq_stats.frag_len_overflow++;
>> +		goto skb_error;
>> +	}
> 
> I don't think drivers should have to check this condition.
> 
> We have netdev->gso_max_size which should be initialized to 
> 
> include/linux/netdevice.h:#define GSO_MAX_SIZE          65536
> 
> in
> 
> net/core/dev.c: dev->gso_max_size = GSO_MAX_SIZE;
> 
> Please send a patch to pktgen to uphold the normal stack guarantees.

Agreed, the driver should not have to validate this.
