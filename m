Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9C81EF658
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 13:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgFELTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 07:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgFELTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 07:19:00 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FD4C08C5C2
        for <netdev@vger.kernel.org>; Fri,  5 Jun 2020 04:19:00 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id n11so9236445qkn.8
        for <netdev@vger.kernel.org>; Fri, 05 Jun 2020 04:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=xKdIBK6vh4VrwRo6cjMZDF/++YitYxEh+O1ta8sFAX4=;
        b=J/5nO8J8aaJCA1OnfhlDWFWOO0giSgmnxwbUiwQi3BJLrGDhnZjG4OL+dx03rlhet3
         wEmGnXRe+JToSrrbUe+LVLxJfyPQ1N8FXK/arFqWGrV+vt/qkn9EJM++81aijnNsCzz8
         s6CRAIjvVEaz1jiz/BhTyka+rZUOplNEvohthX35NLIatoRPxh0AM9ufyc3htFeK4n+Q
         Q5wdPJ2H08JRWP8PR+l5WB2JmMdAVgG3WRbnPpcR2IGQtQaRYGjmfDUu35tGu7myR63h
         lBGu9SdDu0wH6LGAN/pOIgbIxmFZj8PxnggQPWmioglEEnaxfWudSjSlK4pBeiXQDh1Y
         CIHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=xKdIBK6vh4VrwRo6cjMZDF/++YitYxEh+O1ta8sFAX4=;
        b=Ck5Nqi7bi8FPMWh6Xucx14EPzV9VmUzLos1/HNBFGF2KNk0sgJTKkeS3fkYsfVVV/r
         5NoWGgOgCvfyIolL7h3GAwaUl9meX3/5k8aVgCtIotmtBY1b3PWhycQ7kE5i/Qxv28WN
         3FV7O/gdTJpLZAtxvMvIgzew+bVZli8anTuVKxYw0fLPCmWvkk9gkTUP1KXvPz2ob6+O
         C33qbX5fUinzHz9Jq0mCPMKS8+y+Ky6abmdIap0sAj+V/kKgG4Z77pmV/68xuO7EUKR1
         0vnCJ1dEsG1rDA6i1rpncmOMmNTfRFwPyQt6pXV7QgHSewoKKO483GnCxGusNxQOujtc
         3RSA==
X-Gm-Message-State: AOAM5330Ttt6djiSLq6AlZ8O+mUF4/Vj5BJnDV1Is9mmbof8Vgbsxkdi
        j7ZYQXOsznzw/CJbx+DbqPBRoyAzCx3R5sLixb+drx9RTbs=
X-Google-Smtp-Source: ABdhPJz/A8QiAlYMGPMyHDI/afZkGU7/ekTUJK8zlwR/wWh1AqC4BotbO4+uB+zikL/nBNrzygmIEAWFOTo7OtIPxJw=
X-Received: by 2002:a37:a789:: with SMTP id q131mr8956849qke.19.1591355939499;
 Fri, 05 Jun 2020 04:18:59 -0700 (PDT)
MIME-Version: 1.0
From:   "Alexander E. Patrakov" <patrakov@gmail.com>
Date:   Fri, 5 Jun 2020 16:18:48 +0500
Message-ID: <CAN_LGv1uTo2MNso8nT0adWXJ_wGbX5VoiNn9xKoJDR1q04g6FQ@mail.gmail.com>
Subject: VLAN-aware bridge and i40e driver problem
To:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Alexander Duyck <aduyck@mirantis.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

We have some new servers with this kind of dual-port 40GbE network
cards, supported by the in-tree i40e driver:

21:00.0 Ethernet controller [0200]: Intel Corporation Ethernet
Controller XL710 for 40GbE QSFP+ [8086:1583] (rev 02)
21:00.1 Ethernet controller [0200]: Intel Corporation Ethernet
Controller XL710 for 40GbE QSFP+ [8086:1583] (rev 02)

On each server, the two network ports (exposed as enp33s0f0 and
enp33s0f1) are used as slaves of the "bond0" interface, which is
itself used as a port of a vlan-aware bridge (vmbr0). There are tap
interfaces for KVM virtual machines that are also in this bridge, and
assigned to different VLANs as needed. The bond0 interface carries all
VLANs, and is essentially used as a "trunk port".

This is Proxmox (a Debian-based system), so the VLANs are added to the
bond0 interface at boot time via the /etc/network/if-up.d/bridgevlan
script, which runs essentially this:

    port=bond0
    bridge vlan add dev $port vid 2-4094

And here is why this behaves badly.

The "bridge" command does send the whole "add vids" request as a
single netlink message, so there are no inefficiencies at this step.
Then, the bond driver attempts to pass down the VLAN filter down to
the underlying hardware (i.e. to the i40e driver), and that's where
things go downhill.

Apparently the driver attempts to add the VIDs to the hardware filter
one-by-one. And then, after adding 256 VIDs, it hits the hardware
limit and complains:

    i40e 0000:21:00.0: Error I40E_AQ_RC_ENOSPC, forcing overflow
promiscuous on PF

And then goes on to process the next VID, also noticing that it is
beyond the hardware limit, and so on. Result: 3839 lines of log spam
from each network port, and more than 1 minute spent fighting with the
hardware (i.e. slow boot). After that, VLAN filtering and dispatching
of packets to VMs are done in software, and done correctly.

In this setup, the hardware VLAN filtering capability of the card is
useless, because there is actually nothing to filter out from the
wire. However, the slow boot and the log spam annoy sysadmins here. It
would have been better if the i40e driver somehow saw beforehand that
the whole VLAN filtering request is beyond the abilities of the
hardware, and did not attempt to add, fruitlessly, the VID entries
one-by-one. After all, on other servers, with "Mellanox Technologies
MT27700 Family [ConnectX-4] [15b3:1013]" (mlx5_core driver), it takes
less than 1 second to add these VLANs to bond0. Is it because the
Mellanox card is somehow better, or is it just a gross inefficiency of
the i40e driver? Could anyone familiar with the card please try to fix
the i40e driver?

I have tried to force the VLAN filtering in software, via ethtool:

    ethtool -K enp33s0f0 rx-vlan-filter off

But it doesn't work, because (since at least commit
b0fe3306432796c8f7adbede8ccd479bb7b53d0a, which adds it to
netdev->features but not netdev->hw_features) this is not a
user-changeable option on i40e. Question to the driver maintainers:
why is it so?

P.S. We have finally found and adopted this workaround:

    ethtool -K bond0 rx-vlan-filter off

...and things work reasonably well: fast boot, no log spam, okay-ish
performance (14.5 Gbps per CPU core).

P.P.S. I suspect that it would have been better to use macvlan instead
of the VLAN-aware bridge, but for legacy reasons we can't do that.

-- 
Alexander E. Patrakov
CV: http://pc.cd/PLz7
