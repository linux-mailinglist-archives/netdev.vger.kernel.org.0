Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43F00674383
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 21:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjASU3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 15:29:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjASU3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 15:29:34 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97789AAB0;
        Thu, 19 Jan 2023 12:29:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=zIGQalFZHxek35/o2xpf8DzICLu+OhQoZFFooWkYImE=;
        t=1674160173; x=1675369773; b=oEZsiWWasBkHxaFDXu2nwSNxCzCxy85k9XYa1p7XwcG0XHZ
        I7RP5tSDByo/StYcrpRH7bmk96sRe4WlsVR/z93vSTDdxsPABeh9iN/dFuMGhv+kouqDJgam4Cffc
        k8mBcUj0Pq36HBnvkFZYL4aHSu1+FhNJgfQR82nKNKX28NOxG1Khh0oU5V5RXXQVPel6o0/2e8ETU
        fdXHC2wBf/k853ImaaSTX7c1+Mg0s7u4bp6LZ2xqwyVm7onm+o9xoqJlL20ywNybmNe+MhbP8dall
        3zhGLAKWIP1tzzFmp4bexPQGo3T43fXv60UDHerGukl6P/TC/Ni1e+/VJezdz7wg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pIbXH-006eZ8-2m;
        Thu, 19 Jan 2023 21:29:23 +0100
Message-ID: <96618285a772b5ef9998f638ea17ff68c32dd710.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v3 1/8] docs: add more netlink docs (incl. spec
 docs)
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        robh@kernel.org, stephen@networkplumber.org,
        ecree.xilinx@gmail.com, sdf@google.com, f.fainelli@gmail.com,
        fw@strlen.de, linux-doc@vger.kernel.org, razor@blackwall.org,
        nicolas.dichtel@6wind.com, Bagas Sanjaya <bagasdotme@gmail.com>
Date:   Thu, 19 Jan 2023 21:29:22 +0100
In-Reply-To: <20230119003613.111778-2-kuba@kernel.org>
References: <20230119003613.111778-1-kuba@kernel.org>
         <20230119003613.111778-2-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-01-18 at 16:36 -0800, Jakub Kicinski wrote:
>=20
> +Answer requests
> +---------------
> +
> +Older families do not reply to all of the commands, especially NEW / ADD
> +commands. User only gets information whether the operation succeeded or
> +not via the ACK. Try to find useful data to return. Once the command is
> +added whether it replies with a full message or only an ACK is uAPI and
> +cannot be changed. It's better to err on the side of replying.
> +
> +Specifically NEW and ADD commands should reply with information identify=
ing
> +the created object such as the allocated object's ID (without having to
> +resort to using ``NLM_F_ECHO``).

I'm a bit on the fence on this recommendation (as written).

Yeah, it's nice to reply to things ... but!

In userspace, you often request and wait for the ACK to see if the
operation succeeded. This is basically necessary. But then it's
complicated to wait for *another* message to see the ID.

We've actually started using the "cookie" in the extack to report an ID
of an object/... back, see uses of nl_set_extack_cookie_u64() in the
tree.

So I'm not sure I wholeheartedly agree with the recommendation to send a
separate answer. We've done that, but it's ugly on both sender side in
the kernel (requiring an extra message allocation, ideally at the
beginning of the operation so you can fail gracefully, etc.) and on the
receiver (having to wait for another message if the operation was
successful; possibly actually having to check for that message *before*
the ACK arrives.)

> +Support dump consistency
> +------------------------
> +
> +If iterating over objects during dump may skip over objects or repeat
> +them - make sure to report dump inconsistency with ``NLM_F_DUMP_INTR``.

That could be a bit more fleshed out on _how_ to do that, if it's not
somewhere else?

> +kernel-policy
> +~~~~~~~~~~~~~
> +
> +Defines if the kernel validation policy is per operation (``per-op``)
> +or for the entire family (``global``). New families should use ``per-op`=
`
> +(default) to be able to narrow down the attributes accepted by a specifi=
c
> +command.

Again I'm not sure I agree with that recommendation, but I know it's
your preference :-)

(IMHO some things become more complex, such as having a "ifindex" in
each one of them)

> +checks
> +------
> +
> +Documentation for the ``checks`` sub-sections of attribute specs.
> +
> +unterminated-ok
> +~~~~~~~~~~~~~~~
> +
> +Accept strings without the null-termination (for legacy families only).
> +Switches from the ``NLA_NUL_STRING`` to ``NLA_STRING`` policy type.

Should we even document all the legacy bits in such a prominent place?

(or just move it after max-len/min-len?)

> +Attribute type nests
> +--------------------
> +
> +New Netlink families should use ``multi-attr`` to define arrays.

Unrelated to this particular document, but ...

I'm all for this, btw, but maybe we should have a way of representing in
the policy that an attribute is used as multi-attr for an array, and a
way of exposing that in the policy export? Hmm. Haven't thought about
this for a while.

johannes
