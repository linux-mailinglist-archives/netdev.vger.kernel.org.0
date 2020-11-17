Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667142B5B0D
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 09:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726854AbgKQIfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 03:35:46 -0500
Received: from mail.zx2c4.com ([192.95.5.64]:42039 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbgKQIfq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 03:35:46 -0500
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 5f5f8117;
        Tue, 17 Nov 2020 08:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=Hr+jI+KVdqgUSqaJucRaw9uwCVA=; b=ZAGMil
        2h6me0N7K8kyNY4QsrK8PyskCMWyz9/JNkfEywmRPm2FPJumdSZdhMUWiS7+rAhK
        Lf9kiMA4h/IN7aF+k5H1loaXIr4qOzlRV9lfv6JZIYnKhDaGyBHKW6R8gF9ChgRe
        Vm+9S2rfvh/+/VC4GecX8VNItLHAF4CKT3EyesP/UgT26Us4wp2hhswk1IzIw6Ap
        02a+1gT0CIlz15iy4VTiydfYh8WAxb/eA4wbKlzqH4UTPZuhsyC8QjkAckdW0OF4
        LqBy0oobxCWUkYnFLWLg7GyAHS1YdUF5f88okOEmPC7YXb5CrtQJXJti3DAsOK9s
        cJCi2qRlx5f9ZrAg==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 14ca90a1 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 17 Nov 2020 08:31:54 +0000 (UTC)
Received: by mail-yb1-f174.google.com with SMTP id c129so18201561yba.8;
        Tue, 17 Nov 2020 00:35:42 -0800 (PST)
X-Gm-Message-State: AOAM533TrTfq/08KF4CH8nr3aKc3kICHKnOdcu2qnwmGbjX6VM+J7X8u
        k2HK4AypLey+Id8F3NkQKZ8DLzAzZmeNlN8KvVw=
X-Google-Smtp-Source: ABdhPJxltpJ7lh/BAV2z4t5JKlLag1wKxZinZcAn5MaBtMCCdqxT5sWm5uXwl/7xTG7nwungx+QhIoCScN+KUkPRPIw=
X-Received: by 2002:a25:6f83:: with SMTP id k125mr26083401ybc.123.1605602142005;
 Tue, 17 Nov 2020 00:35:42 -0800 (PST)
MIME-Version: 1.0
References: <20201117021839.4146-1-a@unstable.cc> <CAMj1kXFxk31wtD3H8V0KbMd82UL_babEWpVTSkfqPpNjSqPNLA@mail.gmail.com>
In-Reply-To: <CAMj1kXFxk31wtD3H8V0KbMd82UL_babEWpVTSkfqPpNjSqPNLA@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 17 Nov 2020 09:35:31 +0100
X-Gmail-Original-Message-ID: <CAHmME9p8XNfz1ZdELVFXC4=QY-S6VzJfyf4oREgTM96WJUKeTQ@mail.gmail.com>
Message-ID: <CAHmME9p8XNfz1ZdELVFXC4=QY-S6VzJfyf4oREgTM96WJUKeTQ@mail.gmail.com>
Subject: Re: [PATCH cryptodev] crypto: lib/chacha20poly1305 - allow users to
 specify 96bit nonce
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Antonio Quartulli <a@unstable.cc>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, keyrings@vger.kernel.org,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Antonio Quartulli <antonio@openvpn.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 9:32 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> If you are going back to the drawing board with in-kernel acceleration
> for OpenVPN

As far as I can tell, they're mostly after compatibility with their
existing userspace stuff. Otherwise, if they were going back to the
drawing board, they could just make openvpn userspace set up xfrm or
wg tunnels to achieve basically the same design. And actually, the
xfrm approach kind of makes a lot of sense for what they're doing; it
was designed for that type of split-daemon tunneling design.
