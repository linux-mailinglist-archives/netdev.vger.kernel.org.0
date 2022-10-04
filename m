Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7B115F3AFD
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 03:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiJDBYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 21:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiJDBYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 21:24:33 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035D42125D;
        Mon,  3 Oct 2022 18:24:31 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MhKk53JCDz4xGn;
        Tue,  4 Oct 2022 12:24:29 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1664846670;
        bh=ZCstmyH2hO9l5kvpoL5Fy+0+Pcsrd9iY4Ml/itl3ps4=;
        h=Date:From:To:Cc:Subject:From;
        b=gvuHKVajFNfiZ2yeTiK5qqffUwbz5itqqWmtxq7NyYA3PndWyDGyUlN7KWcQR6p9U
         hokaNG6/RKIvcfwsPcmt+0giNwSp2TaH+UXtZjR/TZ5pUrg5Jkffhkd7NfQMJH6LpD
         Gm26Kle2qjtk3fuTSLZknexrvQx4u+ZsHbwybfta8JS12woTVsJnMrqZLmndGv0H3V
         rX3if+t8wGlBXpROXiWa2U9I531D/RSIzDqsUdZaWbVRBCxW05NwReUItNQBKqhGy8
         Z79JcbU0YTuayzwqSvIi+/wNw8FB7ALqY5LVyzknXuGV8JRbL3Xvw4ioXxkSkHUlsd
         3olcCSyMGstrw==
Date:   Tue, 4 Oct 2022 12:24:28 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        David Vernet <void@manifault.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>
Subject: linux-next: manual merge of the net-next tree with the bpf tree
Message-ID: <20221004122428.653bd5cd@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/IUl9e/+DjimaHHOGYoTvQ.P";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/IUl9e/+DjimaHHOGYoTvQ.P
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  kernel/bpf/helpers.c

between commit:

  8addbfc7b308 ("bpf: Gate dynptr API behind CAP_BPF")

from the bpf tree and commits:

  8a67f2de9b1d ("bpf: expose bpf_strtol and bpf_strtoul to all program type=
s")
  5679ff2f138f ("bpf: Move bpf_loop and bpf_for_each_map_elem under CAP_BPF=
")
  205715673844 ("bpf: Add bpf_user_ringbuf_drain() helper")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc kernel/bpf/helpers.c
index 3814b0fd3a2c,b069517a3da0..000000000000
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@@ -1627,12 -1609,26 +1609,12 @@@ bpf_base_func_proto(enum bpf_func_id fu
  		return &bpf_ringbuf_discard_proto;
  	case BPF_FUNC_ringbuf_query:
  		return &bpf_ringbuf_query_proto;
- 	case BPF_FUNC_for_each_map_elem:
- 		return &bpf_for_each_map_elem_proto;
- 	case BPF_FUNC_loop:
- 		return &bpf_loop_proto;
 -	case BPF_FUNC_ringbuf_reserve_dynptr:
 -		return &bpf_ringbuf_reserve_dynptr_proto;
 -	case BPF_FUNC_ringbuf_submit_dynptr:
 -		return &bpf_ringbuf_submit_dynptr_proto;
 -	case BPF_FUNC_ringbuf_discard_dynptr:
 -		return &bpf_ringbuf_discard_dynptr_proto;
  	case BPF_FUNC_strncmp:
  		return &bpf_strncmp_proto;
+ 	case BPF_FUNC_strtol:
+ 		return &bpf_strtol_proto;
+ 	case BPF_FUNC_strtoul:
+ 		return &bpf_strtoul_proto;
 -	case BPF_FUNC_dynptr_from_mem:
 -		return &bpf_dynptr_from_mem_proto;
 -	case BPF_FUNC_dynptr_read:
 -		return &bpf_dynptr_read_proto;
 -	case BPF_FUNC_dynptr_write:
 -		return &bpf_dynptr_write_proto;
 -	case BPF_FUNC_dynptr_data:
 -		return &bpf_dynptr_data_proto;
  	default:
  		break;
  	}
@@@ -1661,20 -1657,12 +1643,26 @@@
  		return &bpf_timer_cancel_proto;
  	case BPF_FUNC_kptr_xchg:
  		return &bpf_kptr_xchg_proto;
 +	case BPF_FUNC_ringbuf_reserve_dynptr:
 +		return &bpf_ringbuf_reserve_dynptr_proto;
 +	case BPF_FUNC_ringbuf_submit_dynptr:
 +		return &bpf_ringbuf_submit_dynptr_proto;
 +	case BPF_FUNC_ringbuf_discard_dynptr:
 +		return &bpf_ringbuf_discard_dynptr_proto;
 +	case BPF_FUNC_dynptr_from_mem:
 +		return &bpf_dynptr_from_mem_proto;
 +	case BPF_FUNC_dynptr_read:
 +		return &bpf_dynptr_read_proto;
 +	case BPF_FUNC_dynptr_write:
 +		return &bpf_dynptr_write_proto;
 +	case BPF_FUNC_dynptr_data:
 +		return &bpf_dynptr_data_proto;
+ 	case BPF_FUNC_for_each_map_elem:
+ 		return &bpf_for_each_map_elem_proto;
+ 	case BPF_FUNC_loop:
+ 		return &bpf_loop_proto;
+ 	case BPF_FUNC_user_ringbuf_drain:
+ 		return &bpf_user_ringbuf_drain_proto;
  	default:
  		break;
  	}

--Sig_/IUl9e/+DjimaHHOGYoTvQ.P
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmM7i0wACgkQAVBC80lX
0Gw8lwf+J/jqy44wKr8M/nNjGWRexIFe7aRCXhS6KaY1kLEGZmpiawLUPG3R1Ocy
AjHFYKEwUPZu5cfhZpmnSHc2qM3aTBUMMMbMkjcT1eEMfrruG9qRprLnp7k96XGo
SJfFb3Jq9KF1AvdCxKB0yOaIRx8x/v5uVwam8xojEBoTBXifMrUQuTXrKkg+xr/w
RACHJcr7iTP7cf7n2Kuzq3qgl+FAbD8Bnbg/s41M7ehDeNfWcEq9GEwIX5GGvtmm
ne6o4RgWokG49sWhnCOYVIhgiemNkXcU1R5t5nbYOhp5hghCx4JXzZpBegt1B8Kf
1uiYjw5V6DXKxFhTnSXT+W+Qq7bULA==
=fZ29
-----END PGP SIGNATURE-----

--Sig_/IUl9e/+DjimaHHOGYoTvQ.P--
