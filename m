Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F7B221281
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 18:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgGOQkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 12:40:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42748 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbgGOQkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 12:40:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FGSbYv028465;
        Wed, 15 Jul 2020 16:39:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=k5zSAo+DYmjFyDq68+jvxd9Dt4r7usycofHJ4FxGsj0=;
 b=iJ+X+zEEPIgVZc2AkcyIn43zzb23xgQjntkuFE0A0WoQvjZhL+rjDVz81aSqYF/8Bm0L
 KQWUZ6SnInwMQT3gxrANrGXjhG/wlq2vQbj7yV4Re4MGYihN+IQ9Uykn2venSiByOgPY
 CXgpAoBTwoamCDXTbdgi/tVYMC/IGHXiWKQhgkyUPjAoAfjBrW688jgrUOYffIkxeIJW
 s+o1AHbpZeogNaXAmn791ynPZXzvRmDUmbzwZpy58Ajq9woy64GzOBTW1Pyy1VzEZjVv
 ctL/8gp532Re6au6ejWLvmXv1WJd9wLCXSlD47pmsQYzrONiBuvAzJED5HqiSwTO+NHn Ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3274urcjsw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 16:39:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FGNdxH046871;
        Wed, 15 Jul 2020 16:39:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 327qb847t5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 16:39:54 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06FGdlwv006212;
        Wed, 15 Jul 2020 16:39:47 GMT
Received: from anon-dhcp-152.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 09:39:47 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] xprtrdma: fix incorrect header size calcations
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <eb5d2ead-807b-3435-5024-b8cc4a1311f3@canonical.com>
Date:   Wed, 15 Jul 2020 12:39:46 -0400
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Bruce Fields <bfields@fieldses.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <20DD16C5-2A91-4B3A-9879-D381EE40AF1A@oracle.com>
References: <20200715162604.1080552-1-colin.king@canonical.com>
 <eb5d2ead-807b-3435-5024-b8cc4a1311f3@canonical.com>
To:     Colin Ian King <colin.king@canonical.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007150129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150129
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 15, 2020, at 12:31 PM, Colin Ian King =
<colin.king@canonical.com> wrote:
>=20
> Bah, $SUBJECT typo "calcations" -> "calculations". can that be fixed =
up
> when it's applied, or shall I send a V2?

Anna's preference.

Reviewed-by: Chuck Lever <chuck.lever@oracle.com>


> On 15/07/2020 17:26, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>=20
>> Currently the header size calculations are using an assignment
>> operator instead of a +=3D operator when accumulating the header
>> size leading to incorrect sizes.  Fix this by using the correct
>> operator.
>>=20
>> Addresses-Coverity: ("Unused value")
>> Fixes: 302d3deb2068 ("xprtrdma: Prevent inline overflow")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>> net/sunrpc/xprtrdma/rpc_rdma.c | 4 ++--
>> 1 file changed, 2 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c =
b/net/sunrpc/xprtrdma/rpc_rdma.c
>> index 935bbef2f7be..453bacc99907 100644
>> --- a/net/sunrpc/xprtrdma/rpc_rdma.c
>> +++ b/net/sunrpc/xprtrdma/rpc_rdma.c
>> @@ -71,7 +71,7 @@ static unsigned int =
rpcrdma_max_call_header_size(unsigned int maxsegs)
>> 	size =3D RPCRDMA_HDRLEN_MIN;
>>=20
>> 	/* Maximum Read list size */
>> -	size =3D maxsegs * rpcrdma_readchunk_maxsz * sizeof(__be32);
>> +	size +=3D maxsegs * rpcrdma_readchunk_maxsz * sizeof(__be32);
>>=20
>> 	/* Minimal Read chunk size */
>> 	size +=3D sizeof(__be32);	/* segment count */
>> @@ -94,7 +94,7 @@ static unsigned int =
rpcrdma_max_reply_header_size(unsigned int maxsegs)
>> 	size =3D RPCRDMA_HDRLEN_MIN;
>>=20
>> 	/* Maximum Write list size */
>> -	size =3D sizeof(__be32);		/* segment count */
>> +	size +=3D sizeof(__be32);		/* segment count */
>> 	size +=3D maxsegs * rpcrdma_segment_maxsz * sizeof(__be32);
>> 	size +=3D sizeof(__be32);	/* list discriminator */
>>=20
>>=20
>=20

--
Chuck Lever



