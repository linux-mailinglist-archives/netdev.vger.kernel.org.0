Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10E8C47242
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 23:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbfFOVqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 17:46:17 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45992 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfFOVqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 17:46:17 -0400
Received: by mail-lj1-f196.google.com with SMTP id m23so5716579lje.12;
        Sat, 15 Jun 2019 14:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hYTYW6IZAeP4tQBXMbfaMW4PaVUM/8gJ0AvydW6uNfY=;
        b=CuJVuDGgH2o7twgGYU5eLOv7aiye65VapfBq209uyPNpBXrLGyglJJDBJOy2O5gNX2
         AGGP6ddGEtp75ofVP67AhoiUaJZZU+WlPk/BIGALYxeZDMhJBUaxQ0DgXCLo+J+5QD8a
         9tEu3lFaHjllVgYAHteH8HandSMpSHWSYva4jxccu8bpyYWqeLojbAHaHFNwTn4Z87zC
         vQd0dD6KrUWEQGWPY0Ua73WHa38+0RUn220nq6iaBKBb300fOxnuoeVJh5d1oS5K5UAM
         xEEX7iQGb1lo/6nmBbvBEDb4fqS/chL5Rx68q6QpPuNJBkGvNQC6b9dNtpR9wWNljWyF
         Nc+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hYTYW6IZAeP4tQBXMbfaMW4PaVUM/8gJ0AvydW6uNfY=;
        b=F+k8UA41/Fafy57QnL5HWfMQnAvu7qiYAueXR7Eyz0NavnSmU3zSiUSvGan6dVb37N
         THscOtBOfBFOQ5ESvimCQuO4A8IYRFzOtb7POUqZVwlHCL6j6Np/rc+PLtbtoNkNnsy2
         +IkId+LxxFwaN1hRpe6qKOtfLDsxGdWkA87JWUkGN6RNh8LauahkNN67WGr5K2TrKRmD
         Byds+j6MDnEP38Fnubt+oMthCURSoLJ1TpgUsraQwKLgxvh6J2Vw8dNtmFHL2+UXseoj
         ZV9aEWQiA7kdlAmdobjcLgswJS3OkUAe2mapKJNczyU9ejq/KasQicHp1A/q78cPy7AT
         UbmQ==
X-Gm-Message-State: APjAAAXtbgJAc5zzSdAAM+MCO5rTOVc8k0ItHQS/1lwKalmG9QLO9AAv
        4FAxwQ7ARC7QhXu6PFv7P+ifiOteayK3HWQLgOc=
X-Google-Smtp-Source: APXvYqyBQ5bz7L/zMaO1OwZgvUHhpUqxUT6QEQmGntUzy166XZNsEw25FbmmgprjdVT/K8mN8xyb0Drt2FPzymm62dY=
X-Received: by 2002:a2e:9dca:: with SMTP id x10mr23318282ljj.17.1560635174630;
 Sat, 15 Jun 2019 14:46:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190614230821.3146272-1-ast@kernel.org>
In-Reply-To: <20190614230821.3146272-1-ast@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 15 Jun 2019 14:46:03 -0700
Message-ID: <CAADnVQK2Nq6_HQT7Opn1XkA7s6UteVE_qOpXq8AiQwFOmeB6jA@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf, x64: fix stack layout of JITed bpf code
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 4:10 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Since commit 177366bf7ceb the %rbp stopped pointing to %rbp of the
> previous stack frame. That broke frame pointer based stack unwinding.
> This commit is a partial revert of it.
> Note that the location of tail_call_cnt is fixed, since the verifier
> enforces MAX_BPF_STACK stack size for programs with tail calls.
>
> Fixes: 177366bf7ceb ("bpf: change x86 JITed program stack layout")
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Applied to bpf tree.
