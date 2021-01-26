Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCE0303835
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 09:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390316AbhAZIkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 03:40:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57720 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729296AbhAZIkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 03:40:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611650320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AkXC1zXFV2gPXqR41W/MxNBLdY5rI7YrQ0qNjPQBT+k=;
        b=UGQzIBmQHmKsX2bLE1dOHUi2tatgPd+nUdjTUyhxzfPV098s1uzTTzplRjDxCkDLbouTtZ
        pTj5lzB8nmIiE/yTUVIOZz6Cuny0G5xgZ1QrXS0D2Nvu3e5Y4n8K54GbhX8dGPn4a+VU4j
        HlFQEW5JnWic4XKeP0AiTliZxq12244=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353--A5M0qV9Mde95S4tTnSA7g-1; Tue, 26 Jan 2021 03:38:37 -0500
X-MC-Unique: -A5M0qV9Mde95S4tTnSA7g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D5FB8017FB;
        Tue, 26 Jan 2021 08:38:29 +0000 (UTC)
Received: from carbon (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AFB8374AD3;
        Tue, 26 Jan 2021 08:38:24 +0000 (UTC)
Date:   Tue, 26 Jan 2021 09:38:23 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     brouer@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        =?UTF-8?B?QmrDtnJuIFTDtnBl?= =?UTF-8?B?bA==?= 
        <bjorn.topel@intel.com>, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, kuba@kernel.org,
        jonathan.lemon@gmail.com, maximmi@nvidia.com, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, ciara.loftus@intel.com,
        weqaar.a.janjua@intel.com, andrii@kernel.org,
        Marek Majtyka <alardam@gmail.com>
Subject: Re: [PATCH bpf-next 3/3] libbpf, xsk: select AF_XDP BPF program
 based on kernel version
Message-ID: <20210126093823.633448e0@carbon>
In-Reply-To: <20210122105351.11751-4-bjorn.topel@gmail.com>
References: <20210122105351.11751-1-bjorn.topel@gmail.com>
        <20210122105351.11751-4-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jan 2021 11:53:51 +0100
Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:

> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>=20
> Add detection for kernel version, and adapt the BPF program based on
> kernel support. This way, users will get the best possible performance
> from the BPF program.

You say "detection for kernel version", but doesn't the code detect the
feature rather than kernel version ?

If so, please update the description.

> Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> Signed-off-by: Marek Majtyka  <alardam@gmail.com>
> ---
>  tools/lib/bpf/xsk.c | 82 +++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 79 insertions(+), 3 deletions(-)
>=20
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index e3e41ceeb1bc..1df8c133a5bc 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -46,6 +46,11 @@
>   #define PF_XDP AF_XDP
>  #endif
> =20
> +enum xsk_prog {
> +	XSK_PROG_FALLBACK,
> +	XSK_PROG_REDIRECT_FLAGS,
> +};
> +
>  struct xsk_umem {
>  	struct xsk_ring_prod *fill_save;
>  	struct xsk_ring_cons *comp_save;
> @@ -351,6 +356,55 @@ int xsk_umem__create_v0_0_2(struct xsk_umem **umem_p=
tr, void *umem_area,
>  COMPAT_VERSION(xsk_umem__create_v0_0_2, xsk_umem__create, LIBBPF_0.0.2)
>  DEFAULT_VERSION(xsk_umem__create_v0_0_4, xsk_umem__create, LIBBPF_0.0.4)
> =20
> +
> +static enum xsk_prog get_xsk_prog(void)
> +{
> +	enum xsk_prog detected =3D XSK_PROG_FALLBACK;
> +	struct bpf_load_program_attr prog_attr;
> +	struct bpf_create_map_attr map_attr;
> +	__u32 size_out, retval, duration;
> +	char data_in =3D 0, data_out;
> +	struct bpf_insn insns[] =3D {
> +		BPF_LD_MAP_FD(BPF_REG_1, 0),
> +		BPF_MOV64_IMM(BPF_REG_2, 0),
> +		BPF_MOV64_IMM(BPF_REG_3, XDP_PASS),
> +		BPF_EMIT_CALL(BPF_FUNC_redirect_map),
> +		BPF_EXIT_INSN(),
> +	};
> +	int prog_fd, map_fd, ret;
> +
> +	memset(&map_attr, 0, sizeof(map_attr));
> +	map_attr.map_type =3D BPF_MAP_TYPE_XSKMAP;
> +	map_attr.key_size =3D sizeof(int);
> +	map_attr.value_size =3D sizeof(int);
> +	map_attr.max_entries =3D 1;
> +
> +	map_fd =3D bpf_create_map_xattr(&map_attr);
> +	if (map_fd < 0)
> +		return detected;
> +
> +	insns[0].imm =3D map_fd;
> +
> +	memset(&prog_attr, 0, sizeof(prog_attr));
> +	prog_attr.prog_type =3D BPF_PROG_TYPE_XDP;
> +	prog_attr.insns =3D insns;
> +	prog_attr.insns_cnt =3D ARRAY_SIZE(insns);
> +	prog_attr.license =3D "GPL";
> +
> +	prog_fd =3D bpf_load_program_xattr(&prog_attr, NULL, 0);
> +	if (prog_fd < 0) {
> +		close(map_fd);
> +		return detected;
> +	}
> +
> +	ret =3D bpf_prog_test_run(prog_fd, 0, &data_in, 1, &data_out, &size_out=
, &retval, &duration);
> +	if (!ret && retval =3D=3D XDP_PASS)
> +		detected =3D XSK_PROG_REDIRECT_FLAGS;
> +	close(prog_fd);
> +	close(map_fd);
> +	return detected;
> +}
> +
>  static int xsk_load_xdp_prog(struct xsk_socket *xsk)
>  {
>  	static const int log_buf_size =3D 16 * 1024;
> @@ -358,7 +412,7 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
>  	char log_buf[log_buf_size];
>  	int err, prog_fd;
> =20
> -	/* This is the C-program:
> +	/* This is the fallback C-program:
>  	 * SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
>  	 * {
>  	 *     int ret, index =3D ctx->rx_queue_index;
> @@ -414,9 +468,31 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
>  		/* The jumps are to this instruction */
>  		BPF_EXIT_INSN(),
>  	};
> -	size_t insns_cnt =3D sizeof(prog) / sizeof(struct bpf_insn);
> =20
> -	prog_fd =3D bpf_load_program(BPF_PROG_TYPE_XDP, prog, insns_cnt,
> +	/* This is the post-5.3 kernel C-program:
> +	 * SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
> +	 * {
> +	 *     return bpf_redirect_map(&xsks_map, ctx->rx_queue_index, XDP_PASS=
);
> +	 * }
> +	 */
> +	struct bpf_insn prog_redirect_flags[] =3D {
> +		/* r2 =3D *(u32 *)(r1 + 16) */
> +		BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, 16),
> +		/* r1 =3D xskmap[] */
> +		BPF_LD_MAP_FD(BPF_REG_1, ctx->xsks_map_fd),
> +		/* r3 =3D XDP_PASS */
> +		BPF_MOV64_IMM(BPF_REG_3, 2),
> +		/* call bpf_redirect_map */
> +		BPF_EMIT_CALL(BPF_FUNC_redirect_map),
> +		BPF_EXIT_INSN(),
> +	};
> +	size_t insns_cnt[] =3D {sizeof(prog) / sizeof(struct bpf_insn),
> +			      sizeof(prog_redirect_flags) / sizeof(struct bpf_insn),
> +	};
> +	struct bpf_insn *progs[] =3D {prog, prog_redirect_flags};
> +	enum xsk_prog option =3D get_xsk_prog();
> +
> +	prog_fd =3D bpf_load_program(BPF_PROG_TYPE_XDP, progs[option], insns_cn=
t[option],
>  				   "LGPL-2.1 or BSD-2-Clause", 0, log_buf,
>  				   log_buf_size);
>  	if (prog_fd < 0) {



--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

