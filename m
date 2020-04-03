Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B196019D232
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 10:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390267AbgDCIaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 04:30:05 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38674 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727803AbgDCIaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 04:30:05 -0400
Received: by mail-wr1-f68.google.com with SMTP id c7so7439538wrx.5;
        Fri, 03 Apr 2020 01:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3iWIecZVAUc54be4Wh163O1yVl1PDGP5Br1BGuUzE/8=;
        b=XwyRgY4XjYW/Buw6NkjUDhGOBN/O+2O7qIlzjL3nuX+C+FmJLzmJoTbaGWIw15L0wU
         1w8rq6bJ24+y9oLw7IuaiA+DmkyyWiBNzFA7deImL3PqNVuEUMhZe7gTRAsBa4zO52VD
         DIucnu/amcrZw8l7kx1nYlSK32PT4ELjC0Y2aXbYc4edhgoPM4JNX4LPmbrYlPmJIaDX
         iO03Gc6riPqeNBjUSc57aV/y1zK5cvS0etXOLfypdkeoDYX2sB//2g/tpjg9bKzsF2Cs
         9asxqdGcf34vUks2c2R5/OhTXphysCT4AbzU50Mz4A4R0FcvVg8VQqw7EWmKEhsyqtpe
         2wzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3iWIecZVAUc54be4Wh163O1yVl1PDGP5Br1BGuUzE/8=;
        b=jYRPvC3xRvI0wB4rY/sJec6tYIULsw++6uyFkHAtDoweAB5vpPF7IGMbNPZ18UWLwg
         ccAP8qyby8KzjynrWFwUf3wb7AGDT73EKPbtq9ydVlgXktshCmzwld/k/Ch35W5r7Ej/
         mVY4Ok43EY5Pm1TSNNefzJRSbZAYon6nTsJHDsZhfAyVY2USlSsGvtAIj8EjPpOONb5Z
         H0+krr/BJ0WiWeqyqzXQansIE3QIhw5fPVVahuzXp0yQZgVRRCNW/4FKRoyLwIXfeJV/
         gGZlQPPG3qyyVb/XrW+hx/Tta8ybXjmLUPF0uGeLZSpiXWxovjyS8Y3HBIikgTld8M1P
         7lUQ==
X-Gm-Message-State: AGi0PubHgYxF+V2+hWkOK5ounUuK9/M1xxS8BfDjKC5cG/0O3gCQEvax
        L7F0WNvc2U3YVqUyeM/JV7JPVzDHRjp8be6XJ58=
X-Google-Smtp-Source: APiQypLZTMuFMIiys8xTsHicNhdnmlOZZLjZ64lcpWDqZtPx2rlxI5fuJ9y+byBrgy0epOJ3Y8B+B0NNDcO2ODscwIc=
X-Received: by 2002:adf:f852:: with SMTP id d18mr8249972wrq.172.1585902602006;
 Fri, 03 Apr 2020 01:30:02 -0700 (PDT)
MIME-Version: 1.0
References: <1585813930-19712-1-git-send-email-lirongqing@baidu.com> <6BB0E637-B5F8-4B50-9B70-8A30F4AF6CF5@gmail.com>
In-Reply-To: <6BB0E637-B5F8-4B50-9B70-8A30F4AF6CF5@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 3 Apr 2020 10:29:50 +0200
Message-ID: <CAJ+HfNjTaWp+=na14mjMzpbRzM2Ea5wK_MNJddFNEJ59XDLPNw@mail.gmail.com>
Subject: Re: [PATCH] xsk: fix out of boundary write in __xsk_rcv_memcpy
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Li RongQing <lirongqing@baidu.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kevin Laatz <kevin.laatz@intel.com>,
        Ciara Loftus <ciara.loftus@intel.com>,
        Bruce Richardson <bruce.richardson@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Apr 2020 at 00:22, Jonathan Lemon <jonathan.lemon@gmail.com> wrot=
e:
>
> On 2 Apr 2020, at 0:52, Li RongQing wrote:
>
> > first_len is remainder of first page, if write size is
> > larger than it, out of page boundary write will happen
> >
> > Fixes: c05cd3645814 "(xsk: add support to allow unaligned chunk placeme=
nt)"
> > Signed-off-by: Li RongQing <lirongqing@baidu.com>
>
> Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Good catch!
Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
