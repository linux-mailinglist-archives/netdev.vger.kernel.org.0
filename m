Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCF664690E
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 07:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiLHGXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 01:23:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLHGXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 01:23:15 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CBF28E33
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 22:23:13 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 7055B22CB7;
        Thu,  8 Dec 2022 06:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670480592; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5xIWSPi7LHVx7Q/T0pNE3IL5y3tbV7k8spG4CeJJfvs=;
        b=joRvfzFaaRsO8uGrIBO+3GULEYDnRrsYTBZOFqrRr9TplUqQjkmy+LtoKiUzNVD4mCNpiZ
        RYax2iKCThI2GTlyWFzm2BBj8LP14xESabN3cwsAJNV8T7KT9dBjHgGn1u8l8QGOifS9rl
        h5QVSZPpKN/EIaET/2RcebIUoQQlJ6Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670480592;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5xIWSPi7LHVx7Q/T0pNE3IL5y3tbV7k8spG4CeJJfvs=;
        b=jyAGnCOiHVB0j7kschwLYzIVIbU5RncelhtB2g0RPsWN3cPV+ouA58BK8S3dxNfuCw0JKL
        tU/WXrxCLGNsP9Aw==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 65E7C2C142;
        Thu,  8 Dec 2022 06:23:12 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 37C0D6045E; Thu,  8 Dec 2022 07:23:12 +0100 (CET)
Date:   Thu, 8 Dec 2022 07:23:12 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool v2 07/13] ethtool: avoid null pointer dereference
Message-ID: <20221208062312.2emtsvurflldumsr@lion.mk-sys.cz>
References: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
 <20221208011122.2343363-8-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uj6q5osuvp26m73k"
Content-Disposition: inline
In-Reply-To: <20221208011122.2343363-8-jesse.brandeburg@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--uj6q5osuvp26m73k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 07, 2022 at 05:11:16PM -0800, Jesse Brandeburg wrote:
> '$ scan-build make' reports:
>=20
> Description: Array access (from variable 'arg') results in a null
> pointer dereference
> File: /git/ethtool/netlink/parser.c
> Line: 782
>=20
> Description: Dereference of null pointer (loaded from variable 'p')
> File: /git/ethtool/netlink/parser.c
> Line: 794
>=20
> Both of these bugs are prevented by checking the input in
> nl_parse_char_bitset(), which is called from nl_sset() via the kernel
> callback, specifically for the parsing of the wake-on-lan options (-s
> wol). None of the other functions in this file seem to have the issue of
> deferencing data without checking for validity first. This could
> "technically" allow nlctxt->argp to be NULL, and scan-build is limited
> in it's ability to parse for bugs only at file scope in this case.
> This particular bug should be unlikely to happen because the kernel
> builds/parses the netlink structure before handing it to the

Again: this has nothing to do with netlink, this is command line parser,
nlctx->argp is a member of argv[] array. And as execve() (which is the
only syscall in the exec* family, the rest are wrappers) does not pass
argc, only argv[], argc is actually determined by kernel so for it to be
actually null, you would need a serious bug in kernel first.

Even if we want to be safe against buggy kernel passing garbage as
command line arguments, I still believe we should do that earlier, in
the general code, not deep in a specific helper function. Also, you only
check for null but that does not catch an invalid pointer in argv[]
which, unlike a null pointer, could do an actual harm. And I don't see
how that could be checked, I'm afraid we have to trust kernel.

Michal

> application. However in the interests of being able to run this
> scan-build tool regularly, I'm still sending the initial version of this
> patch as I tried several other ways to fix the bug with an earlier check
> for NULL in nl_sset, but it won't prevent the scan-build error due to
> the file scope problem.
>=20
> CC: Michal Kubecek <mkubecek@suse.cz>
> Fixes: 81a30f416ec7 ("netlink: add bitset command line parser handlers")
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
> v2: updated commit message with more nuance after feedback from ethtool
> maintainer. I'd be open to fixing this a different way but this seemed
> the most straight-forward with the smallest amount of code changed.
> v1: original version
> ---
>  netlink/parser.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/netlink/parser.c b/netlink/parser.c
> index 70f451008eb4..c573a9598a9f 100644
> --- a/netlink/parser.c
> +++ b/netlink/parser.c
> @@ -874,7 +874,7 @@ int nl_parse_bitset(struct nl_context *nlctx, uint16_=
t type, const void *data,
>   * optionally followed by '/' and another numeric value (mask, unless no=
_mask
>   * is set), or a string consisting of characters corresponding to bit in=
dices.
>   * The @data parameter points to struct char_bitset_parser_data. Generat=
es
> - * biset nested attribute. Fails if type is zero or if @dest is not null.
> + * bitset nested attribute. Fails if type is zero or if @dest is not nul=
l.
>   */
>  int nl_parse_char_bitset(struct nl_context *nlctx, uint16_t type,
>  			 const void *data, struct nl_msg_buff *msgbuff,
> @@ -882,7 +882,7 @@ int nl_parse_char_bitset(struct nl_context *nlctx, ui=
nt16_t type,
>  {
>  	const struct char_bitset_parser_data *parser_data =3D data;
> =20
> -	if (!type || dest) {
> +	if (!type || dest || !*nlctx->argp) {
>  		fprintf(stderr, "ethtool (%s): internal error parsing '%s'\n",
>  			nlctx->cmd, nlctx->param);
>  		return -EFAULT;
> --=20
> 2.31.1
>=20

--uj6q5osuvp26m73k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmORgssACgkQ538sG/LR
dpXfDQgArfc2AQJI6RjyMWGpsw/5ZFFZDmBrVcFp6IMyA0A+eFCHJ+xI56vLgheE
5KwVfZ0KDaUx00Sfe6kQ9tSz551DigvV/SFxV0lXtFf05XBqFlx+WQW0JIvjUc3y
Rz37nPHNKod8qpK8mzByTD5ShmxR21MoqMZmN7ftCTKjk16HjQsz5DYVZkCCT1uW
pc68YGfkPv9mRG6RpwOkDTYLhB0BSb1NYJZ/kvCJhWwFosQNA6kFjfk+axnDr5dR
FmhAscvr5inpvZQYNtGIFodlYsgKOIzmY7eYJaTq42nxxR2mNS/QOpQkh6yDjY4h
smIiIBcd3dv+q0CHOm4JXvglJQKVlA==
=gVsz
-----END PGP SIGNATURE-----

--uj6q5osuvp26m73k--
