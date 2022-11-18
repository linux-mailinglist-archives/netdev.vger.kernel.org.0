Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0274D62F1F7
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 10:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241457AbiKRJ54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 04:57:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234867AbiKRJ5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 04:57:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EC58E0B9
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 01:57:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668765423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZFWIcbwdUkbTl5Asr+COpxfctyOv67ZGwR5/fHyh/4Y=;
        b=DhlK0rjmMFUAWtSrllOi1rBTbzz37eebVO0rkTcMVWDoKZvbYtqG1oX2SzK/TrwXqkmeQB
        aKCFpW6SU7sowv1J23ywcLTLywut546WAE22fvjSsC4xMZD5zVyeQ942oP8p+qXAhGx8e4
        sKsQO6sxsEqwPIvMKGLNunsmozPhtb0=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-108-KqLZgKERPbCWAidfMNMLTA-1; Fri, 18 Nov 2022 04:57:02 -0500
X-MC-Unique: KqLZgKERPbCWAidfMNMLTA-1
Received: by mail-qk1-f198.google.com with SMTP id bi42-20020a05620a31aa00b006faaa1664b9so5450099qkb.8
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 01:57:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZFWIcbwdUkbTl5Asr+COpxfctyOv67ZGwR5/fHyh/4Y=;
        b=RlnvLmTdBEFtLkrbTQYUGWOlzwxRcgPhaJhPCMdv34AVbyyIpN2b5sARc6tBLosajc
         VE31rrYRaWbW+GsCePwIpuEKxkf1xo/HgtFL2IAZSRMsikwIxyodrxQvnVTGDAGGyo+Y
         /G1DF0l+15FFR7Ldgsp6na9ovW8ddenvc2+5VU9sYyxOx0HkV3Lu0KaL7UREXVm5ONeS
         3eSV0xfQynrzdMZsNsjIaxLiUd6r5XJ+FsxduP/Ki94MV7aNJUAqTjFhRugAEniz5rW8
         hvvHQeqThfslqCMXS9VfpV/RHMA2OhQrdstqzkG9S1zzO1XYmc4JtyuwjdtksWc5Rfr3
         9j7A==
X-Gm-Message-State: ANoB5pmm+oTJodCs6F7M+zeRAWq0QgFaTB92uwpPP8PKMk3TaRz516oO
        kI4ToJperOWzZIdDubk6Od6CBRtbx3qA6gQqSqNf6Wz5F+5GxE83/9h5ou8HsaoPj4iTVZSzP3/
        O2rtCqleMAPkCv9uW
X-Received: by 2002:ae9:ee1a:0:b0:6fa:8de1:16cb with SMTP id i26-20020ae9ee1a000000b006fa8de116cbmr5047645qkg.552.1668765419592;
        Fri, 18 Nov 2022 01:56:59 -0800 (PST)
X-Google-Smtp-Source: AA0mqf51jHSo6HSzyaOji0wHVfiUA5qLZwpEIGs/bjYus4rwguDiknSqjN/AOVNXLzG8o/u4J79RwA==
X-Received: by 2002:ae9:ee1a:0:b0:6fa:8de1:16cb with SMTP id i26-20020ae9ee1a000000b006fa8de116cbmr5047634qkg.552.1668765419275;
        Fri, 18 Nov 2022 01:56:59 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id u20-20020a05620a0c5400b006cf8fc6e922sm2105288qki.119.2022.11.18.01.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 01:56:58 -0800 (PST)
Message-ID: <f632781defea57a3c919ae91430f42e09f268de1.camel@redhat.com>
Subject: Re: KASAN: double-free in kfree
From:   Paolo Abeni <pabeni@redhat.com>
To:     Alexander Potapenko <glider@google.com>,
        Wei Chen <harperchen1110@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, trix@redhat.com,
        syzkaller-bugs@googlegroups.com, syzkaller@googlegroups.com
Date:   Fri, 18 Nov 2022 10:56:54 +0100
In-Reply-To: <CAG_fn=UHgpEcGLjvHu8ze6jV8q_R9uSnvbeijsFFNmqchAe6OA@mail.gmail.com>
References: <CAO4mrfdb1UdjQxr0zLH9J8b6T+8kn4UOm-sO6nZ2aKErKg7i0A@mail.gmail.com>
         <CAG_fn=UHgpEcGLjvHu8ze6jV8q_R9uSnvbeijsFFNmqchAe6OA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-11-18 at 09:50 +0100, Alexander Potapenko wrote:
