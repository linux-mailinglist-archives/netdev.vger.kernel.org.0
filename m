Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 949C718FB8C
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 18:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgCWRem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 13:34:42 -0400
Received: from smtprelay0022.hostedemail.com ([216.40.44.22]:33532 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726984AbgCWRem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 13:34:42 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 0BABA180984B5;
        Mon, 23 Mar 2020 17:34:41 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3866:3868:3871:3872:4321:5007:7576:7901:9036:10004:10400:10848:11026:11232:11658:11914:12043:12297:12438:12740:12760:12895:13069:13311:13357:13439:14181:14659:14721:21080:21627:21990:30012:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: thumb83_800e47564c30b
X-Filterd-Recvd-Size: 2322
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf19.hostedemail.com (Postfix) with ESMTPA;
        Mon, 23 Mar 2020 17:34:39 +0000 (UTC)
Message-ID: <df5c9ad7a5684e3ee0998559aebd9755cf70ee96.camel@perches.com>
Subject: Re: [PATCH net-next 13/17] net: atlantic: MACSec ingress offload HW
 bindings
From:   Joe Perches <joe@perches.com>
To:     Igor Russkikh <irusskikh@marvell.com>, netdev@vger.kernel.org
Cc:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Date:   Mon, 23 Mar 2020 10:32:50 -0700
In-Reply-To: <20200323131348.340-14-irusskikh@marvell.com>
References: <20200323131348.340-1-irusskikh@marvell.com>
         <20200323131348.340-14-irusskikh@marvell.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-03-23 at 16:13 +0300, Igor Russkikh wrote:
> From: Mark Starovoytov <mstarovoitov@marvell.com>
[]
> +static int
> +set_ingress_prectlf_record(struct aq_hw_s *hw,
> +			   const struct aq_mss_ingress_prectlf_record *rec,
> +			   u16 table_index)
> +{
> +	u16 packed_record[6];
> +
> +	if (table_index >= NUMROWS_INGRESSPRECTLFRECORD)
> +		return -EINVAL;
> +
> +	memset(packed_record, 0, sizeof(u16) * 6);
> +
> +	packed_record[0] = (packed_record[0] & 0x0000) |
> +			   (((rec->sa_da[0] >> 0) & 0xFFFF) << 0);
> +	packed_record[1] = (packed_record[1] & 0x0000) |
> +			   (((rec->sa_da[0] >> 16) & 0xFFFF) << 0);
> +	packed_record[2] = (packed_record[2] & 0x0000) |
> +			   (((rec->sa_da[1] >> 0) & 0xFFFF) << 0);
> +	packed_record[3] = (packed_record[3] & 0x0000) |
> +			   (((rec->eth_type >> 0) & 0xFFFF) << 0);
> +	packed_record[4] = (packed_record[4] & 0x0000) |
> +			   (((rec->match_mask >> 0) & 0xFFFF) << 0);
> +	packed_record[5] = (packed_record[5] & 0xFFF0) |
> +			   (((rec->match_type >> 0) & 0xF) << 0);
> +	packed_record[5] =
> +		(packed_record[5] & 0xFFEF) | (((rec->action >> 0) & 0x1) << 4);

This sort of code is not very readable.

Using val & 0x0000 is silly.

Using >> 0 and << 0 is pretty useless.

Masking a u16 with 0xffff is also pretty useless.

It seems a lot of this patch does this unnecessarily.


