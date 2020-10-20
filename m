Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D310F29395C
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 12:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393335AbgJTKvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 06:51:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31269 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390242AbgJTKvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 06:51:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603191067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=KwfbgL4VkvlpcrctmgM+75E+GqELWCxxSa2IffQoc1Q=;
        b=ahzkGshrx+S7Ba3z4kip0Qb1CQTlFbB1Pk9nzDpdE/efmuWu/8BjN3EHE9vyE7Z0AMPb7g
        cS0mSpYyzEEl8MrJG3LXoNVoCyVIuTyfXop7Fwl26Uh2YYfSppDz6zlSpgrD2v+TS/s8Tc
        5HXMCSZDh+NksTrsjlmrFZEW41Mmnsg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-AgJtfq9OPBaWa5c77POSwA-1; Tue, 20 Oct 2020 06:51:05 -0400
X-MC-Unique: AgJtfq9OPBaWa5c77POSwA-1
Received: by mail-wm1-f69.google.com with SMTP id c204so313573wmd.5
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 03:51:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=KwfbgL4VkvlpcrctmgM+75E+GqELWCxxSa2IffQoc1Q=;
        b=t9eJF4Y+wRyeVUA/v9tsSmlDygS+IfXjqPFxLY+6cLI4YVt5aZhGPji0wWEbpDa3R7
         zfNhVcv9VLH8rg8EjN+DMpsfb5Yg4an1Pmt03l1UIeQhGfyFDX1m/mbt1HDuWxRk6Xb/
         UjiYvm/jL/GebWU3BDNN8ztsdvPtHr9KSWujw0n7uRoHVpi5NSlCXvLliU/LqYJsZMEr
         8U8hSHcYUI/JBU8TkCtSnlLUDmzWYB+OaAr0GLs6LcDIn/Lot45te5PdRswv1jpSkngZ
         +yK9HadwnCIAYow/awvTUZgBAX9ksMWjvyFnjemaJh4QaOY2w6NGoy8R5su+aCLdpZ1j
         jAQg==
X-Gm-Message-State: AOAM53350N6mZQwpTH8fc7y+WweO8WhkGYXwU8hW+4V1OCXuNa9syH9z
        Z74r6VJKvGhkIVoEL+D4Qum1whN/+5sEAgQfwiL9Y0kljX3Vd0KsdsZ0FE09+7j8JUQVJWtI381
        Rohyv5HhifX9n2aJT
X-Received: by 2002:a1c:9c41:: with SMTP id f62mr768502wme.23.1603191063855;
        Tue, 20 Oct 2020 03:51:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzsblmFdsTvprfU15R/tkPaacNxJ0y9wRruiz1To13u2gT3z0E/Xy0rhnzwbzVrnFzP8b7bbg==
X-Received: by 2002:a1c:9c41:: with SMTP id f62mr768471wme.23.1603191063443;
        Tue, 20 Oct 2020 03:51:03 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id g5sm2151573wmi.4.2020.10.20.03.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 03:51:02 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 358DE1838FA; Tue, 20 Oct 2020 12:51:01 +0200 (CEST)
Subject: [PATCH bpf v2 0/3] bpf: Rework bpf_redirect_neigh() to allow
 supplying nexthop from caller
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Tue, 20 Oct 2020 12:51:01 +0200
Message-ID: <160319106111.15822.18417665895694986295.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on previous discussion[0], we determined that it would be beneficial to
rework bpf_redirect_neigh() so the caller can supply the nexthop information
(e.g., from a previous call to bpf_fib_lookup()). This way, the two helpers can
be combined without incurring a second FIB lookup to find the nexthop, and
bpf_fib_lookup() becomes usable even if no nexthop entry currently exists.

This patch (and accompanying selftest update) accomplishes this by way of an
optional paramter to bpf_redirect_neigh(). This series is against the -bpf tree,
since we need to change this call signature before it becomes API. As a
companion change, it also adds a flag to bpf_fib_lookup() that will make it skip
the neighbour lookup, for cases where the caller knows it is likely for fail
anyway, and wants to go straight to bpf_redirect_neigh().

[0] https://lore.kernel.org/bpf/393e17fc-d187-3a8d-2f0d-a627c7c63fca@iogearbox.net/

Changelog:

v2:
- Add 'unused' member to fill hole in bpf_redir_neigh struct (David Ahern)
- Fix compilation with INET/INET6 disabled - properly this time (kbot)
- Add back the BPF_FIB_LOOKUP_SKIP_NEIGH flag as new patch 2 (Daniel)

v1:
- Rebase on -bpf tree
- Fix compilation with INET/INET6 disabled (kbot)
- Keep v4/v6 signatures similar, use internal flag (Daniel)
- Use a separate selftest BPF program instead of modifying existing one (Daniel)
- Fix a few style nits (David Ahern)

---

Toke Høiland-Jørgensen (3):
      bpf_redirect_neigh: Support supplying the nexthop as a helper parameter
      bpf_fib_lookup: optionally skip neighbour lookup
      selftests: Update test_tc_redirect.sh to use the modified bpf_redirect_neigh()


 include/uapi/linux/bpf.h                      |  10 +-
 net/core/filter.c                             |  16 +-
 tools/include/uapi/linux/bpf.h                |  10 +-
 .../selftests/bpf/progs/test_tc_neigh.c       |   5 +-
 .../selftests/bpf/progs/test_tc_neigh_fib.c   | 153 ++++++++++++++++++
 .../testing/selftests/bpf/test_tc_redirect.sh |  18 ++-
 6 files changed, 197 insertions(+), 15 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_tc_neigh_fib.c

