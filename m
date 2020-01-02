Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5192E12F085
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 23:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728977AbgABWVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 17:21:21 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51248 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728744AbgABWVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 17:21:19 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 002MEAv9098418;
        Thu, 2 Jan 2020 22:21:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=/pDeOFfBMlaJ6dkh/Gf2pA6ydbfzUxlRHjA2/TA8UxE=;
 b=U5CE7+66BYBkNuzfz5ICcKqNfCe7xBQsHXA9tBH+o9cOkgt11BId2ngtssfz1rgSsZ0M
 8TFMs5f9EH07LgTsBOmf9Pnjk9AeJN0f3HlUxrxdmZhbHB5EH/IDlfn4l1cQ2a3pcLEi
 FNIcZMBS8qWvauRJah0z5x7SZSu8XDF1DsQVA2+RAUd+SkBYibWeSeN4C/IlCqvWEfmv
 0AswUxaSkG6wYld8KXUXcmr78e6U9MeGHeW0PvEWMPyg/LoafFZR/GCFviIrdST7JRIV
 Qd/XpBUyDFKihweawRHPHlodEMdTAkDAmLYBE9YByvhk4v9Kn7SryHv8koBa1KQI57No 2w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2x5y0psq9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jan 2020 22:21:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 002MJDqg157929;
        Thu, 2 Jan 2020 22:21:13 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2x9jm6nptf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jan 2020 22:21:13 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 002MLBeC001535;
        Thu, 2 Jan 2020 22:21:11 GMT
Received: from [192.168.14.112] (/79.178.220.19)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jan 2020 14:21:10 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] net: mlx5: Use writeX() to ring doorbell and remove
 reduntant wmb()
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20200102205847.GJ9282@ziepe.ca>
Date:   Fri, 3 Jan 2020 00:21:06 +0200
Cc:     Will Deacon <will@kernel.org>, saeedm@mellanox.com,
        leon@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, eli@mellanox.com, tariqt@mellanox.com,
        danielm@mellanox.com,
        =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <79BB7EDF-406D-4FA1-ADDC-634D55F15C37@oracle.com>
References: <20200102174436.66329-1-liran.alon@oracle.com>
 <20200102192934.GH9282@ziepe.ca>
 <6524AE07-2ED7-41B5-B761-9F6BE8D2049B@oracle.com>
 <20200102205847.GJ9282@ziepe.ca>
To:     Jason Gunthorpe <jgg@ziepe.ca>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001020180
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001020180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 2 Jan 2020, at 22:58, Jason Gunthorpe <jgg@ziepe.ca> wrote:
>=20
> On Thu, Jan 02, 2020 at 09:45:52PM +0200, Liran Alon wrote:
>>=20
>>=20
>>> On 2 Jan 2020, at 21:29, Jason Gunthorpe <jgg@ziepe.ca> wrote:
>>>=20
>>> On Thu, Jan 02, 2020 at 07:44:36PM +0200, Liran Alon wrote:
>>>> Currently, mlx5e_notify_hw() executes wmb() to complete writes to =
cache-coherent
>>>> memory before ringing doorbell. Doorbell is written to by =
mlx5_write64()
>>>> which use __raw_writeX().
>>>>=20
>>>> This is semantically correct but executes reduntant wmb() in some =
architectures.
>>>> For example, in x86, a write to UC memory guarantees that any =
previous write to
>>>> WB memory will be globally visible before the write to UC memory. =
Therefore, there
>>>> is no need to also execute wmb() before write to doorbell which is =
mapped as UC memory.
>>>>=20
>>>> The consideration regarding this between different architectures is =
handled
>>>> properly by the writeX() macro. Which is defined differently for =
different
>>>> architectures. E.g. On x86, it is just a memory write. However, on =
ARM, it
>>>> is defined as __iowmb() folowed by a memory write. __iowmb() is =
defined
>>>> as wmb().
>>>=20
>>> This reasoning seems correct, though I would recommend directly
>>> refering to locking/memory-barriers.txt which explains this.
>>=20
>> I find memory-barriers.txt not explicit enough on the semantics of =
writeX().
>> (For example: Should it flush write-combined buffers before writing =
to the UC memory?)
>> That=E2=80=99s why I preferred to explicitly state here how I =
perceive it.
>=20
> AFAIK WC is largely unspecified by the memory model. Is wmb() even
> formally specified to interact with WC?

