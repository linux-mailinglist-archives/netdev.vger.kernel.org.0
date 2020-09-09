Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5DD0262BE6
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 11:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbgIIJdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 05:33:55 -0400
Received: from smtprelay0068.hostedemail.com ([216.40.44.68]:57658 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725826AbgIIJdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 05:33:53 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 7218F182CED34;
        Wed,  9 Sep 2020 09:33:52 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:3868:3873:4321:5007:6742:8603:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12296:12297:12438:12740:12760:12895:13019:13069:13311:13357:13439:14659:14721:21080:21524:21627:21990:30012:30054:30055:30056:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: floor94_611501d270dc
X-Filterd-Recvd-Size: 2099
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf20.hostedemail.com (Postfix) with ESMTPA;
        Wed,  9 Sep 2020 09:33:49 +0000 (UTC)
Message-ID: <2530c5c8a596b7edd7e2273cffc3b76ac4b437c7.camel@perches.com>
Subject: Re: [net-next] net: iavf: Use the ARRAY_SIZE macro for aq_to_posix
From:   Joe Perches <joe@perches.com>
To:     Wei Xu <xuwei5@hisilicon.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, linuxarm@huawei.com,
        shameerali.kolothum.thodi@huawei.com, jonathan.cameron@huawei.com,
        john.garry@huawei.com, salil.mehta@huawei.com,
        shiju.jose@huawei.com, jinying@hisilicon.com,
        zhangyi.ac@huawei.com, liguozhu@hisilicon.com,
        tangkunshan@huawei.com, huangdaode@hisilicon.com,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org
Date:   Wed, 09 Sep 2020 02:33:48 -0700
In-Reply-To: <1599641471-204919-1-git-send-email-xuwei5@hisilicon.com>
References: <1599641471-204919-1-git-send-email-xuwei5@hisilicon.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-09-09 at 16:51 +0800, Wei Xu wrote:
> Use the ARRAY_SIZE macro to calculate the size of an array.
> This code was detected with the help of Coccinelle.
[]
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_adminq.h b/drivers/net/ethernet/intel/iavf/iavf_adminq.h
[]
> @@ -120,7 +120,7 @@ static inline int iavf_aq_rc_to_posix(int aq_ret, int aq_rc)
>  	if (aq_ret == IAVF_ERR_ADMIN_QUEUE_TIMEOUT)
>  		return -EAGAIN;
>  
> -	if (!((u32)aq_rc < (sizeof(aq_to_posix) / sizeof((aq_to_posix)[0]))))
> +	if (!((u32)aq_rc < ARRAY_SIZE(aq_to_posix)))
>  		return -ERANGE;

If you want to use a cast,

	if ((u32)aq_rc >= ARRAY_SIZE(aq_to_posix))
		return -ERANGE;

would be a more common and simpler style, though
perhaps testing ac_rc < 0 would be more intelligible.

	if (ac_rc < 0 || ac_rq >= ARRAY_SIZE(aq_to_posix))
		return -ERANGE;



