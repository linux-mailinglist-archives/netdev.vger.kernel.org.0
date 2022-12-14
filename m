Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A46D64CFFF
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 20:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238046AbiLNTTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 14:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239134AbiLNTSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 14:18:36 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B44E2B267
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 11:18:08 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id t17so7986134pjo.3
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 11:18:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4WOA8HZ1xBUzETGx9Vz6eEj1inwn6zRTWDCgCJNL7hQ=;
        b=p7wbCGL1CpRaKJRvhh9u+ieDd/cBKCQIhSE9E4LO61kcbyC/HAEfR4+puG2i0sZm9J
         YugzjIJhPx4WKLhkM5AfMbo3ARuv8WHbYFg1yjo2H+pjRkB14CMYuoUJgijm1l7traGZ
         ZRGxHRGGuefcF5oshGDvukmEmFZoazRQrbdhakxVx2k45IIZ9MpwXPIrTwFwwHr784XJ
         zfcusM0xCvCu1dbJHZzfne9izlh+YxqScGjapCgWuf0evggaORjTxXwld2DRPMCxmUNt
         1CpCke/jE35Nvb0hcVUSqbtCzqavBo9Gc0GDB7c52OkXmTVZ9kJPlRgxjXpufQs+j+PC
         CJkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4WOA8HZ1xBUzETGx9Vz6eEj1inwn6zRTWDCgCJNL7hQ=;
        b=gTfvDBgHOlsfphMdJsjN2coCnG+cxhEarj1PJo03MTW7CtlG2rlxYcSmybgoL0AGfg
         6gP6BBSqu6pP2WHtqHqvenwhDHvTFU3JtcRSWPOjB6vVTbenaYGKt/aPdUP72HdHNo+P
         PBBGedsImjhRp9klON/oRY8BkyRqiZMOKOZGSKajpfQ0NUZBySnGCJwtXhdla1JTa6TX
         ywaWwXFrwC+Q6RJxnMECMSVM5o0L9IiRNhj6PiHX0itIrs3rnZVFP2vaZUr0AjRmVgaY
         NFjAvkyl+aPEeHvioSZLlKocHEi46mRl1J9Zc7S953bJZabcWnZhTTlJz7le2q75qHwU
         tMbg==
X-Gm-Message-State: ANoB5pnuhbkXmMj/74Qfp+1dZEO/Ndtxxa8mOG9KHR0Le2tGVTxMXXBK
        sBuziXWlgV3XTIf24+D9rUPWx7bytb0=
X-Google-Smtp-Source: AA0mqf7nVYexeDgjvQlDVLrSwt3TV6jNqUYBkjNLpfvii64AecAU3hWPXDX6o0QYR2fknkz/PSmpLQ==
X-Received: by 2002:a05:6a20:1395:b0:a9:e225:6f7b with SMTP id w21-20020a056a20139500b000a9e2256f7bmr47595761pzh.0.1671045487660;
        Wed, 14 Dec 2022 11:18:07 -0800 (PST)
Received: from [192.168.0.128] ([98.97.42.38])
        by smtp.googlemail.com with ESMTPSA id f1-20020a635541000000b0047917991e83sm201578pgm.48.2022.12.14.11.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 11:18:07 -0800 (PST)
Message-ID: <83daafadbf10945692689aa9431e42c8e790d3b7.camel@gmail.com>
Subject: Re: [PATCH v1 net] af_unix: Add error handling in af_unix_init().
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "Denis V. Lunev" <den@openvz.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
Date:   Wed, 14 Dec 2022 11:18:05 -0800
In-Reply-To: <20221214092008.47330-1-kuniyu@amazon.com>
References: <20221214092008.47330-1-kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
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

On Wed, 2022-12-14 at 18:20 +0900, Kuniyuki Iwashima wrote:
> sock_register() and register_pernet_subsys() in af_unix_init() could
> fail.
>=20
> For example, after loading another PF_UNIX module (it's improbable
> though), loading unix.ko fails at sock_register() and leaks slab
> memory.  Also, register_pernet_subsys() fails when running out of
> memory.
>=20
> Let's handle errors appropriately.
>=20
> Fixes: 097e66c57845 ("[NET]: Make AF_UNIX per network namespace safe [v2]=
")
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>

So the "Fixes" tags for this are no good. The 2nd one is from the start
of using git for the kernel. As such I am suspecting that this isn't
fixing a patch that introduced an issue.

Since it doesn't really seem like this is fixing an issue other than
adding some additional exception handling. I would suggest getting rid
of the "Fixes" tags and just submitting this for net-next once the
window opens.

The code itself looks fine, but I don't think it is really fixing much
either. If you want to wait to submit this for net-next you can include
this:

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

