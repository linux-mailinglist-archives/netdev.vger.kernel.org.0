Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47F6DC2CBB
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 06:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbfJAE7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 00:59:40 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:38700 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfJAE7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 00:59:40 -0400
Received: by mail-ed1-f66.google.com with SMTP id l21so10636151edr.5
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 21:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sbWGoDIcBVKVVXhXHRb6SeILiiXvltGOO4zLdWCERws=;
        b=eOFh/bGjYqN1njXIJLXGPgJ3FM3o4H1WiGIhCmInJWK7hZRdqTZ8Xxl//SLsYe4j2S
         HD37MagRpADXKcQZ31rD+4OB6+jeTa3GgMCPoNAlmayrGd7TmWdSYO4YQjwo8bCdwR5i
         pGwiSJnbQ7GyClwnfpQVuGElZE3ZB6zczGzR33WgNLJxr44yXm/ZpqJGZQwECxon6+Qo
         LAaR6+yeLr3ual83pJ1+a2UTx+olPB2SU6ycmvkVClD1Y5u+lR/uUUewmkYGYcVdbI0T
         S/Ho9pCMd2b2Ze5fh8m1CDwWvnL55d8j2B3BI6tyjvp8E7rcGqc8pHgXNtaBAKSZzbws
         Y4LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sbWGoDIcBVKVVXhXHRb6SeILiiXvltGOO4zLdWCERws=;
        b=nAulPG5hhhKnop79vxBJ7MOin0iOegKws7w7itSFPXAapeTrCSFdqER5dRf78heqxe
         t7eqUVD12lJkdA+OzXvb7nixnbMNBgM9+GVCCUc+hD8wwqHHyJ6V0FNAAUDFSviU0kAS
         7kS34/4efiJvQI95MLdTpaGGf43zbF9ziNtZqf5RJmzMFGnkA8yQDNyUrq6mUzixpjO9
         7p5vW1y5Fj5c2+tllKPR+iX8Y3xHgWfeO4jZM83iw1ekARcWF9G+lPPuJdovXBzhZGjv
         zGETloTp15j2g/cXBByZxNnG0enqrwQQZ9ndqwQKV6MIGpKVBHQLgFf9CUV8RQP0IfVS
         TTjA==
X-Gm-Message-State: APjAAAVkrqP2zHadIV0J/HMnVwvgbFILfxJwZ2inYGjG35lBKl4iCabX
        tqD9jPmpg8OUYCArtkC4rLt7QyEGLHc7BHE2n+BEEA==
X-Google-Smtp-Source: APXvYqx+ar4xrk7WTStMots+H7oZNEIyF2psRBCbMKAuP4xalNjSSgxe9SCyv7kQy1Tn+MdmPYEQqsqo3eLUxQFRFzw=
X-Received: by 2002:a50:fa09:: with SMTP id b9mr23486949edq.165.1569905978333;
 Mon, 30 Sep 2019 21:59:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190928220745.23804-1-olteanv@gmail.com> <20190930.172027.1837315999928472989.davem@davemloft.net>
In-Reply-To: <20190930.172027.1837315999928472989.davem@davemloft.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 1 Oct 2019 07:59:27 +0300
Message-ID: <CA+h21hqt+iLJ5yCTvnysEoeK08Ce7yRK1+nSniaBd=p=4y0_SQ@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: sja1105: Fix sleeping while atomic in .port_hwtstamp_set
To:     David Miller <davem@davemloft.net>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Tue, 1 Oct 2019 at 03:20, David Miller <davem@davemloft.net> wrote:
>
> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Sun, 29 Sep 2019 01:07:45 +0300
>
> > Currently this stack trace can be seen with CONFIG_DEBUG_ATOMIC_SLEEP=y:
>  ...
> > Enabling RX timestamping will logically disturb the fastpath (processing
> > of meta frames). Replace bool hwts_rx_en with a bit that is checked
> > atomically from the fastpath and temporarily unset from the sleepable
> > context during a change of the RX timestamping process (a destructive
> > operation anyways, requires switch reset).
> > If found unset, the fastpath will just drop any received meta frame and
> > not take the meta_lock at all.
> >
> > Fixes: a602afd200f5 ("net: dsa: sja1105: Expose PTP timestamping ioctls to userspace")
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
>
> Well, two things:
>
> 1) Even assuming #2 wasn't true, you're adding the missing initialization
>    of meta_lock and that would need to be mentioned in the commit message.
>

Thanks, I forgot to break that line apart into a new patch.

> 2) After these changes meta_lock is no longer used so it should be removed.

The meta_lock is still very much used: see net/dsa/tag_sja1105.c (that
is where DSA keeps its fastpath). The fact that meta_lock is no longer
used within the driver (slowpath) is entirely the point of the patch.

-Vladimir
