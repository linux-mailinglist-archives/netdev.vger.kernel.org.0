Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A14468E20
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 00:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241292AbhLEXnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 18:43:11 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:59557 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241256AbhLEXnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 18:43:10 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4J6jhN6WH2z4xZ4;
        Mon,  6 Dec 2021 10:39:32 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1638747573;
        bh=OYwEC5U/0QxVL+Ch7IjHIOA46R5CkpweTTN2VWUX0zw=;
        h=Date:From:To:Cc:Subject:From;
        b=fXK4yh+7HQOMgEtFPMsEhHCMQB9u3DbE8UtphQK48/vGf1ysUSWeX3LCoDxbr0ZNH
         SsFL14dG+1o2Oi+nh2tnzOHF1Ayy1wAEBFvV5h+3UF5Nnm077Ysq3QKKcIInUb3I1A
         W/mI9yhCwpk/pGJdWE1FSlVfJfQGpO5A1LmqDjjIKwJa7JB/B98VhaL63awa4e56ar
         luWMftw+K7qWpRIzLv9b/Ll1mFONqtJwaYG73lAWJ9M+h6oU6fPrBqFY1O+GyR1dEC
         aTzt5sumchNhpG4WriFw8O4oEcqQpl5KAHI4pqkA/Du32yWRCaTJPU46kA1YkOMqD6
         c8Nj6w2MNXGPA==
Date:   Mon, 6 Dec 2021 10:39:31 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the bpf-next tree with the bpf tree
Message-ID: <20211206103931.5e75b1a7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/aFyWMXJGlUFEiu5wPX29Ork";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/aFyWMXJGlUFEiu5wPX29Ork
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  kernel/bpf/btf.c

