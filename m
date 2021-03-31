Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAAE3501DA
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 16:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235939AbhCaOEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 10:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235948AbhCaOE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 10:04:26 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0665C061574
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 07:04:25 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id y1so23950474ljm.10
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 07:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7WkKKW/QkEs9/kkL1SzWso2zmgtPiw9JFTK148I7Nb4=;
        b=niP6gSWqtgY8fqKdzU9VHeMUI4+Y+aJZqdJSpI7MrXBBXbr/yaOMsYQfYPtRMHvRbr
         HFVoWRpG01gTfsI1lXIUDCA6ip2c2A8W/taxgcGCoJ7VmKM/TJYvM9p4JFAmOjKjWed/
         qYpl40v1nu9CC9vOjChykYcdyjD5HQw6VVb3w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7WkKKW/QkEs9/kkL1SzWso2zmgtPiw9JFTK148I7Nb4=;
        b=EX5ZYoWzCiS/7wee6fUXLJaLoa5nf8oJwbkvI+o4O+BPznDrAWx1UX24eX+HI6Juwc
         FvH/53PNLO9a40THKA7LmFQHegc10e0Ucvmn0yvKaGDH7EtRz/VOeBclRpYi94VFmeVN
         8dLbNUWfQ3vWnOp0CcwnNF6ztccf9cPVH0av2du6b69b4NUzACyCi1B2hA/dvT0JIpHX
         ufGhB0lwReqi1Nwcf1kOlvGFsHzD5fT21chPWJ0Az0Tfh6gaufFzJK7hUhTinKw3NUGp
         QeaJhnuHOjqJb9prz2xYkKn/t0mpQ+QNKaHM1lNz39JoPOmJp5G1mgJmfcl81VyAXvpS
         PLLQ==
X-Gm-Message-State: AOAM530azTwZX9N3XtNLt+WfVbPvFbdZAHh1eXw0PqWTF0qeEF+4E16D
        hK/mbJYNqEmFr21EkaOmYtREH+twjcKdP2mgsP5HGw==
X-Google-Smtp-Source: ABdhPJwGGJC46aQqg9+k+oN5WbxooZfC2RyoJrBbGmk9xp43AiM5ChwTRs/po0Pv34t6pPvRXgiXVBdqaoqxaQxZxkQ=
X-Received: by 2002:a05:651c:118b:: with SMTP id w11mr2156382ljo.223.1617199463908;
 Wed, 31 Mar 2021 07:04:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210326160501.46234-1-lmb@cloudflare.com>
In-Reply-To: <20210326160501.46234-1-lmb@cloudflare.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Wed, 31 Mar 2021 15:04:13 +0100
Message-ID: <CACAyw9_FHepkTzdFkiGUFV6F8u7zaZYOeH+bUjWxcBNBNeBYBg@mail.gmail.com>
Subject: Re: [PATCH bpf v2 1/2] bpf: link: refuse non-O_RDWR flags in BPF_OBJ_GET
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     kernel-team <kernel-team@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Mar 2021 at 16:05, Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> Invoking BPF_OBJ_GET on a pinned bpf_link checks the path access
> permissions based on file_flags, but the returned fd ignores flags.
> This means that any user can acquire a "read-write" fd for a pinned
> link with mode 0664 by invoking BPF_OBJ_GET with BPF_F_RDONLY in
> file_flags. The fd can be used to invoke BPF_LINK_DETACH, etc.
>
> Fix this by refusing non-O_RDWR flags in BPF_OBJ_GET. This works
> because OBJ_GET by default returns a read write mapping and libbpf
> doesn't expose a way to override this behaviour for programs
> and links.

Hi Alexei and Daniel,

I think these two patches might have fallen through the cracks, could
you take a look? I'm not sure what the etiquette is around bumping a
set, so please let me know if you'd prefer me to send the patches with
acks included or something like that.

Best

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
