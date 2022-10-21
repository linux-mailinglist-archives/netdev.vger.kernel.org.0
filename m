Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1663607F5D
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 21:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiJUT6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 15:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiJUT6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 15:58:11 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999D929CB94
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 12:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=zJ+XePwgNqWeLh7x9bbzzO+Rl9WRgHkczsATyBUXYX4=;
        t=1666382286; x=1667591886; b=hJ3eXNJcrH10WfcgnCoIhyuHODFJVRWwGAZd5ZVtgrWgl8l
        F5RS42m0OlOY5DGJdTPsSrfMNniDXdUlOv+oEjIi1ieCaaYRe0Bd3/BSVaCN5o693rrJv3NWR1yUC
        p4bTTSVDvKcfVyWSaRnWOR8Nm8H+odlJEsKviJzCEphTLwhYH4Xj5lclnjWhe4/LZX2Nb/PRL3lAl
        h/Nk70u61xUyMqOSP+p8DnT5zvN7eUKoDKQ1NjU6GGl9WlbapozXzIarDIrtguaqzD2aKyYAQSlvS
        ybFNunNEBBMsdLKfEM+sWrymRMwSMBRMnB3OkpBaiK33JFOEvVoe7GQss15JqYzQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oly9S-00CznE-0h;
        Fri, 21 Oct 2022 21:57:54 +0200
Message-ID: <6ba9f727e555fd376623a298d5d305ad408c3d47.camel@sipsolutions.net>
Subject: Re: [PATCH net] genetlink: piggy back on resv_op to default to a
 reject policy
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, fw@strlen.de, jiri@nvidia.com
Date:   Fri, 21 Oct 2022 21:57:53 +0200
In-Reply-To: <20221021193532.1511293-1-kuba@kernel.org>
References: <20221021193532.1511293-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-10-21 at 12:35 -0700, Jakub Kicinski wrote:
>=20
> +/* We need the last attribute with non-zero ID therefore a 2-entry array=
 */
> +static struct nla_policy genl_policy_reject_all[] =3D {
> +	{ .type =3D NLA_REJECT },
> +	{ .type =3D NLA_REJECT },
> +};
> +
>  static int genl_ctrl_event(int event, const struct genl_family *family,
>  			   const struct genl_multicast_group *grp,
>  			   int grp_id);
> =20
> +static void
> +genl_op_fill_in_reject_policy(const struct genl_family *family,
> +			      struct genl_ops *op)
> +{
> +	BUILD_BUG_ON(ARRAY_SIZE(genl_policy_reject_all) - 1 !=3D 1);
> +
> +	if (op->policy || op->cmd < family->resv_start_op)
> +		return;
> +
> +	op->policy =3D genl_policy_reject_all;
> +	op->maxattr =3D 1;
> +}

It feels it might've been easier to implement as simply, apart from the
doc changes:

--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -529,6 +529,10 @@ genl_family_rcv_msg_attrs_parse(const struct genl_fami=
ly *family,
 	struct nlattr **attrbuf;
 	int err;
=20
+	if (ops->cmd >=3D family->resv_start_op && !ops->maxattr &&
+	    nlmsg_attrlen(nlh, hdrlen))
+		return ERR_PTR(-EINVAL);
+
 	if (!ops->maxattr)
 		return NULL;
=20


But maybe I'm missing something in the relation with the new split ops
etc.

Also, technically, you could now have an op that is >=3D resv_start_op,
but sets one of GENL_DONT_VALIDATE{_DUMP,}_STRICT and then gets the old
behaviour except that attributes 0 and 1 are rejected?

Any particular reason you chose this implementation here? I can
understand having chosen it with the yaml things since then you can be
sure you're not setting GENL_DONT_VALIDATE{_DUMP,}_STRICT and you don't
have another choice anyway, but here?

Hmm.

Then again, maybe anyway we should make sure that
GENL_DONT_VALIDATE{_DUMP,}_STRICT aren't set for ops >=3D resv_start_op?


Anyway, for the intended use it works, and I guess it'd be a stupid
family that makes sure to set this but then still uses non-strict
validation, though I've seen people (try to) copy/paste non-strict
validation into new ops ...

johannes
