Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B001B97AE
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 08:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbgD0Gpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 02:45:35 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:34908 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbgD0Gpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 02:45:35 -0400
Received: by mail-ot1-f65.google.com with SMTP id e26so24457844otr.2;
        Sun, 26 Apr 2020 23:45:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A20QEuwcQ3bPQDVPM4YhHWYF19sEEIWz0tIXZgQQNBA=;
        b=aElH/Npms16am5+g19bdMxGhPitYhjP6kwaB/Nzwg1Sf2NOqQPGHzk3tT705f278hU
         DsFXXM8Ck+1c3QUrpU6m2CBSes95pItbPJAjI/P4PQGx0fyEU2MZBsJ0hh6yOneqLj5u
         2lJvxbIVAyIG6U12fCRbeFnDZWXJpO/+H8GTXm1H5CBg9H88iveg6V/Y8/NK1qFskgwq
         1EuCVd9IOJPx5GOOfmrM5HjurxVfns3J2qv5a1Oy83OeH5Iob8IwIyZ/Ccn7p9S4J1FO
         K44SCw0ku1ObK7fSHxqPGPZ9FvXD4uaKhKxmVuTGdoA3TN2fdThOWOSGYQautXLgILf1
         0n9A==
X-Gm-Message-State: AGi0PubGXODkQXJ4ss5ivF/wQAF70hj6vGvfE+63iH6LtL1EZhiEBzJ/
        UyF1Tfh+hjEBQm6UQ0FW2yaRvwXXqxrPMEVmo64=
X-Google-Smtp-Source: APiQypKnNMH9rOhofcKlK7I9omQSdQmvVEfckYI5Sp58zjUJsZuaoc+VBXSc57/r+A1q4uEpYjSTT0Irt0S0re1bJoY=
X-Received: by 2002:a9d:564:: with SMTP id 91mr17254715otw.250.1587969933846;
 Sun, 26 Apr 2020 23:45:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200420143229.245488-1-mst@redhat.com>
In-Reply-To: <20200420143229.245488-1-mst@redhat.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 27 Apr 2020 08:45:22 +0200
Message-ID: <CAMuHMdWaG5EUsbTOMPkj4i50D40T0TLRvB6g-Y8Dj4C0v7KTqQ@mail.gmail.com>
Subject: Re: [PATCH v4] vhost: disable for OABI
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Richard Earnshaw <Richard.Earnshaw@arm.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        KVM list <kvm@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

Thanks for your patch!

On Mon, Apr 20, 2020 at 5:13 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> vhost is currently broken on the some ARM configs.
>
> The reason is that the ring element addresses are passed between
> components with different alignments assumptions. Thus, if
> guest selects a pointer and host then gets and dereferences
> it, then alignment assumed by the host's compiler might be
> greater than the actual alignment of the pointer.
> compiler on the host from assuming pointer is aligned.
>
> This actually triggers on ARM with -mabi=apcs-gnu - which is a
> deprecated configuration. With this OABI, compiler assumes that
> all structures are 4 byte aligned - which is stronger than
> virtio guarantees for available and used rings, which are
> merely 2 bytes. Thus a guest without -mabi=apcs-gnu running
> on top of host with -mabi=apcs-gnu will be broken.
>
> The correct fix is to force alignment of structures - however
> that is an intrusive fix that's best deferred until the next release.
>
> We didn't previously support such ancient systems at all - this surfaced
> after vdpa support prompted removing dependency of vhost on
> VIRTULIZATION. So for now, let's just add something along the lines of
>
>         depends on !ARM || AEABI
>
> to the virtio Kconfig declaration, and add a comment that it has to do
> with struct member alignment.
>
> Note: we can't make VHOST and VHOST_RING themselves have
> a dependency since these are selected. Add a new symbol for that.

Adding the dependencies to VHOST and VHOST_RING themselves is indeed not
sufficient.  But IMHO you should still add VHOST_DPN dependencies t
 these two symbols, so any driver selecting them without fulfilling the
VHOST_DPN dependency will trigger a Kconfig warning.  Else the
issue will be ignored silently.

> We should be able to drop this dependency down the road.
>
> Fixes: 20c384f1ea1a0bc7 ("vhost: refine vhost and vringh kconfig")
> Suggested-by: Ard Biesheuvel <ardb@kernel.org>
> Suggested-by: Richard Earnshaw <Richard.Earnshaw@arm.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
