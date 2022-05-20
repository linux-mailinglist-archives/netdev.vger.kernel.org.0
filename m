Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A77F252F558
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 23:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353759AbiETVxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 17:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236955AbiETVxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 17:53:53 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C333B193212
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 14:53:52 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id d137so16208683ybc.13
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 14:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u+vxzOC+e+K4YlTbhvwasA4pWfk68i0BGc1264DuI50=;
        b=s9MDIDi3WtqND7yM9Rdjo2fcYZ4ODNGaOQk8NCmX5vYHsQ8YrjQbSh9zBAZHZ2F+pp
         nUpnWK1+TBRcfn+ptLmcmXc9ELq25zU30xF537AY0iY90JMcgdxxG3jYCKX5JDLSb+PS
         ElYCaftSwKPnQk1RH+6zeYZldDHTnzGrgOvv6M36JAqRqqPKXn5pqZ+GMUQtDdyug/VB
         8nXtB0WpHEhor9Qq8XbOh/FWYN5QU/qXql1kRiygg0nW08AdDbVMR8ygDvkwVy2vjLTf
         YgAjgfeZ86V/gpLjqBWkQdGxB6QlKh/qd6Qwi2lT82YFCMwyiVtCISVK6lLtUkfPg2vl
         L44A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u+vxzOC+e+K4YlTbhvwasA4pWfk68i0BGc1264DuI50=;
        b=IG10+T2rR3IBAjJht/vCPddU4ZQUjeBsfhqlUqoSvRt1cJiuR0GpeI6hAz8oirGfm/
         ZV/YI95aQ8gOXogovRDCseMEVYLjcOzZj7sjRhKZMGWznWOJ/LWSYDXjHgHGmm531v2e
         D54gNkEyUIjCb6txKeBNkd5dZiipUwOULY4uySZrtEvATwbAsE9Cgz379FWg8OwmexUg
         gyzC09upCAwOZFaoHsIu9+ja0roERMkYNyUc1VfJT9W+Y90SHiQaCvTv8SaL9ReQe1HJ
         1PpzEeAFvmiwnqTfsmaHMJPoB1UJZUqu4LoW8DjfYpd+ituM927YvHsKRFEx4ny6FKbd
         Wb9w==
X-Gm-Message-State: AOAM531c2tK3JgHORtaJzG/NBZG05QqdInV+i6rat2iwDakX2MpSW0fX
        yzSSGsgQI7z0x4xgPsL5z5QERVk7+nJ68n4+sXCo4A==
X-Google-Smtp-Source: ABdhPJz0oeLWlsoWR6ZLCr2hEL3m1WSrRN88nO60jLlMmteRPZeK1tA414up8t2Q84SE0o1SEZtoXlhgyd96rwiDxHw=
X-Received: by 2002:a05:6902:13c4:b0:64d:5e80:142 with SMTP id
 y4-20020a05690213c400b0064d5e800142mr11134044ybu.55.1653083631765; Fri, 20
 May 2022 14:53:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220518185522.2038683-1-kuba@kernel.org>
In-Reply-To: <20220518185522.2038683-1-kuba@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 20 May 2022 14:53:40 -0700
Message-ID: <CANn89iK918nE4vCS2WUC2qFoH8YkCPXThytgKszSi3Edr0S8jQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: avoid strange behavior with skb_defer_max
 == 1
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>
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

On Wed, May 18, 2022 at 11:55 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> When user sets skb_defer_max to 1 the kick threshold is 0
> (half of 1). If we increment queue length before the check
> the kick will never happen, and the skb may get stranded.
> This is likely harmless but can be avoided by moving the
> increment after the check. This way skb_defer_max == 1
> will always kick. Still a silly config to have, but
> somehow that feels more correct.
>
> While at it drop a comment which seems to be outdated
> or confusing, and wrap the defer_count write with
> a WRITE_ONCE() since it's read on the fast path
> that avoids taking the lock.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---

SGTM thanks.

Reviewed-by: Eric Dumazet <edumazet@google.com>
