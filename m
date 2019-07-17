Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6548E6B950
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 11:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbfGQJcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 05:32:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:56182 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726180AbfGQJcQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 05:32:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CB8BDAFBF;
        Wed, 17 Jul 2019 09:32:15 +0000 (UTC)
Date:   Wed, 17 Jul 2019 18:32:09 +0900
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Firo Yang <firo.yang@suse.com>
Cc:     Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Sathya Perla <sathya.perla@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] be2net: Signal that the device cannot transmit
 during reconfiguration
Message-ID: <20190717093208.GA6511@f1>
References: <20190716081655.7676-1-bpoirier@suse.com>
 <CH2PR18MB31898E033896F9760D36BFF288C90@CH2PR18MB3189.namprd18.prod.outlook.com>
 <20190717082340.GA6015@f1>
 <CH2PR18MB3189AD09E590F16443D8D5BA88C90@CH2PR18MB3189.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH2PR18MB3189AD09E590F16443D8D5BA88C90@CH2PR18MB3189.namprd18.prod.outlook.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/07/17 17:56, Firo Yang wrote:
> I don't think this change could fix this problem because if SMP, dev_watchdog() could run on a different CPU.

hmm, SMP is clearly part of the picture here. The change I proposed
revolves around the synchronization offered by dev->tx_global_lock:

we have
\ dev_watchdog
	\ netif_tx_lock
		spin_lock(&dev->tx_global_lock);
	...
	\ netif_tx_unlock

and

\ be_update_queues
	\ netif_tx_lock_bh
		\ netif_tx_lock
			spin_lock(&dev->tx_global_lock);

Makes sense?
