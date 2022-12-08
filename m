Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57519646BBA
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 10:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbiLHJP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 04:15:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbiLHJPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 04:15:14 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB90C2F030
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 01:14:23 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 6052033708;
        Thu,  8 Dec 2022 09:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670490862; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cS94+yMjfRIjh4vGGXJW2gDS4LoqcrzsrtSQGxQM9ZE=;
        b=TZBr/HxFPXJTQJtbq5hJTR+sI0qhJSZyux53bRqUR01oHO5HpLm5UR9JdWkWXTLl0hDxQE
        d/bdWi+x+ooJMwGgEDc5T6k+ZtVU7I9o1GOoviZ2XPyUBM+aWP/G/j7GzG8g22NxBotM2m
        +qjoCbqY7MofKsOQiXnYnJhrWRPV6/8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670490862;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cS94+yMjfRIjh4vGGXJW2gDS4LoqcrzsrtSQGxQM9ZE=;
        b=Bq2EhHywHYX6+jrHIhnlpWqGMHIoHwmsn5kfFnVB6U04gJ0BwetkCuzYHBGnoTn2ZvlwEx
        b0Yl8zD3WjzzM5BQ==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 551792C69C;
        Thu,  8 Dec 2022 09:14:22 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 167656045E; Thu,  8 Dec 2022 10:14:22 +0100 (CET)
Date:   Thu, 8 Dec 2022 10:14:22 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool v2 03/13] ethtool: disallow passing null to
 find_option
Message-ID: <20221208091422.pwsa36wl72qdzmpi@lion.mk-sys.cz>
References: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
 <20221208011122.2343363-4-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yqvk3gi5xfetjaxs"
Content-Disposition: inline
In-Reply-To: <20221208011122.2343363-4-jesse.brandeburg@intel.com>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--yqvk3gi5xfetjaxs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 07, 2022 at 05:11:12PM -0800, Jesse Brandeburg wrote:
> After testing with this code in the debugger, it is technically possible
> to pass a NULL argument to ethtool which then prods it to call strncmp
> with a NULL value, which triggers this warning:
>=20
> Description: Null pointer passed to 1st parameter expecting 'nonnull'
> File: /git/ethtool/ethtool.c
> Line: 6129
>=20
> Since segfaults are bad, let's just add a check for NULL when parsing
> the initial arguments. The other cases of a NULL option are seemingly
> handled.
>=20
> Fixes: 127f80691f96 ("Move argument parsing to sub-command functions")
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

Learning about (kernel) mainline commit dcd46d897adb ("exec: Force
single empty string when argv is empty"), I'm not opposed to mistrusting
kernel provided argc and argv[] but rather than hunting all places where
we might possibly hit a null pointer in argv[] (mind that we may iterate
over argv[] up to three times), I would simply check the whole array at
the beginning of main() with something like

	k =3D 0;
	while (k <=3D argc && argv[k])
		k++;
	if (k !=3D argc) {
		fprintf(stderr, "ethtool: inconsistent command line (OS bug?)\n");
		return 1;
	}

and be done with it.

Michal

> ---
>  ethtool.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/ethtool.c b/ethtool.c
> index 3207e49137c4..a72577b32601 100644
> --- a/ethtool.c
> +++ b/ethtool.c
> @@ -6389,7 +6389,7 @@ int main(int argc, char **argp)
>  	 * name to get settings for (which we don't expect to begin
>  	 * with '-').
>  	 */
> -	if (argc =3D=3D 0)
> +	if (argc =3D=3D 0 || *argp =3D=3D NULL)
>  		exit_bad_args();
> =20
>  	k =3D find_option(*argp);
> --=20
> 2.31.1
>=20

--yqvk3gi5xfetjaxs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmORqukACgkQ538sG/LR
dpVPZQf7BulNX+fNVSkk0dfmYFsVKihGEPF1xi9YIjTIObaq1HArMQNpgn7g0Zvb
tBv7WQn9Cg0bzDs+e07QbX3DNtfMP5Nt+kiq4dI+E87jkxIziq5Xd0lxM4j1K+hT
SEBtP1h9ywcnP1cWzEPaEw/3jCB5WZiqbGyNxhFnBrRPTOzwD1qBBg1C6xtc66vE
s3UuGE8HUatzdbIH8oxaul3QttRkQvO6csi3AbwRT5JMZ4UYy1U1+ArctecONeqb
TifnwLhHer1FKa+7uyMtL4layGF344M+4E7c99FV73PT+ObiS+v3V2fVxBw0EWfE
ZdqEmNIuTVzieLZPUJPEvfPg/JpKoQ==
=9loU
-----END PGP SIGNATURE-----

--yqvk3gi5xfetjaxs--
