Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF767298E14
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 14:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780221AbgJZNgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 09:36:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34309 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1775576AbgJZNgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 09:36:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603719367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=z/er2CNBtuu3u07SVquLUf0SAnl4JDGceDVR9Xoiv+8=;
        b=UM5Bj4G1fzFDhIT2CBOrcW9K//I3/xYHdJpeRQASaZptZCwoDet/z160Yk0q1DU4PlKvhc
        iOIY5p9K38c6xl1igNNm7nO3/zAef1QNza9A7cuogKHcx8L+fBARBH4Wpi/a7OvueoIbk0
        ZGvMx/6ORDkn8FBEwqD5RcmiVzE/ry4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-570-UlG5xXGKOh227ZM4BLYixA-1; Mon, 26 Oct 2020 09:36:03 -0400
X-MC-Unique: UlG5xXGKOh227ZM4BLYixA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3035D803637;
        Mon, 26 Oct 2020 13:36:00 +0000 (UTC)
Received: from [10.10.114.126] (ovpn-114-126.rdu2.redhat.com [10.10.114.126])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 798E05D9E4;
        Mon, 26 Oct 2020 13:35:54 +0000 (UTC)
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to housekeeping
 CPUs
To:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>, helgaas@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        jlelli@redhat.com, hch@infradead.org, bhelgaas@google.com,
        mike.marciniszyn@intel.com, dennis.dalessandro@intel.com,
        thomas.lendacky@amd.com, jiri@nvidia.com, mingo@redhat.com,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        lgoncalv@redhat.com
References: <20200928183529.471328-5-nitesh@redhat.com>
 <20201016122046.GP2611@hirez.programming.kicks-ass.net>
 <79f382a7-883d-ff42-394d-ec4ce81fed6a@redhat.com>
 <20201019111137.GL2628@hirez.programming.kicks-ass.net>
 <20201019140005.GB17287@fuller.cnet>
 <20201020073055.GY2611@hirez.programming.kicks-ass.net>
 <078e659e-d151-5bc2-a7dd-fe0070267cb3@redhat.com>
 <20201020134128.GT2628@hirez.programming.kicks-ass.net>
 <6736e643-d4ae-9919-9ae1-a73d5f31463e@redhat.com>
 <260f4191-5b9f-6dc1-9f11-085533ac4f55@redhat.com>
 <20201023085826.GP2611@hirez.programming.kicks-ass.net>
 <9ee77056-ef02-8696-5b96-46007e35ab00@redhat.com>
 <87ft6464jf.fsf@nanos.tec.linutronix.de>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <9529ddd0-28f7-fa74-e56f-39de84321a22@redhat.com>
Date:   Mon, 26 Oct 2020 09:35:52 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <87ft6464jf.fsf@nanos.tec.linutronix.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nitesh@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mMrZauSHmHzl6OKZzqjVFZbr6v3JtsNsW"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mMrZauSHmHzl6OKZzqjVFZbr6v3JtsNsW
Content-Type: multipart/mixed; boundary="anU3HvRpYs9wkdqXN8kHgy3KmgpyFByKb"

--anU3HvRpYs9wkdqXN8kHgy3KmgpyFByKb
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 10/23/20 5:00 PM, Thomas Gleixner wrote:
> On Fri, Oct 23 2020 at 09:10, Nitesh Narayan Lal wrote:
>> On 10/23/20 4:58 AM, Peter Zijlstra wrote:
>>> On Thu, Oct 22, 2020 at 01:47:14PM -0400, Nitesh Narayan Lal wrote:
>>> So shouldn't we then fix the drivers / interface first, to get rid of
>>> this inconsistency?
>>>
>> Considering we agree that excess vector is a problem that needs to be
>> solved across all the drivers and that you are comfortable with the othe=
r
>> three patches in the set. If I may suggest the following:
>>
>> - We can pick those three patches for now, as that will atleast fix a
>> =C2=A0 driver that is currently impacting RT workloads. Is that a fair
>> =C2=A0 expectation?
> No. Blindly reducing the maximum vectors to the number of housekeeping
> CPUs is patently wrong. The PCI core _cannot_ just nilly willy decide
> what the right number of interrupts for this situation is.
>
> Many of these drivers need more than queue interrupts, admin, error
> interrupt and some operate best with seperate RX/TX interrupts per
> queue. They all can "work" with a single PCI interrupt of course, but
> the price you pay is performance.
>
> An isolated setup, which I'm familiar with, has two housekeeping
> CPUs. So far I restricted the number of network queues with a module
> argument to two, which allocates two management interrupts for the
> device and two interrupts (RX/TX) per queue, i.e. a total of six.

Does it somehow take num_online_cpus() into consideration while deciding
the number of interrupts to create?

