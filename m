Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3096B53EC4E
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241462AbiFFQFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 12:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241450AbiFFQFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 12:05:31 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F82916646E
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 09:05:22 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-300628e76f3so147471667b3.12
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 09:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hkb/bGVyuMqTZRXVw6tHXbfDJb2Rv/dx6ERatAJ2rC0=;
        b=sWnen0QbVrpHJrYP5g4e/CpughJv5Xsf8460mMdBKUx4OTmW9Qr3EJjZH24KgWua78
         7SO6mkI+7tUe89LfbJsvCFDzlzdNeMw/gz1PVyPzlV50tpFc3IhJK1mSOpN9IJnBXgIg
         e0zSuMMRoHlevEhKJFjxeieKivjrkcWH3fivpf+3ozagiT6DrvjNMAmWx+uWXx/QH3Yb
         hKQPIrtydMfIlf4AGKk5CQ8cjr3EG1XPrlTBkEkTQbKjS6zhKIElw0kkgYB+uUipIsRQ
         qrBsNJCuvIfH2Ro5oe7HsiF7IpkIq6163YEEyjL0hHD0J0b/x/cAuqcGxch9bKP3rKD8
         8n9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hkb/bGVyuMqTZRXVw6tHXbfDJb2Rv/dx6ERatAJ2rC0=;
        b=HLgPEybKZWDRg4Y+kqhkgowIjshtuBKIxw/bnNad3GTHHcKjmI9vnEGopWt1EMaVwY
         1gAAlSSX9JMrvN1UjkpwM6I6tBZZI5A4s0S6pIYCcic3l6mwLm2j7PomuDLkpbpP++qC
         +3xexiob11y4oon3f18W3J0DE0yCPVIsz+74rzPwjlV6saHGUBeO5xj1cgBZyNACcsYk
         ZxYVMyoYUdrYO5RdzvMNDj/N8jJzE5C7An3t927j5fv4JnDB0yGb26EJSaKSJvMjqWKO
         p9ZiXGxVivRsPV88FRlFSl4V1DkbQ9ap5xmbWwZRagxKtynLcf3Z03t72OUu7ssXtqKW
         qdNQ==
X-Gm-Message-State: AOAM532nl6okMw/RkhDlNCchOZrq7bLXMoTI0Xz0XvsePsbB1xEMDiMX
        /3lRQa0Nw4ZN5wP4q35cx34+dAGECt9yUNITpn3e0g==
X-Google-Smtp-Source: ABdhPJwva2zNMNdY7W28yUe2zvaMfHOUFz8u4sZGR3aghRSe9HFp2eMiDV5XEb1NIf2ZbVxtbmqrDyTidCAc4E0ed5s=
X-Received: by 2002:a81:4811:0:b0:30c:8021:4690 with SMTP id
 v17-20020a814811000000b0030c80214690mr26771026ywa.47.1654531520769; Mon, 06
 Jun 2022 09:05:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220606070804.40268-1-songmuchun@bytedance.com>
In-Reply-To: <20220606070804.40268-1-songmuchun@bytedance.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 6 Jun 2022 09:05:09 -0700
Message-ID: <CANn89iJwuW6PykKE03wB24KATtk88tS4eSHH42i+dBFtaK8zsg@mail.gmail.com>
Subject: Re: [PATCH] tcp: use kvmalloc_array() to allocate table_perturb
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 6, 2022 at 12:08 AM Muchun Song <songmuchun@bytedance.com> wrote:
>
> In our server, there may be no high order (>= 6) memory since we reserve
> lots of HugeTLB pages when booting.  Then the system panic.  So use
> kvmalloc_array() to allocate table_perturb.
>
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Please add a Fixes: tag and CC original author ?

Thanks.
