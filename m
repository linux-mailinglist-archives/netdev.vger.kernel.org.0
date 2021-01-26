Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA86304CFB
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 00:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731322AbhAZXAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:00:32 -0500
Received: from smtprelay0161.hostedemail.com ([216.40.44.161]:46970 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727782AbhAZREe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 12:04:34 -0500
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave01.hostedemail.com (Postfix) with ESMTP id A67621803DDAB;
        Tue, 26 Jan 2021 16:46:57 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id E64DE180A90FF;
        Tue, 26 Jan 2021 16:46:55 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2911:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:4321:4425:5007:7652:10004:10400:11232:11473:11657:11658:11914:12043:12297:12555:12740:12895:13069:13311:13357:13439:13894:14659:14721:21080:21324:21451:21627:30012:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: burn65_26005d02758f
X-Filterd-Recvd-Size: 2031
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf05.hostedemail.com (Postfix) with ESMTPA;
        Tue, 26 Jan 2021 16:46:54 +0000 (UTC)
Message-ID: <7d113851044ad16fa7f4c4e5c32af723e2f3c359.camel@perches.com>
Subject: Re: [PATCH v3] rtlwifi: Simplify bool comparison
From:   Joe Perches <joe@perches.com>
To:     Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>,
        kvalo@codeaurora.org
Cc:     pkshih@realtek.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 26 Jan 2021 08:46:53 -0800
In-Reply-To: <1611649916-21936-1-git-send-email-abaci-bugfix@linux.alibaba.com>
References: <1611649916-21936-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-01-26 at 16:31 +0800, Jiapeng Zhong wrote:
> Fix the following coccicheck warning:
> ./drivers/net/wireless/realtek/rtlwifi/ps.c:798:7-21: WARNING:
> Comparison to bool
> ./drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:3848:7-17:
> WARNING: Comparison of 0/1 to bool variable
[]
> diff --git a/drivers/net/wireless/realtek/rtlwifi/ps.c b/drivers/net/wireless/realtek/rtlwifi/ps.c
[]
> @@ -798,9 +798,9 @@ static void rtl_p2p_noa_ie(struct ieee80211_hw *hw, void *data,
>  		ie += 3 + noa_len;
>  	}
>  
> 
> -	if (find_p2p_ie == true) {
> +	if (find_p2p_ie) {
>  		if ((p2pinfo->p2p_ps_mode > P2P_PS_NONE) &&
> -		    (find_p2p_ps_ie == false))
> +		    (!find_p2p_ps_ie))
>  			rtl_p2p_ps_cmd(hw, P2P_PS_DISABLE);
>  	}

Always review suggested coccinelle patches before submission and
see if there are ways to improve the code beyond what the spatch
tool suggests.

Perhaps integrate these tests and removed an indent level too:

	if (find_p2p_ie && !find_p2p_ps_ie &&
	    p2pinfo->p2p_ps_mode > P2P_PS_NONE)
		rtl_p2p_ps_cmd(hw, P2P_PS_DISABLE);


