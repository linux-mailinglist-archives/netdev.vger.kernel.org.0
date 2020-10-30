Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E5C2A0F6D
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 21:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbgJ3U1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 16:27:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbgJ3U1F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 16:27:05 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4334E20739;
        Fri, 30 Oct 2020 20:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604089624;
        bh=xvwGnhWKImR03nlDLE/0k7Ws1jtv1PJyIxZ6Of0TVKY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Kr8LM0r1NiJoYEVApVJtMdri+ZT0t0FSkr0fGZcAxtFeDIMAyILEdWW86l6nl0Ycc
         JmLwIHOYAz7fGT72nvFQ30Mc0OS34CeD3FoFy1Itd365rd0/+hO2v/RPdsLJbVoKm1
         406kNKh4FTzqhp3JUPEIdLgaTLIwTOw/Ki3fp4JI=
Date:   Fri, 30 Oct 2020 13:27:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>,
        Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>,
        Dany Madden <drt@linux.ibm.com>
Subject: Re: [PATCH net 1/2] ibmvnic: notify peers when failover and
 migration happen
Message-ID: <20201030132703.03fa6d4f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201028055742.74941-2-ljp@linux.ibm.com>
References: <20201028055742.74941-1-ljp@linux.ibm.com>
        <20201028055742.74941-2-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 00:57:41 -0500 Lijun Pan wrote:
> We need to notify peers only when failover and migration happen.
> It is unnecessary to call that in other events like
> FATAL, NON_FATAL, CHANGE_PARAM, and TIMEOUT resets
> since in those scenarios the MAC address and ip address mapping
> does not change. Originally all the resets except CHANGE_PARAM
> are processed by do_reset such that we need to find out
> failover and migration cases in do_reset and call notifier functions.
> We only need to notify peers in do_reset and do_hard_reset.
> We don't need notify peers in do_change_param_reset since it is
> a CHANGE_PARAM reset. In a nested reset case, it will finally
> call into do_hard_reset with reasons other than failvoer and
> migration. So, we don't need to check the reset reason in
> do_hard_reset and just call notifier functions anyway.

You're completely undoing the commit you linked to:

commit 61d3e1d9bc2a1910d773cbf4ed6f587a7a6166b5
Author: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Date:   Mon Jun 12 20:47:45 2017 -0400

    ibmvnic: Remove netdev notify for failover resets
    
    When handling a driver reset due to a failover of the backing
    server on the vios, doing the netdev_notify_peers() can cause
    network traffic to stall or halt. Remove the netdev notify call
    for failover resets.
    
    Signed-off-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index fd3ef3005fb0..59ea7a5ae776 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1364,7 +1364,9 @@ static int do_reset(struct ibmvnic_adapter *adapter,
        for (i = 0; i < adapter->req_rx_queues; i++)
                napi_schedule(&adapter->napi[i]);
 
-       netdev_notify_peers(netdev);
+       if (adapter->reset_reason != VNIC_RESET_FAILOVER)
+               netdev_notify_peers(netdev);
+
        return 0;
 }

But you don't seem to address why this change was unnecessary.

AFAIK you're saying "we only need this event for FAILOVER and MOBILITY"
but the previous commit _excluded_ FAILOVER for some vague reason.

If the previous commit was incorrect you need to explain that in the
commit message.

> netdev_notify_peers calls below two functions with rtnl lock().
> 	call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, dev);
> 	call_netdevice_notifiers(NETDEV_RESEND_IGMP, dev);
> When netdev_notify_peers was substituted in
> commit 986103e7920c ("net/ibmvnic: Fix RTNL deadlock during device reset"),
> call_netdevice_notifiers(NETDEV_RESEND_IGMP, dev) was missed.

That should be a separate patch.

> Fixes: 61d3e1d9bc2a ("ibmvnic: Remove netdev notify for failover resets")
> Fixes: 986103e7920c ("net/ibmvnic: Fix RTNL deadlock during device
> reset")

Please don't line-wrap fixes tags.

> Suggested-by: Brian King <brking@linux.vnet.ibm.com>
> Suggested-by: Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>
> Signed-off-by: Dany Madden <drt@linux.ibm.com>
> Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> index 1b702a43a5d0..718da39f5ae4 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -2067,8 +2067,11 @@ static int do_reset(struct ibmvnic_adapter *adapter,
>  	for (i = 0; i < adapter->req_rx_queues; i++)
>  		napi_schedule(&adapter->napi[i]);
>  
> -	if (adapter->reset_reason != VNIC_RESET_FAILOVER)
> +	if (adapter->reset_reason == VNIC_RESET_FAILOVER ||
> +	    adapter->reset_reason == VNIC_RESET_MOBILITY) {
>  		call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, netdev);
> +		call_netdevice_notifiers(NETDEV_RESEND_IGMP, netdev);
> +	}
>  
>  	rc = 0;
>  
> @@ -2138,6 +2141,9 @@ static int do_hard_reset(struct ibmvnic_adapter *adapter,
>  	if (rc)
>  		return IBMVNIC_OPEN_FAILED;
>  
> +	call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, netdev);
> +	call_netdevice_notifiers(NETDEV_RESEND_IGMP, netdev);
> +
>  	return 0;
>  }
>  

