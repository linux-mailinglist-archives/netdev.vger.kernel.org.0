Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 168371085A8
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 00:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbfKXX6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 18:58:52 -0500
Received: from ozlabs.org ([203.11.71.1]:51779 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbfKXX6w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Nov 2019 18:58:52 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47LnF30Brfz9sPn;
        Mon, 25 Nov 2019 10:58:46 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1574639928;
        bh=OAVbe2yC0rx13soTDnUOVwUCtkL0XiHFd05I/rKPaWI=;
        h=Date:From:To:Cc:Subject:From;
        b=DwrhTfKNn2GaUQjImkc4EHkBrFoupiFqH3pq2omtgqjy5OIe2YHaOHUvNWKxWWX+f
         AltTISlIxuSkeRe37KRe2w11Aizmukb75oPnEAAJxl60b0M82pjC7wPQFV1To3QSJ7
         0E8T5AArTIOBw5tDdwm+bNeQm5gMxucQP2a7ui/iLsf6v7kNYOADPGIPHBUUgiDVU2
         StuAqlveycnPsTO0BayBeuqhSDS0YoAtkVVWROzxdoWKpsJ/BL68Y/RrWHy46HmtFM
         1rg5XWybaA2PJnCzPA3LS7ET6D3QugNDcQVlzvVgaPYNhqjptKWomaEHmNEBh15svD
         jPdlXdHQxCD9w==
Date:   Mon, 25 Nov 2019 10:58:43 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: linux-next: manual merge of the bpf-next tree with the net-next
 tree
Message-ID: <20191125105843.2bdea309@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/GURF76nV68Qoxv_unG2o0iq";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/GURF76nV68Qoxv_unG2o0iq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  kernel/bpf/syscall.c

between commit:

  84bb46cd6228 ("Revert "bpf: Emit audit messages upon successful prog load=
 and unload"")

from the net-next tree and commit:

  8793e6b23b1e ("bpf: Move bpf_free_used_maps into sleepable section")

from the bpf-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc kernel/bpf/syscall.c
index 4ae52eb05f41,bb002f15b32a..000000000000
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@@ -23,14 -23,16 +23,15 @@@
  #include <linux/timekeeping.h>
  #include <linux/ctype.h>
  #include <linux/nospec.h>
 -#include <linux/audit.h>
  #include <uapi/linux/btf.h>
 =20
- #define IS_FD_ARRAY(map) ((map)->map_type =3D=3D BPF_MAP_TYPE_PROG_ARRAY =
|| \
- 			   (map)->map_type =3D=3D BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
- 			   (map)->map_type =3D=3D BPF_MAP_TYPE_CGROUP_ARRAY || \
- 			   (map)->map_type =3D=3D BPF_MAP_TYPE_ARRAY_OF_MAPS)
+ #define IS_FD_ARRAY(map) ((map)->map_type =3D=3D BPF_MAP_TYPE_PERF_EVENT_=
ARRAY || \
+ 			  (map)->map_type =3D=3D BPF_MAP_TYPE_CGROUP_ARRAY || \
+ 			  (map)->map_type =3D=3D BPF_MAP_TYPE_ARRAY_OF_MAPS)
+ #define IS_FD_PROG_ARRAY(map) ((map)->map_type =3D=3D BPF_MAP_TYPE_PROG_A=
RRAY)
  #define IS_FD_HASH(map) ((map)->map_type =3D=3D BPF_MAP_TYPE_HASH_OF_MAPS)
- #define IS_FD_MAP(map) (IS_FD_ARRAY(map) || IS_FD_HASH(map))
+ #define IS_FD_MAP(map) (IS_FD_ARRAY(map) || IS_FD_PROG_ARRAY(map) || \
+ 			IS_FD_HASH(map))
 =20
  #define BPF_OBJ_FLAG_MASK   (BPF_F_RDONLY | BPF_F_WRONLY)
 =20
@@@ -1302,25 -1307,34 +1306,6 @@@ static int find_prog_type(enum bpf_prog
  	return 0;
  }
 =20
- /* drop refcnt on maps used by eBPF program and free auxilary data */
- static void free_used_maps(struct bpf_prog_aux *aux)
- {
- 	enum bpf_cgroup_storage_type stype;
- 	int i;
 -enum bpf_event {
 -	BPF_EVENT_LOAD,
 -	BPF_EVENT_UNLOAD,
 -};
--
- 	for_each_cgroup_storage_type(stype) {
- 		if (!aux->cgroup_storage[stype])
- 			continue;
- 		bpf_cgroup_storage_release(aux->prog,
- 					   aux->cgroup_storage[stype]);
- 	}
 -static const char * const bpf_event_audit_str[] =3D {
 -	[BPF_EVENT_LOAD]   =3D "LOAD",
 -	[BPF_EVENT_UNLOAD] =3D "UNLOAD",
 -};
--
- 	for (i =3D 0; i < aux->used_map_cnt; i++)
- 		bpf_map_put(aux->used_maps[i]);
 -static void bpf_audit_prog(const struct bpf_prog *prog, enum bpf_event ev=
ent)
 -{
 -	bool has_task_context =3D event =3D=3D BPF_EVENT_LOAD;
 -	struct audit_buffer *ab;
--
- 	kfree(aux->used_maps);
 -	if (audit_enabled =3D=3D AUDIT_OFF)
 -		return;
 -	ab =3D audit_log_start(audit_context(), GFP_ATOMIC, AUDIT_BPF);
 -	if (unlikely(!ab))
 -		return;
 -	if (has_task_context)
 -		audit_log_task(ab);
 -	audit_log_format(ab, "%sprog-id=3D%u event=3D%s",
 -			 has_task_context ? " " : "",
 -			 prog->aux->id, bpf_event_audit_str[event]);
 -	audit_log_end(ab);
--}
--
  int __bpf_prog_charge(struct user_struct *user, u32 pages)
  {
  	unsigned long memlock_limit =3D rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;

--Sig_/GURF76nV68Qoxv_unG2o0iq
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3bGTQACgkQAVBC80lX
0GwZaQf8DsSv4j56gVQOhUUOsFN3X3XPlHTjfRECC5dDUHcaZO/XcM+rXalsAhYB
3JUB1m6vzz6XPbj+R6dVnvttDLmaULKq0gh+I/S8XL0u6Z9xwwGITqWZ1VXqfTKB
U3Jyz2sLkFngqaYbt7Ci+iUKJ/aS9E9ASWEy3coI/qX9TlWD7JIxUCw0s+TIQLy7
BigwfBU8L8ZS3Fc0gmiawX85SwxdcjW1BdJKg7DY62E+8Spbmkao6/A+0Ful7bz1
76uQSA2Mc4W6I9tflVoWRba8cpOy6GiO18++yuKGd92vbaQLqpXwOv2VzPWu1zfu
ult1S3jtH1QvbNr2hvFgqqv3gDroRg==
=oWqT
-----END PGP SIGNATURE-----

--Sig_/GURF76nV68Qoxv_unG2o0iq--
