Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7B8D54A4
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 07:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbfJME7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 00:59:41 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:33789 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbfJME7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 00:59:41 -0400
Received: by mail-lf1-f65.google.com with SMTP id y127so9622790lfc.0;
        Sat, 12 Oct 2019 21:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q6UM81QVu0g8B790B9HS33FwVmQAj8ztbARaQxYqUMg=;
        b=qoybofSOmnKeQDR+5nHiLTGyULrVm194uVIlttyiLvZwXxGksFpZnbvGsxS5cjGsGZ
         mhrrfjyHsMioENy5pUql0BN9/tYNil09990SNvJs1RFeqrs1jSSNv+jtJEmsrhEiwxDp
         bGZQap8fD5+OREbsF2pIWL9xBk2lrACUuoP3zzgQkvzE0sRByLMWtbApMnJ2PI7Ad9Wg
         wsVA7ZmuzxrGtcLSKy2eY195ovwxN9qj0xqkn/n/GtYhkmDs37i/eKOmDkU4YndK8Iiu
         k3U5mtbb5Rf16rsKm9+rYDWbjgU/8l0UR/iLbypVbjR73K/w0HHXcfAWbbuRINwjSzeh
         /B5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q6UM81QVu0g8B790B9HS33FwVmQAj8ztbARaQxYqUMg=;
        b=UBIUQ0cSo3SIPxTjMw+KWh2nu6EKX1Wf1igAMXsccU/3YAf1EUM9mbUQzk4RJsBCYu
         a51AgXbhbfgo3QRWdCvkjKYhFVjS61Hd5VBniK0lIpglFmlqmk2NZIu7e5Bv4fQzF+W2
         K9Ethm/zu3+Xzde8nHV8aIiXcgLXljNLktPfsJPVfSO5MfpfOxScfZ5rMoCnBXlY1iGQ
         ErabzeAGtUG6ZEjMfbKobk7O7EjoHOEtS7tcaY2SgkZNomYqnNSGEZpqn6bEprwJL5dO
         Su8LYyAF+7cM6zGN699B4Na5yARRUmOjazXpzofbIvOT7l0T+/NCwhcieyUeFvZruC8A
         CDTg==
X-Gm-Message-State: APjAAAXcU52rO6oMEwJL2mxlEYZ9HMC/5cBNwbQXSD34byO8CH2ZT6eh
        lG2Q9VnU9yfuV5YoL758whVmG7eugOWcbLkhPq4=
X-Google-Smtp-Source: APXvYqy1wi9v13QqBiW8S7d3gqZHecXqoR5sYStLbxjbsSYRGtJKipwZT669sLcw5kjSpb2Try4PW9H/wejLhGAB3B4=
X-Received: by 2002:a19:5050:: with SMTP id z16mr14394005lfj.181.1570942778928;
 Sat, 12 Oct 2019 21:59:38 -0700 (PDT)
MIME-Version: 1.0
References: <5da2ad7f.1c69fb81.2ed87.f547SMTPIN_ADDED_BROKEN@mx.google.com>
In-Reply-To: <5da2ad7f.1c69fb81.2ed87.f547SMTPIN_ADDED_BROKEN@mx.google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 12 Oct 2019 21:59:26 -0700
Message-ID: <CAADnVQLczRWyWa44+ogr1UkcOObA40zurwxMY=0hO9_1Y1yeDA@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix passing uninitialized bytes to setsockopt
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 12, 2019 at 9:52 PM Ilya Maximets <i.maximets@ovn.org> wrote:
>
> 'struct xdp_umem_reg' has 4 bytes of padding at the end that makes
> valgrind complain about passing uninitialized stack memory to the
> syscall:
>
>   Syscall param socketcall.setsockopt() points to uninitialised byte(s)
>     at 0x4E7AB7E: setsockopt (in /usr/lib64/libc-2.29.so)
>     by 0x4BDE035: xsk_umem__create@@LIBBPF_0.0.4 (xsk.c:172)
>   Uninitialised value was created by a stack allocation
>     at 0x4BDDEBA: xsk_umem__create@@LIBBPF_0.0.4 (xsk.c:140)
>
> Padding bytes appeared after introducing of a new 'flags' field.
>
> Fixes: 10d30e301732 ("libbpf: add flags to umem config")
> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>

Something is not right with (e|g)mail.
This is 3rd email I got with the same patch.
First one (the one that was applied) was 3 days ago.
