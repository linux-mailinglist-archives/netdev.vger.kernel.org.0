Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D59C09C588
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 20:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbfHYS1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 14:27:37 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:33086 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbfHYS1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 14:27:36 -0400
Received: by mail-ed1-f68.google.com with SMTP id s15so23151069edx.0
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 11:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rI+8choy45ch3oAWLKsa9G88wnwGOvm5yRFqAqpXxx8=;
        b=WOozwVQ9q7Tc3G4LvH522PVvwkYvtsU8rWbiciKgFnODwC05ECLgX2OL+PQGMj5UcD
         dqwc9gaO/fwWxXN3nD5uh9QElHkv4yGbPUg0jRuEzVPXbKhL5Bd6PA5jcwXfKsm87RD7
         h+UgmIZUiDobDh56KuxqxMKqJK/5n7PT8Q2y8AwAlB/LphF4zbYFFfZ7IicXT/MivZKL
         r5mFwrGT/L5LO10tgLsEXU9wTqb+xiudoajzlXMZQLjvmG268h8jFKzicVHY4LtX3E7U
         xdDDFqpnb8/YV+1vZV1Ax4ePpvNNmJl8E68nlhCw6BBwYB9706arwxi/aYRmsc6d+jji
         c5oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rI+8choy45ch3oAWLKsa9G88wnwGOvm5yRFqAqpXxx8=;
        b=b0u7OmaEUswLHNQtR1jjcPTuiV23nj04qaBivyuHReNUwad2M+WZi0H9Bc/799TrzD
         6POA5xZGqXGKktxBPZP+7d6O+D3U29XBm/U4OZ4Vm+KVZF9e61oLIuaR4OtCeEdw1bUo
         sAqakVN8ZdM3NBc210LP/Kv2eKvpU3L4IxcyHy/f+TINFuCr8gacWp+IR3iPKN75GyY1
         y0ET2XotcjqT3LkFRZiSNmVeCDv8Hzverzvv1qXXa5kMxFuApaeCSJjo0VvhLPwHvRAn
         EMw+WUASl8DU0zqjEHb+7Cz+yvRUm997gAJqkJ6zu954xO6zOFkAtvyK2jOJ+sitXmGU
         UY/A==
X-Gm-Message-State: APjAAAUPONU7doZUXzo1CiKiPCM7WVogBjnCYWrfQGHUDVxyji3lUWlv
        6bKLlDkty1aZ1jqllAFWP2bV4Ho000z/dOszP37SnQ==
X-Google-Smtp-Source: APXvYqxNMOZjCQMTrMS1s983l/idGDAeR2wYTGTE3ftx3cnn++4iD4SwxcbD7d3RYV9jLeDhSQ3TBJzpnv4iwBl186Q=
X-Received: by 2002:aa7:d811:: with SMTP id v17mr14970130edq.165.1566757655044;
 Sun, 25 Aug 2019 11:27:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190825172520.22798-1-vivien.didelot@gmail.com>
In-Reply-To: <20190825172520.22798-1-vivien.didelot@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 25 Aug 2019 21:27:23 +0300
Message-ID: <CA+h21hqPTqzCPPYqF1zvbGhu=yeqPFQ_X77xtfmt1mzENDQ9Dw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/6] net: dsa: explicit programmation of VLAN
 on CPU ports
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 25 Aug 2019 at 20:25, Vivien Didelot <vivien.didelot@gmail.com> wrote:
>
> When a VLAN is programmed on a user port, every switch of the fabric also
> program the CPU ports and the DSA links as part of the VLAN. To do that,
> DSA makes use of bitmaps to prepare all members of a VLAN.
>
> While this is expected for DSA links which are used as conduit between
> interconnected switches, only the dedicated CPU port of the slave must be
> programmed, not all CPU ports of the fabric. This may also cause problems in
> other corners of DSA such as the tag_8021q.c driver, which needs to program
> its ports manually, CPU port included.
>
> We need the dsa_port_vlan_{add,del} functions and its dsa_port_vid_{add,del}
> variants to simply trigger the VLAN programmation without any logic in them,
> but they may currently skip the operation based on the bridge device state.
>
> This patchset gets rid of the bitmap operations, and moves the bridge device
> check as well as the explicit programmation of CPU ports where they belong,
> in the slave code.
>
> While at it, clear the VLAN flags before programming a CPU port, as it
> doesn't make sense to forward the PVID flag for example for such ports.
>
> Changes in v2: only clear the PVID flag.
>
> Vivien Didelot (6):
>   net: dsa: remove bitmap operations
>   net: dsa: do not skip -EOPNOTSUPP in dsa_port_vid_add
>   net: dsa: add slave VLAN helpers
>   net: dsa: check bridge VLAN in slave operations
>   net: dsa: program VLAN on CPU port from slave
>   net: dsa: clear VLAN PVID flag for CPU port
>
>  include/net/dsa.h |   3 --
>  net/dsa/dsa2.c    |  14 -----
>  net/dsa/port.c    |  14 ++---
>  net/dsa/slave.c   |  79 +++++++++++++++++++++++----
>  net/dsa/switch.c  | 135 +++++++++++++++++++++-------------------------
>  5 files changed, 136 insertions(+), 109 deletions(-)
>
> --
> 2.23.0
>

For the whole series:
Tested-by: Vladimir Oltean <olteanv@gmail.com>
Thanks!
