Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91812AC2C0
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 00:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392504AbfIFW4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 18:56:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40108 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390953AbfIFW4N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 18:56:13 -0400
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com [209.85.167.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F06B886662
        for <netdev@vger.kernel.org>; Fri,  6 Sep 2019 22:56:12 +0000 (UTC)
Received: by mail-lf1-f70.google.com with SMTP id c83so1715234lfg.8
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 15:56:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=9EKYu82rH0AppuIGL/K/4O7DMgdGWr7EvzF0kBcZoW8=;
        b=XHYGcqBBYaSDY+J90941vumj2dERuWUIoiNJghpWF6gYq5kWGy85J9lKEnWNlktPDS
         LaCLRN2nQLNxEXj752x/0kwOH1EDUKlyGUYei+I6ooALS6kE4mowqZjOnpBPP85f1tsR
         IN0u1PQNkVCy7/mi+Mgm3gfwMzdZrkuoqumkXp6AK6x09F7V3XERQ82asTAYM0srthDt
         QLEIK/m/vx+v6aJRPi7DF3cf7xt5JeZ7zmttw4Oti/z4u9HzIh46vTf5AfuGRNVKGs2R
         zIwtbW5AanFn7+28+wphphEGD8VJ7GQcAISmnEwDVDux9C48CD4rOGHut9P48UVNiWDH
         NrYA==
X-Gm-Message-State: APjAAAVjeZ3ov0HjNknISYvTiIL0nBD+L95ZW/y/UtScUoxM0fAgvPi3
        J9jb5VaQSnzXs4w4BXifFcNjMcGTlv+Ob80nyXh5lh3Uqu1KItqIVkke/ZQcEJ2ALracJl/aeFM
        Km5fwNTPCHE0gE3D1
X-Received: by 2002:a2e:5d82:: with SMTP id v2mr1210125lje.51.1567810571520;
        Fri, 06 Sep 2019 15:56:11 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxOHFJM7Cz763OPRZNrhMmMEp0lu9lCR9D8zW1Pbhwj8C+KOZ4WL1kEP/j93KyIPzyfhYRAzQ==
X-Received: by 2002:a2e:5d82:: with SMTP id v2mr1210117lje.51.1567810571370;
        Fri, 06 Sep 2019 15:56:11 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id e21sm1359296lfj.10.2019.09.06.15.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2019 15:56:10 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E603D18061B; Fri,  6 Sep 2019 23:56:07 +0100 (WEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Manish Chopra <manishc@marvell.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: ndo_xdp_xmit - on which queue to transmit the packet (if core_id >= total_xdp_queues ) ?
In-Reply-To: <DM6PR18MB3388D5F49B3A0A3522A40184ABBA0@DM6PR18MB3388.namprd18.prod.outlook.com>
References: <DM6PR18MB3388D5F49B3A0A3522A40184ABBA0@DM6PR18MB3388.namprd18.prod.outlook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 06 Sep 2019 23:56:07 +0100
Message-ID: <8736h9yqyg.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Manish Chopra <manishc@marvell.com> writes:

> Hello,
>
> I am working on XDP_REDIRECT implementation and got a query. Some of
> the ethernet drivers decide the xdp queue index on which xdp packet
> should be redirected based on smp_processor_id() in their
> ndo_xdp_xmit() handler, if smp_processor_id() >= total_num_xdp_queues,
> they decide to drop the packets and return error from the handler.

Congratulations, you've hit upon one of the major usability issues with
XDP_REDIRECT! ;)

> I am hitting the same condition where using 8 XDP queues, I get CPU id
> 8 to redirect the XDP packet and I am not sure if it should be dropped
> or can be transmitted on a queue (= smp_processor_id() %
> total_num_xdp_queues) safely ?.

I would expect you would at least need some kind of locking to do this
safely, but I guess it depends on how your driver is structured...

> freescale/dpaa2 seems to be handling this case by sending the packet
> on the queue (= smp_processor_id() % total_num_xdp_queues) but unsure
> what should be the expected behavior.

As you've noted, this varies somewhat between drivers, and there's
really no "expected behaviour" today. Drivers basically do what they
think makes sense for their hardware.

We're trying to fix this, and make the behaviour configurable; if you
happen to be at LPC, please come discuss it with us at this session:

https://linuxplumbersconf.org/event/4/contributions/462/

-Toke
