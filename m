Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6462211EF
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 18:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgGOQGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 12:06:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33400 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgGOQGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 12:06:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FFlE3M035510;
        Wed, 15 Jul 2020 16:05:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=Ho0h/PXvKNz4buENJQeQYv8x5o54xLFUN6ZESVyWhjo=;
 b=A/Eaj5VOsDmdEKpvjnf/Ad8EhW0tXGtYkap9cQxzxnfTP5RCKlYtx943NImRisqEXxvq
 QYXNapoBkdIY9+SBnQGNgVaILPSxlEftfNfuI3vXpXvr3zNRXdpQZmk3uinn7wiCBImg
 MMZIFZ0+EOSu4GdZ0fT8jP1TA5n9p0CJBkmbNKkuZlt2U34BJJimc4bi9pcqboOGMcN2
 5dUv2PCJ9gsBoWWvVMFQYxvD/6No2A3EaSmMZrhsqtuIYWMQUA8L4q/Hpn0t8sVSczxH
 5K2GEtYKnj3y8EniLZcUUUjyDZmc3ybwmCNo/+2J5frLUAP008Xb3vC1zLZvPRvRWm6Y MA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3275cmcb1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 16:05:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FFlq5b114720;
        Wed, 15 Jul 2020 16:05:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 32a4cqt8vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 16:05:29 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06FG5Nal007365;
        Wed, 15 Jul 2020 16:05:23 GMT
Received: from anon-dhcp-152.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 09:05:21 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: xprtrdma: Prevent inline overflow
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <ac00f855-e67c-b3d5-2be8-a18b07fcc8f8@canonical.com>
Date:   Wed, 15 Jul 2020 12:05:19 -0400
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Bruce Fields <bfields@fieldses.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <239E2F87-E595-4132-B133-504EFF9103B8@oracle.com>
References: <ac00f855-e67c-b3d5-2be8-a18b07fcc8f8@canonical.com>
To:     Colin Ian King <colin.king@canonical.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 suspectscore=0 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1011 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150126
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 15, 2020, at 11:56 AM, Colin Ian King =
<colin.king@canonical.com> wrote:
>=20
> Hi,
>=20
> Static analysis with Coverity has found a potential issue with the
> header size calculations in source net/sunrpc/xprtrdma/rpc_rdma.c in
> functions rpcrdma_max_call_header_size and =
rpcrdma_max_reply_header_size.
>=20
> The commit in question is relatively old:
>=20
> commit 302d3deb20682a076e1ab551821cacfdc81c5e4f
> Author: Chuck Lever <chuck.lever@oracle.com>
> Date:   Mon May 2 14:41:05 2016 -0400
>=20
>    xprtrdma: Prevent inline overflow
>=20
> The two issues are as follows:
>=20
> Issue #1:
>=20
> 66 static unsigned int rpcrdma_max_call_header_size(unsigned int =
maxsegs)
> 67 {
> 68        unsigned int size;
> 69
> 70        /* Fixed header fields and list discriminators */
>=20
> Unused value (UNUSED_VALUE)
>=20
> 71        size =3D RPCRDMA_HDRLEN_MIN;
> 72
> 73        /* Maximum Read list size */
> 74        size =3D maxsegs * rpcrdma_readchunk_maxsz * sizeof(__be32);
> 75
>=20
> should the size assignment on line 74 be instead:
>=20
> 	size +=3D maxsegs * rpcrdma_readchunk_maxsz * sizeof(__be32);
>=20
>=20
> Issue #2:
>=20
> 89 static unsigned int rpcrdma_max_reply_header_size(unsigned int =
maxsegs)
> 90 {
> 91        unsigned int size;
> 92
> 93        /* Fixed header fields and list discriminators */
>=20
> Unused value (UNUSED_VALUE)
>=20
> 94        size =3D RPCRDMA_HDRLEN_MIN;
> 95
> 96        /* Maximum Write list size */
> 97        size =3D sizeof(__be32);          /* segment count */
>=20
> should the size assignment in line 97 be instead:
>=20
> 	size +=3D sizeof(__be32)?

Colin, Yes to both questions. Can you send a fix to Anna?

--
Chuck Lever



