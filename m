Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA136BBD93
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 20:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbjCOTuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 15:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbjCOTuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 15:50:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548D75FEC;
        Wed, 15 Mar 2023 12:50:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E216761D90;
        Wed, 15 Mar 2023 19:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5068C433D2;
        Wed, 15 Mar 2023 19:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678909806;
        bh=al5UOANFHtnpNCLQ/B2KpizIrzaQPYdmI8m2JBI6XXM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YFg4YtgDl6U0tZMxILxyZEbz8ZoEYvFuADZRUEZGLgAvWmW7N7gZIGt0yH6esuTwO
         D3TIdKRJkeuiv9wUsxAdc9YF+30W3BWIEQNlO993VcRK8FCcUNRIQMlu3u3q9j3+Bc
         7Fx9e8eAujUdihE277UiGbpheXWbcIHjflz3gTgAeGSRE44XSJgT/zrJh9Y/j7LZ6B
         SiMUy0KJBb46fTxNlOrd4uBU+pFecRwktkttoqVzU9oTX3pJc0fib2bhrG5Kd202tv
         8M9f1k3IH2kFzwpONOfqMiuCd1ESjsBeMCgPMY5iCuAIgXtSTvhwsPPXy8RufZYZ8y
         FlxcWh3hCfiUg==
Date:   Wed, 15 Mar 2023 12:50:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "zbr@ioremap.net" <zbr@ioremap.net>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 2/5] connector/cn_proc: Add filtering to fix some
 bugs
Message-ID: <20230315125004.5b203529@kernel.org>
In-Reply-To: <F553A86D-966E-4EE4-83FB-DB42CD83E81B@oracle.com>
References: <20230310221547.3656194-1-anjali.k.kulkarni@oracle.com>
        <20230310221547.3656194-3-anjali.k.kulkarni@oracle.com>
        <20230313172441.480c9ec7@kernel.org>
        <BY5PR10MB41295AF42563F023651E109FC4BE9@BY5PR10MB4129.namprd10.prod.outlook.com>
        <20230314215945.3336aeb3@kernel.org>
        <F553A86D-966E-4EE4-83FB-DB42CD83E81B@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Mar 2023 19:08:34 +0000 Anjali Kulkarni wrote:
> > On Mar 14, 2023, at 9:59 PM, Jakub Kicinski <kuba@kernel.org> wrote:
> >=20
> > On Tue, 14 Mar 2023 02:32:13 +0000 Anjali Kulkarni wrote: =20
> >> This is clearly a layering violation, right?
> >> Please don't add "if (family_x)" to the core netlink code.
> >> The other option is to add a flag in netlink_sock, something like
> >> NETLINK_F_SK_USER_DATA_FREE, which will free the sk_user_data, if
> >> this flag is set. But it does not solve the above scenario. =20
> >=20
> > Please fix your email setup, it's really hard to read your replies.
> >  =20
>=20
> I have changed my email client, let me know if this does not fix the issu=
e you see.

Quite a bit better, thanks!

> > There is an unbind callback, and a notifier. Can neither of those=20
> > be made to work? ->sk_user_data is not a great choice of a field,
> > either, does any other netlink family use it this way?
> > Adding a new field for family use to struct netlink_sock may be better.=
 =20
>=20
> The unbind call will not work because it is for the case of adding and de=
leting group memberships and hence called from netlink_setsockopt() when  N=
ETLINK_DROP_MEMBERSHIP option is given. We would not be able to distinguish=
 between the drop membership & release cases.
> The notifier call seems to be for blocked clients? Am not sure if the we =
need to block/wait on this call to be notified to free/release. Also, the A=
PI does not pass in struct sock to free what we want, so we will need to ch=
ange that everywhere it is currently used.

I think that adding the new release callback is acceptable.
I haven't seen your v2 before replying.

> As for using sk_user_data - this field seems to be used by different appl=
ications in different ways depending on how they need to use data. If we us=
e a new field in netlink_sock, we would need to add a new API function to a=
llocate this member, similar to release, because it seems you cannot access=
 netlink_sock outside of af_netlink, or at least I do not see any current a=
ccess to it, and functions like nlk_sk are static. Also, if we add an alloc=
ation function, we won=E2=80=99t know the first time the client sends it=E2=
=80=99s data (we need to know =E2=80=9Cinitial=E2=80=9D in the patches), so=
 we will need to add a new field in the socket to indicate first access or =
add a lot more infrastructure in cn_proc to store each client=E2=80=99s inf=
ormation.

Alright, I guess we can risk the sk_user_data, and see if anything
explodes. Normally higher protocol wraps the socket structure in its
own structure and the sk_user_data pointer is for an in-kernel user
of the socket (i.e. in kernel client). But "classic netlink" is all
legacy code (new subsystem use the generic netlink overlay) so trying
to decode now why things are the way they are and fixing the structure
would be a major effort :(
