Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD99709F8
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 21:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732300AbfGVTnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 15:43:19 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:40288 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732126AbfGVTnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 15:43:18 -0400
Received: by mail-ed1-f68.google.com with SMTP id k8so41611231eds.7
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 12:43:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=egr5Kh4eBg/xC7/XFAF1IBuNmDxDL9wrp7NxRy/jEvA=;
        b=FESKKDchIuOi7vaJoXUWRbRvfcGzuCLo4eO7FvZFMA2R0nXYR2NQJKRStX+xqgDToz
         hBLV40FBIe/kTdqwUfocYU8sQI+ifEPkaaFBGwz7ZAdSzoRL5L1gXAPGfenDMsAE4b2T
         9qEZWpmxsUXMwz08JKA5iyAYjuRuRN0qfkpdiDx77PQBOvPts3IhqW1ad5H3rQhzY8aJ
         HKp5WK+6iHfgTC8RjJKGjUWDqn2OM8r/1UD9OZjj82rFOpQcrhUCEf921r2b1f2YfMHN
         Sl3x32pK1fYbU7XRHkKMqxsmT2dElaS1gVgiFbDJgFbpbwbVwH8NXHoSKl1mVQTnYPMt
         HGhQ==
X-Gm-Message-State: APjAAAXnVUKdCB4cX9CR8czRC/RIqTmItiz4pQFhDnLJAh4VFAs9SvYE
        WpStvHgLWWBE2b3NT78mOEtZOg==
X-Google-Smtp-Source: APXvYqwCSYXliF9t7T+Ke9lI/FxfgwoO9vE+rb+NY7+uHoRGm1RqGfTQaqh7VzhxMh+QowdLYDw/SA==
X-Received: by 2002:a17:906:2111:: with SMTP id 17mr53454802ejt.75.1563824597474;
        Mon, 22 Jul 2019 12:43:17 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id rv16sm8110436ejb.79.2019.07.22.12.43.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 12:43:16 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 63CBF181CE7; Mon, 22 Jul 2019 21:43:15 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        jakub.kicinski@netronome.com, andy@greyhouse.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 00/12] drop_monitor: Capture dropped packets and metadata
In-Reply-To: <20190722183134.14516-1-idosch@idosch.org>
References: <20190722183134.14516-1-idosch@idosch.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 22 Jul 2019 21:43:15 +0200
Message-ID: <87imrt4zzg.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ido Schimmel <idosch@idosch.org> writes:

> From: Ido Schimmel <idosch@mellanox.com>
>
> So far drop monitor supported only one mode of operation in which a
> summary of recent packet drops is periodically sent to user space as a
> netlink event. The event only includes the drop location (program
> counter) and number of drops in the last interval.
>
> While this mode of operation allows one to understand if the system is
> dropping packets, it is not sufficient if a more detailed analysis is
> required. Both the packet itself and related metadata are missing.
>
> This patchset extends drop monitor with another mode of operation where
> the packet - potentially truncated - and metadata (e.g., drop location,
> timestamp, netdev) are sent to user space as a netlink event. Thanks to
> the extensible nature of netlink, more metadata can be added in the
> future.
>
> To avoid performing expensive operations in the context in which
> kfree_skb() is called, the dropped skbs are cloned and queued on per-CPU
> skb drop list. The list is then processed in process context (using a
> workqueue), where the netlink messages are allocated, prepared and
> finally sent to user space.
>
> As a follow-up, I plan to integrate drop monitor with devlink and allow
> the latter to call into drop monitor to report hardware drops. In the
> future, XDP drops can be added as well, thereby making drop monitor the
> go-to netlink channel for diagnosing all packet drops.

I like this!

Is there a mechanism for the user to filter the packets before they are
sent to userspace? A bpf filter would be the obvious choice I guess...

For integrating with XDP the trick would be to find a way to do it that
doesn't incur any overhead when it's not enabled. Are you envisioning
that this would be enabled separately for the different "modes" (kernel,
hardware, XDP, etc)?

-Toke
