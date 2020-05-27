Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B251E4FC6
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 23:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbgE0VEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 17:04:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726114AbgE0VEJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 17:04:09 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F31032075A;
        Wed, 27 May 2020 21:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590613449;
        bh=jldTWw0tp6vNMINwRPUcr5HlfaJdP889vwsjw0UuTP0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=enrPqQr7VF+mpqVTPE2zAzj5zYbeXkPLIhefiJjKroI9Cvp8PA2H2SAgB+j14H7Z1
         jzduJUvw9x7dumMIl+PJwJLVbk/XmptcSD2C2pT/jk0edn7r+LCeIgePhKIxV5uhC5
         pdlgfJ3yeu5kuKouIuQDqPJ8WTpmQ7DypGl+qtpU=
Date:   Wed, 27 May 2020 14:04:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     rohit maheshwari <rohitm@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
Subject: Re: [PATCH net v2] cxgb4/chcr: Enable ktls settings at run time
Message-ID: <20200527140406.420ed7fd@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <00b63ada-06d0-5298-e676-1c02e8676d61@chelsio.com>
References: <20200526140634.21043-1-rohitm@chelsio.com>
        <20200526154241.24447b41@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <00b63ada-06d0-5298-e676-1c02e8676d61@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 May 2020 10:02:42 +0530 rohit maheshwari wrote:
> On 27/05/20 4:12 AM, Jakub Kicinski wrote:
> > On Tue, 26 May 2020 19:36:34 +0530 Rohit Maheshwari wrote:  
> >> Current design enables ktls setting from start, which is not
> >> efficient. Now the feature will be enabled when user demands
> >> TLS offload on any interface.
> >>
> >> v1->v2:
> >> - taking ULD module refcount till any single connection exists.
> >> - taking rtnl_lock() before clearing tls_devops.  
> > Callers of tls_devops don't hold the rtnl_lock.  
> I think I should correct the statement here, " taking rtnl_lock()
> before clearing tls_devops and device flags". There won't be any
> synchronization issue while clearing tls_devops now, because I
> am incrementing module refcount of CRYPTO ULD, so this will
> never be called if there is any connection (new connection
> request) exists.

Please take a look at tls_set_device_offload():

	if (!(netdev->features & NETIF_F_HW_TLS_TX)) {
		rc = -EOPNOTSUPP;
		goto release_netdev;
	}

	/* Avoid offloading if the device is down
	 * We don't want to offload new flows after
	 * the NETDEV_DOWN event
	 *
	 * device_offload_lock is taken in tls_devices's NETDEV_DOWN
	 * handler thus protecting from the device going down before
	 * ctx was added to tls_device_list.
	 */
	down_read(&device_offload_lock);
	if (!(netdev->flags & IFF_UP)) {
		rc = -EINVAL;
		goto release_lock;
	}

	ctx->priv_ctx_tx = offload_ctx;
	rc = netdev->tlsdev_ops->tls_dev_add(netdev, sk, TLS_OFFLOAD_CTX_DIR_TX,
					     &ctx->crypto_send.info,
					     tcp_sk(sk)->write_seq);

This does not hold rtnl_lock. If you clear the ops between the feature
check and the call - there will be a crash. Never clear tls ops on a
registered netdev.

Why do you clear the ops in the first place? It shouldn't be necessary.
