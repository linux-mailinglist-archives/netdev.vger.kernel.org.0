Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD5BF69B435
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 21:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjBQUuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 15:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjBQUuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 15:50:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C88627C7
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 12:49:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676666971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HPpXeHE7yIpnwoVN+RSEHBL4ndqdA5mUvILcECe2pZs=;
        b=g5lIYQe02jg59pvppIELKN9+og45/VzMaXHPY/XQf1O0PKh6Q8UFdy4np45EoIIapnyJk1
        04y+thyEm2TTvgHD3nkICSZJfOc75ZrVuEgxKb4TiuYaXcMplpUYXmWvLywDlNYYvnyCv0
        XjaeZlKByfEopg0dUh2uhwgr+GobAbs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-262-0qRL45TAMDi4HzflR7Oohg-1; Fri, 17 Feb 2023 15:49:22 -0500
X-MC-Unique: 0qRL45TAMDi4HzflR7Oohg-1
Received: by mail-ed1-f70.google.com with SMTP id bd13-20020a056402206d00b004acd97105ffso3471765edb.19
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 12:49:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HPpXeHE7yIpnwoVN+RSEHBL4ndqdA5mUvILcECe2pZs=;
        b=01K84eSNLG5Sg5jXsof03Dha2OgoQuEk1OXldQ8Jd8Q2gBnXGeP/gkEpXKT39kkzk9
         SvZaJ/J10/MdCu40Wpd1gxVP2odsABmNnCezCxa9uNbTDVqsyZe7LSOvYSOhRHXL+63D
         49Bikvfnw0uwvm3G/qAj5GJtr1lxFxO6uzvX81DkikPdNTr6ZNwzh5sHAfpVfJYaImHP
         SDKA3RHLrjdUShcJFL/LXdNtg/775h27ndQX1MN1F50ZhRO21swuJRIk4WvC0KfcB1tV
         sQqOnEwfClnL4+Le6d7zHJVk2+e1cHXW5OJ/thufdkOkiZ/nCbqSEhB5CUtT/wPw02NU
         BLoA==
X-Gm-Message-State: AO0yUKW5obhMhHf/aRBP/m3OK0msvmNTv0Wx1chwJMVsqdkXN4XxlnSB
        O9J8CdkFLULXXuKVnEkhZ6L5Gz/k1xwsKADdG30MZHFbDUK2D+goAMkYEqIKDhZJJm4WyyExoQ+
        IzGyI6LQmGyVT3l1r
X-Received: by 2002:a17:906:6d84:b0:87f:2d81:1d2a with SMTP id h4-20020a1709066d8400b0087f2d811d2amr1325416ejt.35.1676666961412;
        Fri, 17 Feb 2023 12:49:21 -0800 (PST)
X-Google-Smtp-Source: AK7set/Wu74Ud4NsNvjllIQkdpd0JezWa+v3sHmHVHdl+b9b154S4zTinLDgzvLbQq0rj42RB+Jqvw==
X-Received: by 2002:a17:906:6d84:b0:87f:2d81:1d2a with SMTP id h4-20020a1709066d8400b0087f2d811d2amr1325387ejt.35.1676666960966;
        Fri, 17 Feb 2023 12:49:20 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id p8-20020a170906838800b0088f8abd3214sm2551770ejx.92.2023.02.17.12.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 12:49:20 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 073D59748D9; Fri, 17 Feb 2023 21:49:20 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, martin.lau@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net
Subject: Re: [xdp-hints] Re: [PATCH bpf-next V2] xdp: bpf_xdp_metadata use
 NODEV for no device support
In-Reply-To: <CAKH8qBvwPA_VaHfwqzPN4SNFqCTgVFWH9zMj0LXio_=8Dg3TOw@mail.gmail.com>
References: <167663589722.1933643.15760680115820248363.stgit@firesoul>
 <Y++6IvP+PloUrCxs@google.com>
 <514bb57b-cc3e-7b7e-c7d4-94cdf52565d6@linux.dev>
 <CAKH8qBujK0RnOHi3EH_KwKamEtQRYJ6izoYRBB2_2CQias0HXA@mail.gmail.com>
 <eed53c45-84c4-9978-5323-cede57d9d797@linux.dev>
 <CAKH8qBvwPA_VaHfwqzPN4SNFqCTgVFWH9zMj0LXio_=8Dg3TOw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 17 Feb 2023 21:49:19 +0100
Message-ID: <87mt5cow4w.fsf@toke.dk>
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

> On Fri, Feb 17, 2023 at 9:55 AM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>>
>> On 2/17/23 9:40 AM, Stanislav Fomichev wrote:
>> > On Fri, Feb 17, 2023 at 9:39 AM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>> >>
>> >> On 2/17/23 9:32 AM, Stanislav Fomichev wrote:
>> >>> On 02/17, Jesper Dangaard Brouer wrote:
>> >>>> With our XDP-hints kfunc approach, where individual drivers overload the
>> >>>> default implementation, it can be hard for API users to determine
>> >>>> whether or not the current device driver have this kfunc available.
>> >>>
>> >>>> Change the default implementations to use an errno (ENODEV), that
>> >>>> drivers shouldn't return, to make it possible for BPF runtime to
>> >>>> determine if bpf kfunc for xdp metadata isn't implemented by driver.
>> >>>
>> >>>> This is intended to ease supporting and troubleshooting setups. E.g.
>> >>>> when users on mailing list report -19 (ENODEV) as an error, then we can
>> >>>> immediately tell them their device driver is too old.
>> >>>
>> >>> I agree with the v1 comments that I'm not sure how it helps.
>> >>> Why can't we update the doc in the same fashion and say that
>> >>> the drivers shouldn't return EOPNOTSUPP?
>> >>>
>> >>> I'm fine with the change if you think it makes your/users life
>> >>> easier. Although I don't really understand how. We can, as Toke
>> >>> mentioned, ask the users to provide jited program dump if it's
>> >>> mostly about user reports.
>> >>
>> >> and there is xdp-features also.
>> >
>> > Yeah, I was going to suggest it, but then I wasn't sure how to
>> > reconcile our 'kfunc is not a uapi' with xdp-features (that probably
>> > is a uapi)?
>>
>> uapi concern is a bit in xdp-features may go away because the kfunc may go away ?
>
> Yeah, if it's another kind of bitmask we'd have to retain those bits
> (in case of a particular kfunc ever going away)..
>
>> May be a list of xdp kfunc names that it supports? A list of kfunc btf id will
>> do also and the user space will need to map it back. Not sure if it is easily
>> doable in xdp-features.
>
> Good point. A string list / btf_id list of kfuncs implemented by
> netdev might be a good alternative.

Yup, Lorenzo and I discussed something similar at one point, I think
having this as part of the feature thing would be useful!

-Toke

