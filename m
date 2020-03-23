Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1B0818FC8A
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 19:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbgCWSTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 14:19:31 -0400
Received: from smtprelay0109.hostedemail.com ([216.40.44.109]:46896 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727149AbgCWSTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 14:19:31 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id C06C6183E603E;
        Mon, 23 Mar 2020 18:19:29 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:305:355:379:599:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:4250:4321:4384:5007:6119:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12296:12297:12438:12740:12760:12895:13019:13101:13439:14659:14721:21080:21627:21740:21966:21990:30054:30069:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: horn36_5245a80256a1d
X-Filterd-Recvd-Size: 3527
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf08.hostedemail.com (Postfix) with ESMTPA;
        Mon, 23 Mar 2020 18:19:25 +0000 (UTC)
Message-ID: <4150e0930415966768ca2fa4621194e475c25235.camel@perches.com>
Subject: Re: [PATCH net-next 14/17] net: atlantic: MACSec ingress offload
 implementation
From:   Joe Perches <joe@perches.com>
To:     Igor Russkikh <irusskikh@marvell.com>, netdev@vger.kernel.org
Cc:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Date:   Mon, 23 Mar 2020 11:17:34 -0700
In-Reply-To: <20200323131348.340-15-irusskikh@marvell.com>
References: <20200323131348.340-1-irusskikh@marvell.com>
         <20200323131348.340-15-irusskikh@marvell.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-03-23 at 16:13 +0300, Igor Russkikh wrote:
> This patch adds support for MACSec ingress HW offloading on Atlantic
> network cards.

Just random notes, I haven't looked at much of the patch set.

> diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
[]
> +static int aq_rxsc_validate_frames(const enum macsec_validation_type validate)
> +{
> +	switch (validate) {
> +	case MACSEC_VALIDATE_DISABLED:
> +		return 2;
> +	case MACSEC_VALIDATE_CHECK:
> +		return 1;
> +	case MACSEC_VALIDATE_STRICT:
> +		return 0;
> +	default:
> +		break;
> +	}
> +
> +	/* should never be here */
> +	WARN_ON(true);

If this is ever reached at all, this should likely
be a WARN_ONCE to avoid log spam.

> +	return 0;
> +}
> +
> +static int aq_set_rxsc(struct aq_nic_s *nic, const u32 rxsc_idx)
> +{
> +	const struct aq_macsec_rxsc *aq_rxsc =
> +		&nic->macsec_cfg->aq_rxsc[rxsc_idx];
> +	struct aq_mss_ingress_preclass_record pre_class_record;
> +	const struct macsec_rx_sc *rx_sc = aq_rxsc->sw_rxsc;
> +	const struct macsec_secy *secy = aq_rxsc->sw_secy;
> +	const u32 hw_sc_idx = aq_rxsc->hw_sc_idx;
> +	struct aq_mss_ingress_sc_record sc_record;
> +	struct aq_hw_s *hw = nic->aq_hw;
> +	__be64 nsci;
> +	int ret = 0;
> +
> +	netdev_dbg(nic->ndev,
> +		   "set rx_sc: rxsc_idx=%d, sci %#llx, hw_sc_idx=%d\n",

Could use __func__ or just remove as ftrace works.

> +		   rxsc_idx, rx_sc->sci, hw_sc_idx);
> +
> +	memset(&pre_class_record, 0, sizeof(pre_class_record));
> +	nsci = cpu_to_be64((__force u64)rx_sc->sci);
> +	memcpy(pre_class_record.sci, &nsci, sizeof(nsci));

put_unaligned_be64

> +	pre_class_record.sci_mask = 0xff;
> +	/* match all MACSEC ethertype packets */
> +	pre_class_record.eth_type = ETH_P_MACSEC;
> +	pre_class_record.eth_type_mask = 0x3;
> +
> +	aq_ether_addr_to_mac(pre_class_record.mac_sa, (char *)&rx_sc->sci);
> +	pre_class_record.sa_mask = 0x3f;
> +
> +	pre_class_record.an_mask = nic->macsec_cfg->sc_sa;
> +	pre_class_record.sc_idx = hw_sc_idx;
> +	/* strip SecTAG & forward for decryption */
> +	pre_class_record.action = 0x0;
> +	pre_class_record.valid = 1;
> +
> +	ret = aq_mss_set_ingress_preclass_record(hw, &pre_class_record,
> +						 2 * rxsc_idx + 1);
> +	if (ret) {
> +		netdev_err(nic->ndev,
> +			"aq_mss_set_ingress_preclass_record failed with %d\n",
> +			ret);

Every return of this function emits netdev_err on error.

Why not put the err in the function itself and likely
use a ratelimit on it too?



