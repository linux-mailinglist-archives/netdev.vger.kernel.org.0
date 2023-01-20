Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C14D4675B64
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 18:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjATRaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 12:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbjATRah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 12:30:37 -0500
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D464EDBCF
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 09:30:30 -0800 (PST)
Received: by mail-qv1-xf2e.google.com with SMTP id g10so4251947qvo.6
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 09:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PwZXs6K2a6IO3sOCpDdgAJceFEm2RB4apdmb8kQpbx4=;
        b=UygCEQw1sNdw6KDAK8Wc8jwv9kTrpdaJXi1VB0GAYtAaOEdRXr7Ws25t3NUivaeRWR
         rOJLsa9Tl8Q5oZBeAoBNZUBFMuQR6xiX/AzGdzWBMqgadk3zhdxsOxtXW28u4jihafN1
         8oY/CwiNnCMHyUYN9cLIlZ6oVwjw6TFQYCdKc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PwZXs6K2a6IO3sOCpDdgAJceFEm2RB4apdmb8kQpbx4=;
        b=44v3As94r72AbHUGhyOlIpjKgsj0JLpDxTDj+QntQ4JF0d3iVeASGWujcYfDOUPTgd
         SGYhjHI4jSuJ08Pv75Rxm/aY2+mLgmoi3S+nvxt0BUL1VVFkDqBR6izOi+fpnslHGcak
         USOoLhjKxS3ifTjXXCVejfGwAA71kyrDLwXv+Y8mwFnn8Wxw7roDFaYZhuJTUASr1/zX
         scjAzdGlPMuN5JFBuyfU5A1fbgWQ8tbifDnuHVZ3IzdHGpZwLWL2NILnXeEwd2OaehWA
         PDzhlTop+ZuHbga1Vj+46yg0jUkrpZDXjGP84st3zeGWdK/kTj77zVs4Zw962FGf7l9Y
         GU0w==
X-Gm-Message-State: AFqh2kqAeA2Ff7XnJWrtJFbJQTuo15fPZxyr/fVGN6eW30LpgYNlpA+x
        rLxxhh5ox0/92qzFy3RuDju93ppRX2RKTAOk
X-Google-Smtp-Source: AMrXdXtb0Zv4/KPmRHTFvd/wdzED0FNVQ1RUjGaaLREhNl5caRaOlaGmtZAPXUmHF7xkB3guZv8KoA==
X-Received: by 2002:a05:6214:2e8c:b0:532:264f:b909 with SMTP id oc12-20020a0562142e8c00b00532264fb909mr26214946qvb.28.1674235829821;
        Fri, 20 Jan 2023 09:30:29 -0800 (PST)
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com. [209.85.222.169])
        by smtp.gmail.com with ESMTPSA id y15-20020a05620a0e0f00b006f7ee901674sm26186348qkm.2.2023.01.20.09.30.29
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jan 2023 09:30:29 -0800 (PST)
Received: by mail-qk1-f169.google.com with SMTP id i28so3256265qkl.6
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 09:30:29 -0800 (PST)
X-Received: by 2002:a37:45d3:0:b0:706:96dd:8d4a with SMTP id
 s202-20020a3745d3000000b0070696dd8d4amr761386qka.336.1674235828818; Fri, 20
 Jan 2023 09:30:28 -0800 (PST)
MIME-Version: 1.0
References: <20230119185300.517048-1-kuba@kernel.org> <20230120085114.6c30d514@kernel.org>
In-Reply-To: <20230120085114.6c30d514@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 20 Jan 2023 09:30:12 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgsKaO7qxOso_PrmsBEfpN-Wot=V0fUAy3oKOSFuAQxVw@mail.gmail.com>
Message-ID: <CAHk-=wgsKaO7qxOso_PrmsBEfpN-Wot=V0fUAy3oKOSFuAQxVw@mail.gmail.com>
Subject: Re: [PULL] Networking for v6.2-rc5
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 8:51 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> v2 coming, in case you haven't pulled yet. Extra stuff went into the
> tree overnight, insufficient communication between netdev maintainers,
> IDK..

I had actually pulled it yesterday, but apparently I then forgot to
push that out.

So I undid my pull and will do your v2,

               Linus
