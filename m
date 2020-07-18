Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7E9224C39
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 17:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgGRPGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 11:06:19 -0400
Received: from smtprelay0163.hostedemail.com ([216.40.44.163]:40920 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726155AbgGRPGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 11:06:19 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 1BCCA180A8CA9;
        Sat, 18 Jul 2020 15:06:18 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3867:3868:4250:4321:4605:5007:10004:10400:10848:11026:11232:11657:11658:11914:12043:12048:12296:12297:12438:12555:12740:12760:12895:12986:13069:13311:13357:13439:14659:14721:21080:21451:21627:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: fear80_261175726f14
X-Filterd-Recvd-Size: 2490
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf13.hostedemail.com (Postfix) with ESMTPA;
        Sat, 18 Jul 2020 15:06:16 +0000 (UTC)
Message-ID: <3093bc36c2ad86170e2e90a3451e5962d0815122.camel@perches.com>
Subject: Re: [PATCH -next] net: ena: use NULL instead of zero
From:   Joe Perches <joe@perches.com>
To:     Wang Hai <wanghai38@huawei.com>, netanel@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com, saeedb@amazon.com,
        zorik@amazon.com, davem@davemloft.net, kuba@kernel.org,
        sameehj@amazon.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sat, 18 Jul 2020 08:06:14 -0700
In-Reply-To: <20200718115633.37464-1-wanghai38@huawei.com>
References: <20200718115633.37464-1-wanghai38@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-07-18 at 19:56 +0800, Wang Hai wrote:
> Fix sparse build warning:
> 
> drivers/net/ethernet/amazon/ena/ena_netdev.c:2193:34: warning:
>  Using plain integer as NULL pointer

Better to remove the initialization altogether and
move the declaration into the loop.

> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
[]
> @@ -2190,7 +2190,7 @@ static void ena_del_napi_in_range(struct ena_adapter *adapter,
>  static void ena_init_napi_in_range(struct ena_adapter *adapter,
>  				   int first_index, int count)
>  {
> -	struct ena_napi *napi = {0};
> +	struct ena_napi *napi = NULL;
>  	int i;
>  
>  	for (i = first_index; i < first_index + count; i++) {

---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 91be3ffa1c5c..470d8f38b824 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -2190,11 +2190,10 @@ static void ena_del_napi_in_range(struct ena_adapter *adapter,
 static void ena_init_napi_in_range(struct ena_adapter *adapter,
 				   int first_index, int count)
 {
-	struct ena_napi *napi = {0};
 	int i;
 
 	for (i = first_index; i < first_index + count; i++) {
-		napi = &adapter->ena_napi[i];
+		struct ena_napi *napi = &adapter->ena_napi[i];
 
 		netif_napi_add(adapter->netdev,
 			       &adapter->ena_napi[i].napi,


