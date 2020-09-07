Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D02B5260644
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 23:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgIGV2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 17:28:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727088AbgIGV2g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 17:28:36 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D3F0215A4;
        Mon,  7 Sep 2020 21:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599514116;
        bh=BJZvKDJY9C0f4CMK+61SF1pC5Mi/osPFC1w7YiXBVg4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tBzUUZNGi9nHbfBr41ZDevX3KGZg9+RN+6irT1AoJuWSJQssBZBKdaUaNLYuaGACR
         /rP6eTxLrx+RB0dxaYUgKKyvkAbb04uUXMYDYYysmxUZKSdv8cmSXRxmJjqqEYn5l+
         wMdzZC/T3ilbM7LIYRpSaH3XEL8AHnoiTAa3jg4E=
Date:   Mon, 7 Sep 2020 14:28:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo bin <luobin9@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <chiqijun@huawei.com>
Subject: Re: [PATCH net] hinic: fix rewaking txq after netif_tx_disable
Message-ID: <20200907142834.368b9bae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200907141516.16817-1-luobin9@huawei.com>
References: <20200907141516.16817-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Sep 2020 22:15:16 +0800 Luo bin wrote:
> When calling hinic_close in hinic_set_channels, all queues are
> stopped after netif_tx_disable, but some queue may be rewaken in
> free_tx_poll by mistake while drv is handling tx irq. If one queue
> is rewaken core may call hinic_xmit_frame to send pkt after
> netif_tx_disable within a short time which may results in accessing
> memory that has been already freed in hinic_close. So we judge
> whether the netdev is in down state before waking txq in free_tx_poll
> to fix this bug.

The right fix is to call napi_disable() _before_ you call
netif_tx_disable(), not after, like hinic_close() does.