>
> Now I reduced the number of available interrupts to two according to
> your hack, which makes it use one queue RX/TX combined and one
> management interrupt. Guess what happens? Network performance tanks to
> the points that it breaks a carefully crafted setup.
>
> The same applies to a device which is application specific and wants one
> channel including an interrupt per isolated application core. Today I
> can isolate 8 out of 12 CPUs and let the device create 8 channels and
> set one interrupt and channel affine to each isolated CPU. With your
> hack, I get only 4 interrupts and channels. Fail!
>
> You cannot declare that all this is perfectly fine, just because it does
> not matter for your particular use case.

I agree that does sound wrong.

>
> So without information from the driver which tells what the best number
> of interrupts is with a reduced number of CPUs, this cutoff will cause
> more problems than it solves. Regressions guaranteed.

Indeed.
I think one commonality among the drivers at the moment is the usage of
num_online_cpus() to determine the vectors to create.

So, maybe instead of doing this kind of restrictions in a generic level
API, it will make more sense to do this on a per-device basis by replacing
the number of online CPUs with the housekeeping CPUs?

This is what I have done in the i40e patch.
But that still sounds hackish and will impact the performance.

>
> Managed interrupts base their interrupt allocation and spreading on
> information which is handed in by the individual driver and not on crude
> assumptions. They are not imposing restrictions on the use case.

Right, FWIU it is irq_do_set_affinity that prevents the spreading of
managed interrupts to isolated CPUs if HK_FLAG_MANAGED_IRQ is enabled,
isn't?

>
> It's perfectly fine for isolated work to save a data set to disk after
> computation has finished and that just works with the per-cpu I/O queue
> which is otherwise completely silent. All isolated workers can do the
> same in parallel without trampling on each other toes by competing for a
> reduced number of queues which are affine to the housekeeper CPUs.
>
> Unfortunately network multi-queue is substantially different from block
> multi-queue (as I learned in this conversation), so the concept cannot
> be applied one-to-one to networking as is. But there are certainly part
> of it which can be reused.

So this is one of the areas that I don't understand well yet and will
explore now.

>
> This needs a lot more thought than just these crude hacks.

Got it.
I am indeed not in the favor of pushing a solution that has a possibility
of regressing/breaking things afterward.

>
> Especially under the aspect that there are talks about making isolation
> runtime switchable. Are you going to rmmod/insmod the i40e network
> driver to do so? That's going to work fine if you do that
> reconfiguration over network...

That's an interesting point. However, for some of the drivers which uses
something like cpu_online/possible_mask while creating its affinity mask
reloading will still associate jobs to the isolated CPUs.


--=20
Thanks
Nitesh


--anU3HvRpYs9wkdqXN8kHgy3KmgpyFByKb--

--mMrZauSHmHzl6OKZzqjVFZbr6v3JtsNsW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl+W0LkACgkQo4ZA3AYy
ozka2hAArZcVOVBHutp1ebSRDqJJy4GDqX5EHcGQrrriws+OxvBMeiFx+09+sEhO
dtlYhB+mnLKKXHSSKd9/lEl7paJ5S+QorXaLcM5AuY1mC4xSRE21RSoF5t4wIF9w
upkXfy9D/4h4Y52Lm/l7ekUxF0Ve7giLqKLJeKjRpZA6Z8n5gQWfuDKlmufpxVzZ
xVkdbhSFqSg4u+gN52TWi2rkzBpoxdTWxSgXF5L/QGQnPxeTIreK7MH4c+G6zLxN
YSyY+q7oRx/aM4rvbVybVuoQr/DWniCYl3V1G+5ZXlMgXYv6iMAE3oXSsh8MI4tu
6ucMf+cvCl+T9uBZGi+BQ+WZdZ/dNEHAVkeQP2faNLXpnTOMFoHtOO8ajD6+BBaB
jfNCe21YyW9o4oGTsva66IuzOPNDLkYyY5bgn8vTZ7CytN1cTz290bzr/TsxLlVb
ArD+GGPxdVIL10N6vKXBqVWuxK/73P/2Ag2bXOpx9GAWOUcmxOZJr2FN6qSR2dWw
xZHdT9C1bYbI5c2JKcTae2jvvmvpx8hDvFIkZeRTeGsZFqRIg9qKJ+g5p4eelrbF
OrVHbRnji0COsFiE9GXdaGShKLM2Gdd2Vr5aMyC6N5jG1UjxmCglmOM/Yp4BgF/8
up+p5gokiF4VDmY9MElIwNbQ0qfOq9yhyvd5I7svPKJGrC1Zdxs=
=K9P3
-----END PGP SIGNATURE-----

--mMrZauSHmHzl6OKZzqjVFZbr6v3JtsNsW--

