Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB66269B8A
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 03:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgIOBqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 21:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbgIOBqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 21:46:09 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B59C06174A;
        Mon, 14 Sep 2020 18:46:07 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id u8so1384000lff.1;
        Mon, 14 Sep 2020 18:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8UX+7606NvwN134bBYk64tMmkWhjQQ6qaKmA4SRnH98=;
        b=HMzEskD7c8eW3sOp5vwGr2xblyHZxQZEAL176bXp47msnUFAfA3Xvg82/fH/v6rW2x
         waDuPXSxdsg2IJaB5RDF/RPJOv7ON/eIsYTZPJ5wGZD/69WHNeycHSVYuTMARkimE8SC
         j6iFYZz/hxtajF7vTBidNR/qvLmYfGq2OztAOJCoJzyrTUqy0RUQ0/s6yQB/laJpFUy+
         TyT74oS8EglWVQjlkEXz4mA/afqNxKCt3MIz+PMrrro6Or6qMX9dK/W6ny8Vh0/XCwFt
         x+epITMESx0t2dwq+FXG7WJ7YurW126LmGrLGeu6exBPPoPYbOQjvjxUPmCPG5ks0GlT
         jZlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8UX+7606NvwN134bBYk64tMmkWhjQQ6qaKmA4SRnH98=;
        b=Ytgq2DhBIlPS31Fq69NJyabZ4qriD4tPpb4jKRlUFthxkfkFUmRENILCrL9LdTaG+j
         pmv4VLdXpe+Ck0VNcK1fyxjGEyjAdmgYWaf7xyvoweoE4ZuAuWqgZeQ93Ykdrs8xxuK7
         J3d5Dl1vhLVLHIP6RX4wJZZN65aieAzBbvPUjTh5hU806XMEr/uMqzYfIwwJbqVBwEIA
         x8DvzvLJd9FNfoeBRI3IUhdyqjGcaqPVRcR7Raav/1lZOgq1ah5GcZguwtqOMhMp2vJI
         fomMBSBlK6E1zk9pA56YfersRS/DbXx1b2qbO3QlhyXNE+p84TYNf3hjJNnJMwjMDZpC
         qTmg==
X-Gm-Message-State: AOAM531Zyq+ZHZX43BVjR2N858cuCjykW+XKuWRRdj62aDKMFtnizMc2
        LbQsQbo9uO7OxjxY3dJfi0JVz/kt10eVKAc+ItQ=
X-Google-Smtp-Source: ABdhPJzQarmOR4PBw+Bpim3dk+ED49K8bP5NL9isgMuxt2di6NFt38Du8Y/EyxlGaFGZNxHjKety2F/nwk82acePyZ4=
X-Received: by 2002:a19:df53:: with SMTP id q19mr5329190lfj.119.1600134365607;
 Mon, 14 Sep 2020 18:46:05 -0700 (PDT)
MIME-Version: 1.0
References: <1600095036-23868-1-git-send-email-magnus.karlsson@gmail.com> <CAPhsuW4ktphxDkbZbvuQZUd09vBdNJbn2EfB5mDQ9-6FoXoFKQ@mail.gmail.com>
In-Reply-To: <CAPhsuW4ktphxDkbZbvuQZUd09vBdNJbn2EfB5mDQ9-6FoXoFKQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 14 Sep 2020 18:45:54 -0700
Message-ID: <CAADnVQ+s+2isJ0bEJCqBm_Cy-frfopWGs7YEZBy8uG5hREO5Hw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] xsk: fix refcount warning in xp_dma_map
To:     Song Liu <song@kernel.org>
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 2:13 PM Song Liu <song@kernel.org> wrote:
>
> On Mon, Sep 14, 2020 at 7:52 AM Magnus Karlsson
> <magnus.karlsson@gmail.com> wrote:
> >
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Fix a potential refcount warning that a zero value is increased to one
> > in xp_dma_map, by initializing the refcount to one to start with,
> > instead of zero plus a refcount_inc().
> >
> > Fixes: 921b68692abb ("xsk: Enable sharing of dma mappings")
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
>
> Acked-by: Song Liu <songliubraving@fb.com>

Applied. Thanks
