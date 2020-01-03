Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D73FD12FA78
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 17:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbgACQbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 11:31:31 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:40426 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727859AbgACQba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 11:31:30 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 003GTOc9073919;
        Fri, 3 Jan 2020 16:31:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=MCxYQsBaQc/0r53GJBQloDBNau19kLxx+ZWgJIG73yU=;
 b=HJ1BwP3qUX0HX17Agd95w345APBbQmWb7x7cMln6v8GcvJdXvH/iH/1UCr8Mz2fbnrYb
 g//huKlSJLwRrOlfYOfpetg6hun+Q+i45imd8JjYw7MRv39v0mvHl//RGTNyRq4IQs7R
 M0hG2lnJ1wXar3qqK7Wtoc3vtlzpTwCGXzxpOXnDdKB5Zivul7AAcUq8D1pSTMjHtTrk
 DTWg3KuQGRLKTgQ9c7/6FEpDht93jbqWEuiT9HfJ1Vphd3sJM1Ot5sQOxxwKTIAANqxn
 lLn0MkZsPcLgsx2K3qRet4AB716VsrmQN3Zi0TnXLhF6M/0Yv0yPlNKzBKFfx3UHi4jc RA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2x5y0pw3s4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 16:31:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 003GSduV051923;
        Fri, 3 Jan 2020 16:31:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2xa7ty60a1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 16:31:24 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 003GVNkY019507;
        Fri, 3 Jan 2020 16:31:23 GMT
Received: from [192.168.14.112] (/79.178.220.19)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jan 2020 08:31:23 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] net: mlx5: Use writeX() to ring doorbell and remove
 reduntant wmb()
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20200103133749.GA9706@ziepe.ca>
Date:   Fri, 3 Jan 2020 18:31:18 +0200
Cc:     Will Deacon <will@kernel.org>, saeedm@mellanox.com,
        leon@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, eli@mellanox.com, tariqt@mellanox.com,
        danielm@mellanox.com,
        =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F7C45792-2F17-42AE-88A2-F744EEAD68A5@oracle.com>
References: <20200102174436.66329-1-liran.alon@oracle.com>
 <20200102192934.GH9282@ziepe.ca>
 <6524AE07-2ED7-41B5-B761-9F6BE8D2049B@oracle.com>
 <20200102205847.GJ9282@ziepe.ca>
 <79BB7EDF-406D-4FA1-ADDC-634D55F15C37@oracle.com>
 <20200103133749.GA9706@ziepe.ca>
To:     Jason Gunthorpe <jgg@ziepe.ca>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9489 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001030151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9489 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001030151
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 3 Jan 2020, at 15:37, Jason Gunthorpe <jgg@ziepe.ca> wrote:
>=20
> On Fri, Jan 03, 2020 at 12:21:06AM +0200, Liran Alon wrote:
>=20
>>> AFAIK WC is largely unspecified by the memory model. Is wmb() even
>>> formally specified to interact with WC?
>>=20
>> As I said, I haven=E2=80=99t seen such semantics defined in kernel
>> documentation such as memory-barriers.txt.  However, in practice, it
>> does flush WC buffers. At least for x86 and ARM which I=E2=80=99m =
familiar
>> enough with.  I think it=E2=80=99s reasonable to assume that wmb() =
should
>> flush WC buffers while dma_wmb()/smp_wmb() doesn=E2=80=99t =
necessarily have
>> to do this.
>=20
> It is because WC is rarely used and laregly undefined for the kernel
> :(

Yep.

>=20
>>>>>> Therefore, change mlx5_write64() to use writeX() and remove wmb() =
from
>>>>>> it's callers.
>>>>>=20
>>>>> Yes, wmb(); writel(); is always redundant
>>>>=20
>>>> Well, unfortunately not=E2=80=A6
>>>> See: =
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__marc.info_-3Fl-3Dli=
nux-2Dnetdev-26m-3D157798859215697-26w-3D2&d=3DDwIDaQ&c=3DRoP1YumCXCgaWHvl=
ZYR8PZh8Bv7qIrMUB65eapI_JnE&r=3DJk6Q8nNzkQ6LJ6g42qARkg6ryIDGQr-yKXPNGZbpTx=
0&m=3DOx1lCS1KAGBvJrf24kiFQrranIaNi_zeo05sqCUEf7Y&s=3DMz6MJzUQ862DGjgGnj3n=
eX4ZpjI88nOI9KpZhNF9TqQ&e=3D
>>>> (See my suggestion to add flush_wc_writeX())
>>>=20
>>> Well, the last time wmb & writel came up Linus was pretty clear that
>>> writel is supposed to remain in program order and have the barriers
>>> needed to do that.
>>=20
>> Right. But that doesn=E2=80=99t take into account that WC writes are
>> considered completed when they are still posted in CPU WC buffers.
>=20
>> The semantics as I understand of writeX() is that it guarantees all
>> prior writes have been completed.  It means that all prior stores
>> have executed and that store-buffer is flushed. But it doesn=E2=80=99t =
mean
>> that WC buffers is flushed as-well.
>=20
> The semantic for writel is that prior program order stores will be
> observable by DMA from the device receiving the writel. This is
> required for UC and NC stores today. WC is undefined, I think.
>=20
> This is why ARM has the additional barrier in writel.

Yep.

>=20
> It would logically make sense if WC followed the same rule, however,
> adding a barrier to writel to make WC ordered would not be popular, so
> I think we are left with using special accessors for WC and placing
> the barrier there..

Right.

>=20
>>> IMHO you should start there before going around and adding/removing =
wmbs
>>> related to WC. Update membory-barriers.txt and related with the =
model
>>> ordering for WC access and get agreement.
>>=20
>> I disagree here. It=E2=80=99s more important to fix a real bug (e.g. =
Not
>> flushing WC buffers on x86 AMD).  Then, we can later formalise this
>> and refactor code as necessary. Which will also optimise it as-well.
>> Bug fix can be merged before we finish all these discussions and get
>> agreement.
>=20
> Is it a real bug that people actually hit? It wasn't clear from the
> commit message. If so, sure, it should be fixed and the commit message
> clarified. (but I'd put the wmb near the WC writes..)

I found this bug during code review. I=E2=80=99m not aware if AWS saw =
this bug happening in production.
But according to AMD SDM and Optimization Guide SDM, this is a bug.

I think it doesn=E2=80=99t happen in practice because the write of the =
Tx descriptor + 128 first bytes of packet
Effectively fills the relevant WC buffers and when a WC buffer is fully =
written to, the CPU *should*
(Not *must*) flush the WC buffer to memory.

Having said that, I (and AWS maintainers of this code which I spoke with =
them about this) still think
that we should first apply this patch and later refactor this code when =
we will introduce the proper
memory accessor (flush_wc_writeX()).

But I would be glad to hear thoughts from memory-barriers.txt =
maintainers such as Will on this.

>=20
> I am surprised that AMD is different here, the evolution of the WC
> feature on x86 was to transparently speed up graphics, so I'm pretty
> surprised AMD can get away with not ordering the same as Intel..

Completely agree. I was very surprised to see this from AMD SDM and =
Optimization Guide SDM.
It made sense to me too that graphics frame buffer is written to WC =
memory and then is committed
to GPU by writing to some doorbell register mapped as UC memory.

My personal theory is that the difference is rooted from the fact that =
AMD use dedicated CPU registers
for WC buffers in contrast to Intel which utilise LFB entries for that =
(In addition to their standard role).
But this is a pure guess of course. :)

>=20
>> I do completely agree we should have this discussion on WC and
>> barriers and I already sent an email on this to all the
>> memory-barriers.txt maintainers. Waiting to see how that discussion
>> go and get community feedback before I will submit a patch-series
>> that will introduce new changes to memory-barriers.txt and probably
>> also new barrier macro.
>=20
> The barrier macros have been unpopular, ie the confusing mmiowb was
> dumped, and I strongly suspect to contain WC within a spinlock (which
> is very important!) you need a barrier instruction on some archs.
>=20
> New accessors might work better.

We agree. I just use wrong terminology :)
I meant we should probably introduce something as flush_wc_writeX().

