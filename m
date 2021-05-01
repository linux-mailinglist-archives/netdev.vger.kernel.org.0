Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F975370947
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 00:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbhEAW4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 18:56:43 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:35355 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231266AbhEAW4m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 May 2021 18:56:42 -0400
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 141MtXDx028102;
        Sun, 2 May 2021 00:55:38 +0200
Received: from imac-di-mac.homenet.telecomitalia.it (host-79-17-226-205.retail.telecomitalia.it [79.17.226.205])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 7A626121E10;
        Sun,  2 May 2021 00:55:29 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1619909729; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NY7ISbPCwp7ehsxTZ9MqZAsaXh3/VxsqmpAjy61u14U=;
        b=YbWYokTdSu2aGoxzU+pPcdF9D6LIL3cfLeBr7zitYKs8WVpYlZqFoLsXThO8SuKEACEhqj
        Pu7vLIheO60K2vBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1619909729; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NY7ISbPCwp7ehsxTZ9MqZAsaXh3/VxsqmpAjy61u14U=;
        b=FUPRhOCJYa9B1yAZjBC57O7lmuW292Lujv1zs8YPHMPLpX8hLzLNJFl2vDyBULD55477CS
        7XOUqCVAp0g64I0ubIEJMSqxqq0v4QmUNxIDbbrmntkGdRo6hxMynSdzzW002sS5+9wghX
        KYnTNpM3sqtsvdDsEKjyQywZELb+XWibTP0cHzC7CLv0Dm56HZMi0syMxLyW9ZRBq+XZxi
        LMix3gSGvgVXXCDC8pggB3HY0VBT9MDWBu3hUjxilQ7c1rk6Oqd6rAukuHE4RAlONTVe/G
        U0ZRleYBVYguFNSIelD38fB3n6dmu6hVWha0tr57q0Oz3Uhz6O1IHonSoSChdA==
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.7\))
Subject: Re: [iproute2-next] seg6: add counters support for SRv6 Behaviors
From:   Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
In-Reply-To: <44091450-1b0d-664f-07e6-7eff48ca92c7@gmail.com>
Date:   Sun, 2 May 2021 00:55:27 +0200
Cc:     David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "Prof. Stefano Salsano" <stefano.salsano@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Content-Transfer-Encoding: quoted-printable
Message-Id: <6AF1ABCB-3A12-4016-810F-703754D90463@uniroma2.it>
References: <20210427155543.32268-1-paolo.lungaroni@uniroma2.it>
 <44091450-1b0d-664f-07e6-7eff48ca92c7@gmail.com>
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
X-Mailer: Apple Mail (2.3445.9.7)
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il giorno 01 mag 2021, alle ore 17:14, David Ahern <dsahern@gmail.com> =
ha scritto:
>=20
> On 4/27/21 9:55 AM, Paolo Lungaroni wrote:
>> @@ -932,6 +997,11 @@ static int parse_encap_seg6local(struct rtattr =
*rta, size_t len, int *argcp,
>> 			if (!oif)
>> 				exit(nodev(*argv));
>> 			ret =3D rta_addattr32(rta, len, SEG6_LOCAL_OIF, =
oif);
>> +		} else if (strcmp(*argv, "count") =3D=3D 0) {
>> +			if (counters_ok++)
>> +				duparg2("count", *argv);
>> +			ret =3D seg6local_fill_counters(rta, len,
>> +						      =
SEG6_LOCAL_COUNTERS);
>> 		} else if (strcmp(*argv, "srh") =3D=3D 0) {
>> 			NEXT_ARG();
>> 			if (srh_ok++)
>>=20
>=20
> change looks fine. Can you send a v2 with the help and route.8 man =
page
> updates? Thanks,

sure, I will send a v2 in a couple of days.

Thanks,
Paolo.

