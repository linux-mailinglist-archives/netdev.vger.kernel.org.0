Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006F2309E89
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 21:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbhAaUDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 15:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbhAaTs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 14:48:26 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FF9C061A2B
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 11:27:33 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id t8so16889162ljk.10
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 11:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m6H5fcOYsCdCMeYtK9w3yBnEADl8ww3PIrbmNmUj0zc=;
        b=VP+jz4z48jAJrpEvYsTpMFNfMe2qxiAH1/I2a2lexKBJP3F2grNQr9PHwlif8mGFi5
         53a+hzhGsyG7FnQz3m/eADFq1z2nVcTaqrDaGnyTMa7xpBgP9LyDZ6sacoXlrR6qFfKZ
         +z6/8PmqcVKJ8EcHlmju64NeVLWhA1ETHUmQI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m6H5fcOYsCdCMeYtK9w3yBnEADl8ww3PIrbmNmUj0zc=;
        b=qRTwOqATm+ydZcOycZuUosPFK4/WajbcpJzLbvuGorbLA4uArGBRWBld4e8zfUmTgM
         EbrzxKzFpVq99dPHYdjFvUlSu+bnUlZ5ILyP6SPn2p5kvUlXTeetwSsz8HVMkVfCCVxo
         /IS9iDLPHWx6pHfddDnJrJr+CBeOMbc70XDwSioXpAyDs9EO1XqY+usr+yoAU6um7cTZ
         qYyefoKy9lNsHkKpHoxil3PMmWF6df8RY6bITjfs5icv27z3VXaRCLMl5kjC6SQLa+L6
         wpnDWrKg0D7nVEy/StuDGhzjDYReCyXqxXIWYQanzz+PjWEWakGb4xxWRWFU5a3YXF8W
         I5PQ==
X-Gm-Message-State: AOAM533NOTprGa2tqgLWbzDNqj+4ryYVs9MftWF89R1nmjlEiyogHM7B
        2md2dk8QFgcf1YQWlXj++X2fj5cgehLtDw==
X-Google-Smtp-Source: ABdhPJxbK+8ZYSyO9xTQQ34xUOeMnUPAnX3Bno6X2lXAUXGW7XgpgdD5ay1bh6al6vax1maZY8EmMg==
X-Received: by 2002:a2e:b17c:: with SMTP id a28mr7972743ljm.189.1612121251834;
        Sun, 31 Jan 2021 11:27:31 -0800 (PST)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com. [209.85.208.170])
        by smtp.gmail.com with ESMTPSA id e10sm3528913ljn.79.2021.01.31.11.27.30
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Jan 2021 11:27:31 -0800 (PST)
Received: by mail-lj1-f170.google.com with SMTP id f19so16931768ljn.5
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 11:27:30 -0800 (PST)
X-Received: by 2002:a2e:b70b:: with SMTP id j11mr7966866ljo.61.1612121250410;
 Sun, 31 Jan 2021 11:27:30 -0800 (PST)
MIME-Version: 1.0
References: <20210131105914.2217229-1-alex.popov@linux.com>
In-Reply-To: <20210131105914.2217229-1-alex.popov@linux.com>
From:   Linus Torvalds <torvalds@linuxfoundation.org>
Date:   Sun, 31 Jan 2021 11:27:14 -0800
X-Gmail-Original-Message-ID: <CAHk-=wibeoCxGOaHxmEnFC=Ar45=qAwu2myrTUCiF3iiYKPs1Q@mail.gmail.com>
Message-ID: <CAHk-=wibeoCxGOaHxmEnFC=Ar45=qAwu2myrTUCiF3iiYKPs1Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] vsock: fix the race conditions in multi-transport support
To:     Alexander Popov <alex.popov@linux.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Jeff Vander Stoep <jeffv@google.com>,
        Greg KH <greg@kroah.com>, Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ I'm checking lkml for at least some of the emails that I'm cc'd on ]

On Sun, Jan 31, 2021 at 2:59 AM Alexander Popov <alex.popov@linux.com> wrote:
>
> There are multiple similar bugs implicitly introduced by the
> commit [...]

Note: this got eaten or delayed by the mailing list issues that seem
to be plaguing lkml - I'm not seeing it on lore, although google does
find it on mail-archive.com.

The maintainers are cc'd, but it means - for example - that if
maintainers rely on patchwork, I thin kthat will be missing this email
too.

            Linus
