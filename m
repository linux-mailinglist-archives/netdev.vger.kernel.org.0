Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350CA43FFF2
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 17:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbhJ2P7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 11:59:41 -0400
Received: from mx0a-002e3701.pphosted.com ([148.163.147.86]:16992 "EHLO
        mx0a-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229607AbhJ2P7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 11:59:40 -0400
Received: from pps.filterd (m0150242.ppops.net [127.0.0.1])
        by mx0a-002e3701.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19TDvtvl012353;
        Fri, 29 Oct 2021 15:57:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pps0720; bh=PvtnFKUwoxC1d4Tl3mFsm0wWDs8NjpptC9T1LPJ7O6c=;
 b=pjDW8XJLK153nODLmWl7SKkzeYEivL/M+6txqnS5seY+3e8YKCPh5kFp9VHaQ1oA61OC
 8tIypMeJAazcex2gmro9ZyVCRQtAXVB9FfxbNqPcwwywcDSDJ7vZeQUIm93OGtXg3+RA
 YEU29NZ9cZ+wPNggJ/F+v3GHCUQSLsh92IT4kZREsVVGy37qCF3XeDRwdMiGaiBGMp86
 xWt/0R6p3Pm23Si+nHrydeII/GwCAZVKrISZMJm9ZhrsBQXbC/ASTCPO6rqa4mzm1FMI
 dktGemSous2DPIEcOrC3d9R5S82RtIrtcOmGRM4EWcnNpheo9q/s4wb/jTrrWCUQDHoh 2g== 
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
        by mx0a-002e3701.pphosted.com with ESMTP id 3c0ja5gw9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Oct 2021 15:57:02 +0000
Received: from g2t2360.austin.hpecorp.net (g2t2360.austin.hpecorp.net [16.196.225.135])
        by g2t2354.austin.hpe.com (Postfix) with ESMTP id 233DFB5;
        Fri, 29 Oct 2021 15:57:02 +0000 (UTC)
Received: from swahl-home.5wahls.com (unknown [16.99.162.214])
        by g2t2360.austin.hpecorp.net (Postfix) with ESMTP id 1F4093A;
        Fri, 29 Oct 2021 15:57:01 +0000 (UTC)
Date:   Fri, 29 Oct 2021 10:57:00 -0500
From:   Steve Wahl <steve.wahl@hpe.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, robinmholt@gmail.com,
        steve.wahl@hpe.com, mike.travis@hpe.com, arnd@arndb.de,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH net-next 1/3] net: sgi-xp: use eth_hw_addr_set()
Message-ID: <YXwZzBzmIFBMS0gO@swahl-home.5wahls.com>
References: <20211029024707.316066-1-kuba@kernel.org>
 <20211029024707.316066-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211029024707.316066-2-kuba@kernel.org>
X-Proofpoint-ORIG-GUID: 1urZH8uONtAlK2UscWZtZTFKsKu1JYQ_
X-Proofpoint-GUID: 1urZH8uONtAlK2UscWZtZTFKsKu1JYQ_
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-29_04,2021-10-29_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1011
 spamscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 mlxscore=0
 priorityscore=1501 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2110290091
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reveiwed-by: Steve Wahl <steve.wahl@hpe.com>

On Thu, Oct 28, 2021 at 07:47:05PM -0700, Jakub Kicinski wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it go through appropriate helpers.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: robinmholt@gmail.com
> CC: steve.wahl@hpe.com
> CC: mike.travis@hpe.com
> CC: arnd@arndb.de
> CC: gregkh@linuxfoundation.org
> ---
>  drivers/misc/sgi-xp/xpnet.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/misc/sgi-xp/xpnet.c b/drivers/misc/sgi-xp/xpnet.c
> index 2508f83bdc3f..dab7b92db790 100644
> --- a/drivers/misc/sgi-xp/xpnet.c
> +++ b/drivers/misc/sgi-xp/xpnet.c
> @@ -514,6 +514,7 @@ static const struct net_device_ops xpnet_netdev_ops = {
>  static int __init
>  xpnet_init(void)
>  {
> +	u8 addr[ETH_ALEN];
>  	int result;
>  
>  	if (!is_uv_system())
> @@ -545,15 +546,17 @@ xpnet_init(void)
>  	xpnet_device->min_mtu = XPNET_MIN_MTU;
>  	xpnet_device->max_mtu = XPNET_MAX_MTU;
>  
> +	memset(addr, 0, sizeof(addr));
>  	/*
>  	 * Multicast assumes the LSB of the first octet is set for multicast
>  	 * MAC addresses.  We chose the first octet of the MAC to be unlikely
>  	 * to collide with any vendor's officially issued MAC.
>  	 */
> -	xpnet_device->dev_addr[0] = 0x02;     /* locally administered, no OUI */
> +	addr[0] = 0x02;     /* locally administered, no OUI */
>  
> -	xpnet_device->dev_addr[XPNET_PARTID_OCTET + 1] = xp_partition_id;
> -	xpnet_device->dev_addr[XPNET_PARTID_OCTET + 0] = (xp_partition_id >> 8);
> +	addr[XPNET_PARTID_OCTET + 1] = xp_partition_id;
> +	addr[XPNET_PARTID_OCTET + 0] = (xp_partition_id >> 8);
> +	eth_hw_addr_set(xpnet_device, addr);
>  
>  	/*
>  	 * ether_setup() sets this to a multicast device.  We are
> -- 
> 2.31.1
> 

-- 
Steve Wahl, Hewlett Packard Enterprise
