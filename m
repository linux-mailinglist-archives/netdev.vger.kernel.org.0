Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 120F78A4DC
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 19:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfHLRtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 13:49:46 -0400
Received: from smtprelay0243.hostedemail.com ([216.40.44.243]:38410 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726263AbfHLRtq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 13:49:46 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id AD926180A7F94;
        Mon, 12 Aug 2019 17:49:44 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3870:3871:3872:4250:4321:5007:7514:7903:8957:9010:9012:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12296:12297:12438:12555:12740:12760:12895:12986:13439:14096:14097:14181:14659:14721:21080:21324:21433:21451:21627:30034:30054:30080:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:24,LUA_SUMMARY:none
X-HE-Tag: legs21_1a94506e05015
X-Filterd-Recvd-Size: 3584
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf08.hostedemail.com (Postfix) with ESMTPA;
        Mon, 12 Aug 2019 17:49:42 +0000 (UTC)
Message-ID: <93581c35c0a8c06434221e628153028105849064.camel@perches.com>
Subject: Re: [PATCH net] ibmveth: Convert multicast list size for
 little-endian systems
From:   Joe Perches <joe@perches.com>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>, netdev@vger.kernel.org
Cc:     liuhangbin@gmail.com, davem@davemloft.net
Date:   Mon, 12 Aug 2019 10:49:40 -0700
In-Reply-To: <1565631786-18860-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1565631786-18860-1-git-send-email-tlfalcon@linux.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-08-12 at 12:43 -0500, Thomas Falcon wrote:
> The ibm,mac-address-filters property defines the maximum number of
> addresses the hypervisor's multicast filter list can support. It is
> encoded as a big-endian integer in the OF device tree, but the virtual
> ethernet driver does not convert it for use by little-endian systems.
> As a result, the driver is not behaving as it should on affected systems
> when a large number of multicast addresses are assigned to the device.
> 
> Reported-by: Hangbin Liu <liuhangbin@gmail.com>
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
> ---
>  drivers/net/ethernet/ibm/ibmveth.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
> index d654c23..b50a6cf 100644
> --- a/drivers/net/ethernet/ibm/ibmveth.c
> +++ b/drivers/net/ethernet/ibm/ibmveth.c
> @@ -1645,7 +1645,7 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
>  
>  	adapter->vdev = dev;
>  	adapter->netdev = netdev;
> -	adapter->mcastFilterSize = *mcastFilterSize_p;
> +	adapter->mcastFilterSize = be32_to_cpu(*mcastFilterSize_p);
>  	adapter->pool_config = 0;
>  
>  	netif_napi_add(netdev, &adapter->napi, ibmveth_poll, 16);

Perhaps to keep sparse happy too: (untested)
---
 drivers/net/ethernet/ibm/ibmveth.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index d654c234aaf7..90539d7ce565 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1605,7 +1605,7 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	struct net_device *netdev;
 	struct ibmveth_adapter *adapter;
 	unsigned char *mac_addr_p;
-	unsigned int *mcastFilterSize_p;
+	__be32 *mcastFilterSize_p;
 	long ret;
 	unsigned long ret_attr;
 
@@ -1627,7 +1627,7 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 		return -EINVAL;
 	}
 
-	mcastFilterSize_p = (unsigned int *)vio_get_attribute(dev,
+	mcastFilterSize_p = (__be32 *)vio_get_attribute(dev,
 						VETH_MCAST_FILTER_SIZE, NULL);
 	if (!mcastFilterSize_p) {
 		dev_err(&dev->dev, "Can't find VETH_MCAST_FILTER_SIZE "
@@ -1645,7 +1645,7 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 
 	adapter->vdev = dev;
 	adapter->netdev = netdev;
-	adapter->mcastFilterSize = *mcastFilterSize_p;
+	adapter->mcastFilterSize = be32_to_cpu(*mcastFilterSize_p);
 	adapter->pool_config = 0;
 
 	netif_napi_add(netdev, &adapter->napi, ibmveth_poll, 16);


