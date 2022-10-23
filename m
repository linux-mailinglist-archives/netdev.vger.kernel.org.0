Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 099426094AF
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 18:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiJWQUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 12:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiJWQUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 12:20:10 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41972DAA6
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 09:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Date:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Cc:To:From:Subject:Message-ID:Sender:
        Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=ZDjNX3pk5i7R9iOuCRDDqivE9UdIuBlP7ou5DS8iHE8=;
        t=1666542007; x=1667751607; b=llDbt3Z/1gA00sEKuB+yo1rMmkBCXVWH0uEwkzP4U8ReJ4F
        cu2CDEqeeeJbWAlOaEsr0oj0c+Qs+IGCyiUcv2JCUVXrIT1LlmscosvWbya79hhJHM86NVrL5rm+0
        PaZSyybA0W/AQ5azdjKRk7iSowOyoch9f2OxHT/XtfcxzR+q1r686ZXY9x1fNiBvEFuho2vjwlzE9
        Sx3s+GMu4/o/LJzTdTp6bn0QNrVMgk1Qa0H44QpM9qyaMZbxQDHt/FBjP0KgEkjRyzItcwtICTwn2
        Sxw20+mPoygmpb4u39fVcUu6nSOPgi5VU9uoXocsAreZagMRsW4zD0//9fh/g6qw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1omdhe-00EbrB-1z;
        Sun, 23 Oct 2022 18:19:59 +0200
Message-ID: <1b5ce217d872cdb59b73f1dc745819861e46c8cb.camel@sipsolutions.net>
Subject: Re: [PATCH net] genetlink: piggy back on resv_op to default to a
 reject policy
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        jiri@nvidia.com
In-Reply-To: <20221021210815.44e8220f@kernel.org>
References: <20221021193532.1511293-1-kuba@kernel.org>
         <6ba9f727e555fd376623a298d5d305ad408c3d47.camel@sipsolutions.net>
         <20221021210815.44e8220f@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Date:   Sun, 23 Oct 2022 18:19:51 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-10-21 at 21:08 -0700, Jakub Kicinski wrote:
> On Fri, 21 Oct 2022 21:57:53 +0200 Johannes Berg wrote:
> > It feels it might've been easier to implement as simply, apart from the
> > doc changes:
> >=20
> > --- a/net/netlink/genetlink.c
> > +++ b/net/netlink/genetlink.c
> > @@ -529,6 +529,10 @@ genl_family_rcv_msg_attrs_parse(const struct genl_=
family *family,
> >  	struct nlattr **attrbuf;
> >  	int err;
> > =20
> > +	if (ops->cmd >=3D family->resv_start_op && !ops->maxattr &&
> > +	    nlmsg_attrlen(nlh, hdrlen))
> > +		return ERR_PTR(-EINVAL);
> > +
> >  	if (!ops->maxattr)
> >  		return NULL;
> >=20
> > But maybe I'm missing something in the relation with the new split ops
> > etc.
>=20
> The reason was that payload length check is... "unintrospectable"?

Fair enough.

> The reject all policy shows up in GETPOLICY. Dunno how much it matters
> in practice but that was the motivation. LMK which way you prefer.

No I guess it's fine, it just felt a lot of overhead for what could've
been a one-line check. Having it introspectable is a nice benefit I
didn't think about :)

> > Anyway, for the intended use it works, and I guess it'd be a stupid
> > family that makes sure to set this but then still uses non-strict
> > validation, though I've seen people (try to) copy/paste non-strict
> > validation into new ops ...
>=20
> Hm, yeah, adding DONT*_STRICT for new commands would be pretty odd as
> you say. Someone may copy & paste an existing command, tho, without
> understanding what this flag does.=20
>=20
> I can add a check separately I reckon. It's more of a "no new command
> should set this flag" thing rather than inherently related to the
> reject-all policy, right?

Yes. In fact there's also the strict_start_type in the policy[0] entry
too, which was kind of similar.

johannes
