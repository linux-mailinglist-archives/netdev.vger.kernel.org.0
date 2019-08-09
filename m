Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7C387472
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 10:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406001AbfHIIlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 04:41:50 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:40605 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbfHIIlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 04:41:49 -0400
Received: by mail-ed1-f66.google.com with SMTP id h8so5991943edv.7
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 01:41:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=6mdtSWIg7NYUFiP/ToX0yvw1nXM+VQIcaO9X22isQbg=;
        b=VCwO0CuwqN8ECJ9BKjqwwC8FuXhP/ZDs3b/RvEXfmgHldODi6j9XG3w4VdKf97eu87
         P8AldyNU1i4vFb6kqv10vGZSAM3yPzmzdZx1o16hUQy911dTkoEZFhD+FBnZW3RLgouX
         iC5F7bApngMfkuQNqoqpLQoYPxZLFD+hML0SxxfHlHvMVZrKkJZp3fGbjp4Z2bMdEHKE
         JrokHAzU9rna804OiyJzax9s5VunwTAnWhryCwr79yt81dzUz2gy5V869ps1QyM0L9rm
         bPPBRfN3QeE1l8NB+RmSr2V6OueJFxfrM7Ax4cz7F/9yfON45GC1Ff6JaWYxl/GolRH7
         zLuA==
X-Gm-Message-State: APjAAAX9TxSzDsE26rolUrCmNV2sYklTa48OTeebuxzAWdVOMliFAuMx
        eDEve1Dqs/DIDz1WrXdgF1QCLg==
X-Google-Smtp-Source: APXvYqx1BYeRXfZ6hadIyIabFrSzmSM6K229YFtzkhDNzXcjUyHDIRixNOnmo1b8P3OpLF9UkgjY6Q==
X-Received: by 2002:a17:906:b7d8:: with SMTP id fy24mr17613962ejb.230.1565340108256;
        Fri, 09 Aug 2019 01:41:48 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id fj15sm16184302ejb.78.2019.08.09.01.41.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 01:41:47 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2D575180BF7; Fri,  9 Aug 2019 10:41:47 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 00/10] drop_monitor: Capture dropped packets and metadata
In-Reply-To: <20190807103059.15270-1-idosch@idosch.org>
References: <20190807103059.15270-1-idosch@idosch.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 09 Aug 2019 10:41:47 +0200
Message-ID: <87o90yrar8.fsf@toke.dk>
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
> A follow-up patchset will integrate drop monitor with devlink and allow
> the latter to call into drop monitor to report hardware drops. In the
> future, XDP drops can be added as well, thereby making drop monitor the
> go-to netlink channel for diagnosing all packet drops.

This is great. Are you planning to add the XDP integration as well? :)

-Toke
