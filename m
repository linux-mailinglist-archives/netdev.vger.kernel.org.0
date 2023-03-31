Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3996D160A
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 05:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjCaDep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 23:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjCaDen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 23:34:43 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033F5CA28
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 20:34:42 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id v5so8347616ilj.4
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 20:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680233681;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fJ4L8MBmmlbqXwxa+QtgaSaY5jzVQBlwTK3f8gdCHCk=;
        b=HQGH3vCmiVO+8G7jt9dVAHVVFx10k0O8/wlp7DhiwFCC+mGptxyo9PikU9fk8zKTK2
         x6z8WQNjKLMDqSzXFgf9npEDHnB6SeHMUO1f2pc2j9oHdLKMi/+64Ym2zo2lhXFNdwNp
         7nPgxBIvT1txt+RDDII8gip/N83X7o6Tzcs3dvr4zZbdtxrzV1fKWl12Ww369nsoY/VE
         Uaw00gMinrZ/i974kQm8qJ+jf8YsIKX8b1NB15ctGsBxS1FoZ4K6VXrQjRy5/fUK5BcC
         03m/GyGtJw/xaU0tANnxLObSCoQhdlUqY7XGqH79wK2C50LLrejILELSWFdyu/YacGbi
         hCIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680233681;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fJ4L8MBmmlbqXwxa+QtgaSaY5jzVQBlwTK3f8gdCHCk=;
        b=s1e83n6+awz4m9l2K3eS4RbpKDir1aSIlAxonu+GBIX4MdKQsm2om1+8WM6OfWIdzq
         497R7DxybddxZ2wocl4Q+ydqkf18FmoY94K+lnBjcLEHOYIC1yDIeq6woQSbxL4ojXi8
         PReGmtnuHxc+PHcg+HuVM/KFpFd5MCOdZcfkXxaRx3vToQwELQhempxdX+Io0H0VC95x
         5PuhccfF4T6LH2gNxwEJOnHYuB8YflA6UNEeFQbbcuFQvHjjoTwvY2Pu4pUWzNfac8Lj
         iS52P0lWkKp6Sga7f6GLb00uF4EEIHCow0a2iM891V968NG2YQZwkbxJdBwgRNHA+wCT
         Bq2w==
X-Gm-Message-State: AAQBX9djBpRpDG3DAhlHe3attSQ1Vv4G/dVUIqypg/G8vlQdZ6oiCCQK
        tWYOXIf4a9mk/b8p1PFOV7qXBVBd41NtTnwNA4+FUg==
X-Google-Smtp-Source: AKy350YNf3Z5u8AVlbz1MzR0N1B1tSKBQgfqMA5yfIgJB4ijZ2BuxzKcvB9/+8TZ0n42y7cnuNXy1PX6xFLYxuQcVLw=
X-Received: by 2002:a92:cda6:0:b0:313:f870:58fb with SMTP id
 g6-20020a92cda6000000b00313f87058fbmr12476623ild.2.1680233681202; Thu, 30 Mar
 2023 20:34:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230331022144.2998493-1-kuba@kernel.org> <CANn89iL99-uzrktK=hKLrmoWhhqCnH5rNUC9K4W9cOs+CQrbdA@mail.gmail.com>
 <20230330202333.108dadd9@kernel.org>
In-Reply-To: <20230330202333.108dadd9@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 31 Mar 2023 05:34:29 +0200
Message-ID: <CANn89iKoxQ2hjZaEQyLbD0Xt3s6uewU4pSyLKiW7HPz5bcM9gw@mail.gmail.com>
Subject: Re: [PATCH net] net: don't let netpoll invoke NAPI if in xmit context
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        Roman Gushchin <roman.gushchin@linux.dev>, leitao@debian.org,
        shemminger@linux.foundation.org
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

On Fri, Mar 31, 2023 at 5:23=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Fri, 31 Mar 2023 04:41:23 +0200 Eric Dumazet wrote:
> > Note that we update WRITE_ONCE(txq->xmit_lock_owner, cpu) _after_
> > spin_lock(&txq->_xmit_lock);
> >
> > So there is a tiny window I think, for missing that we got the
> > spinlock, but I do not see how to avoid it without excessive cost.
>
> Ugh, true. Hopefully the chances of taking an IRQ which tries to print
> something between those two instructions are fairly low.
>
> I was considering using dev_recursion_level() but AFAICT we don't
> currently bump it when dequeuing from the qdisc..

SGTM, thanks.

Reviewed-by: Eric Dumazet <edumazet@google.com>
