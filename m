Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88ACA20BA70
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 22:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgFZUmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 16:42:09 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:46199 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgFZUmI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 16:42:08 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 29f4a66b
        for <netdev@vger.kernel.org>;
        Fri, 26 Jun 2020 20:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=wxnOOml3JHYM1DKXMM9+1x9WEFA=; b=iWpjf9
        TknlxFriv78ZtJahRqfcLhwZY2QuNDCEwEImqUAh9j09ewOt5+dDNDTxUM6WajWa
        vgLqyxX6hCOF6p7NWQp4+K/breUiUXDhmpPJkx0kpm2X99vc4GFfJbKMDxG+W/07
        aHrnZHwEKdTrHaWf5ZBOfQYMs3DHffhH4NvUgBZgUmQ0xIyGXcijW5894I8gFMcV
        EG2ti8g2e4w7+w7VYCqD7/XhPvLYYY8ad6TO0LpMZer3bHhCJaUsYXqZ3UxvIr8z
        T1jScQKcYfW2lo7eDtIy9rhhqnLG8vI0e4nHUjvFqPtEh+jpPWOaAK8wDLxJGfYr
        +SbbKmb20jD4BblA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ee6cf1a7 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Fri, 26 Jun 2020 20:22:47 +0000 (UTC)
Received: by mail-io1-f41.google.com with SMTP id c16so11202281ioi.9
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 13:42:06 -0700 (PDT)
X-Gm-Message-State: AOAM531GXFZKlDZg8SkDOWxRDexiVCJgNxMMAztCPJ3y7Coaibe7U4dD
        XEbbQDKCxm8rGYeQwEWvxxkNMkvvChEK+yK/Ypg=
X-Google-Smtp-Source: ABdhPJzOQJm5CwSuzBLlIm7f2d/B2iDB26DRcTjAb550CK8zXdO5Pb4X6luBlSkuCvbDziy1bEFl1uuzreDeeCe4vU4=
X-Received: by 2002:a5e:9703:: with SMTP id w3mr5259914ioj.29.1593204125504;
 Fri, 26 Jun 2020 13:42:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200626201330.325840-1-ndev@hwipl.net>
In-Reply-To: <20200626201330.325840-1-ndev@hwipl.net>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 26 Jun 2020 14:41:54 -0600
X-Gmail-Original-Message-ID: <CAHmME9r7Q_+_3ePj4OzxZOkkrSdKA_THNjk6YjHxTQyNA2iaAw@mail.gmail.com>
Message-ID: <CAHmME9r7Q_+_3ePj4OzxZOkkrSdKA_THNjk6YjHxTQyNA2iaAw@mail.gmail.com>
Subject: Re: wireguard: problem sending via libpcap's packet socket
To:     Hans Wippel <ndev@hwipl.net>
Cc:     WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hans,

On Fri, Jun 26, 2020 at 2:14 PM Hans Wippel <ndev@hwipl.net> wrote:
> while toying around with sending packets with libpcap, I noticed that it
> did not work with a wireguard interface in contrast to my regular
> ethernet interface.

Thanks for letting me know. I'll try to repro and will look if this is
common behavior for all virtual drivers, or simply a bug in WireGuard
that I need to address.

If it is the latter, your patch below isn't quite correct; we'll
probably address this instead by simply setting skb->protocol in xmit
by peaking at the header, if skb->protocol is zero, and then keeping
the rest of the logic the same elsewhere.

Jason
