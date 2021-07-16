Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE993CB225
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 08:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234530AbhGPGDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 02:03:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230088AbhGPGDN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 02:03:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52075613AF;
        Fri, 16 Jul 2021 06:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626415219;
        bh=PgrHgohX9pk702vBlT0LnHfqXt4bH8D+RAr5u/CmCj4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P+xwNDIGrOD3LiCrL/Atlu1LlIbv2ejinjYLsfztWgNkkTthUKNCUJv9JhnL05NKZ
         ufXd+al7GS2FSocUAToR9hNCRxzMNlX40R6jULlqUC+gnovyvpnVa4jKRShF2MKkIw
         8mxbpXQue3RUntG+lPt7URlOBh0msU119hAA/8eMbVrl32dmIcEx+e5AG0vC2qWBpu
         YX9cN2i4j2SlZr8rdW9y1nFlpDJtO1aC/4Gy2KZIB8NgDKrEE0HKePCEfJnhsq1giG
         udN//yAI/kJACyK5GCtN/Rlqcwho8z1/9IDZUKBTzoDQTeKjNP8AGdwUMklFELEGVF
         RNF7IsZxQhw/g==
Date:   Fri, 16 Jul 2021 08:00:13 +0200
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     <davem@davemloft.net>, <jiri@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: Re: [PATCH V2 net-next 1/9] devlink: add documentation for hns3
 driver
Message-ID: <20210716080013.652969bf@cakuba>
In-Reply-To: <1626335110-50769-2-git-send-email-huangguangbin2@huawei.com>
References: <1626335110-50769-1-git-send-email-huangguangbin2@huawei.com>
        <1626335110-50769-2-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Jul 2021 15:45:02 +0800, Guangbin Huang wrote:
> From: Hao Chen <chenhao288@hisilicon.com>
> 
> Add a file to document devlink support for hns3 driver.
> 
> Now support devlink param and devlink info.
> 
> Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>

> +This document describes the devlink features implemented by the ``hns3``
> +device driver.
> +
> +Parameters
> +==========
> +
> +The ``hns3`` driver implements the following driver-specific
> +parameters.
> +
> +.. list-table:: Driver-specific parameters implemented
> +   :widths: 10 10 10 70
> +
> +   * - Name
> +     - Type
> +     - Mode
> +     - Description
> +   * - ``rx_buf_len``
> +     - U32
> +     - driverinit
> +     - Set rx BD buffer size, now only support setting 2048 and 4096.
> +
> +       * The feature is used to change the buffer size of each BD of Rx ring
> +         between 2KB and 4KB, then do devlink reload operation to take effect.

Does the reload required here differ from the reload performed when the
ring size is changed? You can extend the ethtool API, devlink params
should be used for very vendor specific configuration. Which page
fragment size very much is not.

> +   * - ``tx_buf_size``
> +     - U32
> +     - driverinit
> +     - Set tx bounce buf size.
> +
> +       * The size is setted for tx bounce feature. Tx bounce buffer feature is
> +         used for small size packet or frag. It adds a queue based tx shared
> +         bounce buffer to memcpy the small packet when the len of xmitted skb is
> +         below tx_copybreak(value to distinguish small size and normal size),
> +         and reduce the overhead of dma map and unmap when IOMMU is on.

IMHO setting the tx_copybreak should be configured thru the same API as
the size of the buffer it uses. Hence, again, ethtool.
