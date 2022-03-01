Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65F074C8BE6
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 13:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234826AbiCAMpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 07:45:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232420AbiCAMpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 07:45:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE5D5DE47;
        Tue,  1 Mar 2022 04:44:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18A98B818D6;
        Tue,  1 Mar 2022 12:44:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6ADC340EE;
        Tue,  1 Mar 2022 12:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646138659;
        bh=Dvmj37OjCzYRSD5lH+68CdPQAV0uvqJN0PHM1p+T0So=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cvEy4Celqtz56G+ZmoQDluWwekayBnfTCkFgpjXIFUH67plCHqLaSs3bbB243KlIR
         c45wYDECEVf4LWJ00ZQiKAcyUSHL64BhIGFvma252WcK0UALkdGdrYGD/dqovDJKtR
         nXEk3Ag/hwkYm5li4hxxk+HMio8KgibuwB4aX5v1Z2zZmHKVjrxL7cIQKNI/tiMITd
         NkO+5zDQZmAzNeWpLD6uKGpNz/FoYh51Uy8J52cCMjZhmPH1IJKDOsrwcP7vK2YjZm
         nonLZCYTS9eYAKYZRMI8CD96NDXVzp27Rt1yTEqCpDc6ETJVDQByLrDXXZXW/TIYGE
         LR+shwwVPEBnw==
Date:   Tue, 1 Mar 2022 12:44:12 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, f.suligoi@asem.it,
        kuninori.morimoto.gx@renesas.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] ASoC: fsi: Add check for clk_enable
Message-ID: <Yh4VHFviMI/LbjVe@sirena.org.uk>
References: <20220301073949.3678707-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="a4D1fYTki8ZRdcZe"
Content-Disposition: inline
In-Reply-To: <20220301073949.3678707-1-jiasheng@iscas.ac.cn>
X-Cookie: You have a message from the operator.
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--a4D1fYTki8ZRdcZe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 01, 2022 at 03:39:49PM +0800, Jiasheng Jiang wrote:
> As the potential failure of the clk_enable(),
> it should be better to check it and return error
> if fails.

> -		clk_enable(clock->xck);
> -		clk_enable(clock->ick);
> -		clk_enable(clock->div);
> +		ret =3D clk_enable(clock->xck);
> +		if (ret)
> +			goto err;
> +		ret =3D clk_enable(clock->ick);
> +		if (ret)
> +			goto err;
> +		ret =3D clk_enable(clock->div);
> +		if (ret)
> +			goto err;
> =20
>  		clock->count++;
>  	}
> =20
>  	return ret;
> +
> +err:
> +	clk_disable(clock->xck);
> +	clk_disable(clock->ick);
> +	clk_disable(clock->div);

You need separate labels for each enable so that we don't end up
disabling clocks we didn't enable, that would also be a bug.

--a4D1fYTki8ZRdcZe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmIeFRwACgkQJNaLcl1U
h9DwBgf/bin2luVJoiauARSYcwKh6nAuT6t1+pRx4vZsv96asJBq6mHzg3Lde11Y
m2QgosA3PwMCLdvAIk4gZc2OQfzLQ6r96lgNEFHE3fmZknc9qPeO5P8275sdgfRy
xn7l5w0j4y/4QoGu6YpE9EidGOGlkLQMcMvVc3CcpIUQLexWdGIgYUoJDT8MaIrA
NNlrI3R296GI6oToypsEEC+KnTcddRKhEqd/wlCTD75OP9WmbQdUkw84mXq4A29F
yDHw4BIYC8Mhx+RvUUXSaBue6Ow0kk58x9hdeFIE7Zc2qRk8xuSTxnju+QXIPNZK
djNrcWAUdWEufFhsSf26mOnIq6bsrQ==
=LFkr
-----END PGP SIGNATURE-----

--a4D1fYTki8ZRdcZe--
