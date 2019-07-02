Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71E2F5C91D
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 08:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbfGBGKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 02:10:22 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:40192 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfGBGKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 02:10:22 -0400
Received: by mail-io1-f65.google.com with SMTP id n5so34377350ioc.7;
        Mon, 01 Jul 2019 23:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dpESTJoUvt6Vlyr2kYxBbiDvhF3//mz2Ax3svrqr2kE=;
        b=W865J4+mrF5Yn7FnCiXw+p98Y95MH4uAyIgkm0DqjJL+9nNU9iqodi4ESm+R1PPEZ4
         /KKeDkiMDgGukVHp19vlTdAekaez0CCS/SdEjr+02UYkt5RdrRTsDQr4W8AUDZEA3hLS
         1ODcMsklNh67jggsDpAdfbDwtN1XD1A85qxcpE1hzgw4kOvLaBE099lSbLPuALAAO6zG
         +gn4mL+CIm7sHpXGwT09+LNzl7B9YHLyrrlhHypKKw1bqmwwKFyPINUQgjoM3L0memAC
         w2IVyLDV2jTBwGntYSSs2olA75P/EkhjwLK2AlnWwh+HvDeK56h/fZTpPr+J1CoCeCr+
         pmCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dpESTJoUvt6Vlyr2kYxBbiDvhF3//mz2Ax3svrqr2kE=;
        b=IwGI6kjVveMvV7PxMxu8yCPaR+rjFNJS3J/HzHKvweW54pRmqPBNE7E559sdt4eMnj
         +QsZlYujwui6yHR7nYzV7e99uT8JKqqCEcQ93CE+GuyJb2zBdi64c2aBxkTGDC/DaSNu
         ElFQ6crqkhFpsm6FTqWJxj6Si0az/lc8TkKwlNFPXDmlpryeTWstGdIO5nxW5q3iG7+c
         kZR6CxvVHw1Ucfd9ofjf3c4zk8mGZQL9sF87To/1FddUWPPm/sLwwLdLATiWrQmEt6oO
         2ovEA4Brl0oD7TYlRh5tybquBgx7/q3xM2NryylY0nEgdAr/cyOkYMKrSvX4CEyQX3WE
         JOrg==
X-Gm-Message-State: APjAAAV67LgbB7KqsdsOl65D2bPadolF2tB3yVmJotc5WfRolQriGP0T
        +AlWHnfXAsiJ5SUbMZ93N7Qiwx+t2F1Kd5ORAwY=
X-Google-Smtp-Source: APXvYqztAWJLT71TV/JWgo+PXC1kmCfC0etfReJR3ZZR93dVUlfCDuiYYwZrXSgqgXeJglZwGFtaFlCI7aFbD2+76q8=
X-Received: by 2002:a5e:aa15:: with SMTP id s21mr29112371ioe.221.1562047821457;
 Mon, 01 Jul 2019 23:10:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190702054647.1686489-1-andriin@fb.com>
In-Reply-To: <20190702054647.1686489-1-andriin@fb.com>
From:   Y Song <ys114321@gmail.com>
Date:   Mon, 1 Jul 2019 23:09:45 -0700
Message-ID: <CAH3MdRUv9eJuecKq7weG614+6oEtfLeUHnTxoU19qr39p9-mrQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: fix GCC8 warning for strncpy
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

On Mon, Jul 1, 2019 at 10:47 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> GCC8 started emitting warning about using strncpy with number of bytes
> exactly equal destination size, which is generally unsafe, as can lead
> to non-zero terminated string being copied. Use IFNAMSIZ - 1 as number
> of bytes to ensure name is always zero-terminated.
>
> Cc: Magnus Karlsson <magnus.karlsson@intel.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/xsk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index bf15a80a37c2..9588e7f87d0b 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -327,7 +327,7 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
>
>         channels.cmd = ETHTOOL_GCHANNELS;
>         ifr.ifr_data = (void *)&channels;
> -       strncpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ);
> +       strncpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ - 1);

To accommodate the xsk->ifname string length FNAMSIZ - 1, we need to have
    ifr.ifr_name[FNAMSIZ - 1] = '\0';
right?

>         err = ioctl(fd, SIOCETHTOOL, &ifr);
>         if (err && errno != EOPNOTSUPP) {
>                 ret = -errno;
> --
> 2.17.1
>
