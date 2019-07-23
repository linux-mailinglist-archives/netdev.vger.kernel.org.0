Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE7C72220
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 00:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392392AbfGWWTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 18:19:03 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39513 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387490AbfGWWTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 18:19:03 -0400
Received: by mail-lf1-f67.google.com with SMTP id v85so30432178lfa.6;
        Tue, 23 Jul 2019 15:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d9KrWFWR3+EPPknBsC4NiQfCFdWvYyCQhlLUaLsDH/M=;
        b=j9yZjjpAp3OSx38IouzFRHzPotjI4JX1+Zs/8TMqQIACPValNhoVpVSu0NWlnWxxQc
         qF/kIHsrN9+MilyBSJyYrh4/Z9pHb/C+W3F+f8Uro8cLdtH77f4reu2tc4V6Cif3KTxr
         a7xss8M4fFNYo8PyF/RjRvm++wLfxaOYipfilciR9wySXWOyOFwD0o17pmbjgDwDtRFz
         aQmz5qap8tZ7n0ZHru7KeeXvryc2YaXl4wxW0p2GcIwXwFr1tKlP4YoZPDT50LLJzOdC
         6YcmXHE7iszgmPW6Htz3eqPm9qvgjsWWt3TmNBH8n4+qaqBJlsPL2LJeeDlosMaHBIs8
         TPeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d9KrWFWR3+EPPknBsC4NiQfCFdWvYyCQhlLUaLsDH/M=;
        b=ATXjixXLuPX7xHDpDNmnYDpmk0BeLFcggoVLQgkIVwbwziDGMCI2PEy4bPpo1fNe5l
         3lFz6BhLhKID8CTR3OQDk/buj4Kv5cptCKNUFddBTq0UdahVkO3hhfEVcrUXzzVDMG+c
         oAWRwzQPxJzlkTBF/uf50e+kblhTYxW4kAssOc7KSdn3kTeA9PZhhR3lJWyQy2soVno7
         F/ekxx345F4IlkS8WfEMrI5TfPHhqO41WwXVrwBMWO3l5WWTGC8wg/HmvjAfFCSmmRd4
         oBDTFNhO03Q6/r2p8QpwWso+f2cwWg3Q7+3j+xrUwbDAu53ITikJyDoMHYZKk3HYtvIs
         R+Nw==
X-Gm-Message-State: APjAAAWVzKnUEOodqV5hHc/fGNhn96RwdmD0z8XkphsFrxg1i2TK2gQb
        iqMDYhFdo7U1bTWDIcXQ1aXe7sRDRZGjywTmHyQ=
X-Google-Smtp-Source: APXvYqycuzq7Nf556yHRaZ8Pb4fShV32jJED5/TtC+lZUFQS4AM8PBZxEVKYhdpl4WXoczpNoi/KByW9GnPPC1RI3V0=
X-Received: by 2002:ac2:4351:: with SMTP id o17mr15703541lfl.100.1563920341110;
 Tue, 23 Jul 2019 15:19:01 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20190723120815eucas1p21027b1ab47daba7ebb3a885bf869be8a@eucas1p2.samsung.com>
 <20190723120810.28801-1-i.maximets@samsung.com>
In-Reply-To: <20190723120810.28801-1-i.maximets@samsung.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 23 Jul 2019 15:18:49 -0700
Message-ID: <CAADnVQ+EJ6WArycRgVePTRrqerpt9E47H5EPm7APX5Jjmv-GWw@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix using uninitialized ioctl results
To:     Ilya Maximets <i.maximets@samsung.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 5:08 AM Ilya Maximets <i.maximets@samsung.com> wrote:
>
> 'channels.max_combined' initialized only on ioctl success and
> errno is only valid on ioctl failure.
>
> The code doesn't produce any runtime issues, but makes memory
> sanitizers angry:
>
>  Conditional jump or move depends on uninitialised value(s)
>     at 0x55C056F: xsk_get_max_queues (xsk.c:336)
>     by 0x55C05B2: xsk_create_bpf_maps (xsk.c:354)
>     by 0x55C089F: xsk_setup_xdp_prog (xsk.c:447)
>     by 0x55C0E57: xsk_socket__create (xsk.c:601)
>   Uninitialised value was created by a stack allocation
>     at 0x55C04CD: xsk_get_max_queues (xsk.c:318)
>
> Additionally fixed warning on uninitialized bytes in ioctl arguments:
>
>  Syscall param ioctl(SIOCETHTOOL) points to uninitialised byte(s)
>     at 0x648D45B: ioctl (in /usr/lib64/libc-2.28.so)
>     by 0x55C0546: xsk_get_max_queues (xsk.c:330)
>     by 0x55C05B2: xsk_create_bpf_maps (xsk.c:354)
>     by 0x55C089F: xsk_setup_xdp_prog (xsk.c:447)
>     by 0x55C0E57: xsk_socket__create (xsk.c:601)
>   Address 0x1ffefff378 is on thread 1's stack
>   in frame #1, created by xsk_get_max_queues (xsk.c:318)
>   Uninitialised value was created by a stack allocation
>     at 0x55C04CD: xsk_get_max_queues (xsk.c:318)
>
> CC: Magnus Karlsson <magnus.karlsson@intel.com>
> Fixes: 1cad07884239 ("libbpf: add support for using AF_XDP sockets")
> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
> ---
>  tools/lib/bpf/xsk.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 5007b5d4fd2c..c4f912dc30f9 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -317,7 +317,7 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
>
>  static int xsk_get_max_queues(struct xsk_socket *xsk)
>  {
> -       struct ethtool_channels channels;
> +       struct ethtool_channels channels = { .cmd = ETHTOOL_GCHANNELS };
>         struct ifreq ifr;
>         int fd, err, ret;
>
> @@ -325,7 +325,7 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
>         if (fd < 0)
>                 return -errno;
>
> -       channels.cmd = ETHTOOL_GCHANNELS;
> +       memset(&ifr, 0, sizeof(ifr));

I refactored this bit into
struct ifreq ifr = {};
based on Andrii suggestion and pushed to bpf tree.
Thanks

>         ifr.ifr_data = (void *)&channels;
>         strncpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ - 1);
>         ifr.ifr_name[IFNAMSIZ - 1] = '\0';
> @@ -335,7 +335,7 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
>                 goto out;
>         }
>
> -       if (channels.max_combined == 0 || errno == EOPNOTSUPP)
> +       if (err || channels.max_combined == 0)
>                 /* If the device says it has no channels, then all traffic
>                  * is sent to a single stream, so max queues = 1.
>                  */
> --
> 2.17.1
>
