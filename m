Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C77BC5E70CB
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 02:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbiIWApx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 20:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiIWApw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 20:45:52 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D322EE21F7;
        Thu, 22 Sep 2022 17:45:48 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MYYNQ0zZTz4xFt;
        Fri, 23 Sep 2022 10:45:41 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1663893943;
        bh=rGf9RK9axNS29lF+1Tk0fM4E8gstBlgMV5uuDa8Dis8=;
        h=Date:From:To:Cc:Subject:From;
        b=cdJa2l/NjA63O5kbi8vAAUzH8KEycYSEykyhYn0ooK9GUzCEPq3lE24wVGgas+p36
         j75ZfTNl4qt35sRWAzwOxbFu/EUvfG2hfkKtTJkUTnP7A2Kxr9fwS4dF7CJ2S6cIVN
         bfXw34dbTMI5VuNkxxq/+3OBvVz5xmBj3TRIBm5wiXjay4FVMnoleDQ/lj1Rp5HMqu
         v7Sfv9ikb7F5viY9RopTGBzC+Kkve320utUZfYCObWCZBiI42vBYZf2M1FfLlsGkXI
         7c7FL9iheayAMLjU7SmsM5mP8qT+514+QUhurprcbEq0k1Kybn0HTaxFRZW/3dMotA
         KvWjeCEK5W8Lg==
Date:   Fri, 23 Sep 2022 10:45:38 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>
Subject: linux-next: manual merge of the net-next tree with the bpf tree
Message-ID: <20220923104538.4e159c3a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/x.xndCVlhRvd.Rgtr_1BZpg";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/x.xndCVlhRvd.Rgtr_1BZpg
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
index 3814b0fd3a2c,fc08035f14ed..000000000000
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@@ -1627,12 -1607,26 +1607,12 @@@ bpf_base_func_proto(enum bpf_func_id fu
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
@@@ -1661,20 -1655,10 +1641,24 @@@
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
  	default:
  		break;
  	}

--Sig_/x.xndCVlhRvd.Rgtr_1BZpg
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmMtAbIACgkQAVBC80lX
0GzPpgf/fGxLlpKlv/FkhBQhOtNgln+HvExwblbi1ilrlx22YxH1jwfqQfiTC/aL
bB9ibnBQuNE5eobjf+5cTsQmN2GtwbjpgwcZ5DoZlJayxYewhVCGADVA8wXWklXg
PsciMHevMX59adtsNym61qWgyG04nAgLGRNT9Io/UkmgFXcnqR6Hvq6Hz5cb4p+J
eHr6aN1hJl+97dniJSIZyvtjoTjRAhroFK1A/sN+iMujFSWChDLTIillIz7YSR11
mUkQsEru7ggF0PDEjyaNqYT7wXzpH8zPpENYnoQ59u+4qSKBs1K/AThkv/Xw3d42
MRoHwgpXKcc1ghHmEl8ZBqJJRUZc5Q==
=bMEs
-----END PGP SIGNATURE-----

--Sig_/x.xndCVlhRvd.Rgtr_1BZpg--
