Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08F5BE0950
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 18:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388845AbfJVQke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 12:40:34 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35414 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387675AbfJVQkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 12:40:33 -0400
Received: by mail-lj1-f193.google.com with SMTP id m7so17933296lji.2;
        Tue, 22 Oct 2019 09:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TtGgmuqBdqyw7wZ25ByGei25yVgWCU5+4tIPFcDsJMg=;
        b=gAihmNvwtugOVj8i9Tlu1WOUrbZwI/8Sdjmj22TGo7JshXgMmA924urmRBwQvNy5q2
         Oj+D33I50jybuvtRuAUY6g+hJS2hGw/6tJZxpenF9gcINUIciMTe9WdbrilA/Jt3Mr/K
         57D8+vSklb2g4QiqO59ZsSKJLl6Sl9/5CrwziETdJnAt7id2ucmHaPqfNI2kuiloE3xo
         R7BKZMXIjBtaP8GHCLlyirUAB/gUOkY+4z4mGWUw+XExXX2a2cSaxTeeor+zPmpRLMMa
         jZ1BkIt6kn3UGTZ4NZgMd0znzAa5KNHIsf41D5ICtanyKkepZ1MzdsvJ0PvhiMeQnsEp
         zFmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TtGgmuqBdqyw7wZ25ByGei25yVgWCU5+4tIPFcDsJMg=;
        b=qDfrII4A66AISaSk9hUSobhspUcVNoZPzmgpETokvmVQiN7GzowqLO6U8d54BOW/Zz
         MRpt2H6X3ik9ssQ3E4bj3liEXD+cNzMwxeQBjpW5x08bmSFW8F6J6T3cfSoxrsJJpme4
         isM5Ir13ZIQLfLRYXK1CUHw02ZYmEhEgQHG67uaN17DfyJFGLpXhl2tY3vzwGkLnD1rE
         HOusA4OOkEYEFB0IcvDFV/UxQ9SMN+k5NtxKv6x6xF4imPBiVpiW9jAz0NyBFCrjFx8E
         4jjvvlrKXaz2efcFZS3yh1XCsC8jd02lM/MmV0c35622PN76XiWGVjZwRmjlsBUtTKEG
         UYXw==
X-Gm-Message-State: APjAAAXVEqXUfMi+AM/JwxSqiiWzyQXjN0yMOBEGLT1G9exiesKOKI9s
        gy1rrCKQ8L0ecvAw5h+HC2KBqMdbPOsHsYtlrO4=
X-Google-Smtp-Source: APXvYqy6BnF/34OM8wXY4fvA/Q9SX1RElJC3tPPizJfNEiG5yNKH1EUJ7yeMlbNFbaQ9d0HoD8R8XxQN+CqvXN3cm2o=
X-Received: by 2002:a05:651c:150:: with SMTP id c16mr19829157ljd.222.1571762431296;
 Tue, 22 Oct 2019 09:40:31 -0700 (PDT)
MIME-Version: 1.0
References: <20191021184759.13125-1-ap420073@gmail.com> <c0e17051-ab18-ac60-9c00-348cce84d12f@gmail.com>
In-Reply-To: <c0e17051-ab18-ac60-9c00-348cce84d12f@gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Wed, 23 Oct 2019 01:40:19 +0900
Message-ID: <CAMArcTXhC2O6XiOL0Qm_zRDygeaPuxpz5+jS_s6pVgXQvfaYiA@mail.gmail.com>
Subject: Re: [PATCH net v5 01/10] net: core: limit nested device depth
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        j.vosburgh@gmail.com, vfalico@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Cody Schuffelen <schuffelen@google.com>, bjorn@mork.no
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Oct 2019 at 09:51, David Ahern <dsahern@gmail.com> wrote:
>

Hi David,
Thank you for the review!

> On 10/21/19 12:47 PM, Taehee Yoo wrote:
> > Current code doesn't limit the number of nested devices.
> > Nested devices would be handled recursively and this needs huge stack
> > memory. So, unlimited nested devices could make stack overflow.
> >
> > This patch adds upper_level and lower_level, they are common variables
> > and represent maximum lower/upper depth.
> > When upper/lower device is attached or dettached,
> > {lower/upper}_level are updated. and if maximum depth is bigger than 8,
> > attach routine fails and returns -EMLINK.
> >
> > In addition, this patch converts recursive routine of
> > netdev_walk_all_{lower/upper} to iterator routine.
>
> They were made recursive because of a particular setup. Did you verify
> your changes did not break it? See commits starting with
> 5bb61cb5fd115bed1814f6b97417e0f397da3c79
>

I didn't change the actual logic of walking APIs.
These walking iterator APIs work as DFS.
So it doesn't break existing codes.

> >
> > Test commands:
> >     ip link add dummy0 type dummy
> >     ip link add link dummy0 name vlan1 type vlan id 1
> >     ip link set vlan1 up
> >
> >     for i in {2..55}
> >     do
> >           let A=$i-1
> >
> >           ip link add vlan$i link vlan$A type vlan id $i
> >     done
> >     ip link del dummy0
>
> 8 levels of nested vlan seems like complete nonsense. Why not just limit
> that stacking and not mess with the rest which can affect real use cases?

VLAN, BONDING, TEAM, MACSEC, MACVLAN, IPVLAN, VIRT_WIFI, and VXLAN
These interface types can be nested and these could be combined.

team6
   |
vlan5
   |
team4
    |
macvlan3
    |
bond2
    |
vlan1
    |
dummy0

There are so many similar cases even they are not real use cases.
So I think generic code is needed.

Thank you
Taehee Yoo
