Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC5B12EA9A
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 20:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbgABTqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 14:46:06 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39460 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727951AbgABTqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 14:46:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 002Jcvap176115;
        Thu, 2 Jan 2020 19:46:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=6NF7vpBBfSCBtU1E/fMQ1my7x60489UM466rqvhwlBY=;
 b=N8Tjag0VMJPK8Ycw7rqob6JRF7WdnAeW3NIaL493kG2vX9I11WOmEblYV8N1tRtHH75Q
 M4K6AE+M9lrBURbikVAGuUdibthiaV+p7nk7Yn2qj64k/eQaLt7kGIZUgms9lnA+eb0m
 MPuAt7m/Rsx9BVchx2iynNnGNhsnVFzRY+Ck2WRrK/jwE9J0MCOEbmBg19f1RsrqKtrc
 w0c1mhoU1BIH0IbV6XP8hhhvzigs4eaDz9svNktQ/8L967BvnzJ/sNNsDb5kva4irvx+
 fEP7l37YpGZ3bOhDr0wHlJy/E7bSHrYaxU+WWLXPOqZOHNQEInpEthu/AdEWaEfCiSqS Fg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2x5y0ps3cm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jan 2020 19:46:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 002JdSYi125390;
        Thu, 2 Jan 2020 19:46:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2x8gjay6dp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jan 2020 19:46:00 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 002JjvsW022618;
        Thu, 2 Jan 2020 19:45:57 GMT
Received: from [192.168.14.112] (/79.178.220.19)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jan 2020 11:45:57 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] net: mlx5: Use writeX() to ring doorbell and remove
 reduntant wmb()
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20200102192934.GH9282@ziepe.ca>
Date:   Thu, 2 Jan 2020 21:45:52 +0200
Cc:     saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, eli@mellanox.com, tariqt@mellanox.com,
        danielm@mellanox.com,
        =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <6524AE07-2ED7-41B5-B761-9F6BE8D2049B@oracle.com>
References: <20200102174436.66329-1-liran.alon@oracle.com>
 <20200102192934.GH9282@ziepe.ca>
To:     Jason Gunthorpe <jgg@ziepe.ca>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001020157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001020157
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 2 Jan 2020, at 21:29, Jason Gunthorpe <jgg@ziepe.ca> wrote:
>=20
> On Thu, Jan 02, 2020 at 07:44:36PM +0200, Liran Alon wrote:
>> Currently, mlx5e_notify_hw() executes wmb() to complete writes to =
cache-coherent
>> memory before ringing doorbell. Doorbell is written to by =
mlx5_write64()
>> which use __raw_writeX().
>>=20
>> This is semantically correct but executes reduntant wmb() in some =
architectures.
>> For example, in x86, a write to UC memory guarantees that any =
previous write to
>> WB memory will be globally visible before the write to UC memory. =
Therefore, there
>> is no need to also execute wmb() before write to doorbell which is =
mapped as UC memory.
>>=20
>> The consideration regarding this between different architectures is =
handled
>> properly by the writeX() macro. Which is defined differently for =
different
>> architectures. E.g. On x86, it is just a memory write. However, on =
ARM, it
>> is defined as __iowmb() folowed by a memory write. __iowmb() is =
defined
>> as wmb().
>=20
> This reasoning seems correct, though I would recommend directly
> refering to locking/memory-barriers.txt which explains this.

I find memory-barriers.txt not explicit enough on the semantics of =
writeX().
(For example: Should it flush write-combined buffers before writing to =
the UC memory?)
That=E2=80=99s why I preferred to explicitly state here how I perceive =
it.

But I don=E2=80=99t mind of course adding a pointer to the =
memory-barriers.txt file.

>=20
>> Therefore, change mlx5_write64() to use writeX() and remove wmb() =
from
>> it's callers.
>=20
> Yes, wmb(); writel(); is always redundant

Well, unfortunately not=E2=80=A6
See: https://marc.info/?l=3Dlinux-netdev&m=3D157798859215697&w=3D2
(See my suggestion to add flush_wc_writeX())

>=20
>> diff --git a/include/linux/mlx5/cq.h b/include/linux/mlx5/cq.h
>> index 40748fc1b11b..28744a725e64 100644
>> +++ b/include/linux/mlx5/cq.h
>> @@ -162,11 +162,6 @@ static inline void mlx5_cq_arm(struct =
mlx5_core_cq *cq, u32 cmd,
>>=20
>> 	*cq->arm_db =3D cpu_to_be32(sn << 28 | cmd | ci);
>>=20
>> -	/* Make sure that the doorbell record in host memory is
>> -	 * written before ringing the doorbell via PCI MMIO.
>> -	 */
>> -	wmb();
>> -
>=20
> Why did this one change? The doorbell memory here is not a writel():

Well, it=E2=80=99s not seen in the diff but actually the full code is:

    /* Make sure that the doorbell record in host memory is
     * written before ringing the doorbell via PCI MMIO.
     */
    wmb();

    doorbell[0] =3D cpu_to_be32(sn << 28 | cmd | ci);
    doorbell[1] =3D cpu_to_be32(cq->cqn);

    mlx5_write64(doorbell, uar_page + MLX5_CQ_DOORBELL);

i.e. doorbell is not the write to the doorbell itself. It=E2=80=99s =
still done via mlx5_write64().

>=20
>> 	doorbell[0] =3D cpu_to_be32(sn << 28 | cmd | ci);
>> 	doorbell[1] =3D cpu_to_be32(cq->cqn);
>=20
>> static inline void mlx5_write64(__be32 val[2], void __iomem *dest)
>> {
>> #if BITS_PER_LONG =3D=3D 64
>> -	__raw_writeq(*(u64 *)val, dest);
>> +	writeq(*(u64 *)val, dest);
>=20
> I want to say this might cause problems with endian swapping as writeq
> also does some swaps that __raw does not? Is this true?

Hmm... Looking at ARM64 version, writeq() indeed calls cpu_to_le64() on =
parameter before passing it to __raw_writeq().
Quite surprising from API perspective to be honest.

So should I change this instead to iowrite64be(*(u64 *)val, dest)?

-Liran

>=20
> ie writeq does not accept a be32
>=20
> Some time ago I reworked this similar code in userspace to use a u64
> and remove the swapping from the caller.
>=20
> Jason

