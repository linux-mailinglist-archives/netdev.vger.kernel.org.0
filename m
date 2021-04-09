Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED57635A258
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 17:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbhDIPxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 11:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233916AbhDIPw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 11:52:59 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F96C061761
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 08:52:46 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id x8so1933498ybx.2
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 08:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K187VH9BSEtEqttNZKW+GZp1uNI8wvV/q8bhTw5Ntxo=;
        b=sMq7iRILoluTXvguToDiin3RKUsB7jacScFCxi5T6mvqWYSOKYn7a627L7q5znA6sM
         27/MOUMTNkVBRxz5ULADcvTQYvks2jfP3d6OD0otlcAetKQwdhyDeYuMfGjT0v0QWpnk
         cnByvUo+f1kQnzM21XTiirG1d5fG0EMIGMAok+yHfkx3JUwS/jWq1/2vW2KyszBE4YOj
         2wG9Ep3PmdN7tu9J/qAMqVWtVjH5pcInBcEj1mxl61lFpfZEbQqMSmkYto/hg79xJkkD
         KApycE384kYxwN4waZDjxatjX0Un8/KD87NgrjZhrmKAGfXupGkBI6WbiHIrpChfCq4H
         npyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K187VH9BSEtEqttNZKW+GZp1uNI8wvV/q8bhTw5Ntxo=;
        b=KFmT6WmPy9LpXX2QNl8zzyWNHbt4irwzAChCqbsz6QrjFzoigczZvl7tHutsxXfAim
         rFE6w/Lg63o+9c9Ax4KlG346YEU0VX+KwU6n7p8qE8lDKba3cf43V4rUvZ2gMaj90Z5y
         HkVlxz+o5WpqsOoBT81cKUSUIcfn6J5yTB977qQB9OmWXn/nW+MY8JgN93qmhO64RTAJ
         2Hq4Bxd70ltV9GRCQS7NlnAiL6foWoNJYttHRzkCoBdJqAzjVWpRUyAoksb/u+lIoMNX
         dj5PaPe8i74bPUOCj8/7UYuEIT2Jgsv62JJJvNeMPLHlSbA5ot8dwjwWPEt/BtwVmJa1
         d0WQ==
X-Gm-Message-State: AOAM531M6fAuWzmZh3hVhUdYYEzxEJAkqkorm4/wfTslYKhdbrECZkRH
        Nq/YR4lo+4hqkpINf2/u6txrcEnm3bGJD24jCEu3pQ==
X-Google-Smtp-Source: ABdhPJzLlPsE71l4Fk+UdaAm1yC0Zy9jeo41ZUjfXkEGknA7+DPPUV7DHdEcl5yc2sh5DTUgMb9qOzhN/VsNFfr/1ss=
X-Received: by 2002:a05:6902:4d2:: with SMTP id v18mr19805973ybs.303.1617983565050;
 Fri, 09 Apr 2021 08:52:45 -0700 (PDT)
MIME-Version: 1.0
References: <883923fa22745a9589e8610962b7dc59df09fb1f.1617981844.git.pabeni@redhat.com>
 <385f1818-911e-4c7d-1501-8710691d609a@gmail.com>
In-Reply-To: <385f1818-911e-4c7d-1501-8710691d609a@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 9 Apr 2021 17:52:33 +0200
Message-ID: <CANn89iLiZZeomS2yBh7OXmu_zrxfZt8soebD+XUcJq0f6wH=vg@mail.gmail.com>
Subject: Re: [PATCH net v2] net: fix hangup on napi_disable for threaded napi
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 9, 2021 at 5:35 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>

>
> Unrelated to the actual issue:
> I wonder why -1 is returned, that's unusual in kernel. The return value
> is used as bool, so why not return a bool?

This is a leftover of a prior implementation that returned 3 values.

No bug here really, this is a matter of taste I suppose.
