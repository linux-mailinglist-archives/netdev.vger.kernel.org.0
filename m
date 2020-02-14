Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E493C15F3D7
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 19:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404600AbgBNSPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 13:15:50 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:51751 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726191AbgBNSPl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 13:15:41 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 7beb9041
        for <netdev@vger.kernel.org>;
        Fri, 14 Feb 2020 18:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=2xKsb8PS9uL3oIiu01Li12DoOZc=; b=la2J5l
        SwYdd00SWy5obl8QUBM4K1JcE9s386M3GU8J9S2FWlrLfwecxy1NEtZcrPVS5bvb
        8kWMISwz3uFsS+nBQGLKlWJZkonuG+9mevdMFlrMSJz8US0olzZHFpmdJ1shgScz
        UVRL/qRJYSwEuVP7jyNqAinfStNSkzrkwao+gAQmyS+tEWkXhnC/QFrso3WV+f82
        C+uA+qJWiMTfLmOwEjnQ1oCOsy8lfTT3L5/Ff0hCtBPbZIBGYJFpczuYvQldAoA2
        hD2ozme0YvhubFyFiuqM3qe0qV6Py7rqaGoIBCsltAOfiU88xcQ+D9Zj70M3m928
        do9eB417h8a2ESMg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4e2d3708 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Fri, 14 Feb 2020 18:13:31 +0000 (UTC)
Received: by mail-oi1-f180.google.com with SMTP id a142so10263401oii.7
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 10:15:39 -0800 (PST)
X-Gm-Message-State: APjAAAWqN/3tDviktX+OQXr7TVRSr5qPVakAmcqAAqSI8pCgS3vOYjCI
        Ymfa4LLCaGKxUhsf7b87QoVfpgWjteYAaOTZA3M=
X-Google-Smtp-Source: APXvYqzc7PUt4DGPZX8iSs1laIe7+c6yOsAgWMfdVO4uVY7HTKHpRn8i58W1frmncIKZN4k8hGzzqNZOCowZp0/GpfM=
X-Received: by 2002:a05:6808:a8a:: with SMTP id q10mr2687179oij.66.1581704138212;
 Fri, 14 Feb 2020 10:15:38 -0800 (PST)
MIME-Version: 1.0
References: <20200214173407.52521-1-Jason@zx2c4.com> <20200214173407.52521-4-Jason@zx2c4.com>
 <135ffa7a-f06a-80e3-4412-17457b202c77@gmail.com>
In-Reply-To: <135ffa7a-f06a-80e3-4412-17457b202c77@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 14 Feb 2020 19:15:26 +0100
X-Gmail-Original-Message-ID: <CAHmME9pjLfscZ-b0YFsOoKMcENRh4Ld1rfiTTzzHmt+OxOzdjA@mail.gmail.com>
Message-ID: <CAHmME9pjLfscZ-b0YFsOoKMcENRh4Ld1rfiTTzzHmt+OxOzdjA@mail.gmail.com>
Subject: Re: [PATCH v2 net 3/3] wireguard: send: account for mtu=0 devices
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 14, 2020 at 6:56 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Oh dear, can you describe what do you expect of a wireguard device with mtu == 0 or mtu == 1
>
> Why simply not allowing silly configurations, instead of convoluted tests in fast path ?
>
> We are speaking of tunnels adding quite a lot of headers, so we better not try to make them
> work on networks with tiny mtu. Just say no to syzbot.

The idea was that wireguard might still be useful for the persistent
keepalive stuff. This branch becomes very cold very fast, so I don't
think it makes a difference performance wise, but if you feel strongly
about it, I can get rid of it and set a non-zero min_mtu that's the
smallest thing wireguard's xmit semantics will accept. It sounds like
you'd prefer that?
