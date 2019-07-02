Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 454AD5D3EF
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 18:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbfGBQLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 12:11:16 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41996 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfGBQLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 12:11:15 -0400
Received: by mail-io1-f68.google.com with SMTP id u19so29721333ior.9;
        Tue, 02 Jul 2019 09:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vhnttg8GfYa37KzeI1O1gZvfh7qEvqCw66u1GSR9sxY=;
        b=lHCkeXT3Qb7mIyWuU9+2c3oRQX6QvS9o3c+/lyqA052sYOnRo9ceXiyv0TRZAvBCgA
         lOaQt/buEIFOOaj8unKK0+HdUqoAFSXqe8MGTsaHNmGt9d6stdCsyUD0pstmLy4VMLm4
         1WnSh7vbShIcfHaHmDp2ona7xCX3r6OdSXSHGFW1AFaMvr2wwO72X0a4o5E+7KzO5zp5
         qi6zJ53yqf8H2ccN5eAZk5aJUywLiE7koKlt9Fle9XnLVUDUgmArCaJ7u7NBzeNOHpOO
         n5gGW5dVJUiFOyWoyCzfYYkx6OwdgazLyCWNMQYpwCUFj1xfTM8pCQNHe2aPkka7fc+Q
         52rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vhnttg8GfYa37KzeI1O1gZvfh7qEvqCw66u1GSR9sxY=;
        b=ai5HIo82EaNPV9rWGQPb0Rytp/u3GMdqPflXc6pBXpvTN+T1/ZWaGXC0n7aFtMiAoN
         QW44/VY+qbhXdkGzS4MmkYulGf16B8DfZ6AWbF81ac6va+pn4Ho7EYKtider4tUW8jYA
         wGJtxFHXXvaBbDq66nH52XD3LG1NdRFU6SsHhGjeMPlpRjXWj8e3LdmpR5TlIAw56jZZ
         tE4gVrZvAJZZOsCqoxu/ZvI76a1HUeXfgcEBLApFNbjZ2HWUxVzVke1R7Sg4YE2zoQtC
         Iq+Di7c5XtNFIAI9f77u0TYdDDsFrFO0KxtBwJO0HPuvr7V0RxnF1eVgHRb6mhnbpfrH
         k+qA==
X-Gm-Message-State: APjAAAX/uAbgZoLJ0LNqosk7EuNVu2IMl2pVBzQCrYgs9BSNUQQHFOZ+
        6E7gr84CXAL2XPCk6rHbuuZTREYSRg+HJa1xS5Y+aoGKfAU=
X-Google-Smtp-Source: APXvYqwndZwB2NyFfhheHPF7LqHYcYJJQO0Q2SoYEZ/9ROP4/BEZ2Mt705ohbKLgbpeBzxsHyQsqgiwkJ08QlnhiXkk=
X-Received: by 2002:a5d:9d58:: with SMTP id k24mr7607229iok.116.1562083873917;
 Tue, 02 Jul 2019 09:11:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190702151620.3382559-1-andriin@fb.com>
In-Reply-To: <20190702151620.3382559-1-andriin@fb.com>
From:   Y Song <ys114321@gmail.com>
Date:   Tue, 2 Jul 2019 09:10:37 -0700
Message-ID: <CAH3MdRWeH=Ko_mAvWk2mUaMK50iNHLbZkHKK=dVTzuwihZeRuA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] libbpf: fix GCC8 warning for strncpy
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     andrii.nakryiko@gmail.com, bpf <bpf@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 2, 2019 at 8:17 AM Andrii Nakryiko <andriin@fb.com> wrote:
>
> GCC8 started emitting warning about using strncpy with number of bytes
> exactly equal destination size, which is generally unsafe, as can lead
> to non-zero terminated string being copied. Use IFNAMSIZ - 1 as number
> of bytes to ensure name is always zero-terminated.
>
> Cc: Magnus Karlsson <magnus.karlsson@intel.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>  tools/lib/bpf/xsk.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index bf15a80a37c2..b33740221b7e 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -327,7 +327,8 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
>
>         channels.cmd = ETHTOOL_GCHANNELS;
>         ifr.ifr_data = (void *)&channels;
> -       strncpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ);
> +       strncpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ - 1);
> +       ifr.ifr_name[IFNAMSIZ - 1] = '\0';
>         err = ioctl(fd, SIOCETHTOOL, &ifr);
>         if (err && errno != EOPNOTSUPP) {
>                 ret = -errno;
> --
> 2.17.1
>