>=20
>>>>>> 	doorbell[0] =3D cpu_to_be32(sn << 28 | cmd | ci);
>>>>>> 	doorbell[1] =3D cpu_to_be32(cq->cqn);
>>>>>=20
>>>>>> static inline void mlx5_write64(__be32 val[2], void __iomem =
*dest)
>>>>>> {
>>>>>> #if BITS_PER_LONG =3D=3D 64
>>>>>> -	__raw_writeq(*(u64 *)val, dest);
>>>>>> +	writeq(*(u64 *)val, dest);
>>>>>=20
>>>>> I want to say this might cause problems with endian swapping as =
writeq
>>>>> also does some swaps that __raw does not? Is this true?
>>>>=20
>>>> Hmm... Looking at ARM64 version, writeq() indeed calls =
cpu_to_le64()
>>>> on parameter before passing it to __raw_writeq().  Quite surprising
>>>> from API perspective to be honest.
>>>=20
>>> For PCI-E devices writel(x) is defined to generate the same TLP on =
the
>>> PCI-E bus, across all arches.
>>=20
>> Good to know.
>> Question: Where is this documented?
>=20
> Hmm, haven't ever seen it documented like that. It is sort of a
> logical requirement. If writel(x) produces different TLPs (ie
> different byte order) how could a driver ever work with a PCI-E device
> that requires only one TLP for x?

Makes sense indeed.

>=20
>>>> So should I change this instead to iowrite64be(*(u64 *)val, dest)?
>>>=20
>>> This always made my head hurt, but IIRC, when I looked at it years =
ago
>>> the weird array construction caused problems with that simple =
conversion.
>>>=20
>>> The userspace version looks like this now:
>>>=20
>>>       uint64_t doorbell;
>>>       uint32_t sn;
>>>       uint32_t ci;
>>>       uint32_t cmd;
>>>=20
>>>       sn  =3D cq->arm_sn & 3;
>>>       ci  =3D cq->cons_index & 0xffffff;
>>>       cmd =3D solicited ? MLX5_CQ_DB_REQ_NOT_SOL : =
MLX5_CQ_DB_REQ_NOT;
>>>=20
>>>       doorbell =3D sn << 28 | cmd | ci;
>>>       doorbell <<=3D 32;
>>>       doorbell |=3D cq->cqn;
>>>=20
>>>       mmio_write64_be(ctx->uar[0].reg + MLX5_CQ_DOORBELL, =
htobe64(doorbell));
>>>=20
>>> Where on all supported platforms the mmio_write64_be() expands to a
>>> simple store (no swap)
>>>=20
>>> Which does look functionally the same as
>>>=20
>>>  iowrite64be(doorbell, dest);
>>>=20
>>> So this patch should change the mlx5_write64 to accept a u64 like we
>>> did in userspace when this was all cleaned there.
>>=20
>> If I understand you correctly, you suggest to change callers to pass
>> here a standard u64 and then modify mlx5_write64() to just call
>> iowrite64be(). If so, I agree. Just want to confirm before sending
>> v2.
>=20
> Yes, this is what I did to userspace and it made this all make
> sense. I strongly recommend to do the same in the kernel, particularly
> now that we have iowrite64be()!

Ack.

Thanks,
-Liran

>=20
> Jason

