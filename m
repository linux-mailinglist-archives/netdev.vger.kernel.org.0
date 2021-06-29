Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E0A3B6E78
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 08:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbhF2HBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 03:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232073AbhF2HBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 03:01:45 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 993D7C061574
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 23:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Message-ID:From:CC:To:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:
        Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=YQ52BsnwqUFNqlbLCvUzdDmMijMZthEXJKmIUcfCJ+4=; b=IL3UTKGYU02+RoboincuUN/XCI
        xhTsvN/UifXVcfhFrhLVwQXhEnlEcwKtdASweVEB+C9gB9siuUrMXHzh/nd7L6J09XvWWdORppuI3
        DPRNHI6gavv9rK/uWq/eGK4s2PjQ0sm8X9kw8/Yuag9mfHITQClM7zFXghNHJGLdMq08DBPMkPPXc
        /tOQ4bYHOcpZmwckw4TUps3yXGC3uhKkETak9TSdbByAkVYE+L63sFcmZhto7nHcSOOEmvoOuT7uD
        yWeHCfmMdy7yq0+2mV1dri3qLY+uMHQ3V7iM/5gOuMYyKvRstKaXREEkYUJKDS9gxGnMjOhTNW5lX
        YevgBFsA==;
Received: from [2001:8b0:10b:1:3ca7:fbf:55e4:e1a1]
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ly7iG-00CoeD-Cu; Tue, 29 Jun 2021 06:59:16 +0000
Date:   Tue, 29 Jun 2021 07:59:13 +0100
User-Agent: K-9 Mail for Android
In-Reply-To: <99496947-8171-d252-66d3-0af12c62fd2c@redhat.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org> <20210624123005.1301761-1-dwmw2@infradead.org> <20210624123005.1301761-3-dwmw2@infradead.org> <b339549d-c8f1-1e56-2759-f7b15ee8eca1@redhat.com> <bfad641875aff8ff008dd7f9a072c5aa980703f4.camel@infradead.org> <1c6110d9-2a45-f766-9d9a-e2996c14b748@redhat.com> <72dfecd426d183615c0dd4c2e68690b0e95dd739.camel@infradead.org> <80f61c54a2b39cb129e8606f843f7ace605d67e0.camel@infradead.org> <99496947-8171-d252-66d3-0af12c62fd2c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3 3/5] vhost_net: remove virtio_net_hdr validation, let tun/tap do it themselves
To:     Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org
CC:     =?ISO-8859-1?Q?Eugenio_P=E9rez?= <eperezma@redhat.com>,
        Willem de Bruijn <willemb@google.com>
From:   David Woodhouse <dwmw2@infradead.org>
Message-ID: <CCEDFBF6-0E63-40BA-8F29-55222113BA45@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 29 June 2021 04:43:15 BST, Jason Wang <jasowang@redhat=2Ecom> wrote:
>
>=E5=9C=A8 2021/6/29 =E4=B8=8A=E5=8D=887:29, David Woodhouse =E5=86=99=E9=
=81=93:
>> On Mon, 2021-06-28 at 12:23 +0100, David Woodhouse wrote:
>>> To be clear: from the point of view of my *application* I don't care
>>> about any of this; my only motivation here is to clean up the kernel
>>> behaviour and make life easier for potential future users=2E I have
>found
>>> a setup that works in today's kernels (even though I have to disable
>>> XDP, and have to use a virtio header that I don't want), and will
>stick
>>> with that for now, if I actually commit it to my master branch at
>all:
>>>
>https://gitlab=2Ecom/openconnect/openconnect/-/commit/0da4fe43b886403e6
>>>
>>> I might yet abandon it because I haven't *yet* seen it go any faster
>>> than the code which just does read()/write() on the tun device from
>>> userspace=2E And without XDP or zerocopy it's not clear that it could
>>> ever give me any benefit that I couldn't achieve purely in userspace
>by
>>> having a separate thread to do tun device I/O=2E But we'll see=2E=2E=
=2E
>> I managed to do some proper testing, between EC2 c5 (Skylake) virtual
>> instances=2E
>>
>> The kernel on a c5=2Emetal can transmit (AES128-SHA1) ESP at about
>> 1=2E2Gb/s from iperf, as it seems to be doing it all from the iperf
>> thread=2E
>>
>> Before I started messing with OpenConnect, it could transmit 1=2E6Gb/s=
=2E
>>
>> When I pull in the 'stitched' AES+SHA code from OpenSSL instead of
>> doing the encryption and the HMAC in separate passes, I get to
>2=2E1Gb/s=2E
>>
>> Adding vhost support on top of that takes me to 2=2E46Gb/s, which is a
>> decent enough win=2E
>
>
>Interesting, I think the latency should be improved as well in this
>case=2E

I don't know about that=2E I figured it would be worse in the packet by pa=
cket case (especially VoIP traffic) since instead of just *writing* a packe=
t to the tun device, we stick it in the ring and then make the same write()=
 syscall on an eventfd to wake up the vhost thread which then has to do the=
 *same* copy_from_user() that could have happened directly in our own proce=
ss=2E

Maybe if I have a batch of only 1 or 2 packets I should just write it dire=
ctly=2E I still could :)

>> That's with OpenConnect taking 100% CPU, iperf3
>> taking 50% of another one, and the vhost kernel thread taking ~20%=2E
>>
>>

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
