Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52E55F053E
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 19:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390709AbfKESlT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 5 Nov 2019 13:41:19 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2447 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390673AbfKESlT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 13:41:19 -0500
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 56EF9728BB6444C58FB7;
        Wed,  6 Nov 2019 02:41:16 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 6 Nov 2019 02:41:16 +0800
Received: from lhreml703-chm.china.huawei.com (10.201.108.52) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Wed, 6 Nov 2019 02:41:14 +0800
Received: from lhreml703-chm.china.huawei.com ([10.201.68.198]) by
 lhreml703-chm.china.huawei.com ([10.201.68.198]) with mapi id 15.01.1713.004;
 Tue, 5 Nov 2019 18:41:11 +0000
From:   Salil Mehta <salil.mehta@huawei.com>
To:     Marc Zyngier <maz@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "lipeng (Y)" <lipeng321@huawei.com>,
        "Zhuangyuzeng (Yisen)" <yisen.zhuang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: RE: [PATCH] net: hns: Ensure that interface teardown cannot race with
 TX interrupt
Thread-Topic: [PATCH] net: hns: Ensure that interface teardown cannot race
 with TX interrupt
Thread-Index: AQHVk0n0bjLQxPyNVEeIvNGhOalq6ad8Sp0QgAA7j2A=
Date:   Tue, 5 Nov 2019 18:41:11 +0000
Message-ID: <aa7d625e74c74e4b9810b8ea3e437ca4@huawei.com>
References: <20191104195604.17109-1-maz@kernel.org> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.226.45]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,
I tested with the patch on D05 with the lockdep enabled kernel with below options
and I could not reproduce the deadlock. I do not argue the issue being mentioned
as this looks to be a clear bug which should hit while TX data-path is running
and we try to disable the interface.

Could you please help me know the exact set of steps you used to get into this
problem. Also, are you able to re-create it easily/frequently?


# Kernel Config options:
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_LOCKDEP=y


Thanks
Salil.

