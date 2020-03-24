Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2741904CD
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 06:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgCXFQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 01:16:26 -0400
Received: from smtprelay0217.hostedemail.com ([216.40.44.217]:47668 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725827AbgCXFQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 01:16:26 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 2A8FE837F24A;
        Tue, 24 Mar 2020 05:16:26 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:2898:3138:3139:3140:3141:3142:3354:3622:3865:3868:3871:4321:4384:5007:6119:7576:7903:7904:8957:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12297:12438:12740:12760:12895:13161:13229:13255:13439:14181:14659:14721:21080:21451:21627:21740:30054:30070:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: lace11_8f595a181f32c
X-Filterd-Recvd-Size: 4328
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf09.hostedemail.com (Postfix) with ESMTPA;
        Tue, 24 Mar 2020 05:16:24 +0000 (UTC)
Message-ID: <7dc08daf1e56de6d56fdfe711eeffa9f9bb9ace7.camel@perches.com>
Subject: Re: [PATCH net-next 16/17] net: atlantic: MACSec offload statistics
 implementation
From:   Joe Perches <joe@perches.com>
To:     Igor Russkikh <irusskikh@marvell.com>, netdev@vger.kernel.org
Cc:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Date:   Mon, 23 Mar 2020 22:14:35 -0700
In-Reply-To: <20200323131348.340-17-irusskikh@marvell.com>
References: <20200323131348.340-1-irusskikh@marvell.com>
         <20200323131348.340-17-irusskikh@marvell.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-03-23 at 16:13 +0300, Igor Russkikh wrote:
> From: Dmitry Bogdanov <dbogdanov@marvell.com>
> 
> This patch adds support for MACSec statistics on Atlantic network cards.

trivia:

> diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
[]
> @@ -96,6 +97,62 @@ static const char aq_ethtool_queue_stat_names[][ETH_GSTRING_LEN] = {
>  	"Queue[%d] InErrors",
>  };
[]
> +static const char aq_macsec_txsc_stat_names[][ETH_GSTRING_LEN + 1] = {
> +	"MACSecTXSC%d ProtectedPkts\0",
> +	"MACSecTXSC%d EncryptedPkts\0",
> +	"MACSecTXSC%d ProtectedOctets\0",
> +	"MACSecTXSC%d EncryptedOctets\0",
> +};
> +
> +static const char aq_macsec_txsa_stat_names[][ETH_GSTRING_LEN + 1] = {
> +	"MACSecTXSC%dSA%d HitDropRedirect\0",
> +	"MACSecTXSC%dSA%d Protected2Pkts\0",
> +	"MACSecTXSC%dSA%d ProtectedPkts\0",
> +	"MACSecTXSC%dSA%d EncryptedPkts\0",
> +};
> +
> +static const char aq_macsec_rxsa_stat_names[][ETH_GSTRING_LEN + 1] = {
> +	"MACSecRXSC%dSA%d UntaggedHitPkts\0",
> +	"MACSecRXSC%dSA%d CtrlHitDrpRedir\0",
> +	"MACSecRXSC%dSA%d NotUsingSa\0",
> +	"MACSecRXSC%dSA%d UnusedSa\0",
> +	"MACSecRXSC%dSA%d NotValidPkts\0",
> +	"MACSecRXSC%dSA%d InvalidPkts\0",
> +	"MACSecRXSC%dSA%d OkPkts\0",
> +	"MACSecRXSC%dSA%d LatePkts\0",
> +	"MACSecRXSC%dSA%d DelayedPkts\0",
> +	"MACSecRXSC%dSA%d UncheckedPkts\0",
> +	"MACSecRXSC%dSA%d ValidatedOctets\0",
> +	"MACSecRXSC%dSA%d DecryptedOctets\0",
> +};

The terminating \0 is odd and aren't these used only
for format strings?

If so, why are these [][ETH_GSTRING_LEN + 1] and not
static const char * [] ?

[]

> +#if IS_ENABLED(CONFIG_MACSEC)
> +		if (!aq_nic->macsec_cfg)
> +			break;
> +
> +		memcpy(p, aq_macsec_stat_names, sizeof(aq_macsec_stat_names));
> +		p = p + sizeof(aq_macsec_stat_names);
> +		for (i = 0; i < AQ_MACSEC_MAX_SC; i++) {
> +			struct aq_macsec_txsc *aq_txsc;
> +
> +			if (!(test_bit(i, &aq_nic->macsec_cfg->txsc_idx_busy)))
> +				continue;
> +
> +			for (si = 0;
> +				si < ARRAY_SIZE(aq_macsec_txsc_stat_names);
> +				si++) {
> +				snprintf(p, ETH_GSTRING_LEN,
> +					 aq_macsec_txsc_stat_names[si], i);

Used as format string, etc...

> +				p += ETH_GSTRING_LEN;
> +			}
> +			aq_txsc = &aq_nic->macsec_cfg->aq_txsc[i];
> +			for (sa = 0; sa < MACSEC_NUM_AN; sa++) {
> +				if (!(test_bit(sa, &aq_txsc->tx_sa_idx_busy)))
> +					continue;
> +				for (si = 0;
> +				     si < ARRAY_SIZE(aq_macsec_txsa_stat_names);
> +				     si++) {
> +					snprintf(p, ETH_GSTRING_LEN,
> +						 aq_macsec_txsa_stat_names[si],
> +						 i, sa);
> +					p += ETH_GSTRING_LEN;
> +				}
> +			}
> +		}
> +		for (i = 0; i < AQ_MACSEC_MAX_SC; i++) {
> +			struct aq_macsec_rxsc *aq_rxsc;
> +
> +			if (!(test_bit(i, &aq_nic->macsec_cfg->rxsc_idx_busy)))
> +				continue;
> +
> +			aq_rxsc = &aq_nic->macsec_cfg->aq_rxsc[i];
> +			for (sa = 0; sa < MACSEC_NUM_AN; sa++) {
> +				if (!(test_bit(sa, &aq_rxsc->rx_sa_idx_busy)))
> +					continue;
> +				for (si = 0;
> +				     si < ARRAY_SIZE(aq_macsec_rxsa_stat_names);
> +				     si++) {
> +					snprintf(p, ETH_GSTRING_LEN,
> +						 aq_macsec_rxsa_stat_names[si],
> +						 i, sa);
> +					p += ETH_GSTRING_LEN;
> +				}
> +			}
> +		}
> +#endif

etc...


