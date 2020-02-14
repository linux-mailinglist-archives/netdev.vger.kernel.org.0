Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9D8615D5DE
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 11:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387435AbgBNKg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 05:36:57 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40628 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387397AbgBNKg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 05:36:56 -0500
Received: by mail-ed1-f65.google.com with SMTP id p3so10646424edx.7;
        Fri, 14 Feb 2020 02:36:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WVzlWBO+qXRlFv/AAG4sw5LWPZSIH/FzagE/SkkIFnA=;
        b=mCAXyo9bgMLC68YigAd9JtK/tZqKNr3JX69OB39q7IzGJ7GFxdNSQffMnk7/M3EYAm
         FlC6l/fqszatqihJBwBbC5jzFg+KOHid1L+NXazY6UaZ35+5LC2U0vshCjUUoLA/aq66
         N7KLV6G2csFaJun1YKiimJlTPieSScf0CvNLxdoE2rZj6DwkxEJmUGmFDhE0dhA8H8Co
         ReLuv/q3ZEFRVQRaFt1eaaaVO5d35u97JNhE8WFHG41L6V6QakI12ZX0dzEo76BG2Ipe
         iAJw7HxzcpTuIzqxxbq3gOIyex0KLVfBhw7RZiUSbf7XHYdYpJN1o9LEPRnIwJh0QQ8x
         ARUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WVzlWBO+qXRlFv/AAG4sw5LWPZSIH/FzagE/SkkIFnA=;
        b=pUnw4hQ3gUK8CpwQi2tmrF/vhzSNxactfCMwfPY/mPUdAK6Zp1Txzlje2+DiJ1HPQ/
         Wf1vNUel3fSsXe9hX5DjGlU/6x520fqG20UkDDmdjxu38sibxqu9OUu0kfKUniSgJhpc
         mDqRQZ3LdnYryu0fvjOwsRsdVhRBGTj3NITEv61wBlbptVvo6pggcK3AN2oMBzzCchgz
         kTqZHJmUbHjdqu+/vYIh2Ho6LHEI7rkhvVZhRL+9YKLAZyYGzj97/+tBgOJ6PSo4kFT8
         ZqHnWM5w5IInFiICOJchVHQ7T9BrTKeWb6VXzlBepyAj0bTRmB+pU4R4vGCqCEX5XBZT
         sXKg==
X-Gm-Message-State: APjAAAWzvkvbEQfAHLsR7vTSeT+s//0O212c7dQ939i8CNlvmzDOSMp2
        NCp3HQBcYqfdN8pxdaZlhPEeATv7iuVEciQxyVw=
X-Google-Smtp-Source: APXvYqwx8ZzKTkZpK/TEg7RvlLlZXlhJdcRcHPpJPErTGM2tZs5yqIXkqWPNo8EPorK/Bu17/gK6pZNst1lH16CP1G8=
X-Received: by 2002:a17:906:7a07:: with SMTP id d7mr2449372ejo.176.1581676614799;
 Fri, 14 Feb 2020 02:36:54 -0800 (PST)
MIME-Version: 1.0
References: <20200213191015.7150-1-f.fainelli@gmail.com>
In-Reply-To: <20200213191015.7150-1-f.fainelli@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 14 Feb 2020 12:36:43 +0200
Message-ID: <CA+h21hqVWc6Tis12oJsfgXtsW2mJr0qUFu28G3qjMf-sOJWAwg@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: b53: Ensure the default VID is untagged
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Thu, 13 Feb 2020 at 21:10, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> We need to ensure that the default VID is untagged otherwise the switch
> will be sending frames tagged frames and the results can be problematic.
> This is especially true with b53 switches that use VID 0 as their
> default VLAN since VID 0 has a special meaning.
>
> Fixes: fea83353177a ("net: dsa: b53: Fix default VLAN ID")
> Fixes: 061f6a505ac3 ("net: dsa: Add ndo_vlan_rx_{add, kill}_vid implementation")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/net/dsa/b53/b53_common.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
> index 449a22172e07..f25c43b300d4 100644
> --- a/drivers/net/dsa/b53/b53_common.c
> +++ b/drivers/net/dsa/b53/b53_common.c
> @@ -1366,6 +1366,9 @@ void b53_vlan_add(struct dsa_switch *ds, int port,
>
>                 b53_get_vlan_entry(dev, vid, vl);
>
> +               if (vid == b53_default_pvid(dev))
> +                       untagged = true;
> +
>                 vl->members |= BIT(port);
>                 if (untagged && !dsa_is_cpu_port(ds, port))
>                         vl->untag |= BIT(port);
> --
> 2.17.1
>

Don't you mean to force untagged egress only for the pvid value of 0?

Thanks,
-Vladimir
