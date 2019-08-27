Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95CB59E8C4
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 15:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730108AbfH0NLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 09:11:15 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39405 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728653AbfH0NLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 09:11:15 -0400
Received: by mail-lf1-f67.google.com with SMTP id x3so15138768lfn.6
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 06:11:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dDXX9hAane5Jxpq2uWxzw3oHF7BPKINlu9tcRPv1O74=;
        b=I3GAHdJxIJsjZleQ7TePtiL7zaxMCTw2QaSWtc47pYEhm+C+4tWtF2OjKaTh2ZLcWH
         avlxwl+5q7cWxBBIx9M7AXOLW5d1QR5gZq44QL+2ERJAVsEysnWbTiyzkDFMdhLwWDRZ
         M2j0I++0K9rT9/ZVOERI6ll/wTkQ4N538+OfM99179orH7QswTvRTk18Wyux3E26p2zy
         l0SGUaQ8Wp6lUfBavvs6P7mvtf0bNvLS+9upslDGh42OcypQgPWPzckW/FZSXxBFfGVI
         FkcQX2Ijamfj0tbvsaoyp99MXAzW3doBMjv5fKGM6kb/Nq/PL37zgDiM1eBgHX2qxZTT
         00Hw==
X-Gm-Message-State: APjAAAUQOWHGNH2hnqyJsm9yeAKCWbsd/PslnGUXnWjQSCWFR7SvCsQI
        Esl/mRVHlvT/OOe8wbXVgN70t61qi/PoWkCpTlkrVQyg
X-Google-Smtp-Source: APXvYqwIDMpVRdbewGoJDNA1++iURyRvS7sGaMqwHGI+4cuX/TkmadyTiw7IIjY7ktrQH1zOd0qVi0zkZXuJRJMrFpQ=
X-Received: by 2002:a19:f51a:: with SMTP id j26mr10200019lfb.147.1566911473480;
 Tue, 27 Aug 2019 06:11:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190823154721.9927-1-idosch@idosch.org>
In-Reply-To: <20190823154721.9927-1-idosch@idosch.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 27 Aug 2019 15:10:56 +0200
Message-ID: <CAK8P3a21AeWTvm1+roStbMGHCkK0tWcuWc-Dk-J_5Ea+XTPUMA@mail.gmail.com>
Subject: Re: [PATCH net-next] drop_monitor: Make timestamps y2038 safe
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Networking <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        Andrew Lunn <andrew@lunn.ch>, Aya Levin <ayal@mellanox.com>,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 23, 2019 at 5:48 PM Ido Schimmel <idosch@idosch.org> wrote:
>
> From: Ido Schimmel <idosch@mellanox.com>
>
> Timestamps are currently communicated to user space as 'struct
> timespec', which is not considered y2038 safe since it uses a 32-bit
> signed value for seconds.
>
> Fix this while the API is still not part of any official kernel release
> by using 64-bit nanoseconds timestamps instead.
>
> Fixes: ca30707dee2b ("drop_monitor: Add packet alert mode")
> Fixes: 5e58109b1ea4 ("drop_monitor: Add support for packet alert mode for hardware drops")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> ---
> Arnd, I have followed your recommendation to use 64-bit nanoseconds
> timestamps. I would appreciate it if you could review this change.

somewhat late reply:


> @@ -761,8 +759,8 @@ static int net_dm_hw_packet_report_fill(struct sk_buff *msg,
>                         goto nla_put_failure;
>         }
>
> -       if (ktime_to_timespec_cond(skb->tstamp, &ts) &&
> -           nla_put(msg, NET_DM_ATTR_TIMESTAMP, sizeof(ts), &ts))
> +       if (nla_put_u64_64bit(msg, NET_DM_ATTR_TIMESTAMP,
> +                             ktime_to_ns(skb->tstamp), NET_DM_ATTR_PAD))
>                 goto nla_put_failure;
>
>         if (nla_put_u32(msg, NET_DM_ATTR_ORIG_LEN, skb->len))

Yes, this looks reasonable. I guess since we take the skb timestamps
in CLOCK_REALTIME, there is little point in trying to use
CLOCK_MONOTONIC in the user interface.

64-bit nanoseconds are safe for a few hundred years.

       Arnd
