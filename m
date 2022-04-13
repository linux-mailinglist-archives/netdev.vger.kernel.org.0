Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA7924FFD25
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 19:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237498AbiDMRzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 13:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233973AbiDMRzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 13:55:46 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21BE6D4FE
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 10:53:24 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-2db2add4516so31340667b3.1
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 10:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RyDA9iTfWDztFEqgkjQ89chzQS7kxTaj+KPUwJ15bKQ=;
        b=hm/d5hw0nIb0T07H45j4gZMonAjBta7sGE/+gSqIL0ZfSSa/i6jk87hXkRSs7z/C/R
         60JnUaEuDn6DUDyPkIggKlVmAjiDTk/GQ9G/K/CI/Lm/vr+QIlfxHICshK8N13g1rBuh
         YrPka14d4JSk4qIJngtB173o0mOdiR4YgL6L760zRUikxvhg5TE0FZv7l4ezoZYu7B+V
         Qq+htzJHXO80lH3F1krxeje45ufFPml7qJsln/xNg/7PeZZ59HPVjDKkshG421Fxel1B
         BD61+ZtykRVGIM+sF3Z5LJCxQNE7xrXhVgpsB3QLLikglWiNO9XhjdL9JqPSAd/SV50s
         V5RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RyDA9iTfWDztFEqgkjQ89chzQS7kxTaj+KPUwJ15bKQ=;
        b=s6g9mm1Lj1Gl8QeKquxecKgFOMAoJJvq7EGveRLxqcmaiIaFLb9SIVnoBAi8JEfLpO
         O4wvK8qc5qNAwsKgY+HicLEpPF6vR1vuiGRNcS9q3Dl5HnDDBVgOeV7/ECRIWbfhjyY0
         Xc2z6SZQo4jOgcCDYr2CN/dDWPl6EF5S955Mm2KnU4zRS/482mv+6a+gnepw3fElY2c8
         9P0nW7ajfawKPB5XWuwmEx3FAphtmoQA0mKvTlR4qUBwwOt0ExhszYrHc4WUk9JVWnNh
         ucYFZHEmeCN4b9TpoeXmSWKB2xcola5XeWcsbjDO7i0g2SzS6Ygh4WJrJGu3jIGFM6TN
         iYDA==
X-Gm-Message-State: AOAM533v3nmAyfCVF4wLsIIk+FDaoC1TBQl3PPaBtiC7+mv97L18bkjo
        595XKdM1DWvXvLMMT6/zNDhgYGvXP6OJkMXuoMYUaA==
X-Google-Smtp-Source: ABdhPJwExmug60eQjdpe2sIF2Eb8k/QhuTphLsiPFCLbDhrEUkyvWzjHgHxme2qSemiF2GV3585ju2b+b2Wogr8btKI=
X-Received: by 2002:a0d:cb86:0:b0:2ec:894:aa51 with SMTP id
 n128-20020a0dcb86000000b002ec0894aa51mr27535ywd.467.1649872403635; Wed, 13
 Apr 2022 10:53:23 -0700 (PDT)
MIME-Version: 1.0
References: <164984498582.2000115.4023190177137486137.stgit@warthog.procyon.org.uk>
 <CANn89iLEch=H9OJpwue7HVJNPxxn-TobRyoATHTrSdetwpHVXA@mail.gmail.com> <2419532.1649871672@warthog.procyon.org.uk>
In-Reply-To: <2419532.1649871672@warthog.procyon.org.uk>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 13 Apr 2022 10:53:12 -0700
Message-ID: <CANn89iK=8Z2dznM_SVGtk3NsXu3PK_BOBnCOM2ZgFtKe-mBOyA@mail.gmail.com>
Subject: Re: [PATCH net] rxrpc: Restore removed timer deletion
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Apr 13, 2022 at 10:41 AM David Howells <dhowells@redhat.com> wrote:
>
> Eric Dumazet <edumazet@google.com> wrote:
>
> > ok... so we have a timer and a work queue, both activating each other
> > in kind of a ping pong ?
>
> Yes.  I want to emit regular keepalive pokes.
>
> > Any particular reason not using delayed works ?
>
> Because there's a race between starting the keepalive timer when a new peer is
> added and when the keepalive worker is resetting the timer for the next peer
> in the list.  This is why I'm using timer_reduce().  delayed_work doesn't
> currently have such a facility.  It's not simple to add because
> try_to_grab_pending() as called from mod_delayed_work_on() cancels the timer -
> which is not what I want it to do.
>

SGTM, thanks !

Reviewed-by: Eric Dumazet <edumazet@google.com>
