Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7E691653B2
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 01:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbgBTAk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 19:40:27 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42488 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727086AbgBTAk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 19:40:26 -0500
Received: by mail-pl1-f195.google.com with SMTP id e8so805091plt.9
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 16:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DB+LFc5czNxs9tSs4UMkmswHI0+X8Sj1WtUHwmj5KMk=;
        b=kAQQbreiBTpqEIuQL4vXzOhlDwNwIe31aJAM6FhYLPulkghokG28+lb3UG02A5yeli
         O4Lq824qF3gBtPOBmAm7WlaIWrff/YB3+EYa0coPaqSQ/Q689wcB4kV3LLrFzAdPN6bf
         bFtzPKz522gerEiMmMBWTco1f5upQ9jtbOJ80ox+xfH18yV9qQkcLiMKyQI+jFp2qpI9
         i+XXGqpf73xg/l2QRISrajbsVsaH7in9LBeeWT03poOww87wJddinS1MvQmZbf+Emxz6
         YX9DBhtTEwhe5o6FQ4Z0/fYwwgLFQdLVfaB7KAOl5gpS2BBCQfH/w6uSGX8MS9ZTEcvF
         aH0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DB+LFc5czNxs9tSs4UMkmswHI0+X8Sj1WtUHwmj5KMk=;
        b=FcbdcwfDM8nYIEA5uFfhiVLwtyxZe7ymZBkm5DAnBmkWdJF2V+AYvgIpj8H4YTfbIw
         hrSqSfSNxlCUSwLpgsBaBB/OIYQOuUngNmWC/eSvJ2F16uCd7NPSmM33lYqe3suYCaGx
         10aSsIF5vtzr/dtTvVTe3ZzIL5rvFp2aS+deXPMfN9hbydf98WvNOfThVvhyufq0Xb9Q
         NKHc7RH+AgZ7yqMyQxm384lJlewmyYn0n9BdjUqOx9j7UzeG5c7sumVtFz9s9PdIQ7aZ
         tF58krfodeFReXkiklUO1vIGVt9EI/IMQtIXrvyc29SvCTY9Ez5AHHb3rKShisuJhhMk
         vCYg==
X-Gm-Message-State: APjAAAWtpQKgkmM55rX3X6/XYJ+/QKdgVZ8Iz61XP9BYghtNkdUEkvyv
        qRwOKQgiqRiIBCAu6/XrQWpirR1w1p+fm7MxgsQ=
X-Google-Smtp-Source: APXvYqx7UYrVQG/Z55nBxjhc7fPVDWVDRoYvau9goY9ICREsHabpcv+zOqudapnwSrwzNGQbMllaxE/V68TVJuNFjp8=
X-Received: by 2002:a17:902:9a84:: with SMTP id w4mr28474612plp.21.1582159226077;
 Wed, 19 Feb 2020 16:40:26 -0800 (PST)
MIME-Version: 1.0
References: <20200219191632.253526-1-willemdebruijn.kernel@gmail.com> <20200219.163455.2118359448089082650.davem@davemloft.net>
In-Reply-To: <20200219.163455.2118359448089082650.davem@davemloft.net>
From:   Pavel Roskin <plroskin@gmail.com>
Date:   Wed, 19 Feb 2020 16:40:14 -0800
Message-ID: <CAN_72e31DHQn_a18HLYJ5hz8_HWL=x-D3BEDisyypU35=1h6XA@mail.gmail.com>
Subject: Re: [PATCH net] udp: rehash on disconnect
To:     David Miller <davem@davemloft.net>
Cc:     willemdebruijn.kernel@gmail.com, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>, willemb@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 4:35 PM David Miller <davem@davemloft.net> wrote:
>
> From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Date: Wed, 19 Feb 2020 14:16:32 -0500
>
> > From: Willem de Bruijn <willemb@google.com>
> >
> > As of the below commit, udp sockets bound to a specific address can
> > coexist with one bound to the any addr for the same port.
> >
> > The commit also phased out the use of socket hashing based only on
> > port (hslot), in favor of always hashing on {addr, port} (hslot2).
> >
> > The change broke the following behavior with disconnect (AF_UNSPEC):
> >
> >     server binds to 0.0.0.0:1337
> >     server connects to 127.0.0.1:80
> >     server disconnects
> >     client connects to 127.0.0.1:1337
> >     client sends "hello"
> >     server reads "hello"      // times out, packet did not find sk
> >
> > On connect the server acquires a specific source addr suitable for
> > routing to its destination. On disconnect it reverts to the any addr.
> >
> > The connect call triggers a rehash to a different hslot2. On
> > disconnect, add the same to return to the original hslot2.
> >
> > Skip this step if the socket is going to be unhashed completely.
> >
> > Fixes: 4cdeeee9252a ("net: udp: prefer listeners bound to an address")
> > Reported-by: Pavel Roskin <plroskin@gmail.com>
> > Signed-off-by: Willem de Bruijn <willemb@google.com>
>
> Applied and queued up for -stable, thanks Willem.

Successfully tested with the original server and the demo programs I posted.
Tested-by: Pavel Roskin <plroskin@gmail.com>

-- 
Regards,
Pavel Roskin