> From: Salil Mehta
> Sent: Tuesday, November 5, 2019 9:15 AM
> To: 'Marc Zyngier' <maz@kernel.org>; netdev@vger.kernel.org
> Cc: lipeng (Y) <lipeng321@huawei.com>; Zhuangyuzeng (Yisen)
> <yisen.zhuang@huawei.com>; David S . Miller <davem@davemloft.net>
> Subject: RE: [PATCH] net: hns: Ensure that interface teardown cannot race with
> TX interrupt
> 
> Hi Marc,
> Thanks for the catch & the patch. As such Looks good to me. For the sanity check,
> I will try to reproduce the problem again and test it once with your patch.
> 
> 
> Best Regards
> Salil
> 
> 
> > From: Marc Zyngier [mailto:maz@kernel.org]
> > Sent: Monday, November 4, 2019 7:56 PM
> > To: netdev@vger.kernel.org
> > Cc: lipeng (Y) <lipeng321@huawei.com>; Zhuangyuzeng (Yisen)
> > <yisen.zhuang@huawei.com>; Salil Mehta <salil.mehta@huawei.com>; David S .
> > Miller <davem@davemloft.net>
> > Subject: [PATCH] net: hns: Ensure that interface teardown cannot race with> TX
> > interrupt
> >
> > On a lockdep-enabled kernel, bringing down a HNS interface results
> > in a loud splat. It turns out that  the per-ring spinlock is taken
> > both in the TX interrupt path, and when bringing down the interface.
> >
> > Lockdep sums it up with:
> >
> > [32099.424453]        CPU0
> > [32099.426885]        ----
> > [32099.429318]   lock(&(&ring->lock)->rlock);
> > [32099.433402]   <Interrupt>
> > [32099.436008]     lock(&(&ring->lock)->rlock);
> > [32099.440264]
> > [32099.440264]  *** DEADLOCK ***
> >
> > To solve this, turn the NETIF_TX_{LOCK,UNLOCK} macros from standard
> > spin_[un]lock to their irqsave/irqrestore version.
> >
> > Fixes: f2aaed557ecff ("net: hns: Replace netif_tx_lock to ring spin lock")
> > Cc: lipeng <lipeng321@huawei.com>
> > Cc: Yisen Zhuang <yisen.zhuang@huawei.com>
> > Cc: Salil Mehta <salil.mehta@huawei.com>
> > Cc: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > ---
> >  drivers/net/ethernet/hisilicon/hns/hns_enet.c | 22 ++++++++++---------
> >  1 file changed, 12 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
> > b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
> > index a48396dd4ebb..9fbe4e1e6853 100644
> > --- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
> > +++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
> > @@ -945,11 +945,11 @@ static int is_valid_clean_head(struct hnae_ring *ring,
> > int h)
> >
> >  /* netif_tx_lock will turn down the performance, set only when necessary */
> >  #ifdef CONFIG_NET_POLL_CONTROLLER
> > -#define NETIF_TX_LOCK(ring) spin_lock(&(ring)->lock)
> > -#define NETIF_TX_UNLOCK(ring) spin_unlock(&(ring)->lock)
> > +#define NETIF_TX_LOCK(ring, flags) spin_lock_irqsave(&(ring)->lock, flags)
> > +#define NETIF_TX_UNLOCK(ring, flags) spin_unlock_irqrestore(&(ring)->lock,
> > flags)
> >  #else
> > -#define NETIF_TX_LOCK(ring)
> > -#define NETIF_TX_UNLOCK(ring)
> > +#define NETIF_TX_LOCK(ring, flags)
> > +#define NETIF_TX_UNLOCK(ring, flags)
> >  #endif
> >
> >  /* reclaim all desc in one budget
> > @@ -962,16 +962,17 @@ static int hns_nic_tx_poll_one(struct hns_nic_ring_data
> > *ring_data,
> >  	struct net_device *ndev = ring_data->napi.dev;
> >  	struct netdev_queue *dev_queue;
> >  	struct hns_nic_priv *priv = netdev_priv(ndev);
> > +	unsigned long flags;
> >  	int head;
> >  	int bytes, pkts;
> >
> > -	NETIF_TX_LOCK(ring);
> > +	NETIF_TX_LOCK(ring, flags);
> >
> >  	head = readl_relaxed(ring->io_base + RCB_REG_HEAD);
> >  	rmb(); /* make sure head is ready before touch any data */
> >
> >  	if (is_ring_empty(ring) || head == ring->next_to_clean) {
> > -		NETIF_TX_UNLOCK(ring);
> > +		NETIF_TX_UNLOCK(ring, flags);
> >  		return 0; /* no data to poll */
> >  	}
> >
> > @@ -979,7 +980,7 @@ static int hns_nic_tx_poll_one(struct hns_nic_ring_data
> > *ring_data,
> >  		netdev_err(ndev, "wrong head (%d, %d-%d)\n", head,
> >  			   ring->next_to_use, ring->next_to_clean);
> >  		ring->stats.io_err_cnt++;
> > -		NETIF_TX_UNLOCK(ring);
> > +		NETIF_TX_UNLOCK(ring, flags);
> >  		return -EIO;
> >  	}
> >
> > @@ -994,7 +995,7 @@ static int hns_nic_tx_poll_one(struct hns_nic_ring_data
> > *ring_data,
> >  	ring->stats.tx_pkts += pkts;
> >  	ring->stats.tx_bytes += bytes;
> >
> > -	NETIF_TX_UNLOCK(ring);
> > +	NETIF_TX_UNLOCK(ring, flags);
> >
> >  	dev_queue = netdev_get_tx_queue(ndev, ring_data->queue_index);
> >  	netdev_tx_completed_queue(dev_queue, pkts, bytes);
> > @@ -1052,10 +1053,11 @@ static void hns_nic_tx_clr_all_bufs(struct
> > hns_nic_ring_data *ring_data)
> >  	struct hnae_ring *ring = ring_data->ring;
> >  	struct net_device *ndev = ring_data->napi.dev;
> >  	struct netdev_queue *dev_queue;
> > +	unsigned long flags;
> >  	int head;
> >  	int bytes, pkts;
> >
> > -	NETIF_TX_LOCK(ring);
> > +	NETIF_TX_LOCK(ring, flags);
> >
> >  	head = ring->next_to_use; /* ntu :soft setted ring position*/
> >  	bytes = 0;
> > @@ -1063,7 +1065,7 @@ static void hns_nic_tx_clr_all_bufs(struct
> > hns_nic_ring_data *ring_data)
> >  	while (head != ring->next_to_clean)
> >  		hns_nic_reclaim_one_desc(ring, &bytes, &pkts);
> >
> > -	NETIF_TX_UNLOCK(ring);
> > +	NETIF_TX_UNLOCK(ring, flags);
> >
> >  	dev_queue = netdev_get_tx_queue(ndev, ring_data->queue_index);
> >  	netdev_tx_reset_queue(dev_queue);
> > --
> > 2.20.1

