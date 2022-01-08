Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415CC48859E
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 20:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232457AbiAHThS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 14:37:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbiAHThS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 14:37:18 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02302C06173F;
        Sat,  8 Jan 2022 11:37:18 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id pf13so731799pjb.0;
        Sat, 08 Jan 2022 11:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nxb5DyF/d3hj7nuFxr4i+Ddo95augfcOCVYd8xEXoGw=;
        b=kH1QFSklddjDlMxYFRdfYlENHuD2dQuuhYnte0ClAwcCbV2/+t+qQJYGuu+BMqOs/7
         0xrb/Ilc3PESpwn4CzoHa3qAXHVZpD+VMyXx6UBuy4CPKalqcm5aKeEMMEHbabXrm+Fn
         9ap39RLdjThme+4Vl2NEqo8vUO+X4yYwMrxshEqnMQJdn8upZu9YRC8y9igPkVWSByrE
         ZYMS+IupDGCxhjZSJCf8hiLiIk3mMbbBCDrIBSVxbHK1jIwiHGwgXSdwEt87HI3mFUJO
         HuTgHla36wFxUXhDI5AOVkqYB1ALBx59aH7ZDTWlnMlLX47+J36dbEViPJKpRM2xo4ZM
         6m9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nxb5DyF/d3hj7nuFxr4i+Ddo95augfcOCVYd8xEXoGw=;
        b=jm5woghGqqnGY0+YdU0lRmRGIAGqg+WPn1dHN8Yxq0VAMN1I38gxO2RHrtv8UFb1OC
         sTe7T+AVNgz6GPayK2GjaJ7/T0i0fbFLQnng76bULZQMBlaG4OLfoJg1ZyAtPDTkoINL
         5LxWuF3m/HH/luIJlRyyg6wyVsF0ZiFOKVR8UAwAjSUC8HY1DZ0ib/R67V2xwxgj5M9j
         Gqrby6JpIEh5ZL82FlsLblOzcm/pZRRPrl6HupQg7KSjS6iXE5Pl3h6T4pOpACMViueX
         C2pjPHVzfLHIfQhrU47HvfFX1o/fL4EJqFkh01lEsUVhU00fdpC7PQzI6i9yj6WwLR3/
         +aAQ==
X-Gm-Message-State: AOAM532TjtEwxpzJ23MdLI7JH+3YwpOBn2Xlhfri8VKKr32gV5U6skNb
        dF/dC+TcWl6X187BQDYXWeAP1hlWWzV9lLr6NJE=
X-Google-Smtp-Source: ABdhPJy4dz0+Dr7pib1OQSP8CSCxjw1qXEcwn7w/0CFU2j2hOQsuZZMr/TKiZZ59IN0ucEMgC3V5FV0BxYvmvar+KFk=
X-Received: by 2002:a17:902:860c:b0:149:1017:25f0 with SMTP id
 f12-20020a170902860c00b00149101725f0mr67896704plo.116.1641670637470; Sat, 08
 Jan 2022 11:37:17 -0800 (PST)
MIME-Version: 1.0
References: <20220107221115.326171-1-toke@redhat.com>
In-Reply-To: <20220107221115.326171-1-toke@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 8 Jan 2022 11:37:06 -0800
Message-ID: <CAADnVQLBDwUEcf63Jd2ohe0k5xKAcFaUmPL6tC-h937pSTzcCg@mail.gmail.com>
Subject: Re: [PATCH bpf v2 1/3] xdp: check prog type before updating BPF link
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        syzbot <syzbot+983941aa85af6ded1fd9@syzkaller.appspotmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 7, 2022 at 2:11 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> The bpf_xdp_link_update() function didn't check the program type before
> updating the program, which made it possible to install any program type =
as
> an XDP program, which is obviously not good. Syzbot managed to trigger th=
is
> by swapping in an LWT program on the XDP hook which would crash in a help=
er
> call.
>
> Fix this by adding a check and bailing out if the types don't match.
>
> Fixes: 026a4c28e1db ("bpf, xdp: Implement LINK_UPDATE for BPF XDP link")
> Reported-by: syzbot+983941aa85af6ded1fd9@syzkaller.appspotmail.com
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

Thanks a lot for the quick fix!
The merge window is about to begin.
We will land it as soon as possible when bpf tree will be ready
to accept fixes.
