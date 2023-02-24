Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C11F46A1806
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 09:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbjBXId6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 03:33:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjBXId5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 03:33:57 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1101815D
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 00:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=ZK9mb1BumPRhN4JrwwlTevrrDrgRdzsIgS67pEF4zjs=;
        t=1677227636; x=1678437236; b=jYexD+gaQuJhY+O0K1L+0Zutj9k3MuFalj64tQH/c3AMAK0
        rzddn5+g4KfdAMDVdYa9jpqyy2SqzlaCfym5ydrns6DqWa8Gqz6wPk5NdonvR7EKk1zHMZNF+arVi
        fvm9qcznsC7JJRHICYc2ilfXF0GjLtgDkJPEGofijoWOGV2SikmydsCGOEb8XPsnESLdWME6RJRjU
        caML9HgAF7DdKoBXPxJ50dDpTXyqM3fXTCslX/HRaz45bMaCye0e4rQGHjaqSZanMekXAva9959fl
        dvquOrpKZdZ0Pye4DpIUHFshHUupDE5dljvUjEBYfHwXX7M+wY6Y5G7l/IBSgbuw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pVTWa-0046lu-06;
        Fri, 24 Feb 2023 09:33:52 +0100
Message-ID: <0ae995dd47329e1422cb0e99b7960615c58d37fe.camel@sipsolutions.net>
Subject: Re: [PATCH iproute2] genl: print caps for all families
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, stephen@networkplumber.org
Cc:     dsahern@gmail.com, jhs@mojatatu.com, netdev@vger.kernel.org
Date:   Fri, 24 Feb 2023 09:33:51 +0100
In-Reply-To: <20230223175708.51e593f0@kernel.org>
References: <20230224015234.1626025-1-kuba@kernel.org>
         <20230223175708.51e593f0@kernel.org>
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

On Thu, 2023-02-23 at 17:57 -0800, Jakub Kicinski wrote:
> On Thu, 23 Feb 2023 17:52:34 -0800 Jakub Kicinski wrote:
> > Back in 2006 kernel commit 334c29a64507 ("[GENETLINK]: Move
> > command capabilities to flags.") removed some attributes and
> > moved the capabilities to flags. Corresponding iproute2
> > commit 26328fc3933f ("Add controller support for new features
> > exposed") added the ability to print those caps.
> >=20
> > Printing is gated on version of the family, but we're checking
> > the version of each individual family rather than the control
> > family. The format of attributes in the control family
> > is dictated by the version of the control family alone.
> >=20
> > Families can't use flags for random things, anyway,
> > because kernel core has a fixed interpretation.
> >=20
> > Thanks to this change caps will be shown for all families
> > (assuming kernel newer than 2.6.19), not just those which
> > by coincidence have their local version >=3D 2.
> >=20
> > For instance devlink, before:
> >=20
> >   $ genl ctrl get name devlink
> >   Name: devlink
> > 	ID: 0x15  Version: 0x1  header size: 0  max attribs: 179
> > 	commands supported:
> > 		#1:  ID-0x1
> > 		#2:  ID-0x5
> > 		#3:  ID-0x6
> > 		...
> >=20
> > after:
> >=20
> >   $ genl ctrl get name devlink
> >   Name: devlink
> > 	ID: 0x15  Version: 0x1  header size: 0  max attribs: 179
> > 	commands supported:
> > 		#1:  ID-0x1
> > 		Capabilities (0xe):
> >  		  can doit; can dumpit; has policy
> >=20
> > 		#2:  ID-0x5
> > 		Capabilities (0xe):
> >  		  can doit; can dumpit; has policy
> >=20
> > 		#3:  ID-0x6
> > 		Capabilities (0xb):
> >  		  requires admin permission; can doit; has policy
> >=20
> > Leave ctrl_v as 0 if we fail to read the version. Old code used 1
> > as the default, but 0 or 1 - does not matter, checks are for >=3D 2.
> >=20
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> > Not really sure if this is a fix or not..
>=20
> Adding Johannes, that's probably everyone who ever used this=20
> command on CC? ;)

Hehe. I'm not even sure I use(d) that part of it frequently ;-)

> > --- a/genl/ctrl.c
> > +++ b/genl/ctrl.c
> > @@ -21,6 +21,8 @@
> >  #define GENL_MAX_FAM_OPS	256
> >  #define GENL_MAX_FAM_GRPS	256
> > =20
> > +static unsigned int ctrl_v;

You know I looked at this on my phone this morning and missed the fact
that it's iproute2, and was wondering what you're doing with a global
variable in the kernel ;-)

There's this code also:

> static int print_ctrl_cmds(FILE *fp, struct rtattr *arg, __u32 ctrl_ver)
> ...
> static int print_ctrl_grp(FILE *fp, struct rtattr *arg, __u32 ctrl_ver)

and it feels a bit pointless to pass a now global ctrl_v to the function
arguments?

> > @@ -264,6 +313,9 @@ static int ctrl_list(int cmd, int argc, char **argv=
)
> >  		exit(1);
> >  	}
> > =20
> > +	if (!ctrl_v)
> > +		ctrl_load_ctrl_version(&rth);

You call this here, but what about this:

> struct genl_util ctrl_genl_util =3D {
>         .name =3D "ctrl",
>         .parse_genlopt =3D parse_ctrl,
>         .print_genlopt =3D print_ctrl2,
> };

where print_ctrl2 and hence all the above will be called with a now zero
ctrl_v, whereas before it would've been - at least in some cases? -
initialized by ctrl_list() itself?


Oh. I see now. The issue was which version we use - the family version
vs. the controller version. How did I miss that until here ...

Still it seems it should be always initialized in print_ctrl rather than
in ctrl_list, to capture the case of print_ctrl2? Or maybe in there, but
that's called inside ctrl_list(), so maybe have parse_ctrl() already
initialize it, rather than ctrl_list()?

johannes
