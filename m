Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D749FB8906
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 03:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394648AbfITB5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 21:57:05 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54122 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389787AbfITB5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 21:57:05 -0400
Received: by mail-wm1-f65.google.com with SMTP id i16so546123wmd.3
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 18:57:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PWSXgSG3XQUk3/S3fUmXpI8xu5KR5f/OtLrvOGImhg8=;
        b=C45VbSh8JOzLSWihQ0TwnfBeWLY5T48ZKmi0w1I48VlrbTO+HdsTBZTy+eGDKLW9b1
         8wvpMJtOEVz8P1ubxJhs+Lqebq4qiNnnWEzcw/gjb+Mbz6D+rEljIfVWVUS0IOXPcNqf
         knB0wyUoj5Vm2BpzdAOc7UFL+cpv7wwJynJOI8QvTwm7taBYBgYD7XvMLI0oAd0iLgB2
         9ABlkgSMJft3MIKpYiZejasl+h2hpgQ8Fgs2OJUCcHOTPMun7D4pYFCMt34hJvTToOnE
         oKh05U4+KO2Gj3tzkBqC/VuImQv+DEN9/oG1FxLDdPz++TiiXJjfkLxl8SMXhsAP/lM4
         4PAQ==
X-Gm-Message-State: APjAAAV0eKZGbMCqjE7diNXKci0fvQLDDCdwroXtcvKExxeoekpW5DOE
        +Pee//Yl9KwHdhulXV9FCZQLTOPvNENbz6FCZsQ=
X-Google-Smtp-Source: APXvYqwhvyvPPibkNDoRb0q2jG2eSUuHRof0gcArmjLhdM9MBxtwfgvwHE93oMbKsCotRAF8PHjgEY+OOZslNcw8k84=
X-Received: by 2002:a05:600c:40f:: with SMTP id q15mr787290wmb.23.1568944622799;
 Thu, 19 Sep 2019 18:57:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190919220733.31206-1-joe@wand.net.nz>
In-Reply-To: <20190919220733.31206-1-joe@wand.net.nz>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Thu, 19 Sep 2019 18:56:46 -0700
Message-ID: <CAOftzPiw3ZeCx30MYhg8KBbFe3-FKzKqitd7ipmsxiKgXOwJog@mail.gmail.com>
Subject: Re: [PATCH iproute2 master] bpf: Fix race condition with map pinning
To:     Joe Stringer <joe@wand.net.nz>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 3:07 PM Joe Stringer <joe@wand.net.nz> wrote:
>
> If two processes attempt to invoke bpf_map_attach() at the same time,
> then they will both create maps, then the first will successfully pin
> the map to the filesystem and the second will not pin the map, but will
> continue operating with a reference to its own copy of the map. As a
> result, the sharing of the same map will be broken from the two programs
> that were concurrently loaded via loaders using this library.
>
> Fix this by adding a retry in the case where the pinning fails because
> the map already exists on the filesystem. In that case, re-attempt
> opening a fd to the map on the filesystem as it shows that another
> program already created and pinned a map at that location.
>
> Signed-off-by: Joe Stringer <joe@wand.net.nz>
> ---
>  lib/bpf.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/lib/bpf.c b/lib/bpf.c
> index f64b58c3bb19..23eb8952cc28 100644
> --- a/lib/bpf.c
> +++ b/lib/bpf.c
> @@ -1625,7 +1625,9 @@ static int bpf_map_attach(const char *name, struct bpf_elf_ctx *ctx,
>                           int *have_map_in_map)
>  {
>         int fd, ifindex, ret, map_inner_fd = 0;
> +       bool retried = false;
>
> +probe:
>         fd = bpf_probe_pinned(name, ctx, map->pinning);
>         if (fd > 0) {
>                 ret = bpf_map_selfcheck_pinned(fd, map, ext,
> @@ -1674,7 +1676,11 @@ static int bpf_map_attach(const char *name, struct bpf_elf_ctx *ctx,
>         }
>
>         ret = bpf_place_pinned(fd, name, ctx, map->pinning);
> -       if (ret < 0 && errno != EEXIST) {
> +       if (ret < 0) {
> +               if (!retried && errno == EEXIST) {
> +                       retried = true;
> +                       goto probe;
> +               }

Ah, forgot to close 'fd' before the jump in this retry case. Will fix
that up in v2.
