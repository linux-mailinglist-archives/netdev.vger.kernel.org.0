Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D63BD305673
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 10:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234949AbhA0JG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 04:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234335AbhA0JEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 04:04:36 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4B9C061573
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 01:03:55 -0800 (PST)
From:   Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1611738234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1u36hpoLD/DdxchMkselsxB05sjOdJH6kXFKjz0bs3E=;
        b=qqcDxKfPxpmk6CwA+8+uw/P56kVgH3WeDo6BLFhQS3UKxBn66F5MGNnN474Z043nngzlHM
        iBx/MItBtDE/ZfHbAJeiMcSTZj76NhxfCAicDnritDYzblTWjC5q9eOqaSrX8JWVYo3QkX
        bEDb+OXaQsDonmoP3xCaJ8oIkWJaKqByMTDl7AawBG4e/ydCXBNO1qLifSnAKLv0BQnW0c
        PJlJCaw1krNwtcjW4PUmnkxhssL2gB0OkW57G/BvwXLsvHRmBQd0JnSQKM3cSPmuvGYnww
        LbSZYT+S0eorNS59JEHr7rsj14zVJj9/guKTFZyKMYvVAAlh7VCu/oxrWWVXzw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1611738234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1u36hpoLD/DdxchMkselsxB05sjOdJH6kXFKjz0bs3E=;
        b=DqGBp/w3OIwfALewbhYL6NxHJMr+tOSn3qJRuwpSA5cLi0l3IPNjDJpvJUfvCNCh70Dra9
        sxpHaVmJr+BQ31Dg==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs\@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong\@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri\@resnulli.us" <jiri@resnulli.us>,
        "kuba\@kernel.org" <kuba@kernel.org>,
        "Jose.Abreu\@synopsys.com" <Jose.Abreu@synopsys.com>,
        Po Liu <po.liu@nxp.com>,
        "intel-wired-lan\@lists.osuosl.org" 
        <intel-wired-lan@lists.osuosl.org>,
        "anthony.l.nguyen\@intel.com" <anthony.l.nguyen@intel.com>,
        "mkubecek\@suse.cz" <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v3 5/8] igc: Avoid TX Hangs because long cycles
In-Reply-To: <20210126000228.gpyh3rrp662wysit@skbuf>
References: <20210122224453.4161729-1-vinicius.gomes@intel.com> <20210122224453.4161729-6-vinicius.gomes@intel.com> <20210126000228.gpyh3rrp662wysit@skbuf>
Date:   Wed, 27 Jan 2021 10:03:53 +0100
Message-ID: <87czxqda4m.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue Jan 26 2021, Vladimir Oltean wrote:
> On Fri, Jan 22, 2021 at 02:44:50PM -0800, Vinicius Costa Gomes wrote:
>> Avoid possible TX Hangs caused by using long Qbv cycles. In some
>> cases, using long cycles (more than 1 second) can cause transmissions
>> to be blocked for that time. As the TX Hang timeout is close to 1
>> second, we may need to reduce the cycle time to something more
>> reasonable: the value chosen is 1ms.
>>=20
>> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>> ---
>
> Don't you want this patch to go to 'net' and be backported?

I'm wondering about this patch as well. Is this fix related to frame
preemption? If I understand the code correctly the 1sec is a dummy cycle
and all queues are open. How should Tx hang then?

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmARLHkACgkQeSpbgcuY
8KYw8xAApAhXYhm/AZcD2FuRDeZ/OIPPzW+J6C/nOf105TTBpGqEAWaGhBURtl1i
ZOCt8BV9e2KTLj/+cfcmkcBVIMOonYxwo7CWYNU8M1S2s0W/FZWm6Aj4bPYqM3oh
ZxfuKwCzfro6rjt5I8qLC15pCxM3SW0d7HCDBCBseZdt1QkWNTsCRUJojbLkFQ5P
4V4sFrAgwo6sORLPswvrCLtYK3gIfEBtwNwdldQBLxC7o2EoScixyFvjDF4ArDc1
Gx69tNjMHdSEw2yWuxdZEaN2GM9taoJqWJs9Q/Hra/3wDPL5aLli+V8LxPUvhtDt
iBG01C/gldi3T+JnEmasj4eR/3v6/Nj5+Fr2sCp5dRSB7oGzqsc0eQMf3bN0FK/u
qjBtMxrSwQ51pPgZYLyzI6Lzg+Ji6zJtP6y2UF1BS2VxggtjPwX/cCb5B+9yXrnG
NFjkBNPET/k+5ylJXiB1W+5/mSsS5uajrCi4qreXrL0CiGlVd1w+Ee/zN0RR5Uhf
/fv6WJdibTk2QNL2eVJwC7VP3IVSswHeW8so519Gq7phltvlMXkC9wW8ghNGgxmi
eCg0AmeqotkGtF/MkuyAv8L657cIlnOjjRWREk1J+ASKh/rUchFYe/+p3U0Cmldp
yTj/eQ/+oFa76dvtC4aFyzk0355gyb7Duww6UX2TjuXhOe3B+0A=
=TJzX
-----END PGP SIGNATURE-----
--=-=-=--
