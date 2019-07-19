Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 745286E090
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 07:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfGSF1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 01:27:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:54136 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725777AbfGSF1B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jul 2019 01:27:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A13BEAD51;
        Fri, 19 Jul 2019 05:27:00 +0000 (UTC)
Date:   Fri, 19 Jul 2019 14:26:52 +0900
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Sathya Perla <sathya.perla@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Firo Yang <firo.yang@suse.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] be2net: Synchronize be_update_queues with
 dev_watchdog
Message-ID: <20190719052652.GA19727@f1>
References: <20190718014218.16610-1-bpoirier@suse.com>
 <42269a37-0353-29c8-ce13-51cb2feeb9af@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42269a37-0353-29c8-ce13-51cb2feeb9af@gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/07/18 10:23, Florian Fainelli wrote:
> On 7/17/19 6:42 PM, Benjamin Poirier wrote:
> > As pointed out by Firo Yang, a netdev tx timeout may trigger just before an
> > ethtool set_channels operation is started. be_tx_timeout(), which dumps
> > some queue structures, is not written to run concurrently with
> > be_update_queues(), which frees/allocates those queues structures. Add some
> > synchronization between the two.
> > 
> > Message-id: <CH2PR18MB31898E033896F9760D36BFF288C90@CH2PR18MB3189.namprd18.prod.outlook.com>
> > Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
> 
> Would not moving the netif_tx_disable() in be_close() further up in the
> function resolve that problem as well?

Thanks for your review Florian,

No, netif_tx_disable() doesn't provide mutual exclusion with
dev_watchdog(). You can have:

cpu0                               cpu1
\ dev_watchdog
       \ netif_tx_lock
              \ be_tx_timeout
                     ...
                                   \ be_set_channels
                                          \ be_update_queues
                                                 \ netif_carrier_off
                                                 \ netif_tx_disable
                                                 ...
                                                 \ be_clear_queues
                     still running in
                     be_tx_timeout(),
                     boom!
