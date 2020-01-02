Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0A112EFB8
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 23:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbgABWsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 17:48:12 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42097 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731214AbgABWsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 17:48:10 -0500
Received: by mail-ed1-f66.google.com with SMTP id e10so40337240edv.9;
        Thu, 02 Jan 2020 14:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FxDVgAWCt/FxweqZJ9ECXtjAagQu09sD0MoBdlNxryg=;
        b=LZENSqWA7RVFQddHBKJZYPDG2/cwJ5/SRNHmORY6N0r2a9n46mzde3B6/50GhghXJ0
         uh7+1ZGWPkTWY1KTpkEjbTZ74Hw6i2gL+YWZ3WqAA9r2mEUIzBF6Ttoao/2P9jmgHGOE
         1WNlkVX6Kv2+xEqdpzhLiILQynLl9RMPf8kBPW0kgLIf/CDJhOeI8F0K5R3MAN2V3KQD
         wha2jJ2G9h83MvVJWgu9wht/zKW5KGK9GsHAzutAqSkhU3wgTQeMyoutDg7QhjO3Ji1c
         U3wr52sY9R9bfb0Yei7zIrXN4ES+L7+KSaoBW2nIztlDWgGarEISWH48RosfnAuYoZqd
         GKXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FxDVgAWCt/FxweqZJ9ECXtjAagQu09sD0MoBdlNxryg=;
        b=TgAvYHfhI4yn2I23fNpxPHzcBl2dDC4BK4zclErlIir9K+ew+JtU2Vax6B3sPa49rd
         NYzel33Chtx5fiWnZsJCOWrVLcmt5JDpVPPvIgkO6n0c+5JWz3CH4ps0NvroIfT5bIgc
         2yfJwgXPESw1AbRrjPTlz0IINmyU/TRVCY/JAcE4bR5s9kgSrPKcKEcAME0d/oF9+OvF
         WSkxzjVTrznwnOr6mlJqJMOv0IOCNliw8L+WsNAzxjTXjSbH5dCu+9O4uM79lJ0wrLLN
         grmxaC9s60JvbYD4Ua5W/gm8+Z3HnEKkE+Kl4YgrLyBc5lE4ganuFz9O5XAMh1v13XZg
         jSkA==
X-Gm-Message-State: APjAAAVgvpxSXY4Cy8kM9NRa2pOGAdEJRpN+jEbcRznlTseTKpoEyUGi
        slIHwsi7nIfT4VD0MUmuYEZtdaVEkluoNF/mTj0=
X-Google-Smtp-Source: APXvYqzODZU0xZFkiQbV2oHfKdWv2Gs85kBFpFSsOl9X7Khg89bfVon2QfK8B95R1BbTnQxJrnue+OzlbfWN8xx3r4g=
X-Received: by 2002:a17:907:11cc:: with SMTP id va12mr91018831ejb.164.1578005288253;
 Thu, 02 Jan 2020 14:48:08 -0800 (PST)
MIME-Version: 1.0
References: <20191227014208.7189-1-olteanv@gmail.com> <20200102.134952.739616655559887645.davem@davemloft.net>
In-Reply-To: <20200102.134952.739616655559887645.davem@davemloft.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 3 Jan 2020 00:47:57 +0200
Message-ID: <CA+h21horyGwqBTyBSVDRSSOSAPr_3i1dvz40=qKQMD_Nddtk3Q@mail.gmail.com>
Subject: Re: [PATCH net-next 0/2] Improvements to the DSA deferred xmit
To:     David Miller <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Thu, 2 Jan 2020 at 23:49, David Miller <davem@davemloft.net> wrote:
>
> Two comments about this patch series, I think it needs more work:
>

Thanks for looking at this series.

> 1) This adds the thread and the xmit queue but not code that actually
>    uses it.  You really have to provide the support code in the driver
>    at the same time you add the new facitlity so we can actually see
>    how it'll be used.
>

There is no API change here. There was, and still is, a single caller
of dsa_defer_xmit in the kernel, from net/dsa/tag_sja1105.c:

    if (unlikely(sja1105_is_link_local(skb)))
        return dsa_defer_xmit(skb, netdev);

The whole difference is that what used to be a schedule_work() in that
function is now a kthread_queue_work() call.

> 2) Patch #1 talks about a tradeoff.  Replacing the CB initialization of
>    the field skb_get().  But this skb_get() is an atomic operation and
>    thus much more expensive for users of the deferred xmit scheme.
>

Ok, I'll admit I hadn't considered the exact penalty introduced by
skb_get, but I think it is a matter of proportions.
Worst case I expect no more than 64 packets per second to be
transmitted using the deferred xmit mechanism: there are 4 switch
ports, PTP runs with a sync interval of 1/8 seconds, and the STP hello
timer is 2 seconds. So, not a lot of traffic.
On the other hand, clearing the deferred_xmit bool from the skb->cb is
something that everybody else (including this driver for "normal"
traffic) needs to do at line rate, just for the above 64 packets per
second (in the worst case) to be possible.

> Thanks.

Regards,
-Vladimir
