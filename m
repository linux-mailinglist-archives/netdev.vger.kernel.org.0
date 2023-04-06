Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 292236D9339
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 11:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjDFJuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 05:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236701AbjDFJtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 05:49:35 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB1B18E
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 02:47:57 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id y69so2140257ybe.2
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 02:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680774414;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FazgrPFY3djyzZPHPYX9nbN/ODMQXNog1/KIwCKeFDY=;
        b=X7uAqrbGclHVXqbYHSh/EAecrBEubuaY39NatmOxJE0XIXqV8zUrvnNRbRfyxqZkbc
         XoA5P3emiPKJCmTlP8dTV7Z7PY/gLsd/EA3OPXruLvTILNv4BQvr7691dHmjCJoCu/dv
         kSRJzazXWogjQWoS6uAM9rQR0SRZevXHSTgZ1puYjHxUEYABV/qTIeaV4IoGBLHRBG7z
         7vkXzUZTZ4IM1ED3JJwGLf2MYawCXHKQPp+q1lhO2vhETvQE8NZGWsn24RSx8ZXnImfR
         UcpU6yox1sEmDInIwFUPnzBR2K9m7QrY5R2HDAjL51azojaPsgDh33MezwbrMapIA5Yz
         d2+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680774414;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FazgrPFY3djyzZPHPYX9nbN/ODMQXNog1/KIwCKeFDY=;
        b=sRvqHV3s7SevMh97EWeUu0fCNkDmU8tXEEe8B3wCW1WVZPckHtr8nM0dFDUwRQIxQL
         Z5Ot+mdH2E7l3uC2SSPfBrauyO3pTIAqjY/OHh9hm4FZaAmISJ6rEqGVFw8lPWKEJyHG
         WhZS6XdPng8C7axKVMGC01csGjahmLpyZsVCZUGlv1nStsNmR+Ob7V3wVAlOEOizAFTe
         VL54lmtStdtcKlJXf2H1sjMl3kg3TBvX2QHyD0mTFgC4pa9i+zz8j2Puv0fiUoqtKGne
         iyMQIoO96ASWLao6j3UXLu+txCxCMKlSDNctDo3m9BbX7teYRy1JrDU6c7FR48UPpOqZ
         Ny3Q==
X-Gm-Message-State: AAQBX9ewoCjkMLjzSUsLu1ZjAo+EQR1QPJLtM1JhxI6qClT9XfOd6tV8
        GIf4KCzX8ojxg9ReY0i6E6Hmcu1meoW0KkWf8VANrQ==
X-Google-Smtp-Source: AKy350bq1WlXWlO1l5s2v33lxsNrk8T8LtvMzV0VPBJGlSoPDOhtqDrZ3Ce6iIYQONUD9yoeD0168koK8RkL0a8PXBY=
X-Received: by 2002:a25:da46:0:b0:b09:6f3d:ea1f with SMTP id
 n67-20020a25da46000000b00b096f3dea1fmr1704437ybf.4.1680774414032; Thu, 06 Apr
 2023 02:46:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230406094245.3633290-1-dhowells@redhat.com>
In-Reply-To: <20230406094245.3633290-1-dhowells@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 6 Apr 2023 11:46:42 +0200
Message-ID: <CANn89iLFc3gxo-5gEn36VFYdocXQPiAqRsTPEHcB8JA3mw8+8g@mail.gmail.com>
Subject: Re: [PATCH net-next v5 00/19] splice, net: Replace sendpage with
 sendmsg(MSG_SPLICE_PAGES), part 1
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 6, 2023 at 11:42=E2=80=AFAM David Howells <dhowells@redhat.com>=
 wrote:
>
> Here's the first tranche of patches towards providing a MSG_SPLICE_PAGES
> internal sendmsg flag that is intended to replace the ->sendpage() op wit=
h
> calls to sendmsg().  MSG_SPLICE is a hint that tells the protocol that it
> should splice the pages supplied if it can and copy them if not.
>

I find this patch series quite big/risky for 6.4

Can you spell out why we need "unspliceable pages support" ?
This seems to add quite a lot of code in fast paths.
Thanks.
