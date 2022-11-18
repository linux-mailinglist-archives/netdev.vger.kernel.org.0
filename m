Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0719B62F011
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 09:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235149AbiKRIvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 03:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241579AbiKRIvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 03:51:17 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D973362EC
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 00:51:11 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id b131so4877183yba.11
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 00:51:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=29C9VDb0xFfxfLwch0GtgT2kazUQ6gngPGVWOe9/sG8=;
        b=kg1rS6yrqb4Vbzvloc1Xab/Re0aJ7tlJiS4uTChf44RQwD9LJMqaNcgl+RvOos1BoV
         3D7I6xbz6rgUX2io5f//xhtX3UdxqcMvD0pddUFey2KNcIyH5aGulDulUo7yJlm1wS48
         Qv2yt6/wHWp7O27+/5C1/frtxxLVHqVYS2bGmJKJXAujgxBMlfgUw6NWo51Ax/3sbFwR
         hj2ORdpmJCZTfBPbJlIK2O6MV0Otj21R9l11ewyN2+Kjue4uZCIVD7zYvNyQos5dF3QU
         2ZssHszI4lYndYEvqZZR60H+1fJFoZ/orRX3PWQRrxAPY0G+5BWdaRdMTiA/SiB88ER3
         p+Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=29C9VDb0xFfxfLwch0GtgT2kazUQ6gngPGVWOe9/sG8=;
        b=CLPT9DHsaZhstWgIlWUWa2DY0tJTY8a/JQM0OHUksmxhOf1+3qnnlUo9fS7IQblrRa
         2R1qTf00VwONou3dX6BbYRsfc1ZBPkufix18mfZUGWEYYyqNcBcFeq+txijmce5yUsbB
         ti0+v4LPDSDxnSiopQObqCCEUMqJKgw0PNriFU8Umg9JXEW0lCY2tSqFoJoz8RoxJr6M
         hWhLCtfECf8fYdnODgE5r1eKVQ2RaZUE3MQduO3ww4n5Unfj9OJ5R1htsSzwN5clnYn4
         R7jR6EEzn6IOkyk+hi2UJRLMqkJKyzycGnAgBl4iceW13/GpN4smIYF1JpTmvMwWdd36
         LLJQ==
X-Gm-Message-State: ANoB5pk2tlPCR6t2WghjjoM/5dS4lIeq9PtOx7aUWFotpp40pjomux36
        t/BwrOf0qa5sSra1X7ZPIPlEHzaOrKp1fqQuAk9cJg==
X-Google-Smtp-Source: AA0mqf6lR4n2bbFcvSHmJly3xhqjf/lBBF6p9eJW4pVV7WFtDvVjHZaOSXDUt+ebRKHsBSiIwYCE75JlPirtw+wXL3Y=
X-Received: by 2002:a25:268b:0:b0:6e6:e55e:bacb with SMTP id
 m133-20020a25268b000000b006e6e55ebacbmr5661900ybm.250.1668761470501; Fri, 18
 Nov 2022 00:51:10 -0800 (PST)
MIME-Version: 1.0
References: <CAO4mrfdb1UdjQxr0zLH9J8b6T+8kn4UOm-sO6nZ2aKErKg7i0A@mail.gmail.com>
In-Reply-To: <CAO4mrfdb1UdjQxr0zLH9J8b6T+8kn4UOm-sO6nZ2aKErKg7i0A@mail.gmail.com>
From:   Alexander Potapenko <glider@google.com>
Date:   Fri, 18 Nov 2022 09:50:33 +0100
Message-ID: <CAG_fn=UHgpEcGLjvHu8ze6jV8q_R9uSnvbeijsFFNmqchAe6OA@mail.gmail.com>
Subject: Re: KASAN: double-free in kfree
To:     Wei Chen <harperchen1110@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        trix@redhat.com, syzkaller-bugs@googlegroups.com,
        syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 8:37 AM Wei Chen <harperchen1110@gmail.com> wrote:
>
> Dear Linux Developer,
>
> Recently when using our tool to fuzz kernel, the following crash was trig=
gered:
>
> HEAD commit: 4fe89d07 Linux v6.0
> git tree: upstream
> compiler: clang 12.0.0
> console output:
> https://drive.google.com/file/d/1_CdtSwaMJZmN-4dQw1mmZT0Ijq28X8aC/view?us=
p=3Dshare_link
> kernel config: https://drive.google.com/file/d/1ZHRxVTXHL9mENdAPmQYS1Dtgb=
flZ9XsD/view?usp=3Dsharing
>
> Unfortunately, I didn't have a reproducer for this bug yet.

