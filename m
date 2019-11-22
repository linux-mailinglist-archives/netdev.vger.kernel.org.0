Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCFF11066F6
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 08:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfKVHVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 02:21:06 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:34424 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbfKVHVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 02:21:05 -0500
Received: by mail-lf1-f68.google.com with SMTP id l28so4740878lfj.1;
        Thu, 21 Nov 2019 23:21:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hwH6xk8EcOcChp/d0fJ1SRbLCXpO7w1LH8vvcfWfSHI=;
        b=uve6JgQ5neKG9r0ysbEkydnr/uC0rSwD/9iSavhBsZIdDKnrF4Vbmz9J4Z13ZAQKC0
         XDTXIyAnJEBDt8DX6xkKC/uGkXo//BQ2qet0Nb0MCpatyd5eNftjF/Ino34DwGYU88DN
         Ye0WXgEYUEwtFYcm+5Eral9m53t65nCuQQgd+SNODnnF/1QpLcQm83TEBBkyTOZPcPf2
         gn0M0YX5ZZGGWzxza8ghcgx/2OJx38cnfkk0Sl+xiwM3V2tK6SXZmCSAsC5ki/kQq8tq
         nA3+kYWsUdd4FU8/DZGtnPLymfWp2uFuwT5yVFcc1AtO7LlrqJefJ061ktN8bFmsqbX2
         kUmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hwH6xk8EcOcChp/d0fJ1SRbLCXpO7w1LH8vvcfWfSHI=;
        b=HhB1xF4flT3VII4qdm6aSzxSEKd1Fn9hokSV1ODAcPdHGa7T2t84mj1DHMbDNs3UrA
         xp4sSXqPVieyVh8MpLEn6KEHwY0c2Pq45CrTZhtag/AsUVK2R/NH4qITAmG8JR4AjjBF
         6g52ezdpWQFW81QD38yc3YwrkNhI7nSKTy1H94a8kYSHpuVqsWI+c6KUPU2hmE/Otl0u
         +Y9g7eTVQBUA1WsKGI75QEJJowgu7ltBqExWrQGB8xfXSRwho6biJ0ZBOBp5AuzH78bs
         Ce6vF7CH6qKIsxbHCQ81zSqBSjgv1UnhXkYHFt93zIPGISa3WyY5u9O9z/RENpVHwvrk
         0z7A==
X-Gm-Message-State: APjAAAXFlIg9wJCN17VraH0U2XpsM5QDlokwAs+rQc5soCspQ5v4bRoW
        7dg4wVNwjKdG1fkJ4513LwkcJSXFhqnoELFl+aE=
X-Google-Smtp-Source: APXvYqwVp8AXTuOk22q/9NaePjXQEWJnPgmidJIyOg4uzugUjjz5hkX3Vl9Bl+nsaNxByL0vPt3k8xxUinUNNNu4HoA=
X-Received: by 2002:a19:9149:: with SMTP id y9mr11260110lfj.15.1574407263651;
 Thu, 21 Nov 2019 23:21:03 -0800 (PST)
MIME-Version: 1.0
References: <20191122003527.551556-1-andriin@fb.com>
In-Reply-To: <20191122003527.551556-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 21 Nov 2019 23:20:52 -0800
Message-ID: <CAADnVQK2p05qdqNh1vh4XCZi5pyT1u7N2CJbeaBugk9JyPtUOQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: fix bpf_object name determination for bpf_object__open_file()
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 4:36 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> If bpf_object__open_file() gets path like "some/dir/obj.o", it should derive
> BPF object's name as "obj" (unless overriden through opts->object_name).
> Instead, due to using `path` as a fallback value for opts->obj_name, path is
> used as is for object name, so for above example BPF object's name will be
> verbatim "some/dir/obj", which leads to all sorts of troubles, especially when
> internal maps are concern (they are using up to 8 characters of object name).
> Fix that by ensuring object_name stays NULL, unless overriden.
>
> Fixes: 291ee02b5e40 ("libbpf: Refactor bpf_object__open APIs to use common opts")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied to bpf-next. Thanks
