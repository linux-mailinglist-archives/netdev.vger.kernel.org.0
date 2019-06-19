Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BEA14B8A3
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 14:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731738AbfFSMds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 08:33:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36958 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727085AbfFSMds (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 08:33:48 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 634F181E09;
        Wed, 19 Jun 2019 12:33:41 +0000 (UTC)
Received: from cera.brq.redhat.com (unknown [10.43.2.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA0372C8DC;
        Wed, 19 Jun 2019 12:33:37 +0000 (UTC)
Date:   Wed, 19 Jun 2019 14:33:37 +0200
From:   Ivan Vecera <ivecera@redhat.com>
To:     Petr Oros <poros@redhat.com>
Cc:     netdev@vger.kernel.org, sathya.perla@broadcom.com,
        ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com,
        somnath.kotur@broadcom.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net] be2net: fix link failure after ethtool offline
 test
Message-ID: <20190619143337.424f81ed@cera.brq.redhat.com>
In-Reply-To: <20190619122942.15497-1-poros@redhat.com>
References: <20190619122942.15497-1-poros@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Wed, 19 Jun 2019 12:33:48 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Jun 2019 14:29:42 +0200
Petr Oros <poros@redhat.com> wrote:

> Certain cards in conjunction with certain switches need a little more
> time for link setup that results in ethtool link test failure after
> offline test. Patch adds a loop that waits for a link setup finish.
> 
> Changes in v2:
> - added fixes header
> 
> Fixes: 4276e47e2d1c ("be2net: Add link test to list of ethtool self
> tests.") Signed-off-by: Petr Oros <poros@redhat.com>
> ---
>  .../net/ethernet/emulex/benet/be_ethtool.c    | 28
> +++++++++++++++---- 1 file changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/emulex/benet/be_ethtool.c
> b/drivers/net/ethernet/emulex/benet/be_ethtool.c index
> 8a6785173228f3..492f8769ac12c2 100644 ---
> a/drivers/net/ethernet/emulex/benet/be_ethtool.c +++
> b/drivers/net/ethernet/emulex/benet/be_ethtool.c @@ -891,7 +891,7 @@
> static void be_self_test(struct net_device *netdev, struct
> ethtool_test *test, u64 *data) {
>  	struct be_adapter *adapter = netdev_priv(netdev);
> -	int status;
> +	int status, cnt;
>  	u8 link_status = 0;
>  
>  	if (adapter->function_caps & BE_FUNCTION_CAPS_SUPER_NIC) {
> @@ -902,6 +902,9 @@ static void be_self_test(struct net_device
> *netdev, struct ethtool_test *test, 
>  	memset(data, 0, sizeof(u64) * ETHTOOL_TESTS_NUM);
>  
> +	/* check link status before offline tests */
> +	link_status = netif_carrier_ok(netdev);
> +
>  	if (test->flags & ETH_TEST_FL_OFFLINE) {
>  		if (be_loopback_test(adapter, BE_MAC_LOOPBACK,
> &data[0]) != 0) test->flags |= ETH_TEST_FL_FAILED;
> @@ -922,13 +925,26 @@ static void be_self_test(struct net_device
> *netdev, struct ethtool_test *test, test->flags |= ETH_TEST_FL_FAILED;
>  	}
>  
> -	status = be_cmd_link_status_query(adapter, NULL,
> &link_status, 0);
> -	if (status) {
> -		test->flags |= ETH_TEST_FL_FAILED;
> -		data[4] = -1;
> -	} else if (!link_status) {
> +	/* link status was down prior to test */
> +	if (!link_status) {
>  		test->flags |= ETH_TEST_FL_FAILED;
>  		data[4] = 1;
> +		return;
> +	}
> +
> +	for (cnt = 10; cnt; cnt--) {
> +		status = be_cmd_link_status_query(adapter, NULL,
> &link_status,
> +						  0);
> +		if (status) {
> +			test->flags |= ETH_TEST_FL_FAILED;
> +			data[4] = -1;
> +			break;
> +		}
> +
> +		if (link_status)
> +			break;
> +
> +		msleep_interruptible(500);
>  	}
>  }
>  

LGTM

Reviewed-by: Ivan Vecera <ivecera@redhat.com>
