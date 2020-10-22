Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7530E2963EF
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 19:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369315AbgJVRre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 13:47:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22751 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S369298AbgJVRrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 13:47:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603388848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=sO3K7G3TcZ1QGTP9K/3Db+WgquFQFE5buToK1oUkzNk=;
        b=aE2OnRsq69Nha0Eemps3W1WaA3MkC2ZngBPvOD79XYuu4XmTZiMvomIwcibc0QU+NlcaXj
        lakrmL6eTV6PCIa2cxBIwyWe3/SY1XgPunzyTsb2pr49rHjNyIBwFbcMZFE9DXtB8vRDHu
        ONkp/mK4MbwpricThPmsDcdBSYXVcn0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-MfaNNBH1MVSY6IGIRMVOvQ-1; Thu, 22 Oct 2020 13:47:24 -0400
X-MC-Unique: MfaNNBH1MVSY6IGIRMVOvQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5CA81186DD28;
        Thu, 22 Oct 2020 17:47:21 +0000 (UTC)
Received: from [10.10.115.73] (ovpn-115-73.rdu2.redhat.com [10.10.115.73])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7FDC755776;
        Thu, 22 Oct 2020 17:47:15 +0000 (UTC)
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to housekeeping
 CPUs
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, helgaas@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        jlelli@redhat.com, hch@infradead.org, bhelgaas@google.com,
        mike.marciniszyn@intel.com, dennis.dalessandro@intel.com,
        thomas.lendacky@amd.com, jiri@nvidia.com, mingo@redhat.com,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        lgoncalv@redhat.com, Christoph Hellwig <hch@infradead.org>
References: <20200928183529.471328-1-nitesh@redhat.com>
 <20200928183529.471328-5-nitesh@redhat.com>
 <20201016122046.GP2611@hirez.programming.kicks-ass.net>
 <79f382a7-883d-ff42-394d-ec4ce81fed6a@redhat.com>
 <20201019111137.GL2628@hirez.programming.kicks-ass.net>
 <20201019140005.GB17287@fuller.cnet>
 <20201020073055.GY2611@hirez.programming.kicks-ass.net>
 <078e659e-d151-5bc2-a7dd-fe0070267cb3@redhat.com>
 <20201020134128.GT2628@hirez.programming.kicks-ass.net>
 <6736e643-d4ae-9919-9ae1-a73d5f31463e@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <260f4191-5b9f-6dc1-9f11-085533ac4f55@redhat.com>
Date:   Thu, 22 Oct 2020 13:47:14 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <6736e643-d4ae-9919-9ae1-a73d5f31463e@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nitesh@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tC6UfFI6WR38l3rBBuK2i1yKi1B8XUAC0"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tC6UfFI6WR38l3rBBuK2i1yKi1B8XUAC0
Content-Type: multipart/mixed; boundary="sRo9W6wjK2Pxf6wnRqz6v6VFsZXu5meo6"

--sRo9W6wjK2Pxf6wnRqz6v6VFsZXu5meo6
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 10/20/20 10:39 AM, Nitesh Narayan Lal wrote:
> On 10/20/20 9:41 AM, Peter Zijlstra wrote:
>> On Tue, Oct 20, 2020 at 09:00:01AM -0400, Nitesh Narayan Lal wrote:
>>> On 10/20/20 3:30 AM, Peter Zijlstra wrote:
>>>> On Mon, Oct 19, 2020 at 11:00:05AM -0300, Marcelo Tosatti wrote:
>>>>>> So I think it is important to figure out what that driver really wan=
ts
>>>>>> in the nohz_full case. If it wants to retain N interrupts per CPU, a=
nd
>>>>>> only reduce the number of CPUs, the proposed interface is wrong.
>>>>> It wants N interrupts per non-isolated (AKA housekeeping) CPU.
>>>> Then the patch is wrong and the interface needs changing from @min_vec=
s,
>>>> @max_vecs to something that expresses the N*nr_cpus relation.
>>> Reading Marcelo's comment again I think what is really expected is 1
>>> interrupt per non-isolated (housekeeping) CPU (not N interrupts).
>> Then what is the point of them asking for N*nr_cpus when there is no
>> isolation?
>>
>> Either everybody wants 1 interrupts per CPU and we can do the clamp
>> unconditionally, in which case we should go fix this user, or they want
>> multiple per cpu and we should go fix the interface.
>>
>> It cannot be both.
> Based on my understanding I don't think this is consistent, the number
> of interrupts any driver can request varies to an extent that some
> consumer of this API even request just one interrupt for its use.
>
> This was one of the reasons why I thought of having a conditional
> restriction.
>
> But I agree there is a lack of consistency.
>

Hi Peter,

So based on the suggestions from you and Thomas, I think something like the
following should do the job within pci_alloc_irq_vectors_affinity():

+ =C2=A0 =C2=A0 =C2=A0 if (!pci_is_managed(dev) && (hk_cpus < num_online_cp=
us()))
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 max_vecs =3D clamp(hk_cp=
us, min_vecs, max_vecs);

I do know that you didn't like the usage of "hk_cpus < num_online_cpus()"
and to an extent I agree that it does degrade the code clarity.

However, since there is a certain inconsistency in the number of vectors
that drivers request through this API IMHO we will need this, otherwise
we could cause an impact on the drivers even in setups that doesn't
have any isolated CPUs.

If you agree, I can send the next version of the patch-set.

--=20
Thanks
Nitesh


--sRo9W6wjK2Pxf6wnRqz6v6VFsZXu5meo6--

--tC6UfFI6WR38l3rBBuK2i1yKi1B8XUAC0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl+RxaIACgkQo4ZA3AYy
oznkXQ//ZwbbYkVeFlswGVh5f/xWufaxBmeANtowGcNvn79iTwnDMCh0DpDV0Mpa
AHJF062Mx2LPmWJ7HN3UWUNEoHdk0ghCDKf9teYeesviFlx3PCy7L0HKiP7HSEl6
txEhBMVZhAeZRcOfzD6AjIK1wBSX76JNn5YzznnRCnBUXu2uDlMmM9E1+aC9xETu
PQreGPgkKkIQDFUzcwT6IBYOuZJ3ZMlBULThaRWADwJf1vvFyEmQy/u3rsu7FHoC
gwAOaA67PJSqyT48rA0NUTeya/hpbYoLvPS3Qp/3vHLXtLEhUyo3R9oky3CTusts
Z9wjtgTHF77EZTaXBe3J0KLGVJmaFtKgYJ48fHvsoZCrWi/nVX2agHBH/DEGr41a
rv/v28LWYhLkYC9tWDyoANPHHO4B9SaowEBgOnZ99MwdGfU77Qm9QpAsL4sQQG1a
lFf3x2wswe/c0HzmzNDWgft0H6o24pkTFDRYJ0fMqqbMB2wC9u0kYd96zPub1zXP
xbXrCqavfYQ4RfkD/JZOhv2Nm+oZ4cNZ6sSImFMy5F7sJpkCeJ+VCGxcKUlYFkPh
z/peOr5xiJ3AEivqbVpHY6ZiOeK+9FIb9A6fKGe4oWrGKDuZy3cksOsUOkjTVIN6
Vd2FGwALc26C5mAnCXi66TPWJv4Ix/aubaWAvx5TPWA4qVYCEB8=
=Qdiy
-----END PGP SIGNATURE-----

--tC6UfFI6WR38l3rBBuK2i1yKi1B8XUAC0--