between commit:

  d9847eb8be3d ("bpf: Make CONFIG_DEBUG_INFO_BTF depend upon CONFIG_BPF_SYS=
CALL")

from the bpf tree and commit:

  29db4bea1d10 ("bpf: Prepare relo_core.c for kernel duty.")

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

diff --cc kernel/bpf/btf.c
index 48cdf5b425a7,36a5cc0f53c6..000000000000
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@@ -6405,4 -6418,382 +6409,384 @@@ bool bpf_check_mod_kfunc_call(struct kf
  DEFINE_KFUNC_BTF_ID_LIST(bpf_tcp_ca_kfunc_list);
  DEFINE_KFUNC_BTF_ID_LIST(prog_test_kfunc_list);
 =20
 +#endif
++
+ int bpf_core_types_are_compat(const struct btf *local_btf, __u32 local_id,
+ 			      const struct btf *targ_btf, __u32 targ_id)
+ {
+ 	return -EOPNOTSUPP;
+ }
+=20
+ static bool bpf_core_is_flavor_sep(const char *s)
+ {
+ 	/* check X___Y name pattern, where X and Y are not underscores */
+ 	return s[0] !=3D '_' &&				      /* X */
+ 	       s[1] =3D=3D '_' && s[2] =3D=3D '_' && s[3] =3D=3D '_' &&   /* ___=
 */
+ 	       s[4] !=3D '_';				      /* Y */
+ }
+=20
+ size_t bpf_core_essential_name_len(const char *name)
+ {
+ 	size_t n =3D strlen(name);
+ 	int i;
+=20
+ 	for (i =3D n - 5; i >=3D 0; i--) {
+ 		if (bpf_core_is_flavor_sep(name + i))
+ 			return i + 1;
+ 	}
+ 	return n;
+ }
+=20
+ struct bpf_cand_cache {
+ 	const char *name;
+ 	u32 name_len;
+ 	u16 kind;
+ 	u16 cnt;
+ 	struct {
+ 		const struct btf *btf;
+ 		u32 id;
+ 	} cands[];
+ };
+=20
+ static void bpf_free_cands(struct bpf_cand_cache *cands)
+ {
+ 	if (!cands->cnt)
+ 		/* empty candidate array was allocated on stack */
+ 		return;
+ 	kfree(cands);
+ }
+=20
+ static void bpf_free_cands_from_cache(struct bpf_cand_cache *cands)
+ {
+ 	kfree(cands->name);
+ 	kfree(cands);
+ }
+=20
+ #define VMLINUX_CAND_CACHE_SIZE 31
+ static struct bpf_cand_cache *vmlinux_cand_cache[VMLINUX_CAND_CACHE_SIZE];
+=20
+ #define MODULE_CAND_CACHE_SIZE 31
+ static struct bpf_cand_cache *module_cand_cache[MODULE_CAND_CACHE_SIZE];
+=20
+ static DEFINE_MUTEX(cand_cache_mutex);
+=20
+ static void __print_cand_cache(struct bpf_verifier_log *log,
+ 			       struct bpf_cand_cache **cache,
+ 			       int cache_size)
+ {
+ 	struct bpf_cand_cache *cc;
+ 	int i, j;
+=20
+ 	for (i =3D 0; i < cache_size; i++) {
+ 		cc =3D cache[i];
+ 		if (!cc)
+ 			continue;
+ 		bpf_log(log, "[%d]%s(", i, cc->name);
+ 		for (j =3D 0; j < cc->cnt; j++) {
+ 			bpf_log(log, "%d", cc->cands[j].id);
+ 			if (j < cc->cnt - 1)
+ 				bpf_log(log, " ");
+ 		}
+ 		bpf_log(log, "), ");
+ 	}
+ }
+=20
+ static void print_cand_cache(struct bpf_verifier_log *log)
+ {
+ 	mutex_lock(&cand_cache_mutex);
+ 	bpf_log(log, "vmlinux_cand_cache:");
+ 	__print_cand_cache(log, vmlinux_cand_cache, VMLINUX_CAND_CACHE_SIZE);
+ 	bpf_log(log, "\nmodule_cand_cache:");
+ 	__print_cand_cache(log, module_cand_cache, MODULE_CAND_CACHE_SIZE);
+ 	bpf_log(log, "\n");
+ 	mutex_unlock(&cand_cache_mutex);
+ }
+=20
+ static u32 hash_cands(struct bpf_cand_cache *cands)
+ {
+ 	return jhash(cands->name, cands->name_len, 0);
+ }
+=20
+ static struct bpf_cand_cache *check_cand_cache(struct bpf_cand_cache *can=
ds,
+ 					       struct bpf_cand_cache **cache,
+ 					       int cache_size)
+ {
+ 	struct bpf_cand_cache *cc =3D cache[hash_cands(cands) % cache_size];
+=20
+ 	if (cc && cc->name_len =3D=3D cands->name_len &&
+ 	    !strncmp(cc->name, cands->name, cands->name_len))
+ 		return cc;
+ 	return NULL;
+ }
+=20
+ static size_t sizeof_cands(int cnt)
+ {
+ 	return offsetof(struct bpf_cand_cache, cands[cnt]);
+ }
+=20
+ static struct bpf_cand_cache *populate_cand_cache(struct bpf_cand_cache *=
cands,
+ 						  struct bpf_cand_cache **cache,
+ 						  int cache_size)
+ {
+ 	struct bpf_cand_cache **cc =3D &cache[hash_cands(cands) % cache_size], *=
new_cands;
+=20
+ 	if (*cc) {
+ 		bpf_free_cands_from_cache(*cc);
+ 		*cc =3D NULL;
+ 	}
+ 	new_cands =3D kmalloc(sizeof_cands(cands->cnt), GFP_KERNEL);
+ 	if (!new_cands) {
+ 		bpf_free_cands(cands);
+ 		return ERR_PTR(-ENOMEM);
+ 	}
+ 	memcpy(new_cands, cands, sizeof_cands(cands->cnt));
+ 	/* strdup the name, since it will stay in cache.
+ 	 * the cands->name points to strings in prog's BTF and the prog can be u=
nloaded.
+ 	 */
+ 	new_cands->name =3D kmemdup_nul(cands->name, cands->name_len, GFP_KERNEL=
);
+ 	bpf_free_cands(cands);
+ 	if (!new_cands->name) {
+ 		kfree(new_cands);
+ 		return ERR_PTR(-ENOMEM);
+ 	}
+ 	*cc =3D new_cands;
+ 	return new_cands;
+ }
+=20
+ static void __purge_cand_cache(struct btf *btf, struct bpf_cand_cache **c=
ache,
+ 			       int cache_size)
+ {
+ 	struct bpf_cand_cache *cc;
+ 	int i, j;
+=20
+ 	for (i =3D 0; i < cache_size; i++) {
+ 		cc =3D cache[i];
+ 		if (!cc)
+ 			continue;
+ 		if (!btf) {
+ 			/* when new module is loaded purge all of module_cand_cache,
+ 			 * since new module might have candidates with the name
+ 			 * that matches cached cands.
+ 			 */
+ 			bpf_free_cands_from_cache(cc);
+ 			cache[i] =3D NULL;
+ 			continue;
+ 		}
+ 		/* when module is unloaded purge cache entries
+ 		 * that match module's btf
+ 		 */
+ 		for (j =3D 0; j < cc->cnt; j++)
+ 			if (cc->cands[j].btf =3D=3D btf) {
+ 				bpf_free_cands_from_cache(cc);
+ 				cache[i] =3D NULL;
+ 				break;
+ 			}
+ 	}
+=20
+ }
+=20
+ static void purge_cand_cache(struct btf *btf)
+ {
+ 	mutex_lock(&cand_cache_mutex);
+ 	__purge_cand_cache(btf, module_cand_cache, MODULE_CAND_CACHE_SIZE);
+ 	mutex_unlock(&cand_cache_mutex);
+ }
+=20
+ static struct bpf_cand_cache *
+ bpf_core_add_cands(struct bpf_cand_cache *cands, const struct btf *targ_b=
tf,
+ 		   int targ_start_id)
+ {
+ 	struct bpf_cand_cache *new_cands;
+ 	const struct btf_type *t;
+ 	const char *targ_name;
+ 	size_t targ_essent_len;
+ 	int n, i;
+=20
+ 	n =3D btf_nr_types(targ_btf);
+ 	for (i =3D targ_start_id; i < n; i++) {
+ 		t =3D btf_type_by_id(targ_btf, i);
+ 		if (btf_kind(t) !=3D cands->kind)
+ 			continue;
+=20
+ 		targ_name =3D btf_name_by_offset(targ_btf, t->name_off);
+ 		if (!targ_name)
+ 			continue;
+=20
+ 		/* the resched point is before strncmp to make sure that search
+ 		 * for non-existing name will have a chance to schedule().
+ 		 */
+ 		cond_resched();
+=20
+ 		if (strncmp(cands->name, targ_name, cands->name_len) !=3D 0)
+ 			continue;
+=20
+ 		targ_essent_len =3D bpf_core_essential_name_len(targ_name);
+ 		if (targ_essent_len !=3D cands->name_len)
+ 			continue;
+=20
+ 		/* most of the time there is only one candidate for a given kind+name p=
air */
+ 		new_cands =3D kmalloc(sizeof_cands(cands->cnt + 1), GFP_KERNEL);
+ 		if (!new_cands) {
+ 			bpf_free_cands(cands);
+ 			return ERR_PTR(-ENOMEM);
+ 		}
+=20
+ 		memcpy(new_cands, cands, sizeof_cands(cands->cnt));
+ 		bpf_free_cands(cands);
+ 		cands =3D new_cands;
+ 		cands->cands[cands->cnt].btf =3D targ_btf;
+ 		cands->cands[cands->cnt].id =3D i;
+ 		cands->cnt++;
+ 	}
+ 	return cands;
+ }
+=20
+ static struct bpf_cand_cache *
+ bpf_core_find_cands(struct bpf_core_ctx *ctx, u32 local_type_id)
+ {
+ 	struct bpf_cand_cache *cands, *cc, local_cand =3D {};
+ 	const struct btf *local_btf =3D ctx->btf;
+ 	const struct btf_type *local_type;
+ 	const struct btf *main_btf;
+ 	size_t local_essent_len;
+ 	struct btf *mod_btf;
+ 	const char *name;
+ 	int id;
+=20
+ 	main_btf =3D bpf_get_btf_vmlinux();
+ 	if (IS_ERR(main_btf))
+ 		return (void *)main_btf;
+=20
+ 	local_type =3D btf_type_by_id(local_btf, local_type_id);
+ 	if (!local_type)
+ 		return ERR_PTR(-EINVAL);
+=20
+ 	name =3D btf_name_by_offset(local_btf, local_type->name_off);
+ 	if (str_is_empty(name))
+ 		return ERR_PTR(-EINVAL);
+ 	local_essent_len =3D bpf_core_essential_name_len(name);
+=20
+ 	cands =3D &local_cand;
+ 	cands->name =3D name;
+ 	cands->kind =3D btf_kind(local_type);
+ 	cands->name_len =3D local_essent_len;
+=20
+ 	cc =3D check_cand_cache(cands, vmlinux_cand_cache, VMLINUX_CAND_CACHE_SI=
ZE);
+ 	/* cands is a pointer to stack here */
+ 	if (cc) {
+ 		if (cc->cnt)
+ 			return cc;
+ 		goto check_modules;
+ 	}
+=20
+ 	/* Attempt to find target candidates in vmlinux BTF first */
+ 	cands =3D bpf_core_add_cands(cands, main_btf, 1);
+ 	if (IS_ERR(cands))
+ 		return cands;
+=20
+ 	/* cands is a pointer to kmalloced memory here if cands->cnt > 0 */
+=20
+ 	/* populate cache even when cands->cnt =3D=3D 0 */
+ 	cc =3D populate_cand_cache(cands, vmlinux_cand_cache, VMLINUX_CAND_CACHE=
_SIZE);
+ 	if (IS_ERR(cc))
+ 		return cc;
+=20
+ 	/* if vmlinux BTF has any candidate, don't go for module BTFs */
+ 	if (cc->cnt)
+ 		return cc;
+=20
+ check_modules:
+ 	/* cands is a pointer to stack here and cands->cnt =3D=3D 0 */
+ 	cc =3D check_cand_cache(cands, module_cand_cache, MODULE_CAND_CACHE_SIZE=
);
+ 	if (cc)
+ 		/* if cache has it return it even if cc->cnt =3D=3D 0 */
+ 		return cc;
+=20
+ 	/* If candidate is not found in vmlinux's BTF then search in module's BT=
Fs */
+ 	spin_lock_bh(&btf_idr_lock);
+ 	idr_for_each_entry(&btf_idr, mod_btf, id) {
+ 		if (!btf_is_module(mod_btf))
+ 			continue;
+ 		/* linear search could be slow hence unlock/lock
+ 		 * the IDR to avoiding holding it for too long
+ 		 */
+ 		btf_get(mod_btf);
+ 		spin_unlock_bh(&btf_idr_lock);
+ 		cands =3D bpf_core_add_cands(cands, mod_btf, btf_nr_types(main_btf));
+ 		if (IS_ERR(cands)) {
+ 			btf_put(mod_btf);
+ 			return cands;
+ 		}
+ 		spin_lock_bh(&btf_idr_lock);
+ 		btf_put(mod_btf);
+ 	}
+ 	spin_unlock_bh(&btf_idr_lock);
+ 	/* cands is a pointer to kmalloced memory here if cands->cnt > 0
+ 	 * or pointer to stack if cands->cnd =3D=3D 0.
+ 	 * Copy it into the cache even when cands->cnt =3D=3D 0 and
+ 	 * return the result.
+ 	 */
+ 	return populate_cand_cache(cands, module_cand_cache, MODULE_CAND_CACHE_S=
IZE);
+ }
+=20
+ int bpf_core_apply(struct bpf_core_ctx *ctx, const struct bpf_core_relo *=
relo,
+ 		   int relo_idx, void *insn)
+ {
+ 	bool need_cands =3D relo->kind !=3D BPF_CORE_TYPE_ID_LOCAL;
+ 	struct bpf_core_cand_list cands =3D {};
+ 	struct bpf_core_spec *specs;
+ 	int err;
+=20
+ 	/* ~4k of temp memory necessary to convert LLVM spec like "0:1:0:5"
+ 	 * into arrays of btf_ids of struct fields and array indices.
+ 	 */
+ 	specs =3D kcalloc(3, sizeof(*specs), GFP_KERNEL);
+ 	if (!specs)
+ 		return -ENOMEM;
+=20
+ 	if (need_cands) {
+ 		struct bpf_cand_cache *cc;
+ 		int i;
+=20
+ 		mutex_lock(&cand_cache_mutex);
+ 		cc =3D bpf_core_find_cands(ctx, relo->type_id);
+ 		if (IS_ERR(cc)) {
+ 			bpf_log(ctx->log, "target candidate search failed for %d\n",
+ 				relo->type_id);
+ 			err =3D PTR_ERR(cc);
+ 			goto out;
+ 		}
+ 		if (cc->cnt) {
+ 			cands.cands =3D kcalloc(cc->cnt, sizeof(*cands.cands), GFP_KERNEL);
+ 			if (!cands.cands) {
+ 				err =3D -ENOMEM;
+ 				goto out;
+ 			}
+ 		}
+ 		for (i =3D 0; i < cc->cnt; i++) {
+ 			bpf_log(ctx->log,
+ 				"CO-RE relocating %s %s: found target candidate [%d]\n",
+ 				btf_kind_str[cc->kind], cc->name, cc->cands[i].id);
+ 			cands.cands[i].btf =3D cc->cands[i].btf;
+ 			cands.cands[i].id =3D cc->cands[i].id;
+ 		}
+ 		cands.len =3D cc->cnt;
+ 		/* cand_cache_mutex needs to span the cache lookup and
+ 		 * copy of btf pointer into bpf_core_cand_list,
+ 		 * since module can be unloaded while bpf_core_apply_relo_insn
+ 		 * is working with module's btf.
+ 		 */
+ 	}
+=20
+ 	err =3D bpf_core_apply_relo_insn((void *)ctx->log, insn, relo->insn_off =
/ 8,
+ 				       relo, relo_idx, ctx->btf, &cands, specs);
+ out:
+ 	kfree(specs);
+ 	if (need_cands) {
+ 		kfree(cands.cands);
+ 		mutex_unlock(&cand_cache_mutex);
+ 		if (ctx->log->level & BPF_LOG_LEVEL2)
+ 			print_cand_cache(ctx->log);
+ 	}
+ 	return err;
+ }

--Sig_/aFyWMXJGlUFEiu5wPX29Ork
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmGtTbMACgkQAVBC80lX
0GzVQQf/dCOs/dkwf2s6QCfzapQ5eV1XPZDcmpNaXQ7b/lW2+1nbMZi/ssh/oIOt
L7LkKJBNNfPlUnOjck4hWjuhLggcr0jUgO+AdGBVitYrYFBcQ32PGTUswifRLHtX
V1a46v53EWCond3aX+JruppmrZ8k3R/rDf41ltjTT9A9sK0flwpNlldBL2mPqs54
OVvrqlnzqsQEUzaHg+W9cnii6hEw1qaKeYSW/coIEtn5CivbTOxpGEyXAxzZy/5/
VTNBgO5y4Mxf0fWMpKku/S0pf/29K3CtQ5gFZu489u77MiyxhKNIrq6bwJAMBQub
/hfiprM1GQpGMbRzAujpTklXM4vnfA==
=r5/f
-----END PGP SIGNATURE-----

--Sig_/aFyWMXJGlUFEiu5wPX29Ork--
