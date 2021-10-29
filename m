Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81039440021
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 18:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhJ2QR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 12:17:27 -0400
Received: from mail-yb1-f172.google.com ([209.85.219.172]:34549 "EHLO
        mail-yb1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbhJ2QR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 12:17:26 -0400
Received: by mail-yb1-f172.google.com with SMTP id o12so25559606ybk.1;
        Fri, 29 Oct 2021 09:14:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oKjnW8Wi5ameq9ZMSBh8BH9BlCqJ+OFy7SiHKMqkhbQ=;
        b=3Zv/kSY/iHuzIByGrAYCn/HIJcq2a1odBHs80ClMHDkuumCRSxCfWq5Rl63Ql9ccxK
         9DhPTLaNx4X/M+4IVruPfecbNT0UmORQI4WTJ8hvtXGg4Em67Z7pb0Kc+QgZFqXVRA3S
         TRCI0bZ53xQKyfiLuYqhRe2VUil/Q29tCCQGL0a4PoHZjJEyEBvfltGgKzl1c9r06wqC
         kI2ZM9JI2+JKi9wmzie53rsvUiApCU2qb21dDhVXtonyskrra//vbcENnVVRLGBTJIrl
         48Yt5lx+bxdJ5fNC/Vp2GaZSVOK/TRMFiD7qfBpaOQoky/xxGpzOVCdtc4LQW9t0sznM
         d4vg==
X-Gm-Message-State: AOAM531F2DRo97uwDGfkF/kzMDZ6XRP1g/+S3OrH9Txf6E0Kk4jVV+Xt
        38f3j7URXy6SFlu76y9HLeJICqmlDmR0BAQTb81GBCS9sVw=
X-Google-Smtp-Source: ABdhPJwjI6ho30zLCdGoteZKoFRUeazaC/CJHWBypoQ3wkvjJG7RMribu9cR3x2tON1BJoM5kvJFSRVAbrXIK1je2v0=
X-Received: by 2002:a25:3b49:: with SMTP id i70mr13534928yba.375.1635524097574;
 Fri, 29 Oct 2021 09:14:57 -0700 (PDT)
MIME-Version: 1.0
References: <20211026121651.1814251-1-mailhol.vincent@wanadoo.fr> <20211029124411.lkmngckiiwotste7@pengutronix.de>
In-Reply-To: <20211029124411.lkmngckiiwotste7@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Sat, 30 Oct 2021 01:14:46 +0900
Message-ID: <CAMZ6Rq+RH3C3C5=qzZ_CRRF3bnW+oDB7_P_OW3UEp9Ty2GNfbQ@mail.gmail.com>
Subject: Re: [PATCH v4] can: netlink: report the CAN controller mode supported flags
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri. 29 Oct 2021 at 21:44, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 26.10.2021 21:16:51, Vincent Mailhol wrote:
> > This patch introduces a method for the user to check both the
> > supported and the static capabilities. The proposed method reuses the
> > existing struct can_ctrlmode and thus do not need a new IFLA_CAN_*
> > entry.
> >
> > Currently, the CAN netlink interface provides no easy ways to check
> > the capabilities of a given controller. The only method from the
> > command line is to try each CAN_CTRLMODE_* individually to check
> > whether the netlink interface returns an -EOPNOTSUPP error or not
> > (alternatively, one may find it easier to directly check the source
> > code of the driver instead...)
> >
> > It appears that can_ctrlmode::mask is only used in one direction: from
> > the userland to the kernel. So we can just reuse this field in the
> > other direction (from the kernel to userland). But, because the
> > semantic is different, we use a union to give this field a proper
> > name: "supported".
> >
> > The union is tagged as packed to prevent any ABI from adding
> > padding. In fact, any padding added after the union would change the
> > offset of can_ctrlmode::flags within the structure and thus break the
> > UAPI backward compatibility. References:
> >
> >   - ISO/IEC 9899-1999, section 6.7.2.1 "Structure and union
> >     specifiers", clause 15: "There may be unnamed padding at the end
> >     of a structure or union."
> >
> >   - The -mstructure-size-boundary=64 ARM option in GCC:
> >     https://gcc.gnu.org/onlinedocs/gcc/ARM-Options.html
> >
> >   - A similar issue which occurred on struct can_frame:
> >     https://lore.kernel.org/linux-can/212c8bc3-89f9-9c33-ed1b-b50ac04e7532@hartkopp.net
> >
> > Below table explains how the two fields can_ctrlmode::supported and
> > can_ctrlmode::flags, when masked with any of the CAN_CTRLMODE_* bit
> > flags, allow us to identify both the supported and the static
> > capabilities:
> >
> >  supported &  flags &         Controller capabilities
> >  CAN_CTRLMODE_*       CAN_CTRLMODE_*
> >  -----------------------------------------------------------------------
> >  false                false           Feature not supported (always disabled)
> >  false                true            Static feature (always enabled)
> >  true         false           Feature supported but disabled
> >  true         true            Feature supported and enabled
>
> What about forwards and backwards compatibility?

Backward compatibility (new kernel, old iproute2) should be OK: the
kernel will report the value but it will not be consumed.

> Using the new ip (or any other user space app) on an old kernel, it
> looks like enabled features are static features. For example the ip
> output on a mcp251xfd with enabled CAN-FD, which is _not_ static.
>
> |         "linkinfo": {
> |             "info_kind": "can",
> |             "info_data": {
> |                 "ctrlmode": [ "FD" ],
> |                 "ctrlmode_static": [ "FD" ],
> |                 "state": "ERROR-ACTIVE",
> |                 "berr_counter": {
> |                     "tx": 0,
> |                     "rx": 0
> |                 },

I missed that, nice catch!

> Is it worth and add a new IFLA_CAN_CTRLMODE_EXT that doesn't pass a
> struct, but is a NLA_NESTED type?

Adding a new nested entry only for one u32 seemed overkill to
me. This is why I tried to do the change as tiny as possible.

I would like to use this IFLA_CAN_CTRLMODE_EXT as a last
resort. I gave it a second thought and I have another idea: we
could keep the exact same kernel code and just have the userland
to discard the can_ctrlmode::supported if it is zero. The caveat
would be that it will be impossible to report the static features
of a controller which do have ctrlmode_static features but no
ctrlmode_supported features. Other use cases would be
supported. As a matter of fact, the two drivers which rely on the
static features (m_can and rcar_canfd) do also have supported
modes. So discarding can_ctrlmode::supported when it is zero would
introduce no issue for all existing drivers. The only remaining
risk is for the yet to be introduced drivers.

So if we are ready to accept the limitation that we would not be
able to report the static features of such hypothetical drivers,
then we can keep the current patch (maybe add a comment) and
introduce an if switch in iproute2 to discard zero value.

The probability for such a driver to ever exist is already low. I
think that this limitation is acceptable.

What do you think?
