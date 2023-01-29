Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A70868022D
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 23:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235342AbjA2WPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 17:15:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbjA2WPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 17:15:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393761CAF6
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 14:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675030463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XXH1dUolnvjqQUEAzcLFYStCyTzMyDlnquUNBchw74M=;
        b=FnoJow3BjmjhzhHl4E6Hs1QDmguA1lJmcHF44QYzZIgLcUrk6qpjfBqrEfJbI0T40xcWcY
        BPzKuvy0LAZ4EARl6Lo74msyvpqI6tVwcxgbg54Lr4vugYXp+GR+Y3Jrq43eaMLb14EUG0
        jE5EdIhXtIMxhpNd5yv7JJf8/hXV/ss=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-561-wOZYkgmjMICqNl3AsnlHZg-1; Sun, 29 Jan 2023 17:14:22 -0500
X-MC-Unique: wOZYkgmjMICqNl3AsnlHZg-1
Received: by mail-ej1-f69.google.com with SMTP id nb4-20020a1709071c8400b0084d4712780bso6157591ejc.18
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 14:14:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XXH1dUolnvjqQUEAzcLFYStCyTzMyDlnquUNBchw74M=;
        b=zPaCTsBk9mjneHbHtmvTeirttlVk0yteV65vvn0dd9OO0vDDq5W9qMF0+YsrRQm72n
         jJt89dzRET7C4dqv6P4kENt/GU56EyZWqmxSLjKaMcURRUYoEl4GH5L+/SWrkkcKumsV
         WDKzxOc/oxKxZaSyr40nDKkZCZ5OoQk1QXeuV6br8FUwVZoZV+opF7UmFs/nnmYyfdRM
         vaD40A/CV5WHo3tDSsBTXdZv/bEuUWmGLljA+bu4lUW07BvagC0u5IYZuDXWMWEMktci
         rAGCUfnDRfup0Y+l4yNWHkQ0wSW9rNnSNsh5pd3JL0Er0RzAQRUPku9VTEzZvM6iWqjf
         Qq+w==
X-Gm-Message-State: AO0yUKV4xWb04fk3ZvPzMkrkRw+8MX9UP+l1VvjMsKbspGh6bzQ+uwQT
        kpMijucvVS7RkLhgL6Yu9lDbtnnGY+cN2nckEDvL9lv/ZOOzBXagY2mmZlZYBTejXD6X8wVxXJc
        OEqRGR4DcK6qor+/Z
X-Received: by 2002:a17:906:c20e:b0:885:dd71:89b5 with SMTP id d14-20020a170906c20e00b00885dd7189b5mr4017563ejz.41.1675030460618;
        Sun, 29 Jan 2023 14:14:20 -0800 (PST)
X-Google-Smtp-Source: AK7set90empiHO5tyUo3O7NB+498oChTD+UcFSd1HsWXjluaXbIwvz5YZksaDrRA+wl01CenjViEuA==
X-Received: by 2002:a17:906:c20e:b0:885:dd71:89b5 with SMTP id d14-20020a170906c20e00b00885dd7189b5mr4017522ejz.41.1675030459968;
        Sun, 29 Jan 2023 14:14:19 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id m21-20020a1709062b9500b0086621d9d9b0sm5871749ejg.81.2023.01.29.14.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Jan 2023 14:14:19 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3FFE7972639; Sun, 29 Jan 2023 23:14:18 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Willem de Bruijn <willemb@google.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Jamal Hadi Salim <hadi@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, vladbu@nvidia.com, simon.horman@corigine.com,
        stefanc@marvell.com, seong.kim@amd.com, mattyk@nvidia.com,
        dan.daly@intel.com, john.andy.fingerhut@intel.com
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
In-Reply-To: <CAM0EoMmMd9SSxCV8p5WfmOnGqF+bOrOAOdAw9JGMC-=70Y8qzA@mail.gmail.com>
References: <20230124170346.316866-1-jhs@mojatatu.com>
 <20230126153022.23bea5f2@kernel.org> <Y9QXWSaAxl7Is0yz@nanopsycho>
 <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
 <Y9RPsYbi2a9Q/H8h@google.com>
 <CAM0EoM=ONYkF_1CST7i_F9yDQRxSFSTO25UzWJzcRGa1efM2Sg@mail.gmail.com>
 <CAKH8qBtU-1A1iKnvTXV=5v8Dim1FBmtvL6wOqgdspSFRCwNohA@mail.gmail.com>
 <CA+FuTScHsm3Ajje=ziRBafXUQ5FHHEAv6R=LRWr1+c3QpCL_9w@mail.gmail.com>
 <CAM0EoMnBXnWDQKu5e0z1_zE3yabb2pTnOdLHRVKsChRm+7wxmQ@mail.gmail.com>
 <CA+FuTScBO-h6iM47-NbYSDDt6LX7pUXD82_KANDcjp7Y=99jzg@mail.gmail.com>
 <CAM0EoMmMd9SSxCV8p5WfmOnGqF+bOrOAOdAw9JGMC-=70Y8qzA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sun, 29 Jan 2023 23:14:18 +0100
Message-ID: <87zga1xa2t.fsf@toke.dk>
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

Jamal Hadi Salim <jhs@mojatatu.com> writes:

>> > We use the skip_sw and skip_hw knobs in tc to indicate whether a
>> > policy is targeting hw or sw. Not sure if you are familiar with it but its
>> > been around (and deployed) for a few years now. So a P4 program
>> > policy can target either.
>>
>> I know. So the only reason the kernel ABI needs to be extended with P4
>> objects is to be able to pass the same commands to hardware. The whole
>> kernel dataplane could be implemented as a BPF program, correct?
>>
>
> It's more than an ABI (although that is important as well).
> It is about reuse of the infra which provides a transparent symbiosis
> between hardware offload and software that has matured over time: For
> example, you can take a pipeline or a table or actions (lately) and
> split them between hardware and software transparently, etc. To
> re-iterate, we are reusing and plugging into a proven and deployed
> mechanism which enables our goal (of HW + SW scripting of arbitrary
> P4-enabled datapaths which are functionally equivalent).

But you're doing this in a way that completely ignores the existing
ecosystem for creating programmable software datapaths in the kernel
(i.e., eBPF/XDP) in favour of adding *yet another* interpreter to the
kernel.

In particular, completely excluding the XDP from this is misguided.
Programmable networking in Linux operates at three layers:

- HW: for stuff that's supported and practical there
- XDP: software fast-path for high-performance bits that can't go into HW
- TC/rest of stack: SW slow path for functional equivalence

I can see P4 playing a role as a higher-level data plane definition
language even for Linux SW stacks, but let's have it integrate with the
full ecosystem, not be its own little island in a corner...

-Toke

