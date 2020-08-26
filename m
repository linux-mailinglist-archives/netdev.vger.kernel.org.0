Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF19E2524C1
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 02:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgHZAbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 20:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbgHZAbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 20:31:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0CCC061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 17:31:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 014C211E44280;
        Tue, 25 Aug 2020 17:14:18 -0700 (PDT)
Date:   Tue, 25 Aug 2020 17:31:04 -0700 (PDT)
Message-Id: <20200825.173104.1541443546408114168.davem@davemloft.net>
To:     drt@linux.ibm.com
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mmc@linux.vnet.ibm.com
Subject: Re: [PATCH net v3] ibmvnic fix NULL tx_pools and rx_tools issue at
 do_reset
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200825172641.806912-1-drt@linux.ibm.com>
References: <20200825172641.806912-1-drt@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Aug 2020 17:14:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dany Madden <drt@linux.ibm.com>
Date: Tue, 25 Aug 2020 13:26:41 -0400

> From: Mingming Cao <mmc@linux.vnet.ibm.com>
> 
> At the time of do_rest, ibmvnic tries to re-initalize the tx_pools
> and rx_pools to avoid re-allocating the long term buffer. However
> there is a window inside do_reset that the tx_pools and
> rx_pools were freed before re-initialized making it possible to deference
> null pointers.
> 
> This patch fix this issue by always check the tx_pool
> and rx_pool are not NULL after ibmvnic_login. If so, re-allocating
> the pools. This will avoid getting into calling reset_tx/rx_pools with
> NULL adapter tx_pools/rx_pools pointer. Also add null pointer check in
> reset_tx_pools and reset_rx_pools to safe handle NULL pointer case.
> 
> Signed-off-by: Mingming Cao <mmc@linux.vnet.ibm.com>
> Signed-off-by: Dany Madden <drt@linux.ibm.com>

Applied, but:

> +	if (!adapter->rx_pool)
> +		return -1;
> +

This driver has poor error code usage, it's a random mix of hypervisor
error codes, normal error codes like -EINVAL, and internal error codes.
Sometimes used all in the same function.

For example:

static int ibmvnic_send_crq(struct ibmvnic_adapter *adapter,
			    union ibmvnic_crq *crq)
 ...
	if (!adapter->crq.active &&
	    crq->generic.first != IBMVNIC_CRQ_INIT_CMD) {
		dev_warn(dev, "Invalid request detected while CRQ is inactive, possible device state change during reset\n");
		return -EINVAL;
	}
 ...
	rc = plpar_hcall_norets(H_SEND_CRQ, ua,
				cpu_to_be64(u64_crq[0]),
				cpu_to_be64(u64_crq[1]));

	if (rc) {
		if (rc == H_CLOSED) {
 ...
	return rc;

So obviously this function returns a mix of negative erro codes
and Hypervisor codes such as H_CLOSED.

And stuff like:

	rc = __ibmvnic_open(netdev);
	if (rc)
		return IBMVNIC_OPEN_FAILED;