Hint: if you don't have a reproducer for the bug, look at the process
name that generated the error (syz-executor.0 in this case) and try
the program from the log with that number ("executing program 0")
preceding the report:

r0 =3D accept4(0xffffffffffffffff, &(0x7f0000000600)=3D@in=3D{0x2, 0x0,
@multicast2}, &(0x7f0000000680)=3D0x80, 0x80000)
r1 =3D socket$nl_generic(0x10, 0x3, 0x10)
r2 =3D syz_genetlink_get_family_id$mptcp(&(0x7f00000002c0), 0xfffffffffffff=
fff)
sendmsg$MPTCP_PM_CMD_DEL_ADDR(r1, &(0x7f0000000300)=3D{0x0, 0x0,
&(0x7f0000000000)=3D{&(0x7f0000000280)=3D{0x28, r2, 0x1, 0x0, 0x0, {},
[@MPTCP_PM_ATTR_ADDR=3D{0x14, 0x1, 0x0, 0x1,
[@MPTCP_PM_ADDR_ATTR_ADDR4=3D{0x8, 0x3, @multicast2=3D0xac14140a},
@MPTCP_PM_ADDR_ATTR_FAMILY=3D{0x6, 0x1, 0x2}]}]}, 0x28}}, 0x0)
sendmsg$MPTCP_PM_CMD_FLUSH_ADDRS(r0,
&(0x7f0000000780)=3D{&(0x7f00000006c0), 0xc,
&(0x7f0000000740)=3D{&(0x7f0000000700)=3D{0x1c, r2, 0x4, 0x70bd28,
0x25dfdbfb, {}, [@MPTCP_PM_ATTR_SUBFLOWS=3D{0x8, 0x3, 0x8}]}, 0x1c},
0x1, 0x0, 0x0, 0x4c890}, 0x20008040)
shmat(0xffffffffffffffff, &(0x7f0000ffd000/0x2000)=3Dnil, 0x1000)
r3 =3D shmget$private(0x0, 0x3000, 0x40, &(0x7f0000ffd000/0x3000)=3Dnil)
shmat(r3, &(0x7f0000ffc000/0x2000)=3Dnil, 0x7000)
syz_usb_connect$uac1(0x0, 0x8a,
&(0x7f0000000340)=3DANY=3D[@ANYBLOB=3D"12010000000000206b1f0101400001020301=
0902780003010000000904000000010100000a2401000000020106061d154a00ffac190b240=
4007f1f00000000000000040100000102000009040101010102400008240201000000000905=
0109000000000000250100241694c11a11c2000000090402000001020020090402010105020=
00009058209000000f456c30000fd240100000000000000000076af0bc3ac1605de4480cca5=
3afa66f00807f17fb00132f9de1d1ec1d987f75530448d06a723ae111cb967ab97001d826aa=
f1c7eb0f9d0df07d29aa5a01e58ccbbab20f723605387ba8179874ad74d25d7dd7699a83189=
ba9c8b58980ea9cb58dd3a5afe7244a9d268d2397ac42994de8924d0478b17b13a564f69643=
2da53be08aff66deb52e3f7c90c28079a9562280b9fda5f881598636375cc77499c22fe673f=
e447ac74c25c0e2df0901d8babcdf31f59a3a15daae3f2"],
0x0)
r4 =3D socket$alg(0x26, 0x5, 0x0)
bind$alg(r4, &(0x7f0000002240)=3D{0x26, 'skcipher\x00', 0x0, 0x0,
'cts(cbc-twofish-3way)\x00'}, 0x58)
r5 =3D accept4(r4, 0x0, 0x0, 0x0)
syz_genetlink_get_family_id$nl80211(&(0x7f00000003c0), r5)
sendmsg$NL80211_CMD_SET_WOWLAN(r5, &(0x7f0000000440)=3D{0x0, 0x0,
&(0x7f0000000400)=3D{&(0x7f0000000480)=3DANY=3D[], 0x3e0}}, 0x0)
syz_genetlink_get_family_id$team(&(0x7f0000000040), r5)


> IMPORTANT: if you fix the bug, please add the following tag to the commit=
:
> Reported-by: Wei Chen <harperchen1110@gmail.com>

@Eric, does this have something to do with "tcp: cdg: allow
tcp_cdg_release() to be called multiple times" ?
