Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2A1272ECD
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 14:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbfGXMXs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 24 Jul 2019 08:23:48 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41320 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727032AbfGXMXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 08:23:47 -0400
Received: by mail-ed1-f67.google.com with SMTP id p15so46915781eds.8
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 05:23:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=q8jWSYlG2MMT/NEW2AROpH5Viwh+Y6uGiXKq1wjSgDs=;
        b=SJcU6k+h/wVirPKBQgiaSsFqgNV2L1uMb0uKr4sL3RQJxcl44R4xVlJ1G2N1PmYp7+
         CCMcdTucOs9g/p+Vn43E/fFKcHfugMbC8x0kMVmJF0BKEw2Zi7CYqw1lhUUqOSqaxv80
         nuMz4z7bocpeUpnkxQTEiOqc95wkshAozGutqR1KYpp3bjJs4s6uQWXUae4UeCdk6NgE
         ABTnHVfpLaF0YN/9s+mhNHv69w74lhsFS/uJXnzQiT2/lggl3mo1K7ElQcmLJM1l5/2I
         OZAd7rof/cMbmxdAeoP+TggL+FGTB+mcSvG3q21+zEAQ/DOogl5cScDJ9eG5j7A5lhd/
         RKkg==
X-Gm-Message-State: APjAAAVtNx56DPlX7VGv54OX16xm6/c9qUlG5AD6AGZRkMPYZzCE6yLQ
        SVP/BA0RzJdNajV8F9nE6UYThA==
X-Google-Smtp-Source: APXvYqxlQQVs+utrllYf6VTgfg23LTv6RIFpt3nlWISkvjlhevqOwUh+KZwT8JpXcMLIMoXFzfe30A==
X-Received: by 2002:a17:906:fc5:: with SMTP id c5mr20323357ejk.129.1563971025867;
        Wed, 24 Jul 2019 05:23:45 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id p15sm7253739ejr.1.2019.07.24.05.23.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 05:23:45 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1AB9D1800C5; Wed, 24 Jul 2019 11:51:44 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 00/12] drop_monitor: Capture dropped packets and metadata
In-Reply-To: <20190724081042.GB15878@splinter>
References: <20190722183134.14516-1-idosch@idosch.org> <87imrt4zzg.fsf@toke.dk> <20190723064659.GA16069@splinter> <875znt3pxu.fsf@toke.dk> <20190723151423.GA10342@splinter> <87ftmw3f9m.fsf@toke.dk> <20190724081042.GB15878@splinter>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 24 Jul 2019 11:51:44 +0200
Message-ID: <874l3b3glr.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ido Schimmel <idosch@idosch.org> writes:

> On Tue, Jul 23, 2019 at 06:08:21PM +0200, Toke Høiland-Jørgensen wrote:
>> Also, presumably the queue will have to change from a struct
>> sk_buff_head to something that can hold XDP frames and whatever devlink
>> puts there as well, right?
>
> Good point!
>
> For HW drops we get an SKB and relevant metadata from devlink about why
> the packet was dropped etc. I plan to store a pointer to this metadata
> in the SKB control block.
>
> Let me see how the implementation goes. Even if use sk_buff_head for
> now, I will make sure that converting to a more generalized data
> structure is straightforward.

Yup, that's fine, just wanted to make sure you were aware of the
eventual need to change it :)

-Toke
