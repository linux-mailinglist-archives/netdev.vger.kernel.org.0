Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 223D09AE48
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 13:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393012AbfHWLlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 07:41:52 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35131 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392919AbfHWLlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 07:41:52 -0400
Received: by mail-lj1-f195.google.com with SMTP id l14so8588165lje.2
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 04:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Wc0pBV8XYSwempgeR3yggrLrzcmJJBDB5ERRq19QP4w=;
        b=IUnWnbLScb1sugwDDrGxqMlHj/JXkMfX4z4uuO9U6yHS5KHJK9DFMSGSFJLfbBFnka
         bgNqVz0VssAEuGgxdSTJQQsrCEXiCtJ9hM+u75ufGAYUzEBUKZDwvP1RNg/OmBeAwRwc
         +sonJewfnrQp3IWhIjAEnjn/mVUrYhP+QON2sSin9pO5PIy3xLvN+nmNL0XfQedWsDfk
         VWbYca0GncQtpQh8WdIvH6NeEKjVAzPSf+EPh98YVuBGofsp6CT+PsRceJDw+HklzBE0
         kNtdPOBlzSYblHeP4Wm+pBoABI3lYqvOttY6AAHjjHAJo4O9iUhQo9WqnnFUsz4XtNOa
         T9DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Wc0pBV8XYSwempgeR3yggrLrzcmJJBDB5ERRq19QP4w=;
        b=V8vcfUimuYcqQf+qowDtdaLHMaroYF23QKDSLb9u4kmoybzgmLAxY/ZpHCyEEA5uKW
         FqzoMABntrJekGF6sHIQNDFl8TibJrYpIbH+FUTPvjiA7ZKvh1f4FUKzdI34+XAYJJYL
         /2rHTki6aVreLJrZUO2deVf/h/XDr4NBR/Wp2zLhV+YJMAUkGOGvaGeFTD7XwAgNlzpX
         e54l5yCcI+5aiwXgqMtfnys0D31VuDguFuL3PWEK+e4rVgtyFs4C09dlqVrUfDt2u567
         UHf9oJpTJ3gafAXaFDQVV3jqUGg2/fTbKN3klwSSEmlAN04RkQjSNKzOg1EHZC3/5lQw
         7KfA==
X-Gm-Message-State: APjAAAUCORL45RZ+wIGsdCNN0utbHM1RKyx4D6XK+4ia/uHk3YCVeJk/
        AA2ieF2RG28sxVHGlrLb4dhjfihrnHCFRTdRGQ9AnQ==
X-Google-Smtp-Source: APXvYqwEuB/cMhl/nAEC7z/qHRnNiNTz/9Il2JH8941tpayvBx6eYlh6aTC2ePXDkr4MAsscUOZ/3mxjMhMkFFMl2ek=
X-Received: by 2002:a2e:2b0a:: with SMTP id q10mr2628388lje.203.1566560510230;
 Fri, 23 Aug 2019 04:41:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190821134547.96929-1-jeffv@google.com> <20190822.161913.326746900077543343.davem@davemloft.net>
In-Reply-To: <20190822.161913.326746900077543343.davem@davemloft.net>
From:   Jeffrey Vander Stoep <jeffv@google.com>
Date:   Fri, 23 Aug 2019 13:41:38 +0200
Message-ID: <CABXk95BF=RfqFSHU_---DRHDoKyFON5kS_vYJbc4ns2OS=_t0w@mail.gmail.com>
Subject: Re: [PATCH 1/2] rtnetlink: gate MAC address with an LSM hook
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>,
        selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 23, 2019 at 1:19 AM David Miller <davem@davemloft.net> wrote:
>
> From: Jeff Vander Stoep <jeffv@google.com>
> Date: Wed, 21 Aug 2019 15:45:47 +0200
>
> > MAC addresses are often considered sensitive because they are
> > usually unique and can be used to identify/track a device or
> > user [1].
> >
> > The MAC address is accessible via the RTM_NEWLINK message type of a
> > netlink route socket[2]. Ideally we could grant/deny access to the
> > MAC address on a case-by-case basis without blocking the entire
> > RTM_NEWLINK message type which contains a lot of other useful
> > information. This can be achieved using a new LSM hook on the netlink
> > message receive path. Using this new hook, individual LSMs can select
> > which processes are allowed access to the real MAC, otherwise a
> > default value of zeros is returned. Offloading access control
> > decisions like this to an LSM is convenient because it preserves the
> > status quo for most Linux users while giving the various LSMs
> > flexibility to make finer grained decisions on access to sensitive
> > data based on policy.
> >
> > [1] https://adamdrake.com/mac-addresses-udids-and-privacy.html
> > [2] Other access vectors like ioctl(SIOCGIFHWADDR) are already covered
> > by existing LSM hooks.
> >
> > Signed-off-by: Jeff Vander Stoep <jeffv@google.com>
>
> I'm sure the MAC address will escape into userspace via other means,
> dumping pieces of networking config in other contexts, etc.  I mean,
> if I can get a link dump, I can dump the neighbor table as well.

These are already gated by existing LSM hooks and capability checks.
They are not allowed on mandatory access control systems unless explicitly
granted.

>
> I kinda think this is all very silly whack-a-mole kind of stuff, to
> be quite honest.

We evaluated mechanisms for the MAC to reach unprivileged apps.
A number of researchers have published on this as well such as:
https://www.usenix.org/conference/usenixsecurity19/presentation/reardon

Three "leaks" were identified, two have already been fixed.
-ioctl(SIOCGIFHWADDR). Fixed using finer grained LSM checks
on socket ioctls (similar to this change).
-IPv6 IP addresses. Fixed by no longer including the MAC as part
of the IP address.
-RTM_NEWLINK netlink route messages. The last mole to be whacked.

>
> And like others have said, tomorrow you'll be like "oh crap, we should
> block X too" and we'll get another hook, another config knob, another
> rulset update, etc.

This seems like an issue inherent with permissions/capabilities. I don=E2=
=80=99t
think we should abandon the concept of permissions because someone
can forget to add a check.  Likewise, if someone adds new code to the
kernel and omits a capable(CAP_NET_*) check, I would expect it to be
fixed like any other bug without the idea of capability checks being tossed
out.

We need to do something because this information is being abused. Any
recommendations? This seemed like the simplest approach, but I can
definitely appreciate that it has downsides.

I could make this really generic by adding a single hook to the end of
sock_msgrecv() which would allow an LSM to modify the message to omit
the MAC address and any other information that we deem as sensitive in the
future. Basically what Casey was suggesting. Thoughts on that approach?

Thanks for your help on this.