> On Fri, Nov 18, 2022 at 8:37 AM Wei Chen <harperchen1110@gmail.com> wrote:
> > 
> > Dear Linux Developer,
> > 
> > Recently when using our tool to fuzz kernel, the following crash was triggered:
> > 
> > HEAD commit: 4fe89d07 Linux v6.0
> > git tree: upstream
> > compiler: clang 12.0.0
> > console output:
> > https://drive.google.com/file/d/1_CdtSwaMJZmN-4dQw1mmZT0Ijq28X8aC/view?usp=share_link
> > kernel config: https://drive.google.com/file/d/1ZHRxVTXHL9mENdAPmQYS1DtgbflZ9XsD/view?usp=sharing
> > 
> > Unfortunately, I didn't have a reproducer for this bug yet.
> 
> Hint: if you don't have a reproducer for the bug, look at the process
> name that generated the error (syz-executor.0 in this case) and try
> the program from the log with that number ("executing program 0")
> preceding the report:
> 
> r0 = accept4(0xffffffffffffffff, &(0x7f0000000600)=@in={0x2, 0x0,
> @multicast2}, &(0x7f0000000680)=0x80, 0x80000)
> r1 = socket$nl_generic(0x10, 0x3, 0x10)
> r2 = syz_genetlink_get_family_id$mptcp(&(0x7f00000002c0), 0xffffffffffffffff)
> sendmsg$MPTCP_PM_CMD_DEL_ADDR(r1, &(0x7f0000000300)={0x0, 0x0,
> &(0x7f0000000000)={&(0x7f0000000280)={0x28, r2, 0x1, 0x0, 0x0, {},
> [@MPTCP_PM_ATTR_ADDR={0x14, 0x1, 0x0, 0x1,
> [@MPTCP_PM_ADDR_ATTR_ADDR4={0x8, 0x3, @multicast2=0xac14140a},
> @MPTCP_PM_ADDR_ATTR_FAMILY={0x6, 0x1, 0x2}]}]}, 0x28}}, 0x0)
> sendmsg$MPTCP_PM_CMD_FLUSH_ADDRS(r0,
> &(0x7f0000000780)={&(0x7f00000006c0), 0xc,
> &(0x7f0000000740)={&(0x7f0000000700)={0x1c, r2, 0x4, 0x70bd28,
> 0x25dfdbfb, {}, [@MPTCP_PM_ATTR_SUBFLOWS={0x8, 0x3, 0x8}]}, 0x1c},
> 0x1, 0x0, 0x0, 0x4c890}, 0x20008040)
> shmat(0xffffffffffffffff, &(0x7f0000ffd000/0x2000)=nil, 0x1000)
> r3 = shmget$private(0x0, 0x3000, 0x40, &(0x7f0000ffd000/0x3000)=nil)
> shmat(r3, &(0x7f0000ffc000/0x2000)=nil, 0x7000)
> syz_usb_connect$uac1(0x0, 0x8a,
> &(0x7f0000000340)=ANY=[@ANYBLOB="12010000000000206b1f01014000010203010902780003010000000904000000010100000a2401000000020106061d154a00ffac190b2404007f1f000000000000000401000001020000090401010101024000082402010000000009050109000000000000250100241694c11a11c200000009040200000102002009040201010502000009058209000000f456c30000fd240100000000000000000076af0bc3ac1605de4480cca53afa66f00807f17fb00132f9de1d1ec1d987f75530448d06a723ae111cb967ab97001d826aaf1c7eb0f9d0df07d29aa5a01e58ccbbab20f723605387ba8179874ad74d25d7dd7699a83189ba9c8b58980ea9cb58dd3a5afe7244a9d268d2397ac42994de8924d0478b17b13a564f696432da53be08aff66deb52e3f7c90c28079a9562280b9fda5f881598636375cc77499c22fe673fe447ac74c25c0e2df0901d8babcdf31f59a3a15daae3f2"],
> 0x0)
> r4 = socket$alg(0x26, 0x5, 0x0)
> bind$alg(r4, &(0x7f0000002240)={0x26, 'skcipher\x00', 0x0, 0x0,
> 'cts(cbc-twofish-3way)\x00'}, 0x58)
> r5 = accept4(r4, 0x0, 0x0, 0x0)
> syz_genetlink_get_family_id$nl80211(&(0x7f00000003c0), r5)
> sendmsg$NL80211_CMD_SET_WOWLAN(r5, &(0x7f0000000440)={0x0, 0x0,
> &(0x7f0000000400)={&(0x7f0000000480)=ANY=[], 0x3e0}}, 0x0)
> syz_genetlink_get_family_id$team(&(0x7f0000000040), r5)
> 
> 
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: Wei Chen <harperchen1110@gmail.com>
> 
> @Eric, does this have something to do with "tcp: cdg: allow
> tcp_cdg_release() to be called multiple times" ?

The double free happens exactly in the same location and the tested
kernel does not contain Eric's fix. This splat is a little different -
it looks like the relevant chunk of memory has been re-used by some
other task before being double-freed - still I think this is the same
issue address by commit 72e560cb8c6f8 ("tcp: cdg: allow
tcp_cdg_release() to be called multiple times").

Cheers,

Paolo

