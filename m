Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79260680BEF
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 12:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235680AbjA3L1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 06:27:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235265AbjA3L1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 06:27:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF231ADE5
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 03:27:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675078024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NB1REK3IXWn/B3d981a1uXPcnJOYW+xUQQxZJwONvuw=;
        b=cYXT9G+ZEPsq6DP/tNoEDHaCHZw2kI0slaXDdNRNhobqBn1ftU9qjOvX84peoSQz2ca/wv
        BXorw/PIQ5SIsg9hp9T/65kQu7IbWwv5VI90qSCCIG9i0F8GcxMUYTJ4LpNP0Vb5X14YjI
        CrUVQYGGfG35Wc4W9aD09t4fzzVCGYU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-663-XKQtxuVdOVqPv3nHO1hraQ-1; Mon, 30 Jan 2023 06:27:03 -0500
X-MC-Unique: XKQtxuVdOVqPv3nHO1hraQ-1
Received: by mail-ed1-f69.google.com with SMTP id w3-20020a056402268300b00487e0d9b53fso8031795edd.10
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 03:27:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NB1REK3IXWn/B3d981a1uXPcnJOYW+xUQQxZJwONvuw=;
        b=lJ8FXuffcLy0oOXfxF+Sq1xNfEqCRm4gohh5mEXuGOvjug7R0JFyfVud0dtSkG4BQG
         nOogTC2QNetDKhOfyHMdw/TY7McG7ffHRQnUt7Ngnt0JBhKE1vv3ApNaPBPMFmYQypZW
         RbmaQ7JodoZDCWHY7g7xtdor+gAKLYpf3/WwDMYVzBibU5zAfPzHhPl+5UGSLqa4n/pv
         ugzbNfpJlNZBv1MRNq1cYxcFWdpfPlVJVSwagU5LBqZMEoZoQvQuHpptjk4m8rpWWuxd
         3Ogu2KIsijufnlNSUHVUiTcKlwQ3FIT6boowzGDP/PiQN1VU+OQ0OuH5XH00OXVYihoe
         Ibhg==
X-Gm-Message-State: AO0yUKUQiffEEvxU6xTlZKmIdwYC4DnTcJ+8QQNpcJEhe6oZ8+0oK80O
        leLVedVknl65DmVWOno4ThQjo1UVmihTg1eLsfAIQqUWisUh/A3tA6UaW1BAq8VNjQwcFBdiql4
        5+AhT8PR9wVNzDJYY
X-Received: by 2002:a05:6402:381a:b0:4a2:3633:952d with SMTP id es26-20020a056402381a00b004a23633952dmr6275419edb.41.1675078021253;
        Mon, 30 Jan 2023 03:27:01 -0800 (PST)
X-Google-Smtp-Source: AK7set/HaIbC3Z2/0DRZM1tedokxMLQsbjTqoRq2WMRHiseS2vlhq5haqzsuFaKc+vowi0jLCeMIaw==
X-Received: by 2002:a05:6402:381a:b0:4a2:3633:952d with SMTP id es26-20020a056402381a00b004a23633952dmr6275342edb.41.1675078020464;
        Mon, 30 Jan 2023 03:27:00 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id c10-20020a056402100a00b00483dd234ac6sm6628861edu.96.2023.01.30.03.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 03:27:00 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8780E972681; Mon, 30 Jan 2023 12:26:58 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Willem de Bruijn <willemb@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Jamal Hadi Salim <hadi@mojatatu.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, vladbu@nvidia.com, simon.horman@corigine.com,
        stefanc@marvell.com, seong.kim@amd.com, mattyk@nvidia.com,
        dan.daly@intel.com, john.andy.fingerhut@intel.com
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
In-Reply-To: <Y9eYNsklxkm8CkyP@nanopsycho>
References: <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
 <Y9RPsYbi2a9Q/H8h@google.com>
 <CAM0EoM=ONYkF_1CST7i_F9yDQRxSFSTO25UzWJzcRGa1efM2Sg@mail.gmail.com>
 <CAKH8qBtU-1A1iKnvTXV=5v8Dim1FBmtvL6wOqgdspSFRCwNohA@mail.gmail.com>
 <CA+FuTScHsm3Ajje=ziRBafXUQ5FHHEAv6R=LRWr1+c3QpCL_9w@mail.gmail.com>
 <CAM0EoMnBXnWDQKu5e0z1_zE3yabb2pTnOdLHRVKsChRm+7wxmQ@mail.gmail.com>
 <CA+FuTScBO-h6iM47-NbYSDDt6LX7pUXD82_KANDcjp7Y=99jzg@mail.gmail.com>
 <63d6069f31bab_2c3eb20844@john.notmuch>
 <CAM0EoMmeYc7KxY=Sv=oynrvYMeb-GD001Zh4m5TMMVXYre=tXw@mail.gmail.com>
 <63d747d91add9_3367c208f1@john.notmuch> <Y9eYNsklxkm8CkyP@nanopsycho>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 30 Jan 2023 12:26:58 +0100
Message-ID: <87pmawxny5.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri Pirko <jiri@resnulli.us> writes:

>>P4TC as SW/HW running same P4:
>>
>>1. This doesn't need to be done in kernel. If one compiler runs
>>   P4 into XDP or TC-BPF that is good and another compiler runs
>>   it into hw specific backend. This satisifies having both
>>   software and hardware implementation.
>>
>>Extra commentary: I agree we've been chatting about this for a long
>>time but until some vendor (Intel?) will OSS and support a linux
>>driver and hardware with open programmable parser and MAT. I'm not
>>sure how we get P4 for Linux users. Does it exist and I missed it?
>
>
> John, I think that your summary is quite accurate. Regarding SW
> implementation, I have to admit I also fail to see motivation to have P4
> specific datapath instead of having XDP/eBPF one, that could run P4
> compiled program. The only motivation would be that if somehow helps to
> offload to HW. But can it?

According to the slides from the netdev talk[0], it seems that
offloading will have to have a component that goes outside of TC anyway
(see "Model 3: Joint loading" where it says "this is impossible"). So I
don't really see why having this interpreter in TC help any.

Also, any control plane management feature specific to managing P4 state
in hardware could just as well manage a BPF-based software path on the
kernel side instead of the P4 interpreter stuff...

-Toke

[0] https://netdevconf.info/0x16/session.html?Your-Network-Datapath-Will-Be-P4-Scripted

