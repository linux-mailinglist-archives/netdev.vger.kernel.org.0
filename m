Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68E73E5DF5
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 17:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbfJZPoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 11:44:54 -0400
Received: from smtprelay0241.hostedemail.com ([216.40.44.241]:48922 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726162AbfJZPoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 11:44:54 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id A39D8181D341E;
        Sat, 26 Oct 2019 15:44:52 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:6119:7903:10004:10400:10848:11026:11232:11657:11658:11914:12043:12048:12296:12297:12740:12760:12895:13069:13311:13357:13439:14659:14721:21080:21627:30054:30091,0,RBL:47.151.135.224:@perches.com:.lbl8.mailshell.net-62.14.0.100 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:24,LUA_SUMMARY:none
X-HE-Tag: cakes35_6487dd8c3ac06
X-Filterd-Recvd-Size: 1961
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf02.hostedemail.com (Postfix) with ESMTPA;
        Sat, 26 Oct 2019 15:44:50 +0000 (UTC)
Message-ID: <cfde329c7ee3c9bb5610bd9b040f95214cc4d9e8.camel@perches.com>
Subject: Re: [PATCH] net: hisilicon: Fix ping latency when deal with high
 throughput
From:   Joe Perches <joe@perches.com>
To:     Jiangfeng Xiao <xiaojiangfeng@huawei.com>, davem@davemloft.net,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        leeyou.li@huawei.com, zhanghan23@huawei.com, nixiaoming@huawei.com,
        zhangqiang.cn@hisilicon.com, dingjingcheng@hisilicon.com
Date:   Sat, 26 Oct 2019 08:44:47 -0700
In-Reply-To: <1572079779-76449-1-git-send-email-xiaojiangfeng@huawei.com>
References: <1572079779-76449-1-git-send-email-xiaojiangfeng@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2019-10-26 at 16:49 +0800, Jiangfeng Xiao wrote:
> This is due to error in over budget processing.
> When dealing with high throughput, the used buffers
> that exceeds the budget is not cleaned up. In addition,
> it takes a lot of cycles to clean up the used buffer,
> and then the buffer where the valid data is located can take effect.
[]
> diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
[]
> @@ -575,7 +575,7 @@ static int hip04_rx_poll(struct napi_struct *napi, int budget)
>  	struct hip04_priv *priv = container_of(napi, struct hip04_priv, napi);
>  	struct net_device *ndev = priv->ndev;
>  	struct net_device_stats *stats = &ndev->stats;
> -	unsigned int cnt = hip04_recv_cnt(priv);
> +	static unsigned int cnt_remaining;

static doesn't seem a great idea here as it's for just a single
driver instance.  Maybe make this part of struct hip04_priv?


