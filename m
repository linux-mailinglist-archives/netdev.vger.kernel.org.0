Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4FA56427E
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 21:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiGBT3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 15:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiGBT3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 15:29:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9DC65A9
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 12:29:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A44D260FB1
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 19:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF328C34114;
        Sat,  2 Jul 2022 19:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656790188;
        bh=1wdYNGygMY3xFou17WNF8f4YszaxqYB6MmyhhQZEMgw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HYxRpVw2EOt4PvbVaVVxG6tkznKugF8kMkoCXOgG96VZp4fmb5NaJCbJ+L0movTFt
         P0jekpt39Ilg3j5W+b7FK8td5mRAmg8i/kwmvjG3lgzH44U650KpBTGHkoHJbwvd+3
         Df0DhBYRWNTb7Ee9shWJa4a+MOaDV5JmF0VNZ+GmcLhl5C5Fc7SeXiJn1NkBfSfNba
         eD/oae54iheXs7BXkKtUg/psjT7bFKGGY4ugG7x/pYfr+xMkKxEHAkcJeSvz496da3
         sfQ9xhB5883VwfvegbvEXQX14WteXDOn+UNhZwK5Q8qTK9Xvu7qAy/a9S0ayW7lLNN
         Ex7jgKhAdcgXA==
Date:   Sat, 2 Jul 2022 12:29:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: Re: [patch net-next 2/3] net: devlink: call lockdep_assert_held()
 for devlink->lock directly
Message-ID: <20220702122946.7bfc387a@kernel.org>
In-Reply-To: <YsBrDhZuV4j3uCk3@nanopsycho>
References: <20220701095926.1191660-1-jiri@resnulli.us>
        <20220701095926.1191660-3-jiri@resnulli.us>
        <20220701093316.410157f3@kernel.org>
        <YsBrDhZuV4j3uCk3@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2 Jul 2022 17:58:06 +0200 Jiri Pirko wrote:
> Fri, Jul 01, 2022 at 06:33:16PM CEST, kuba@kernel.org wrote:
> >On Fri,  1 Jul 2022 11:59:25 +0200 Jiri Pirko wrote: =20
> >> In devlink.c there is direct access to whole struct devlink so there is
> >> no need to use helper. So obey the customs and work with lock directly
> >> avoiding helpers which might obfuscate things a bit. =20
> > =20
> >> diff --git a/net/core/devlink.c b/net/core/devlink.c
> >> index 25b481dd1709..a7477addbd59 100644
> >> --- a/net/core/devlink.c
> >> +++ b/net/core/devlink.c
> >> @@ -10185,7 +10185,7 @@ int devl_rate_leaf_create(struct devlink_port =
*devlink_port, void *priv)
> >>  	struct devlink *devlink =3D devlink_port->devlink;
> >>  	struct devlink_rate *devlink_rate;
> >> =20
> >> -	devl_assert_locked(devlink_port->devlink);
> >> +	lockdep_assert_held(&devlink_port->devlink->lock); =20
> >
> >I don't understand why. Do we use lockdep asserts directly on rtnl_mutex
> >in rtnetlink.c? =20
>=20
> Well:
>=20
> 1) it's been a long time policy not to use helpers for locks if not
>    needed. There reason is that the reader has easier job in seeing what
>    the code is doing. And here, it is not needed to use helper (we can
>    access the containing struct)

AFAIU the policy is not to _create_ helpers for locks for no good
reason. If the helper already exists it's better to consistently use
it.

> 2) lock/unlock for devlink->lock is done here w/o helpers as well

Existing code, I didn't want to cause major code churn until the
transition is finished.

> 3) there is really no gain of using helper here.

Shorter, easier to type and remember, especially if the author is
already using the exported assert in the driver.

> 4) rtnl_mutex is probably not good example, it has a lot of ancient
>    history behind it.

It's our main lock so we know it best. Do you have other examples?

Look, I don't really care, I just want to make sure we document the
rules of engagement clearly for everyone to see and uniformly enforce.=20
So we either need to bash out exactly what we want (and I think our
views differ) or you should switch the commit message to say "I feel
like" rather than referring to "customs" =F0=9F=98=81
