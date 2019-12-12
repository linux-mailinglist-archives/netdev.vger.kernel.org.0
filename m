Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB62D11D25B
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 17:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729956AbfLLQcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 11:32:02 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:40552 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729857AbfLLQcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 11:32:02 -0500
Received: by mail-lf1-f65.google.com with SMTP id i23so2167779lfo.7;
        Thu, 12 Dec 2019 08:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iMtrFaOx5zO3RN/AAutoljB+onBiD3BJRHs5f2zZfww=;
        b=RX0b/2HpsKZ7maRpMri6BR1fLBSsr8jB3blJdj2v9ZtRJDZm/64TPjzD6jAcDoqxCD
         axOyXYFX28C6WELe7LwQkjK1jRxAP4eUWzcIEXMaurpHhAXRyLxKr80Yx0M8gYEik0Rp
         OWV+5nba5PaFRT9LXejGtKdUeavvOE7T+bnLLxG9X4yvLNcfOUannt6ffP38z5NUfeFW
         KU2pvyxU1dNdhfFvsSpDPyeJvakGaSk0K1XirMHIyAnhOLdqeYDPR5b0KmJyvWI9CFFE
         BzYmx598f/124HZuezJ61isYRjRLsgxv/K+n+VIC4K6gMRDu8QkhCsqONjnMkM9JWMnY
         S2ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iMtrFaOx5zO3RN/AAutoljB+onBiD3BJRHs5f2zZfww=;
        b=o669tte2EqOu22/cGBsSzYwSHTrSeT9llGEqF2uGfrEm8vak3MKfPetoKHoL2fFVqu
         c2SO0axLLMQAED1cy4nguy9fRo3E0z+ruBrKsTLvWcz8nbvmrG36vJItCOVEcKAAGP+0
         reIfIsTlo7qGEkgIwEU6JYkqHVWId+8fAMkxwbKPuuBNLBjJcghMhleY+O5GrQO84qsJ
         uKtzX1eJH3w1w2pdb2Ap3cwg4AS6xaRZoc+KDaxLm5L6FLqXXsO20hTYiaxqirJioVLj
         pRKFehTu9GgqOtWdQYp9cor+797IfHCsfLLf7Jb90q0mUVQaEkxiRhtvwiK36EciVgHL
         qilw==
X-Gm-Message-State: APjAAAXfujR4TQ5JS7LY+di9+FD3v0Y8Rgi99PZ22mABuPmhViCTNunT
        /bSIGftguFomgDDJhBcQM3B633Xz/7kNs3HTgfg=
X-Google-Smtp-Source: APXvYqzbEtYK5Q5oEXt2n7X+G+gbVpXS1yFhxc9zA94lLDEQFKWdm/8jhDBvCKej+JQx8nnccF+Nd/csIpO6l6eqoOU=
X-Received: by 2002:ac2:555c:: with SMTP id l28mr6129545lfk.52.1576168319470;
 Thu, 12 Dec 2019 08:31:59 -0800 (PST)
MIME-Version: 1.0
References: <20191212135406.26229-1-pdurrant@amazon.com>
In-Reply-To: <20191212135406.26229-1-pdurrant@amazon.com>
From:   Jason Andryuk <jandryuk@gmail.com>
Date:   Thu, 12 Dec 2019 11:31:48 -0500
Message-ID: <CAKf6xptNRAuvjqzqFwbPmetYsTdPOMgTT0AWEouwjsHq1iCV6w@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH net-next] xen-netback: get rid of old udev
 related code
To:     Paul Durrant <pdurrant@amazon.com>
Cc:     xen-devel <xen-devel@lists.xenproject.org>, netdev@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 8:56 AM Paul Durrant <pdurrant@amazon.com> wrote:
>
> In the past it used to be the case that the Xen toolstack relied upon
> udev to execute backend hotplug scripts. However this has not been the
> case for many releases now and removal of the associated code in
> xen-netback shortens the source by more than 100 lines, and removes much
> complexity in the interaction with the xenstore backend state.
>
> NOTE: xen-netback is the only xenbus driver to have a functional uevent()
>       method. The only other driver to have a method at all is
>       pvcalls-back, and currently pvcalls_back_uevent() simply returns 0.
>       Hence this patch also facilitates further cleanup.
>
> Signed-off-by: Paul Durrant <pdurrant@amazon.com>
> ---
> Cc: Wei Liu <wei.liu@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> ---
>  drivers/net/xen-netback/common.h |  11 ---
>  drivers/net/xen-netback/xenbus.c | 125 ++++---------------------------
>  2 files changed, 14 insertions(+), 122 deletions(-)
>
> diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
> index 05847eb91a1b..e48da004c1a3 100644

<snip>

> -static inline void backend_switch_state(struct backend_info *be,
> -                                       enum xenbus_state state)
> -{
> -       struct xenbus_device *dev = be->dev;
> -
> -       pr_debug("%s -> %s\n", dev->nodename, xenbus_strstate(state));
> -       be->state = state;
> -
> -       /* If we are waiting for a hotplug script then defer the
> -        * actual xenbus state change.
> -        */
> -       if (!be->have_hotplug_status_watch)
> -               xenbus_switch_state(dev, state);

have_hotplug_status_watch prevents xen-netback from switching to
connected state unless the the backend scripts have written
"hotplug-status" "success".  I had always thought that was intentional
so the frontend doesn't connect when the backend is unconnected.  i.e.
if the backend scripts fails, it writes "hotplug-status" "error" and
the frontend doesn't connect.

That behavior is independent of using udev to run the scripts.  I'm
not opposed to removing it, but I think it at least warrants
mentioning in the commit message.

Regards,
Jason
