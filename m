Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB58E6B820
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 10:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbfGQIX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 04:23:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:57702 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725912AbfGQIX5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 04:23:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E2C3CAEA4;
        Wed, 17 Jul 2019 08:23:55 +0000 (UTC)
Date:   Wed, 17 Jul 2019 17:23:40 +0900
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Firo Yang <firo.yang@suse.com>
Cc:     David Miller <davem@davemloft.net>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Sathya Perla <sathya.perla@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] be2net: Signal that the device cannot transmit
 during reconfiguration
Message-ID: <20190717082340.GA6015@f1>
References: <20190716081655.7676-1-bpoirier@suse.com>
 <CH2PR18MB31898E033896F9760D36BFF288C90@CH2PR18MB3189.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH2PR18MB31898E033896F9760D36BFF288C90@CH2PR18MB3189.namprd18.prod.outlook.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/07/17 13:23, Firo Yang wrote:
> I think there is a problem if dev_watchdog() is triggered before netif_carrier_off(). dev_watchdog() might call ->ndo_tx_timeout(), i.e. be_tx_timeout(), if txq timeout  happens. Thus be_tx_timeout() could still be able to access the memory which is being freed by be_update_queues().

Good point. That's a separate problem which would occur in case of real
tx timeout. How about this followup change:

--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -4698,8 +4698,13 @@ int be_update_queues(struct be_adapter *adapter)
 	int status;
 
 	if (netif_running(netdev)) {
+		/* be_tx_timeout() must not run concurrently with this
+		 * function, synchronize with an already-running dev_watchdog
+		 */
+		netif_tx_lock_bh(netdev);
 		/* device cannot transmit now, avoid dev_watchdog timeouts */
 		netif_carrier_off(netdev);
+		netif_tx_unlock_bh(netdev);
 
 		be_close(netdev);
 	}
