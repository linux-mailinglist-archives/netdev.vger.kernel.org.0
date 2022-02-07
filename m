Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 379174AC0D5
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 15:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbiBGOQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 09:16:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389743AbiBGNxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 08:53:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619C7C0401CF;
        Mon,  7 Feb 2022 05:53:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0736C61142;
        Mon,  7 Feb 2022 13:53:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE2EC004E1;
        Mon,  7 Feb 2022 13:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644242014;
        bh=NImESdYa5UQ5C/nCd5YhwKuqjEfChr+OuDFfR9TpsRo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=itczlk34LBCmvKoTEfiPkgUGXJFFhUiw5fDDKIEPmEhDroRfufKCPRnQCKeah/pXe
         rx7C/KtVUwxWJleoCNHmpsxJrnzEutdEBwSR4uY/zN6Ohg0qRI+anEOLHVYtqS3qiG
         7Dg8PNTjxWp14+uTcg4PT9xTXYd/hbvaxFZ8+ee5GejGgoIKuadO68QEtcLDGw37kK
         vBzeMGL7nWBbFP6uTMY/+98wqL0LofNH1N8UR7D5BcQyoeZUm4lp4gq8+q2FMWLyEy
         wNR6D0j9mYOHri+wQQEfYl3pXkqV53ZXG9SEt+Fsk5K109YJEb1mkpy0jzj/ePSytq
         vXkRoeRfTcg9g==
Date:   Mon, 7 Feb 2022 14:53:30 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: test_run: fix overflow in xdp frags
 parsing
Message-ID: <YgEkWnXkEO+aAOX8@lore-desk>
References: <20220204235849.14658-1-sdf@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="j4D4r14HvjbJzlac"
Content-Disposition: inline
In-Reply-To: <20220204235849.14658-1-sdf@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--j4D4r14HvjbJzlac
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> When kattr->test.data_size_in > INT_MAX, signed min_t will assign
> negative value to data_len. This negative value then gets passed
> over to copy_from_user where it is converted to (big) unsigned.
>=20
> Use unsigned min_t to avoid this overflow.

Thx for fixing it.

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
>=20
> usercopy: Kernel memory overwrite attempt detected to wrapped address
> (offset 0, size 18446612140539162846)!
> ------------[ cut here ]------------
> kernel BUG at mm/usercopy.c:102!
> invalid opcode: 0000 [#1] SMP KASAN
> Modules linked in:
> CPU: 0 PID: 3781 Comm: syz-executor226 Not tainted 4.15.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:usercopy_abort+0xbd/0xbf mm/usercopy.c:102
> RSP: 0018:ffff8801e9703a38 EFLAGS: 00010286
> RAX: 000000000000006c RBX: ffffffff84fc7040 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff816560a2 RDI: ffffed003d2e0739
> RBP: ffff8801e9703a90 R08: 000000000000006c R09: 0000000000000001
> R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff84fc73a0
> R13: ffffffff84fc7180 R14: ffffffff84fc7040 R15: ffffffff84fc7040
> FS:  00007f54e0bec300(0000) GS:ffff8801f6600000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000280 CR3: 00000001e90ea000 CR4: 00000000003426f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  check_bogus_address mm/usercopy.c:155 [inline]
>  __check_object_size mm/usercopy.c:263 [inline]
>  __check_object_size.cold+0x8c/0xad mm/usercopy.c:253
>  check_object_size include/linux/thread_info.h:112 [inline]
>  check_copy_size include/linux/thread_info.h:143 [inline]
>  copy_from_user include/linux/uaccess.h:142 [inline]
>  bpf_prog_test_run_xdp+0xe57/0x1240 net/bpf/test_run.c:989
>  bpf_prog_test_run kernel/bpf/syscall.c:3377 [inline]
>  __sys_bpf+0xdf2/0x4a50 kernel/bpf/syscall.c:4679
>  SYSC_bpf kernel/bpf/syscall.c:4765 [inline]
>  SyS_bpf+0x26/0x50 kernel/bpf/syscall.c:4763
>  do_syscall_64+0x21a/0x3e0 arch/x86/entry/common.c:305
>  entry_SYSCALL_64_after_hwframe+0x46/0xbb
>=20
> Cc: Lorenzo Bianconi <lorenzo@kernel.org>
> Fixes: 1c1949982524 ("bpf: introduce frags support to bpf_prog_test_run_x=
dp()")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  net/bpf/test_run.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 0220b0822d77..5819a7a5e3c6 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -960,7 +960,7 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, cons=
t union bpf_attr *kattr,
>  		while (size < kattr->test.data_size_in) {
>  			struct page *page;
>  			skb_frag_t *frag;
> -			int data_len;
> +			u32 data_len;
> =20
>  			if (sinfo->nr_frags =3D=3D MAX_SKB_FRAGS) {
>  				ret =3D -ENOMEM;
> @@ -976,7 +976,7 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, cons=
t union bpf_attr *kattr,
>  			frag =3D &sinfo->frags[sinfo->nr_frags++];
>  			__skb_frag_set_page(frag, page);
> =20
> -			data_len =3D min_t(int, kattr->test.data_size_in - size,
> +			data_len =3D min_t(u32, kattr->test.data_size_in - size,
>  					 PAGE_SIZE);
>  			skb_frag_size_set(frag, data_len);
> =20
> --=20
> 2.35.0.263.gb82422642f-goog
>=20

--j4D4r14HvjbJzlac
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYgEkWgAKCRA6cBh0uS2t
rP2rAQD/FsTqVz6hZTSfyqLSJDp4ErjJEfM9lZ6LaFSDcuJE4wD/bG8mlx8gkOWj
//ZwRss3uEUS5bKm76TmuT2H1lEexwk=
=bXjF
-----END PGP SIGNATURE-----

--j4D4r14HvjbJzlac--
