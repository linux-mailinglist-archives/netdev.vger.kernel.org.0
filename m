Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2906F080A
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 17:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244103AbjD0PPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 11:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244160AbjD0PPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 11:15:49 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3BAD49D5
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 08:15:39 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id e9e14a558f8ab-316d901b2ecso448995ab.0
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 08:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682608539; x=1685200539;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m3NZm02qT/2mcqNVEUtCmlQS07cZ3DMOnFXph9sZJFU=;
        b=Y+veLsJmzolFSmSnaMAwXxOj1ruRaBTUCbFFrqVXy3g/Ii5avu4zOXufFftlGkuMCQ
         MCIbgn2kq872PwNn64bYuLdyJXTW/FCR7/URDN7/qMZNfBhhiBWAb7NjwGNUC8aj3XoM
         8iatw1R/BySvzURAqTDYpBqXWg9dlG1kKKUWP+tZtgKtqgB2T8FSOGZi0faWDkxED223
         aAgZd87iaWG7ki5vrhkdYSz3LTzD5hQ44sMwgRY2/jQ2kC/fWE2t5TBBZCTLY7TyPhtN
         hucQ5tHq+AylrN0l59Xiv5Mwh3+W6VoyS7KhoXQGSWuVV85m7qq3R0EzGgKT0jbh33+R
         yeig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682608539; x=1685200539;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m3NZm02qT/2mcqNVEUtCmlQS07cZ3DMOnFXph9sZJFU=;
        b=G79jSvSAD79EzQYZciAqjVv5fDmEi/l/DtdkzICFoX78CVkzHPUuN3RIBPeV4q0srQ
         KRU3/r11ygwYXDuHyYD6EiJTkbGaD/h/BfgYWUegV7LZI5L6WJY3dZqPPs+Wm/mOltSm
         kftDdD9Yhu+wZsH5XfmHdUagtRxWYBMuA0OJwpwMvmcO/K5dZHwgCKvQ5AxxSDjUz7bY
         8clMYQVfOI1uX2pMFOjUInZXAWGQFWoA7ODBV5q8DgZV033FDFP7RaOwjP5r385h7wu+
         /ZWOfLZmDDrXEJCRzca0FoNfNcRcj4Z+ZSJvviapDjQeTx1XedBbu+EQdmWwM04R88sB
         H2YA==
X-Gm-Message-State: AC+VfDwqwMRWLnKdKMdkRcMjt2LpmkuXaPWDslqSKHshVyObmNwC/ssR
        I4PjYBPHBRDA4K5fhajDyCr31eyXntzmk897AVo31w==
X-Google-Smtp-Source: ACHHUZ4mndXVZdWsmcbmVqgJibjxqDuWTLvNKSqIHX/5X63wjdgKP/ilM1hSYbd/C7rhtvqgxPASIE41MghntrsuN7M=
X-Received: by 2002:a05:6e02:170c:b0:328:3a25:4f2e with SMTP id
 u12-20020a056e02170c00b003283a254f2emr205381ill.9.1682608539181; Thu, 27 Apr
 2023 08:15:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230427134527.18127-1-atenart@kernel.org>
In-Reply-To: <20230427134527.18127-1-atenart@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 27 Apr 2023 17:15:27 +0200
Message-ID: <CANn89iK1=r21a66FVxYf3Zfecvs-QYjkZS+atArRJfJxYw=26Q@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] net: tcp: make txhash use consistent for IPv4
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 27, 2023 at 3:45=E2=80=AFPM Antoine Tenart <atenart@kernel.org>=
 wrote:
>
> Hello,
>
> Series is divided in two parts. First two commits make the txhash (used
> for the skb hash in TCP) to be consistent for all IPv4/TCP packets (IPv6
> doesn't have the same issue). Last two commits improve doc/comment
> hash-related parts.
>
> One example is when using OvS with dp_hash, which uses skb->hash, to
> select a path. We'd like packets from the same flow to be consistent, as
> well as the hash being stable over time when using net.core.txrehash=3D0.
> Same applies for kernel ECMP which also can use skb->hash.

How do you plan to test these patches ?

>
> IMHO the series makes sense in net-next, but we could argue (some)
> commits be seen as fixes and I can resend if necessary.

net-next is closed...
