Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D98D2C4CAC
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 02:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732088AbgKZBcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 20:32:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:41770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730632AbgKZBcT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 20:32:19 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29086206F7;
        Thu, 26 Nov 2020 01:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606354339;
        bh=gY7n5a7FLsXf2uJpTn5XVgbpxWA+8WuRK8ksAaWvY9k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CsbW7Awp7smR9/gGDB8JPA1OCslQwsO1TPQlvnSrGKnKqhC+TPKRF/XENekOKSB/N
         l4xlpHs6V0WobhnYrSbEi35J2WtrgYwJku5fytY/MRNs7S0Npqq8+aiSGs90j2dgzg
         BmI7r4r32mcEi10JMNtbnYQMBCg/hG2sISoutHT8=
Date:   Wed, 25 Nov 2020 17:32:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Maxim Mikityanskiy" <maximmi@mellanox.com>
Subject: Re: [PATCH V2 net] net/tls: Protect from calling tls_dev_del for
 TLS RX twice
Message-ID: <20201125173218.60a8a7ff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201125221810.69870-1-saeedm@nvidia.com>
References: <20201125221810.69870-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Nov 2020 14:18:10 -0800 Saeed Mahameed wrote:
> From: Maxim Mikityanskiy <maximmi@mellanox.com>
> 
> tls_device_offload_cleanup_rx doesn't clear tls_ctx->netdev after
> calling tls_dev_del if TLX TX offload is also enabled. Clearing
> tls_ctx->netdev gets postponed until tls_device_gc_task. It leaves a
> time frame when tls_device_down may get called and call tls_dev_del for
> RX one extra time, confusing the driver, which may lead to a crash.
> 
> This patch corrects this racy behavior by adding a flag to prevent
> tls_device_down from calling tls_dev_del the second time.
> 
> Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
>  Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

Applied, thanks!
