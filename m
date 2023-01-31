Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64CE2682BCA
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 12:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjAaLtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 06:49:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjAaLs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 06:48:59 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208143A88;
        Tue, 31 Jan 2023 03:48:58 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id v10so14112354edi.8;
        Tue, 31 Jan 2023 03:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KA/6v65JHISORnR8UYFr5pvgEPglVJPcah6RD9iD6VE=;
        b=Nujw77PuiFGn4klGYhioYQbFGnOrgJ94CGJa5iR4+YvGmUEVubXX2R7LgcGa5pgJgx
         X8of2j5/hnuPxExovpETezwRrqd+uybx7A3iSuwnMQw9fbu3lRMBBqyo9F90HwqJD5h3
         L7KvzKP2KymKW7PufIKYVbmDkD0eXYEiOryTL1ubA2dj6fH1L5kgWww79L9DufgGyadA
         3+frBKN1mBG5k/ng9iZCpZU/0SiEEdvIo/ikIjUIT7raUBlfFBhxN4DwsxYf5FSfi3du
         Z6EXaZ25lZ136m7I0vZpi1on1YoulBFXRdVwUVjBOg4NkHCkNhh2gMbPqoBxAjxir47d
         wKoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KA/6v65JHISORnR8UYFr5pvgEPglVJPcah6RD9iD6VE=;
        b=PzCohUSsM4dq6L3PwAeY+hqXKfd4MO0ciM+eWgOuc+WjNcKyP3cqoZITgxvm9SUIZG
         tdUDXBHfk72gMRcO8yedkgSKq5p3rbqXB2QZg7DxYrAbmxvNzdh2CO1RBnFETU/mH4nW
         q74t1V6lEzAJOBxZqeJaRlFhoVM213xf8mKCF7Oq3NKrXRtOU5Bu0uXPTCCopu9q2Kdz
         /Pk1+P575+L+hDhcOMsRP2LHnrWx8vRpus8fhlHe9LyBpD8F6onMz5tf840RS30PNd8P
         f3IssnTS4Fs4qgnQeL0DdIVf7uDXnA+feNzwjYD8VXeElJwlOAvH1SP4UmKmEHBlN8O+
         l4Eg==
X-Gm-Message-State: AO0yUKVGgAmi8CGFRW0UAGU9wjjmF52oxq9eMO1LhhAQdo4+0ltA5J7i
        7lxQ3SW2RHP1e+1BwifaJxw=
X-Google-Smtp-Source: AK7set9ONJUUydSWVsEW0vZ9wMG/FheHDnZ8BZqxw4WCElT9fs9JUTmls799MvxYJrqGxDexRGY09w==
X-Received: by 2002:a05:6402:2421:b0:49e:ed9c:215f with SMTP id t33-20020a056402242100b0049eed9c215fmr22203261eda.38.1675165736692;
        Tue, 31 Jan 2023 03:48:56 -0800 (PST)
Received: from touko.myxoz.lan (90-224-45-44-no2390.tbcn.telia.com. [90.224.45.44])
        by smtp.gmail.com with ESMTPSA id a6-20020aa7cf06000000b004a23558f01fsm4190147edy.43.2023.01.31.03.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 03:48:56 -0800 (PST)
Message-ID: <a9d5c49536b3dc5039d981952aa60db6266516e2.camel@gmail.com>
Subject: Re: [UNTESTED PATCH] net/usb: kalmia: Fix uninit-value in
 kalmia_send_init_packet
From:   Miko Larsson <mikoxyzzz@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 31 Jan 2023 12:48:54 +0100
In-Reply-To: <Y9j9jAHLDBsTxZB7@kroah.com>
References: <7266fe67c835f90e5c257129014a63e79e849ef9.camel@gmail.com>
         <Y9j9jAHLDBsTxZB7@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.module_f37+15877+cf3308f9) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-01-31 at 12:37 +0100, Greg KH wrote:
> On Tue, Jan 31, 2023 at 12:14:54PM +0100, Miko Larsson wrote:
> > > From ef617d8df22945b871ab989e25c07d7c60ae21f6 Mon Sep 17 00:00:00
> > > 2001
> > From: Miko Larsson <mikoxyzzz@gmail.com>
> > Date: Tue, 31 Jan 2023 11:01:20 +0100
>=20
> Why is this in the changelog text?
D'oh, sorry about that. Imported the patch directly into Evolution
without trimming that away.

> > Subject: [UNTESTED PATCH] net/usb: kalmia: Fix uninit-value in
> > kalmia_send_init_packet
> >=20
> > syzbot reports that act_len in kalmia_send_init_packet() is
> > uninitialized. Attempt to fix this by initializing it to 0.
>=20
> You can send patches to syzbot to have it test things, have you tried
> that?
Didn't know that, will try!

--=20
~miko