As I said, I haven=E2=80=99t seen such semantics defined in kernel =
documentation such as memory-barriers.txt.
However, in practice, it does flush WC buffers. At least for x86 and ARM =
which I=E2=80=99m familiar enough with.
I think it=E2=80=99s reasonable to assume that wmb() should flush WC =
buffers while dma_wmb()/smp_wmb() doesn=E2=80=99t necessarily have to do =
this.

But this is exactly the types of things that bothered me with =
memory-barriers.txt. That it doesn=E2=80=99t define semantics regarding =
these.

>=20
> At least in this mlx5 case there is no WC, right?

Right. As I made sure to explicitly mention in commit message.
This is also why I haven=E2=80=99t yet also fixed a similar issue in =
mlx4 kernel driver that does use BlueFlame (WC memory).

> The kernel UAR is
> mapped UC?

Yes.

>=20
> So we don't need to worry about the poor specification of WC access
> and you can refer to memory-barriers.txt at least for this patch.

Right.
I just gave it as a general example about that I wasn=E2=80=99t =
personally able to understand the exact intended semantics of writeX() =
by just reading memory-barriers.txt.
Anyway, sure I will rephrase the commit message to refer to =
memory-barriers.txt. No objection there.

>=20
>>>=20
>>>> Therefore, change mlx5_write64() to use writeX() and remove wmb() =
from
>>>> it's callers.
>>>=20
>>> Yes, wmb(); writel(); is always redundant
>>=20
>> Well, unfortunately not=E2=80=A6
>> See: =
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__marc.info_-3Fl-3Dli=
nux-2Dnetdev-26m-3D157798859215697-26w-3D2&d=3DDwIDaQ&c=3DRoP1YumCXCgaWHvl=
ZYR8PZh8Bv7qIrMUB65eapI_JnE&r=3DJk6Q8nNzkQ6LJ6g42qARkg6ryIDGQr-yKXPNGZbpTx=
0&m=3DOx1lCS1KAGBvJrf24kiFQrranIaNi_zeo05sqCUEf7Y&s=3DMz6MJzUQ862DGjgGnj3n=
eX4ZpjI88nOI9KpZhNF9TqQ&e=3D=20
>> (See my suggestion to add flush_wc_writeX())
>=20
> Well, the last time wmb & writel came up Linus was pretty clear that
> writel is supposed to remain in program order and have the barriers
> needed to do that.

Right. But that doesn=E2=80=99t take into account that WC writes are =
considered completed when they are still posted in CPU WC buffers.
The semantics as I understand of writeX() is that it guarantees all =
prior writes have been completed.
It means that all prior stores have executed and that store-buffer is =
flushed. But it doesn=E2=80=99t mean that WC buffers is flushed as-well.

>=20
> I don't think WC was considered when that discussion happened, but we
> really don't have a formal model for how WC works at all within the
> kernel.

Agree. I kinda assumed that wmb() have an extra semantics of also =
guaranteeing that WC buffers are flushed.
(Because in practice, I think it=E2=80=99s true for all cases. In =
contrast to using dma_wmb()/smp_wmb()).
This is why I think we are missing a flush_wc_writeX() macro as I =
specified in that commit message.

>=20
> The above patch is really not a wmb(); writel() pairing, the wmb() is
> actually closing/serializing an earlier WC transaction, and yes you =
need various
> special things to keep WC working right.

Right.

>=20
> IMHO you should start there before going around and adding/removing =
wmbs
> related to WC. Update membory-barriers.txt and related with the model
> ordering for WC access and get agreement.

I disagree here. It=E2=80=99s more important to fix a real bug (e.g. Not =
flushing WC buffers on x86 AMD).
Then, we can later formalise this and refactor code as necessary. Which =
will also optimise it as-well.
Bug fix can be merged before we finish all these discussions and get =
agreement.

I do completely agree we should have this discussion on WC and barriers =
and I already sent an
email on this to all the memory-barriers.txt maintainers. Waiting to see =
how that discussion go
and get community feedback before I will submit a patch-series that will =
introduce new changes
to memory-barriers.txt and probably also new barrier macro.

>=20
> For instance does wmb() even effect WC? Does WC have to be contained
> by spinlocks? Do we need extra special barriers like flush_wc and
> flush_wc_before_spin_unlock ? etc.
>=20
> Perhaps Will has some advice?

