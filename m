Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17D7E12FCA8
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 19:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbgACSjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 13:39:40 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45542 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728279AbgACSjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 13:39:40 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 003Id8Oh183370;
        Fri, 3 Jan 2020 18:39:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=dX26BP7QIFdhpUmPnL8k8nYzVsRvDK3fMTnVqxnXXOw=;
 b=QIKOvfh0oqdfbglNT6AU6149y3Zw0qknUeEIDdRQu4VeHaAfA0WTrJG1bE5DTrta7srl
 AaAIIYI9v8HxCFi+6yphx/CMVa5r18hli52dyv6XILIKf9JjFeOHsaCMY/6A8LS75lGe
 3UvMKaiVzvOf8uGlX8LZiSf2j7btiG7Et/7UKUN4Rs3CWxFv20PzUCFLqLrzrZcFHTtt
 oX7vfU5SZy39+OaEZVHvPPHDpNtDZTzTyUYpOiTyqrE/VEIXVmots3rgs8cO0F7ncDfB
 w7Jtfu+8jTkbTjzak5ZKFYcCyTQVlWYWBtwR7xWVrUCrU2f03Ni3oeTlq1nfEBmmAfbA VA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2x5ypqwpk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 18:39:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 003IdP7P114077;
        Fri, 3 Jan 2020 18:39:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2xa5fgst93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 18:39:32 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 003IcugC016083;
        Fri, 3 Jan 2020 18:38:56 GMT
Received: from [192.168.14.112] (/79.178.220.19)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jan 2020 10:38:56 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] net: mlx5: Use writeX() to ring doorbell and remove
 reduntant wmb()
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <F7C45792-2F17-42AE-88A2-F744EEAD68A5@oracle.com>
Date:   Fri, 3 Jan 2020 20:38:51 +0200
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Will Deacon <will@kernel.org>,
        saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, eli@mellanox.com, tariqt@mellanox.com,
        danielm@mellanox.com,
        =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1C8D5596-F9AD-4E9F-B462-D63DCEEFFE54@oracle.com>
References: <20200102174436.66329-1-liran.alon@oracle.com>
 <20200102192934.GH9282@ziepe.ca>
 <6524AE07-2ED7-41B5-B761-9F6BE8D2049B@oracle.com>
 <20200102205847.GJ9282@ziepe.ca>
 <79BB7EDF-406D-4FA1-ADDC-634D55F15C37@oracle.com>
 <20200103133749.GA9706@ziepe.ca>
 <F7C45792-2F17-42AE-88A2-F744EEAD68A5@oracle.com>
To:     Liran Alon <liran.alon@oracle.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9489 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001030169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9489 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001030169
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 3 Jan 2020, at 18:31, Liran Alon <liran.alon@oracle.com> wrote:
>=20
>=20
>=20
>> On 3 Jan 2020, at 15:37, Jason Gunthorpe <jgg@ziepe.ca> wrote:
>>=20
>> On Fri, Jan 03, 2020 at 12:21:06AM +0200, Liran Alon wrote:
>>=20
>>>> AFAIK WC is largely unspecified by the memory model. Is wmb() even
>>>> formally specified to interact with WC?
>>>=20
>>> As I said, I haven=E2=80=99t seen such semantics defined in kernel
>>> documentation such as memory-barriers.txt.  However, in practice, it
>>> does flush WC buffers. At least for x86 and ARM which I=E2=80=99m =
familiar
>>> enough with.  I think it=E2=80=99s reasonable to assume that wmb() =
should
>>> flush WC buffers while dma_wmb()/smp_wmb() doesn=E2=80=99t =
necessarily have
>>> to do this.
>>=20
>> It is because WC is rarely used and laregly undefined for the kernel
>> :(
>=20
> Yep.
>=20
>>=20
>>>>>>> Therefore, change mlx5_write64() to use writeX() and remove =
wmb() from
>>>>>>> it's callers.
>>>>>>=20
>>>>>> Yes, wmb(); writel(); is always redundant
>>>>>=20
>>>>> Well, unfortunately not=E2=80=A6
>>>>> See: =
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__marc.info_-3Fl-3Dli=
nux-2Dnetdev-26m-3D157798859215697-26w-3D2&d=3DDwIDaQ&c=3DRoP1YumCXCgaWHvl=
ZYR8PZh8Bv7qIrMUB65eapI_JnE&r=3DJk6Q8nNzkQ6LJ6g42qARkg6ryIDGQr-yKXPNGZbpTx=
0&m=3DOx1lCS1KAGBvJrf24kiFQrranIaNi_zeo05sqCUEf7Y&s=3DMz6MJzUQ862DGjgGnj3n=
eX4ZpjI88nOI9KpZhNF9TqQ&e=3D
>>>>> (See my suggestion to add flush_wc_writeX())
>>>>=20
>>>> Well, the last time wmb & writel came up Linus was pretty clear =
that
>>>> writel is supposed to remain in program order and have the barriers
>>>> needed to do that.
>>>=20
>>> Right. But that doesn=E2=80=99t take into account that WC writes are
>>> considered completed when they are still posted in CPU WC buffers.
>>=20
>>> The semantics as I understand of writeX() is that it guarantees all
>>> prior writes have been completed.  It means that all prior stores
>>> have executed and that store-buffer is flushed. But it doesn=E2=80=99t=
 mean
>>> that WC buffers is flushed as-well.
>>=20
>> The semantic for writel is that prior program order stores will be
>> observable by DMA from the device receiving the writel. This is
>> required for UC and NC stores today. WC is undefined, I think.
>>=20
>> This is why ARM has the additional barrier in writel.
>=20
> Yep.
>=20
>>=20
>> It would logically make sense if WC followed the same rule, however,
>> adding a barrier to writel to make WC ordered would not be popular, =
so
>> I think we are left with using special accessors for WC and placing
>> the barrier there..
>=20
> Right.
>=20
>>=20
>>>> IMHO you should start there before going around and adding/removing =
wmbs
>>>> related to WC. Update membory-barriers.txt and related with the =
model
>>>> ordering for WC access and get agreement.
>>>=20
>>> I disagree here. It=E2=80=99s more important to fix a real bug (e.g. =
Not
>>> flushing WC buffers on x86 AMD).  Then, we can later formalise this
>>> and refactor code as necessary. Which will also optimise it as-well.
>>> Bug fix can be merged before we finish all these discussions and get
>>> agreement.
>>=20
>> Is it a real bug that people actually hit? It wasn't clear from the
>> commit message. If so, sure, it should be fixed and the commit =
message
>> clarified. (but I'd put the wmb near the WC writes..)
>=20
> I found this bug during code review. I=E2=80=99m not aware if AWS saw =
this bug happening in production.
> But according to AMD SDM and Optimization Guide SDM, this is a bug.
>=20
> I think it doesn=E2=80=99t happen in practice because the write of the =
Tx descriptor + 128 first bytes of packet
> Effectively fills the relevant WC buffers and when a WC buffer is =
fully written to, the CPU *should*
> (Not *must*) flush the WC buffer to memory.

Actually after re-reading AMD Optimization Guide SDM, I see it is =
guaranteed that:
=E2=80=9CWrite-combining is closed if all 64 bytes of the write buffer =
are valid=E2=80=9D.
And this is indeed always the case for AWS ENA LLQ. Because as can be =
seen at
ena_com_config_llq_info(), desc_list_entry_size is either 128, 192 or =
256. i.e. Always
a multiple of 64 bytes. So this explains why this wasn=E2=80=99t an =
issue in production.

-Liran


