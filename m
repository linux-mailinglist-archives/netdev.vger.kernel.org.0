Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB65A3CD033
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 11:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235709AbhGSIa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 04:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235459AbhGSIaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 04:30:22 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B9AC061766
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 01:12:04 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id a13so21071952wrf.10
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 02:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u5FkYygAP5aYXKhiToJncjQ4pnqt1axbUfxSA6M106E=;
        b=RUoz3S+OzJer2hQ2zynaEh0ahbOByD6Ye2U9E+aySsu09fb59vHB8xqBnMBTNjooXK
         J48srP6gvu9447896+hKmxhF7Yn3jmLZiyQCnSf7eqMm4aPtsMJWS8efN62jjFn9mbAr
         AQL95z7CfrzZnBYbnITt4xTYVjHmXWcnLWPNA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u5FkYygAP5aYXKhiToJncjQ4pnqt1axbUfxSA6M106E=;
        b=DRadIpQak0j2bsPyTNr5kKmp9gEQ8imynSOjRV++Lndmy7yK1Zb8vumo2paf+KUiJj
         lT+FyaTqy+QPR9dL4h5cy5kv4iHmMX8tq+Xpmmo+1rsnyb4Dniwy7h0rhezUXsAv7e3n
         QwffhF3o1wwOaMSeSSWFGXjjaZICm20NIbAGRw0/gJ3aV9/9cvZvsxaybMBU6zXxMO/M
         OogUBSrmSZyTZCDx8nU9keqVlzpKSzWOgSZP/gSgPAeqpUjcUsSlOs7+o74Eib5Gildv
         g7Jgww7juQKyX9JePqaDcqjdSrjHIvCPDwz8oOd4mWqKJIjZji2YHQktQRYkO6JKtu5L
         zaLA==
X-Gm-Message-State: AOAM531wgX1N6baPnIwZ+vKdBqUli+j2WOe45FMY+GR6O1QPxrmyd45L
        Y2zAqhsvxyOciQPO32PSrKN42ZflEpBMet6vHzHNGXmiMhc=
X-Google-Smtp-Source: ABdhPJzlxqfFGaZrZ/5HCQxqAtoUQFd+tAAHV7lDvF2Cb/wf0Cnc0joQvV4k+SOZgE1RrpeWhEROVb9+ifjTZjQ6mgs=
X-Received: by 2002:ac2:43d4:: with SMTP id u20mr17544633lfl.451.1626684328396;
 Mon, 19 Jul 2021 01:45:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210716100452.113652-1-lmb@cloudflare.com> <CAEf4BzauzWhNag0z31krN_MTZTGLynAJvkh_7P3yLQCx5XLTAg@mail.gmail.com>
In-Reply-To: <CAEf4BzauzWhNag0z31krN_MTZTGLynAJvkh_7P3yLQCx5XLTAg@mail.gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Mon, 19 Jul 2021 09:45:16 +0100
Message-ID: <CACAyw98RaF8SgA9nkduXo-wBdsRN86cP=seX9d83i0Qhi0gbeQ@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: fix OOB read when printing XDP link fdinfo
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        kernel-team <kernel-team@cloudflare.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Jul 2021 at 21:44, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> Well, oops. Thanks for the fix!
>
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
>
> It would be great to have a compilation error for something like this.
> I wonder if we can do something to detect this going forward?

I had a second patch that introduced MAX_BPF_LINK_TYPE, etc. and then
added explicit array initializers:

     [MAX_BPF_LINK_TYPE] = NULL,

That turns the OOB read into a NULL read. But it has to be done for
every inclusion of bpf_types.h so it's
a bit cumbersome. Maybe add MAX_BPF_LINK_TYPE and then add an entry in
bpf_types.h for it as well?

--
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