I also sent Will an email about this a few days ago. Thanks for Cc him. =
:)

>=20
>>>> diff --git a/include/linux/mlx5/cq.h b/include/linux/mlx5/cq.h
>>>> index 40748fc1b11b..28744a725e64 100644
>>>> +++ b/include/linux/mlx5/cq.h
>>>> @@ -162,11 +162,6 @@ static inline void mlx5_cq_arm(struct =
mlx5_core_cq *cq, u32 cmd,
>>>>=20
>>>> 	*cq->arm_db =3D cpu_to_be32(sn << 28 | cmd | ci);
>>>>=20
>>>> -	/* Make sure that the doorbell record in host memory is
>>>> -	 * written before ringing the doorbell via PCI MMIO.
>>>> -	 */
>>>> -	wmb();
>>>> -
>>>=20
>>> Why did this one change? The doorbell memory here is not a writel():
>>=20
>> Well, it=E2=80=99s not seen in the diff but actually the full code =
is:
>>=20
>>    /* Make sure that the doorbell record in host memory is
>>     * written before ringing the doorbell via PCI MMIO.
>>     */
>>    wmb();
>>=20
>>    doorbell[0] =3D cpu_to_be32(sn << 28 | cmd | ci);
>>    doorbell[1] =3D cpu_to_be32(cq->cqn);
>>=20
>>    mlx5_write64(doorbell, uar_page + MLX5_CQ_DOORBELL);
>=20
> Ah OK, we have another thing called doorbell which is actually DMA'ble
> memory.

Yep.

>=20
>>>> 	doorbell[0] =3D cpu_to_be32(sn << 28 | cmd | ci);
>>>> 	doorbell[1] =3D cpu_to_be32(cq->cqn);
>>>=20
>>>> static inline void mlx5_write64(__be32 val[2], void __iomem *dest)
>>>> {
>>>> #if BITS_PER_LONG =3D=3D 64
>>>> -	__raw_writeq(*(u64 *)val, dest);
>>>> +	writeq(*(u64 *)val, dest);
>>>=20
>>> I want to say this might cause problems with endian swapping as =
writeq
>>> also does some swaps that __raw does not? Is this true?
>>=20
>> Hmm... Looking at ARM64 version, writeq() indeed calls cpu_to_le64()
>> on parameter before passing it to __raw_writeq().  Quite surprising
>> from API perspective to be honest.
>=20
> For PCI-E devices writel(x) is defined to generate the same TLP on the
> PCI-E bus, across all arches.

Good to know.
Question: Where is this documented?

> __raw_* does something arch specific and
> should not be called from drivers. It is a long standing bug that this
> code is written like this.

Agree. That=E2=80=99s what caught my eye to this in the first place.

>=20
>> So should I change this instead to iowrite64be(*(u64 *)val, dest)?
>=20
> This always made my head hurt, but IIRC, when I looked at it years ago
> the weird array construction caused problems with that simple =
conversion.
>=20
> The userspace version looks like this now:
>=20
>        uint64_t doorbell;
>        uint32_t sn;
>        uint32_t ci;
>        uint32_t cmd;
>=20
>        sn  =3D cq->arm_sn & 3;
>        ci  =3D cq->cons_index & 0xffffff;
>        cmd =3D solicited ? MLX5_CQ_DB_REQ_NOT_SOL : =
MLX5_CQ_DB_REQ_NOT;
>=20
>        doorbell =3D sn << 28 | cmd | ci;
>        doorbell <<=3D 32;
>        doorbell |=3D cq->cqn;
>=20
>        mmio_write64_be(ctx->uar[0].reg + MLX5_CQ_DOORBELL, =
htobe64(doorbell));
>=20
> Where on all supported platforms the mmio_write64_be() expands to a
> simple store (no swap)
>=20
> Which does look functionally the same as
>=20
>   iowrite64be(doorbell, dest);
>=20
> So this patch should change the mlx5_write64 to accept a u64 like we
> did in userspace when this was all cleaned there.

If I understand you correctly, you suggest to change callers to pass =
here a standard u64 and then
modify mlx5_write64() to just call iowrite64be(). If so, I agree. Just =
want to confirm before sending v2.

Thanks for the insightful review,
-Liran

>=20
> Jason

