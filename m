Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEB1A4B798
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 14:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731697AbfFSMDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 08:03:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56270 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727134AbfFSMDe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 08:03:34 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AC15730018D7;
        Wed, 19 Jun 2019 12:03:28 +0000 (UTC)
Received: from cera.brq.redhat.com (unknown [10.43.2.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3139B5C207;
        Wed, 19 Jun 2019 12:03:26 +0000 (UTC)
Date:   Wed, 19 Jun 2019 14:03:25 +0200
From:   Ivan Vecera <ivecera@redhat.com>
To:     Petr Oros <poros@redhat.com>
Cc:     netdev@vger.kernel.org, sathya.perla@broadcom.com,
        ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com,
        somnath.kotur@broadcom.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] be2net: fix link failure after ethtool offline test
Message-ID: <20190619140325.64dafd23@cera.brq.redhat.com>
In-Reply-To: <20190619115231.6020-1-poros@redhat.com>
References: <20190619115231.6020-1-poros@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Wed, 19 Jun 2019 12:03:33 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Jun 2019 13:52:31 +0200
Petr Oros <poros@redhat.com> wrote:

> Certain cards in conjunction with certain switches need a little more
> time for link setup that results in ethtool link test failure after
> offline test. Patch adds a loop that waits for a link setup finish.
> 
> Signed-off-by: Petr Oros <poros@redhat.com>

Missing Fixes header for net stuff... Otherwise LGTM.

Ivan

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

