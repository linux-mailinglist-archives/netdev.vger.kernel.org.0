Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5672FCF05
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 12:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731054AbhATLQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 06:16:48 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:44450 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729711AbhATKqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 05:46:33 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10KAimT4100834;
        Wed, 20 Jan 2021 10:44:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=G282Gdj0Pbyc4y/rMCfFnp0SwX3hRjPRGRhhJATE6v8=;
 b=hy4iTVzxUsGzKNhv+B7GgVqHaIibPU7jQfFLOe1TUrQcOVc/32Ysw65F7GF3/E1zzrLx
 zBRLB8Bj0B5h91aMeViYLy+U+iSNLDp3SOMWW7/LZalSdjv4QfA+zuZ3cc0fR7KuBMn0
 vTULkrZRNUeOk2pI0Ae+2L/rraX3G2nimCQMn98lToJ/bgnfbRT6EZxHJ4X30qVbYFWA
 bn39DrS1VTXnFKz9I1Ok8jNxq5xePKvHJFjd6Q+ChxkhnITlcVgs3Fx1Y1UJmH/t8lU3
 0KT3C2CeiVrekM5hhkGVNfZ7bziTMTBzreM2FYYfCnSzd/AEy5S614h3cDUcozNMgn1v PA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 3668qr9v4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jan 2021 10:44:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10KAYffT085898;
        Wed, 20 Jan 2021 10:42:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3668qvxp5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jan 2021 10:42:55 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10KAgi0u005283;
        Wed, 20 Jan 2021 10:42:44 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Jan 2021 02:42:44 -0800
Date:   Wed, 20 Jan 2021 13:42:36 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Loris Fauster <loris.fauster@ttcontrol.com>,
        Alejandro Concepcion Rodriguez <alejandro@acoro.eu>
Subject: Re: [PATCH v3 1/3] can: dev: can_restart: fix use after free bug
Message-ID: <20210120104236.GF20820@kadam>
References: <20210120102443.198143-1-mailhol.vincent@wanadoo.fr>
 <20210120102443.198143-2-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120102443.198143-2-mailhol.vincent@wanadoo.fr>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101200061
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101200062
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 07:24:41PM +0900, Vincent Mailhol wrote:
> After calling netif_rx_ni(skb), dereferencing skb is unsafe.
> Especially, the can_frame cf which aliases skb memory is accessed
> after the netif_rx_ni() in:
>       stats->rx_bytes += cf->len;
> 
> Reordering the lines solves the issue.
> 
> *Remark for upstream*
> drivers/net/can/dev.c has been moved to drivers/net/can/dev/dev.c in
> below commit, please carry the patch forward.
> Reference: 3e77f70e7345 ("can: dev: move driver related infrastructure
> into separate subdir")

Put these sorts of comments under the --- so that they aren't included
in the permanent git log.

> 
> Fixes: 39549eef3587 ("can: CAN Network device driver and Netlink interface")
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> ---
  ^^^

comment below this line are removed from the git log.

>  drivers/net/can/dev.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

regards,
dan carpenter

