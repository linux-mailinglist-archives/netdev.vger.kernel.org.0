Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F45484FE3
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 10:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiAEJTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 04:19:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiAEJTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 04:19:10 -0500
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E592FC061761;
        Wed,  5 Jan 2022 01:19:09 -0800 (PST)
Received: by mail-qv1-xf2c.google.com with SMTP id o10so36973218qvc.5;
        Wed, 05 Jan 2022 01:19:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:date:subject:from:to:cc:message-id:thread-topic
         :references:in-reply-to:mime-version:content-transfer-encoding;
        bh=Zy2ZAgaAUpRCCsLx1xedFVKI27rg6BQh6wtggQkfm18=;
        b=ju8aYAAQkIEpSn2l+mGJJ8XwVY0UkKWS3zVqJXK4pOkNDn/TcErUidu0lFmjMtx8au
         dprcOM41IVBlJbxGsBAqPV/hHzOgeMpu5dcltwJ+6gi0p4LxOVeCPCnvujvwr1Q7OkmA
         47afq9se7zhUTCK0PWLLFelzkafz7/kA5WIWhygoEEcpucVQu/5kFbuOBetkiW9jGnUP
         iNzE3O8RofC0dFfKKyniKiZha/VYyr18Pr2lEkVdimekHLRpBbrFEa/0qPNoIiEyrO4B
         5eeSP0cr9FipLkcevjLOKZpG96B2Q2IlF+4NwWKre6XQVvGrm5IT8zXyXJQHR9q6VPHo
         nn8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:user-agent:date:subject:from:to:cc:message-id
         :thread-topic:references:in-reply-to:mime-version
         :content-transfer-encoding;
        bh=Zy2ZAgaAUpRCCsLx1xedFVKI27rg6BQh6wtggQkfm18=;
        b=ZhMgpraHEqjDFNChox+lojvXkZ1AFBfxf3vkRy89jEYCqp6efSi7/oCezucO9++Qxy
         eRNp5RVevz0B9qdy/ZDHH6F01rKlbJ1ci4l9z9r/uadFRKZYt66FzfEoF6LNeIxkUpHX
         Vao2PXSeyq0ZBEu0L+/0kHPUbQsca6f079PXCYDAnZ5gWf8+2Rws9/SluGUxNX3oHSsZ
         1qVkLk32ktXqXxOIoMcu97ufIKD+gVLIsqGn3pSRZsfPJmB7Sh8uyjBg5s7FCCbhBbVX
         uby8XHOfihpiFViyuwmvHBqm8ZT9JPoFm5aYzDpohoDB+Pcuif0bK6cfmnQecntiBsC1
         3HYA==
X-Gm-Message-State: AOAM5330GUP/7KM7z8irHoZ9ZMJJXbxI9vHIc9i6JpQX1GMgvAv2Wgfp
        yqMo7tvIXHlkAVaq5jJouJM=
X-Google-Smtp-Source: ABdhPJx/PKjVfCCWveTe/ICqyQ4BObYTFbBS4bclzxtYJCZr5fnQA4JGdcDIQaiMKqumsNoHwoB94w==
X-Received: by 2002:ad4:5cac:: with SMTP id q12mr49611014qvh.37.1641374348977;
        Wed, 05 Jan 2022 01:19:08 -0800 (PST)
Received: from [30.135.82.253] ([23.98.35.75])
        by smtp.gmail.com with ESMTPSA id q12sm35069189qtx.16.2022.01.05.01.19.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jan 2022 01:19:08 -0800 (PST)
User-Agent: Microsoft-MacOutlook/16.56.21121100
Date:   Wed, 05 Jan 2022 17:19:00 +0800
Subject: Re: [PATCH] af_unix: missing lock releases in af_unix.c
From:   Ryan Cai <ycaibb@gmail.com>
To:     Shoaib Rao <rao.shoaib@oracle.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <cong.wang@bytedance.com>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <jiang.wang@bytedance.com>,
        <christian.brauner@ubuntu.com>, <kuniyu@amazon.co.jp>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
Message-ID: <9BADB912-9338-4798-94C4-AA6268C4CA06@gmail.com>
Thread-Topic: [PATCH] af_unix: missing lock releases in af_unix.c
References: <20220103135830.59118-1-ycaibb@gmail.com>
 <555a3e2b-3981-672d-c6cf-5ecb357d2fa6@oracle.com>
In-Reply-To: <555a3e2b-3981-672d-c6cf-5ecb357d2fa6@oracle.com>
Mime-version: 1.0
Content-type: text/plain;
        charset="UTF-8"
Content-transfer-encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Shoaib

          After further checking, the lock is indeed released at the out_fr=
ee. My patch is invalid. Sorry for the inconvenience.

Best,
Ryan

=EF=BB=BFOn 4/1/2022, 2:47 AM, "Shoaib Rao" <rao.shoaib@oracle.com> wrote:


    On 1/3/22 05:58, Ryan Cai wrote:
    > In method __unix_dgram_recvmsg, the lock u->iolock is not released wh=
en skb is true and loop breaks.
    >
    > Signed-off-by: Ryan Cai <ycaibb@gmail.com>
    > ---
    >   net/unix/af_unix.c | 1 +
    >   1 file changed, 1 insertion(+)
    >
    > diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
    > index b0bfc78e421c..b97972948d9d 100644
    > --- a/net/unix/af_unix.c
    > +++ b/net/unix/af_unix.c
    > @@ -2305,6 +2305,7 @@ int __unix_dgram_recvmsg(struct sock *sk, struc=
t msghdr *msg, size_t size,
    >   		if (skb) {
    >   			if (!(flags & MSG_PEEK))
    >   				scm_stat_del(sk, skb);
    > +			mutex_unlock(&u->iolock);
    >   			break;
    >   		}
    >  =20

    It seems to me that the unlock at the end will release the mutex?

    out_free:
             skb_free_datagram(sk, skb);
             mutex_unlock(&u->iolock);

    Shoaib



