Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404E9327C5E
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 11:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbhCAKjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 05:39:24 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49344 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234327AbhCAKiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 05:38:05 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 121AYRqh036884;
        Mon, 1 Mar 2021 10:36:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ztTmG0D3FIVh6A0R5PDcmqcRq76aDK1lu61HlH53ZnI=;
 b=lfatlliHMA/tHZ+fZAwWYm7+Q+RKl3OUkW8pz9MYrYeE2/uMJIW9fx3R1S+WGYFVpuSx
 Qc71ygwcmtszA1nKc2tGC00CbfvA+MKx4qOCIoHM0++iKhQQ2QE3v6kDxppfXvuwcXRH
 +6UUnOtsrmTjGCNt8SCCkfozYJqM5H8ARaLkFUkWUeKN+qhjIAzBnp3eeu3UCvJA124K
 NJdzvn/Iw4Df9eQhS/ECXcxU4JLo996oTb7D5smHjFLM4PA7LHCtoNU0Z0v1Is7CqsnO
 QFB6mgeH/cMW0YuAHOG6BroMIGD11Hiz7qnw1iU4Mj6KEzjb/q5cd+Pvo36IYoDpaMb6 MQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 36ye1m39y6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Mar 2021 10:36:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 121AYruF100201;
        Mon, 1 Mar 2021 10:36:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 36yynmjavp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Mar 2021 10:36:45 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 121AaeS7011432;
        Mon, 1 Mar 2021 10:36:41 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Mar 2021 10:36:40 +0000
Date:   Mon, 1 Mar 2021 13:36:30 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Eran Ben Elisha <eranbe@nvidia.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, Aya Levin <ayal@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        "Pavel Machek (CIP)" <pavel@denx.de>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH mellanox-tree] net/mlx5: prevent an integer underflow in
 mlx5_perout_configure()
Message-ID: <20210301103630.GP2087@kadam>
References: <YC+LoAcvcQSWLLKX@mwanda>
 <e9beab47-4f32-4aa4-cdb6-6fa7402e55de@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9beab47-4f32-4aa4-cdb6-6fa7402e55de@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9909 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103010088
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9909 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 adultscore=0 malwarescore=0
 mlxscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103010088
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 01, 2021 at 12:12:34PM +0200, Eran Ben Elisha wrote:
> 
> 
> On 2/19/2021 11:57 AM, Dan Carpenter wrote:
> > The value of "sec" comes from the user.  Negative values will lead to
> > shift wrapping inside the perout_conf_real_time() function and triggger
> > a UBSan warning.
> > 
> > Add a check and return -EINVAL to prevent that from happening.
> > 
> > Fixes: 432119de33d9 ("net/mlx5: Add cyc2time HW translation mode support")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> > Saeed, I think this goes through your git tree and you will send a pull
> > request to the networking?
> > 
> >  From static analysis.  Not tested.
> > 
> >   drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
> > index b0e129d0f6d8..286824ca62b5 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
> > @@ -516,7 +516,7 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
> >   		nsec = rq->perout.start.nsec;
> >   		sec = rq->perout.start.sec;
> > -		if (rt_mode && sec > U32_MAX)
> 
> This if clause was set to reject perout time start sec bigger than U32_MAX,
> as rt mode specifically doesn't support it.
> 
> A user negative values protection should be generic for all netdev drivers,
> inside the caller ioctl func, and not part of any driver code.
> 

I'm not a networking expert...  :/  It's easier for me to see that this
code will trigger a syzbot splat vs saying that there is no valid use
case for negative seconds any driver.

What you're saying sounds reasonable enough to me, but I don't know
enough about networking to comment one way or the other.  Maybe the
other drivers have a use for negative seconds?

regards,
dan carpenter

> > +		if (rt_mode && (sec < 0 || sec > U32_MAX))
> >   			return -EINVAL;
> >   		time_stamp = rt_mode ? perout_conf_real_time(sec, nsec) :
> > 
