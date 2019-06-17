Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF83648856
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 18:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbfFQQGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 12:06:40 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34394 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfFQQGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 12:06:40 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5HG3OZS060045;
        Mon, 17 Jun 2019 16:06:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=MwKsbM5LDpPZOa0hosVEj1C2BYiLDVw8p7q7vlNExhs=;
 b=C+f+q17L+QwliOrIbbe5MDJsgAPz883cBN/PN6naOCGa/LJzDvyHlWKTnJL5LE6EUqnp
 1z/vg0XAAt/lX643kC4VJ/MXPmo30wPgCY1+kTP1mhTZIVqVwyzwtTEOrzOXfO/jaVU0
 xl6IfIL4vev5ZIEL+ydL5PDpQrkkXDecFQkejtmj1B3DcYoNFFxBRpj37eS8EMVvPAz4
 jewb8o+mhCq46VaaNNpRz21iHYTYsT/p+/sBAEDhNfx43asEJzODwYtjgiIywYn/nc/n
 5hiTGTmpaoZvLuQpnKCLcx/9IpEFLCwE3F17nZjpvA0AKPpQ20ggKlLemYcF/nhmkkra gQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2t4saq7dgq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jun 2019 16:06:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5HG56Xo098370;
        Mon, 17 Jun 2019 16:06:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2t5h5t7cvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jun 2019 16:06:24 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5HG6Lm4004432;
        Mon, 17 Jun 2019 16:06:21 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Jun 2019 16:06:20 +0000
Date:   Mon, 17 Jun 2019 19:06:09 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: lio_core: fix potential sign-extension overflow on
 large shift
Message-ID: <20190617160609.GH28859@kadam>
References: <20190617155325.27017-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617155325.27017-1-colin.king@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906170143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906170143
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 04:53:25PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Left shifting the signed int value 1 by 31 bits has undefined behaviour
> and the shift amount oq_no can be as much as 63.  Fix this by widening
> the int 1 to 1ULL.
> 
> Addresses-Coverity: ("Bad shift operation")
> Fixes: f21fb3ed364b ("Add support of Cavium Liquidio ethernet adapters")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/ethernet/cavium/liquidio/lio_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/cavium/liquidio/lio_core.c b/drivers/net/ethernet/cavium/liquidio/lio_core.c
> index 1c50c10b5a16..e78bdcee200f 100644
> --- a/drivers/net/ethernet/cavium/liquidio/lio_core.c
> +++ b/drivers/net/ethernet/cavium/liquidio/lio_core.c
> @@ -964,7 +964,7 @@ static void liquidio_schedule_droq_pkt_handlers(struct octeon_device *oct)
>  
>  			if (droq->ops.poll_mode) {
>  				droq->ops.napi_fn(droq);
> -				oct_priv->napi_mask |= (1 << oq_no);
> +				oct_priv->napi_mask |= (1ULL << oq_no);

The function uses BIT_ULL(oq_no) earlier, so we should probably do the
same here.

regards,
dan carpenter

