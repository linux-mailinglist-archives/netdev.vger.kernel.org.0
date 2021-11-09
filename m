Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74CF944B901
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 23:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241940AbhKIWy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 17:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345707AbhKIWyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 17:54:08 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A729EC0432D7
        for <netdev@vger.kernel.org>; Tue,  9 Nov 2021 14:25:52 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id r28so456974pga.0
        for <netdev@vger.kernel.org>; Tue, 09 Nov 2021 14:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cilium-io.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kmoy5rAGgZZp57wgnePj16rJ2xiDfWmZHrxezWo+FSE=;
        b=jQ1azQAntPbNJVZqOChZ68OM8heGfYh1USRovJKbmbDY7W2SZDOCXBDxobuEPSGbZM
         jgfe5l0QFx80u8z9nF1Z07YpWmWeWqSi3GisCaC6jxz5uVNeFO4Rk2vrd2JASlsqvz/w
         S3EVvH1gi75QUWg1bnG7SaiklFHzUDc+yxRFeJ4pLLiN5uMPpRgRcRlZdL8thqMLAVrH
         jFGHEa2bOOggerIXr3S2KzsdhD1ek6afsUV06DEN2brpKSEVs0GL2ERrNI1VGbU/s6rO
         WVHZcatLmQCq+rBY4o1pFdQZuPm7K51oZ2ZYiAXwryGD4k1gOU8vPvVlqn/bv5hVG22V
         7frw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kmoy5rAGgZZp57wgnePj16rJ2xiDfWmZHrxezWo+FSE=;
        b=DyMTfcZoOuQuXiJpBrFoXlGQ0ZniZVYKHgWmiCerF9+ana8MtOTJ14iDtIXgBhcelg
         Ga2SeDSQRHie3Fv2ce73KSRR1VC1+oE9pXqcBvreBlcHGynqtL5AB6vIjoMzVZ3RbViV
         vO0DwoNUwlrfADZrR3rqu0odRv3QWz9iM3o8Ve7Y+P7pjy+T3RUz+s2So4hGJpBnEPSd
         at/NLuoj/reIZUpLXX1AhSS2tNDfAi8rCuvqELCo5q9U6Acy3S9z6Wh6E4PsWZdaAzQ0
         wpuWWw/uTO/o0+aK4jH+qRpDC13iXxXYkxQNiIdMlyUt/OvwsPTSAPpKUc+SHXm+T/mm
         2+uA==
X-Gm-Message-State: AOAM533nEbJXZfTG9B0fYH5+z9vx/0vjqDXhCJZf2/e9BznGdVv8jn0Z
        59BP9fDXXn6BLpYdwa9wT2Uc1ZvEtfnIOiK+GFo=
X-Google-Smtp-Source: ABdhPJwZTGQs+kgd3gCos8OB+AV0a2Cu4kU/JvPskynfBf3T5r2UGP4gMHnba7DcT1z7Ds3wQb2XDA==
X-Received: by 2002:a05:6a00:1350:b0:49f:e389:8839 with SMTP id k16-20020a056a00135000b0049fe3898839mr11654263pfu.51.1636496751888;
        Tue, 09 Nov 2021 14:25:51 -0800 (PST)
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com. [209.85.214.178])
        by smtp.gmail.com with ESMTPSA id t13sm8563697pfl.98.2021.11.09.14.25.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Nov 2021 14:25:51 -0800 (PST)
Received: by mail-pl1-f178.google.com with SMTP id o14so1213207plg.5;
        Tue, 09 Nov 2021 14:25:51 -0800 (PST)
X-Received: by 2002:a17:90b:1bcb:: with SMTP id oa11mr11254969pjb.140.1636496750801;
 Tue, 09 Nov 2021 14:25:50 -0800 (PST)
MIME-Version: 1.0
References: <20211105221904.3536-1-quentin@isovalent.com>
In-Reply-To: <20211105221904.3536-1-quentin@isovalent.com>
From:   Joe Stringer <joe@cilium.io>
Date:   Tue, 9 Nov 2021 14:25:40 -0800
X-Gmail-Original-Message-ID: <CAOftzPinVTm3rfVFE-OQ5rtxOAamiJXfyanE7XPr6zNqPgrqsg@mail.gmail.com>
Message-ID: <CAOftzPinVTm3rfVFE-OQ5rtxOAamiJXfyanE7XPr6zNqPgrqsg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpftool: Fix SPDX tag for Makefiles and .gitignore
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Peter Wu <peter@lekensteyn.nl>,
        Roman Gushchin <guro@fb.com>, Song Liu <songliubraving@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        Tobias Klauser <tklauser@distanz.ch>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 5, 2021 at 3:19 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> Bpftool is dual-licensed under GPLv2 and BSD-2-Clause. In commit
> 907b22365115 ("tools: bpftool: dual license all files") we made sure
> that all its source files were indeed covered by the two licenses, and
> that they had the correct SPDX tags.
>
> However, bpftool's Makefile, the Makefile for its documentation, and the
> .gitignore file were skipped at the time (their GPL-2.0-only tag was
> added later). Let's update the tags.
>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Andrii Nakryiko <andriin@fb.com>
> Cc: Ilya Leoshkevich <iii@linux.ibm.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Joe Stringer <joe@cilium.io>
> Cc: Peter Wu <peter@lekensteyn.nl>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Stanislav Fomichev <sdf@google.com>
> Cc: Tobias Klauser <tklauser@distanz.ch>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>

Acked-by: Joe Stringer <joe@cilium.io>
