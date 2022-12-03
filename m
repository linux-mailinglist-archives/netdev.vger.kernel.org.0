Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 171A9641202
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 01:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234853AbiLCA2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 19:28:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233795AbiLCA2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 19:28:46 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9CBEC084
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 16:28:44 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id e18so4526886qvs.1
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 16:28:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7QXLDYBHBoukVILcSnj0EcQlloWfF1awoqO8Bec4odA=;
        b=ADNM6CYvq8gf4uZwEDDYzSRz830RwdkoGK0YMsa4TVWHuC0l+NEJcNb3FCrSy4Z/qa
         Uo7FJM6kDyJsrc9pQW7LWJezM7G7bcf0GAtVOUU9WkQKylEVDWpS04G7LJo2BB7KUbCe
         Gj0dLc7S0jLC3GRaZADaZzgpMIygG3tr8xBCs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7QXLDYBHBoukVILcSnj0EcQlloWfF1awoqO8Bec4odA=;
        b=LxjR9LqUzdTAEevihY5E/lDlcrqUNpfk1UvShJLDlAliKqGkYMB+7nWQwXrAxkWzWZ
         8U6iU5p6zv40r2XaSmbyl2OF5yqEatCY+f/b0LEHbGvS7XUslD6j+rlRLAIg+ihCHECt
         z2ekZmKTyJVbzGxYfv2oxX3docbe+R4zGXUCHQp5Pl4HJLAb19s9KWFZ1l9Ye/HGCqCL
         WBuQDxXJUb+f5bYRyWcRY+yXkZG/uODvSGYoKQqhHAPoHFeIXcHxwYK6+RSUFN6n8Qbt
         ltJtbNlzVCliBEZILMu6H/qX3Ja9KeLRAJ4VkGyk4BAxpJGJGzpq0IxJvo74FCLLqXnU
         EJfQ==
X-Gm-Message-State: ANoB5pkGnk3KXsGFTPHlyDsBmdk3kizEnGWo4AbtzYn/nhCJLK94KZPO
        0uqhgyjxgnQagm3JpjI++ipLBcdBl2Mqvoz9
X-Google-Smtp-Source: AA0mqf471X+ZswGb1VquP4MAsp2iJsFKwOvA8BPGoUI7GKDRKbE6f+PEihNnuOq6hy4ZQExSphVgUg==
X-Received: by 2002:a05:6214:5d91:b0:4c7:1dcd:b6c with SMTP id mf17-20020a0562145d9100b004c71dcd0b6cmr13356483qvb.102.1670027323084;
        Fri, 02 Dec 2022 16:28:43 -0800 (PST)
Received: from smtpclient.apple (c-98-249-43-138.hsd1.va.comcast.net. [98.249.43.138])
        by smtp.gmail.com with ESMTPSA id dt43-20020a05620a47ab00b006fbf88667bcsm6651030qkb.77.2022.12.02.16.28.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 16:28:42 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Joel Fernandes <joel@joelfernandes.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH net-next] tcp: use 2-arg optimal variant of kfree_rcu()
Date:   Fri, 2 Dec 2022 19:28:31 -0500
Message-Id: <21A10014-22D8-4107-8C6C-14102478D19B@joelfernandes.org>
References: <CAEXW_YRW+ZprkN7nE1yJK_g6UhsWBWGUVfzW+gFnjKabgevZWg@mail.gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Dmitry Safonov <dima@arista.com>,
        rcu@vger.kernel.org
In-Reply-To: <CAEXW_YRW+ZprkN7nE1yJK_g6UhsWBWGUVfzW+gFnjKabgevZWg@mail.gmail.com>
To:     paulmck@kernel.org
X-Mailer: iPhone Mail (20B101)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+rcu for archives=20

> On Dec 2, 2022, at 7:16 PM, Joel Fernandes <joel@joelfernandes.org> wrote:=

>=20
> =EF=BB=BFOn Sat, Dec 3, 2022 at 12:12 AM Joel Fernandes <joel@joelfernande=
s.org> wrote:
>>=20
>>> On Sat, Dec 3, 2022 at 12:03 AM Paul E. McKenney <paulmck@kernel.org> wr=
ote:
>>>=20
>>> On Fri, Dec 02, 2022 at 11:49:59PM +0000, Joel Fernandes wrote:
>>>> On Fri, Dec 02, 2022 at 05:28:47AM +0000, Eric Dumazet wrote:
>>>>> kfree_rcu(1-arg) should be avoided as much as possible,
>>>>> since this is only possible from sleepable contexts,
>>>>> and incurr extra rcu barriers.
>>>>>=20
>>>>> I wish the 1-arg variant of kfree_rcu() would
>>>>> get a distinct name, like kfree_rcu_slow()
>>>>> to avoid it being abused.
>>>>=20
>>>> Hi Eric,
>>>> Nice to see your patch.
>>>>=20
>>>> Paul, all, regarding Eric's concern, would the following work to warn o=
f
>>>> users? Credit to Paul/others for discussing the idea on another thread.=
 One
>>>> thing to note here is, this debugging will only be in effect on preempt=
ible
>>>> kernels, but should still help catch issues hopefully.
>>>=20
>>> Mightn't there be some places where someone needs to invoke
>>> single-argument kfree_rcu() in a preemptible context, for example,
>>> due to the RCU-protected structure being very small and very numerous?
>>=20
>> This could be possible but I am not able to find examples of such
>> cases, at the moment. Another approach could be to introduce a
>> dedicated API for such cases, where the warning will not fire. And
>> keep the warning otherwise.
>>=20
>> Example: kfree_rcu_headless()
>> With a big comment saying, use only if you are calling from a
>> preemptible context and cannot absolutely embed an rcu_head. :-)
>>=20
>> Thoughts?
>>=20
>=20
> Just to clarify, where I was getting at was to combine both ideas:
> 1. new API with suppression of the new warning mentioned above.
> 2. old API but add new warning mentioned above.
>=20
> Cheers,
>=20
> - Joel
