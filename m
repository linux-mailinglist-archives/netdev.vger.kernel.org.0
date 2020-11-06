Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DE82A968D
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 13:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbgKFM6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 07:58:32 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:35266 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbgKFM6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 07:58:31 -0500
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604667508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=shG7AJpj82cx0oUcROwbU9VWQmTdciDrS6ngB9yxIsI=;
        b=XT8ck3tdgI8gpazP3uo9gZ3YlqtdHmdo+MHdiKukS1mBakVCU1hSQkmwy7SWadArJSVIPI
        +IsVliIg1BTkXIUCBY6fsctAv2AHc91I+tScG0CwKi12MxqQmKxkrIYk+3iQPZPYZPtIQq
        NzKnQ/lHnW5iMU0qwC83y1qRwkoPz+0KxeTMKoA7CsiypTkueTL1YD16tkRYfrsdVrF1oR
        EGO520h3I1JW5GhC/A9Yw4Osig43uVqrpaX105PlgOPKHVciocqHxDV4ZZ40eZU5Oa0kLP
        hqy8BN6a41+/ApkdXLes2EXIwFXZGbZHEiZ/nd77wqskP6D2JhFfgQdFVeX/+A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604667508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=shG7AJpj82cx0oUcROwbU9VWQmTdciDrS6ngB9yxIsI=;
        b=l1jx89VfA8343zcD85kbWd3IMbrAPDVCx+SenZX7zqcDAWEdOEYgfwru8Pl46clgdLkGfE
        kIJK+0WdY0yfNRAQ==
To:     Arnd Bergmann <arnd@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Wang Qing <wangqing@vivo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Zou <zou_wei@huawei.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/ethernet: update ret when ptp_clock is ERROR
In-Reply-To: <CAK8P3a0Dce3dYER0oJ+2FcV8UbJqCaAv7zSS6JZBdb6ewfnE7g@mail.gmail.com>
References: <1604649411-24886-1-git-send-email-wangqing@vivo.com> <fd46310f-0b4e-ac8b-b187-98438ee6bb60@ti.com> <CAK8P3a0Dce3dYER0oJ+2FcV8UbJqCaAv7zSS6JZBdb6ewfnE7g@mail.gmail.com>
Date:   Fri, 06 Nov 2020 13:58:18 +0100
Message-ID: <87pn4qmyl1.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Fri Nov 06 2020, Arnd Bergmann wrote:
> On Fri, Nov 6, 2020 at 12:35 PM Grygorii Strashko
> <grygorii.strashko@ti.com> wrote:
>> On 06/11/2020 09:56, Wang Qing wrote:
>
>> > +++ b/drivers/net/ethernet/ti/am65-cpts.c
>> > @@ -1001,8 +1001,7 @@ struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
>>
>> there is
>>         cpts->ptp_clock = ptp_clock_register(&cpts->ptp_info, cpts->dev);
>>
>>
>> >       if (IS_ERR_OR_NULL(cpts->ptp_clock)) {
>>
>> And ptp_clock_register() can return NULL only if PTP support is disabled.
>> In which case, we should not even get here.
>>
>> So, I'd propose to s/IS_ERR_OR_NULL/IS_ERR above,
>> and just assign ret = PTR_ERR(cpts->ptp_clock) here.
>
> Right, using IS_ERR_OR_NULL() is almost ever a mistake, either
> from misunderstanding the interface, or from a badly designed
> interface that needs to be changed.

The NULL case should be handled differently and it is documented:

/**
 * ptp_clock_register() - register a PTP hardware clock driver
[...]
 * Returns a valid pointer on success or PTR_ERR on failure.  If PHC
 * support is missing at the configuration level, this function
 * returns NULL, and drivers are expected to gracefully handle that
 * case separately.
 */

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl+lSGoACgkQeSpbgcuY
8KZp9BAAqQMVJ3ieO7c2694yqOwaG7+VL38Jv7x6L1Tjr1AFq1pnroPnS1oP+EPj
ESSOG5Zrdtya/+E3k8a+hbHpbrljlvkLlCv6SSZwRQuxSzuoeY+EDtqCTnYLXJqT
XtVwWWHRNWvFQivXSfbvfFAcP+TsL/1EMgehZgAcRD8LnmyCJgXeSaUY/NkHTIer
kIu0KPsfkFYFsTWdHcgzGh1n7PRZx9SLZTetJH4xqUd2YDE7WzFcrvBVrYutCGg/
Bu+aLOodUK1z0JJTIzAIl/Ug9O//10d1uiVdLF209wgUuDcIzN3HT6LNzZNfcPCE
IobDVvg09w+MayGx2wg1FROhsGLLmjbCtGc+wf+MySeTCXOlACvfVSsw7ULoKgCh
bE0CnOTg+5c0iYYMtavM6PwabO3XJTUTFfxYTtJpQ9GNDipjJZMqxfqXCUO4HuNQ
33fSBfmI54VWRb88ATVAYyLzosJzpNgYR5lbiw8A/zbBtynHQoCh9jpQXink78Y/
3xLxtDvWQQuSmRnPLrbcPc+T2Er3RVKNd9ZxeNGZbgu8OQmm75Zk01PNRL18tKwn
KO3EtDSyHFVJEmIa338qY+6x4GTuCa0L152og7kX4u8gECbK1WBOTS0pPeDbRcrq
cAVAy2/xPt5aG2/ygJpfHdNvMP740uix9g4lDxMNBpCNsEy/yr8=
=Dvwr
-----END PGP SIGNATURE-----
--=-=-=--
