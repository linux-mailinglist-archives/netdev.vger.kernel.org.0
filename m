Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84618BF0E1
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 13:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725806AbfIZLMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 07:12:07 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:46487 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbfIZLMH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 07:12:07 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 08d1f1df;
        Thu, 26 Sep 2019 10:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=0KrXBh/Bsqvx7HfMQP+/WOxM5VQ=; b=SgBxyX
        4NMpvWxsmvkJGlPcW1N1PFhincDEmLASGMhzti7agl4WVuCxMjSBiAJBeRFMKAWB
        3IH22LQ39469zaaVYF53FIPATv7HE6D7Y6ija/Zvrm7cG7q1y8JPEXbTboQS3MJv
        szjScWeJmb+okPp1OjUE7WWHLtk+CRxgfpnqj2FqwKURrzS3NbNdEFxUJWGodVou
        V8+Z1WGBfY4rCD6G1fNaPKLvO8MZVzwzpZ1jwYxMA0Icp0/XFX5lKt0t5VBuryin
        cQmtXGl7ULEMD1xIuT2CNgI6kLPmaYfzZF3rzuYPrbCUW7hXY6hyKxJe/7HyAqkl
        /r5T3GNVIm77+iFQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 09e055a9 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 26 Sep 2019 10:26:12 +0000 (UTC)
Received: by mail-ot1-x330.google.com with SMTP id o44so1596522ota.10;
        Thu, 26 Sep 2019 04:12:03 -0700 (PDT)
X-Gm-Message-State: APjAAAUH+kRSTgzzBJjFMv0/xDRhP5dj/+7G12Z696XBKtjTHacereqr
        mPIJjXah2UHouBiXq7r5Dt+DSVY2PA4tfoXUvo8=
X-Google-Smtp-Source: APXvYqydG2LXHim6dvGxKuF9QbuQYuwfWsygXO1vvnS37Hb0bd207wjixOynX7Ua7HSFpMjDtZo75uIQRCJWV6/vC2A=
X-Received: by 2002:a9d:ec2:: with SMTP id 60mr2198189otj.369.1569496022509;
 Thu, 26 Sep 2019 04:07:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
 <CAHmME9oDhnv7aX77oEERof0TGihk4mDe9B_A3AntaTTVsg9aoA@mail.gmail.com> <MN2PR20MB29733663686FB38153BAE7EACA860@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB29733663686FB38153BAE7EACA860@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 26 Sep 2019 13:06:51 +0200
X-Gmail-Original-Message-ID: <CAHmME9r5m7D-oMU6Lv_ZhEyWmrNscMr5HokzdK0wg2Ayzzbeow@mail.gmail.com>
Message-ID: <CAHmME9r5m7D-oMU6Lv_ZhEyWmrNscMr5HokzdK0wg2Ayzzbeow@mail.gmail.com>
Subject: chapoly acceleration hardware [Was: Re: [RFC PATCH 00/18] crypto:
 wireguard using the existing crypto API]
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Willy Tarreau <w@1wt.eu>, Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Dave Taht <dave.taht@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[CC +willy, toke, dave, netdev]

Hi Pascal

On Thu, Sep 26, 2019 at 12:19 PM Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
> Actually, that assumption is factually wrong. I don't know if anything
> is *publicly* available, but I can assure you the silicon is running in
> labs already. And something will be publicly available early next year
> at the latest. Which could nicely coincide with having Wireguard support
> in the kernel (which I would also like to see happen BTW) ...
>
> Not "at some point". It will. Very soon. Maybe not in consumer or server
> CPUs, but definitely in the embedded (networking) space.
> And it *will* be much faster than the embedded CPU next to it, so it will
> be worth using it for something like bulk packet encryption.

Super! I was wondering if you could speak a bit more about the
interface. My biggest questions surround latency. Will it be
synchronous or asynchronous? If the latter, why? What will its
latencies be? How deep will its buffers be? The reason I ask is that a
lot of crypto acceleration hardware of the past has been fast and
having very deep buffers, but at great expense of latency. In the
networking context, keeping latency low is pretty important. Already
WireGuard is multi-threaded which isn't super great all the time for
latency (improvements are a work in progress). If you're involved with
the design of the hardware, perhaps this is something you can help
ensure winds up working well? For example, AES-NI is straightforward
and good, but Intel can do that because they are the CPU. It sounds
like your silicon will be adjacent. How do you envision this working
in a low latency environment?

Jason
