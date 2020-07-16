Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1D0221FFF
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 11:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgGPJq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 05:46:58 -0400
Received: from smtprelay0186.hostedemail.com ([216.40.44.186]:39450 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726105AbgGPJq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 05:46:58 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 3F00D837F24D;
        Thu, 16 Jul 2020 09:46:57 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:2904:3138:3139:3140:3141:3142:3622:3865:3871:4321:5007:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12048:12114:12296:12297:12438:12740:12760:12895:13069:13311:13357:13439:14659:14721:21080:21451:21627:30046:30054:30070:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: mind98_58102b926f01
X-Filterd-Recvd-Size: 1571
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf03.hostedemail.com (Postfix) with ESMTPA;
        Thu, 16 Jul 2020 09:46:55 +0000 (UTC)
Message-ID: <687734b1623965b154752252968adeca35740c88.camel@perches.com>
Subject: Re: [PATCH] net: neterion: vxge: reduce stack usage in
 VXGE_COMPLETE_VPATH_TX
From:   Joe Perches <joe@perches.com>
To:     Bixuan Cui <cuibixuan@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, linux-next@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jdmason@kudzu.us, christophe.jaillet@wanadoo.fr,
        john.wanghui@huawei.com
Date:   Thu, 16 Jul 2020 02:46:54 -0700
In-Reply-To: <20200716173247.78912-1-cuibixuan@huawei.com>
References: <20200716173247.78912-1-cuibixuan@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-07-16 at 17:32 +0000, Bixuan Cui wrote:
> Fix the warning: [-Werror=-Wframe-larger-than=]
[]
> diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
[]
> @@ -100,8 +100,14 @@ static inline void VXGE_COMPLETE_VPATH_TX(struct vxge_fifo *fifo)
>  	struct sk_buff **temp;
>  #define NR_SKB_COMPLETED 128
>  	struct sk_buff *completed[NR_SKB_COMPLETED];
> +	struct sk_buff **completed;
>  	int more;
> 
> +	completed = kcalloc(NR_SKB_COMPLETED, sizeof(*completed),
> +			    GFP_KERNEL);

I doubt this is a good idea.
Check the callers interrupt status.


