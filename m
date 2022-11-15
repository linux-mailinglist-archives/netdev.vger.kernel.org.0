Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC234629E32
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 16:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbiKOPz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 10:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbiKOPzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 10:55:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89272CDD3
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 07:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668527696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aAB2Hg+RMDMT5I1x428ws21lBRjRICs3mcInuPW5LFo=;
        b=E2+r7VXdzyCPXU6651MytaaAcqzShAP9C22AMuU4PcnZC8rTqvmy2ztktpjG8jP+SD6yQg
        FdU/d6ON7gRZMSXbvIEcMZRCoaNbpgL6BD1GoYR7wffXbooKbMzajyEJ10HqiXcyApUqWJ
        Ku9KBwpdS807YPQoMaEwzEgh8Bl990A=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-60-3SA_fBBUMfy_SgWZNchqQw-1; Tue, 15 Nov 2022 10:54:48 -0500
X-MC-Unique: 3SA_fBBUMfy_SgWZNchqQw-1
Received: by mail-ed1-f71.google.com with SMTP id f20-20020a0564021e9400b00461ea0ce17cso10239261edf.16
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 07:54:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aAB2Hg+RMDMT5I1x428ws21lBRjRICs3mcInuPW5LFo=;
        b=lkvarb7/eIEsRaADG7GjLJWv2KcIA5pQ8sngdrBIfXjwazszVzAelTnYt66wSumKag
         vX28gvhmlrISMsB7110IPq1dyn+cg1S6KFcVyUUq+wPJM+g8vFGGzjmFH7hLBkj7p8mo
         l5nZimRa3zN2S8TQkGEw2qREG41SRma50DgXuI4D7wYW65vxbWGIUDAsUsxG+gWWB404
         xTO1NJstI7oX/dlnP5sHIY8BVPZV2h5VtpHxabYDPikeO3SkFL78MKmfGJGqv/NBo5rZ
         WOsVS9IZAmDYj0CdNAwWECNZ1hn1Dnb12Ib5YJICsLxwDM7UoYvbhiW7aOaKlCpG3QPa
         IUXA==
X-Gm-Message-State: ANoB5pmCsQNFenxnrpP+Qx6psML2BEqQzF6NfBqIQPGON41D8nLXN3wf
        VZLLHKhEPuzX31DRiOs8XejGEHg/ul+sGcDu3222paNeeycgiXPwvWXEC2s4LrporENFc3Es/Jl
        A8n606G2GyJzvft54
X-Received: by 2002:a17:906:2cd6:b0:78d:20f7:1294 with SMTP id r22-20020a1709062cd600b0078d20f71294mr15377375ejr.442.1668527686622;
        Tue, 15 Nov 2022 07:54:46 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5cWcobPYDT3WRhyKVYgNuEsHOuqtMADP3XcGH3zCnehqQcGtUwi3vBUpyahiaXASHL4ecy3A==
X-Received: by 2002:a17:906:2cd6:b0:78d:20f7:1294 with SMTP id r22-20020a1709062cd600b0078d20f71294mr15377338ejr.442.1668527686254;
        Tue, 15 Nov 2022 07:54:46 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id cf6-20020a170906b2c600b007ad94fd48dfsm5623540ejb.139.2022.11.15.07.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 07:54:45 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2F0CE7A6CC4; Tue, 15 Nov 2022 16:54:45 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [xdp-hints] [PATCH bpf-next 00/11] xdp: hints via kfuncs
In-Reply-To: <20221115030210.3159213-1-sdf@google.com>
References: <20221115030210.3159213-1-sdf@google.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 15 Nov 2022 16:54:45 +0100
Message-ID: <87mt8si56i.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev <sdf@google.com> writes:

> - drop __randomize_layout
>
>   Not sure it's possible to sanely expose it via UAPI. Because every
>   .o potentially gets its own randomized layout, test_progs
>   refuses to link.

So this won't work if the struct is in a kernel-supplied UAPI header
(which would include the __randomize_layout tag). But if it's *not* in a
UAPI header it should still be included in a stable form (i.e., without
the randomize tag) in vmlinux.h, right? Which would be the point:
consumers would be forced to read it from there and do CO-RE on it...

-Toke

