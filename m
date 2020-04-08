Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 704E31A29D3
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 21:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730258AbgDHTwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 15:52:09 -0400
Received: from mail-ed1-f45.google.com ([209.85.208.45]:33821 "EHLO
        mail-ed1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730241AbgDHTwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 15:52:09 -0400
Received: by mail-ed1-f45.google.com with SMTP id x62so905972ede.1
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 12:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CboodcVvwtzW3/aQ8Pi+ymM7G7VFfpwymh8FVRRX08M=;
        b=VVl7xO43JjE+fDlHyDC8u3kZSyXD+ij+vvbQLFs1GSXstwnNuFYR9qwFLhsp3m01fI
         B1doHoJKexuaqqAHCd5s/l2RGO5HPlYuyRZWKUZBa2wKH4W9ewga6kg6F8OiQWOAgplf
         CjS5NJxLHZz59hGq/rWVbkrq6iD22jKsXetsdeKGqQVQUEPWM/Ohy+vBt0Z3dhku5wI+
         xLOoVkpcI14tG8P7x99Kf+wj5V8FfnKKIdkmOQMLmFaoE5WpvPJ1/2cgaaCXyZ28YSiu
         UMf0G0sbuFre+yG16d0ueX9NWCgr4duCmdkdcl84JA0lzxoHysKBgzwZe5j8bnDnCLGN
         JNNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CboodcVvwtzW3/aQ8Pi+ymM7G7VFfpwymh8FVRRX08M=;
        b=tA55mg+m/H5dTS58AC7F41XT6luXqBBznbU1VC+76I0ys8eiy7KY2nvVvQK/vPIHJP
         1hGpbBcfSoB6uXhBG2W9pDJc93xx2/nP4p0DaHmkSPTAGh3bYK9pB071yEF4JRuNgl6P
         FII3eVQgusONfTQSUFlk/jymRSHPFIbmAzQNCDbrj5FwwFK97MUmSU6ZL7jeTy9bGIlt
         P3Wwo/Ufk6cb2nA+KDoc+p/eZr1omVEaUg+hx2JGoSfVgOmbQUe6M9ABToxEyJBi6yZ8
         uQyJQ5aKh/gCVgw5LoFtdTKM3sqIppBxzagov3CzUjms/83z607tvOTZFr4YSdb2jan6
         zsxw==
X-Gm-Message-State: AGi0PuaV09HYHzUpmHHqJ+Azh4iIMNN5Q8gys5hWrcYrv3ZdslqeAdAl
        whbBWWgif2UxCJTrpsB+s4J6+MVZvrKtcFy2Wbk=
X-Google-Smtp-Source: APiQypIzTEpgUJoUyVSQX61p2vNfjWv6fLrWPMtqXPPQb0LmSq4bByGRa+tVty2ZdK644Rv95EMsGKAXRsZFD3vE+b0=
X-Received: by 2002:a50:9ea1:: with SMTP id a30mr8340003edf.318.1586375526135;
 Wed, 08 Apr 2020 12:52:06 -0700 (PDT)
MIME-Version: 1.0
References: <ef16b5bb-4115-e540-0ffd-1531e5982612@gmail.com>
In-Reply-To: <ef16b5bb-4115-e540-0ffd-1531e5982612@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 8 Apr 2020 22:51:55 +0300
Message-ID: <CA+h21hrtUg9Xxwxfe+N6MkY2eSjjDTQc+sTtRwYW4kf_u3quwA@mail.gmail.com>
Subject: Re: Changing devlink port flavor dynamically for DSA
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Sun, 5 Apr 2020 at 23:42, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> Hi all,
>
> On a BCM7278 system, we have two ports of the switch: 5 and 8, that
> connect to separate Ethernet MACs that the host/CPU can control. In
> premise they are both interchangeable because the switch supports
> configuring the management port to be either 5 or 8 and the Ethernet
> MACs are two identical instances.
>
> The Ethernet MACs are scheduled differently across the memory controller
> (they have different bandwidth and priority allocations) so it is
> desirable to select an Ethernet MAC capable of sustaining bandwidth and
> latency for host networking. Our current (in the downstream kernel) use
> case is to expose port 5 solely as a control end-point to the user and
> leave it to the user how they wish to use the Ethernet MAC behind port
> 5. Some customers use it to bridge Wi-Fi traffic, some simply keep it
> disabled. Port 5 of that switch does not make use of Broadcom tags in
> that case, since ARL-based forwarding works just fine.
>
> The current Device Tree representation that we have for that system
> makes it possible for either port to be elected as the CPU port from a
> DSA perspective as they both have an "ethernet" phandle property that
> points to the appropriate Ethernet MAC node, because of that the DSA
> framework treats them as CPU ports.
>
> My current line of thinking is to permit a port to be configured as
> either "cpu" or "user" flavor and do that through devlink. This can
> create some challenges but hopefully this also paves the way for finally
> supporting "multi-CPU port" configurations. I am thinking something like
> this would be how I would like it to be configured:
>
> # First configure port 8 as the new CPU port
> devlink port set pci/0000:01:00.0/8 type cpu
> # Now unmap port 5 from being a CPU port
> devlink port set pci/0000:01:00.0/1 type eth
>
> and this would do a simple "swap" of all user ports being now associated
> with port 8, and no longer with port 5, thus permitting port 5 from
> becoming a standard user port. Or maybe, we need to do this as an atomic
> operation in order to avoid a switch being configured with no CPU port
> anymore, so something like this instead:
>
> devlink port set pci/0000:01:00.0/5 type eth mgmt pci/0000:01:00.0/8
>
> The latter could also be used to define groups of ports within a switch
> that has multiple CPU ports, e.g.:
>
> # Ports 1 through 4 "bound" to CPU port 5:
>
> for i in $(seq 0 3)
> do
>         devlink port set pci/0000:01:00.0/$i type eth mgmt pci/0000:01:00.0/5
> done
>
> # Ports 7 bound to CPU port 8:
>
> devlink port set pci/0000:01:00.0/1 type eth mgmt pci/0000:01:00.0/8
>
> Let me know what you think!
>
> Thanks
> --
> Florian

What is missing from your argumentation is what would the new devlink
mechanism of changing the CPU port bring for your particular use case.
I mean you can already remove the "ethernet" device tree property from
port 5 and end up exactly with the configuration that you want, no?

Regards,
-Vladimir
