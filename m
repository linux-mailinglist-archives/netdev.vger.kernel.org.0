Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E708D603B02
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 09:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbiJSH7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 03:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiJSH7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 03:59:37 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F61BE0D
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 00:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=/Y9T2DS+eBm7AcVjco3vgjEafvIeHCy6CPXQU3jDBXc=;
        t=1666166375; x=1667375975; b=nwT6MIca8F0fhJgWWooxeJxxh+htFbzU21ej3//eQeamgpW
        lnfct3o12ooTWXwoJviMVo8X166BX/ONwgeOvgXnlRjWo3iIX0IUE1NYpvxL5B7p6PSCw11k2mfel
        Xdtdjy2HHU5OFbk9r/U9/DJD1lUTpf9PxSBiMIkBAKOn61DIWDynWgvX/c6ZrRohByZgEe6uUz0jh
        Df9rP+QMc1K66SWmKBaFksPib+SgfDq0e23/niRGCnxVmidJ7xPY2JhlAgyX4pIG1+O5bIJgDiFeV
        /3jJYwndqyu0QJsQ8VtOPeizieRWeLwnLNz6xFouHMUQgSTngkTDVcyizrLpRMyg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ol3z3-00B1GG-2D;
        Wed, 19 Oct 2022 09:59:25 +0200
Message-ID: <93e9137fb80f63cd13fa226bcca3007c473a74d4.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 03/13] genetlink: introduce split op
 representation
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, jiri@nvidia.com, nhorman@tuxdriver.com,
        alex.aring@gmail.com, stefan@datenfreihafen.org
Date:   Wed, 19 Oct 2022 09:59:24 +0200
In-Reply-To: <20221018230728.1039524-4-kuba@kernel.org>
References: <20221018230728.1039524-1-kuba@kernel.org>
         <20221018230728.1039524-4-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
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

On Tue, 2022-10-18 at 16:07 -0700, Jakub Kicinski wrote:
>=20
> +/**
> + * struct genl_split_ops - generic netlink operations (do/dump split ver=
sion)
> + * @cmd: command identifier
> + * @internal_flags: flags used by the family
> + * @flags: GENL_* flags (%GENL_ADMIN_PERM or %GENL_UNS_ADMIN_PERM)
> + * @validate: validation flags from enum genl_validate_flags
> + * @policy: netlink policy (takes precedence over family policy)
> + * @maxattr: maximum number of attributes supported
> +  *

nit: extra space here

> + * Do callbacks:
> + * @pre_doit: called before an operation's @doit callback, it may
> + *	do additional, common, filtering and return an error
> + * @doit: standard command callback
> + * @post_doit: called after an operation's @doit callback, it may
> + *	undo operations done by pre_doit, for example release locks


Is that really worth it? I mean, if you need pre/post for a *specific*
op, you can just roll that into it.

Maybe the use case would be something like "groups" where some commands
need one set of pre/post, and some other commands need another set, and
then it's still simpler to do as pre/post rather than calling them
inside the doit()?

(and you also have space for the pointers given the dump part of the
union, so ...)

> +static void
> +genl_cmd_full_to_split(struct genl_split_ops *op,
> +		       const struct genl_family *family,
> +		       const struct genl_ops *full, u8 flags)
> +{

[...]


> +	op->flags		|=3D flags;


why |=3D ?

> @@ -776,8 +821,9 @@ static int genl_family_rcv_msg(const struct genl_fami=
ly *family,
>  {
>  	struct net *net =3D sock_net(skb->sk);
>  	struct genlmsghdr *hdr =3D nlmsg_data(nlh);
> -	struct genl_ops op;
> +	struct genl_split_ops op;

it's not even initialized?


> +	flags =3D (nlh->nlmsg_flags & NLM_F_DUMP) =3D=3D NLM_F_DUMP ?
> +		GENL_CMD_CAP_DUMP : GENL_CMD_CAP_DO;
> +	if (genl_get_cmd_split(hdr->cmd, flags, family, &op))
>  		return -EOPNOTSUPP;

before being used

or am I misreading something?

johannes
