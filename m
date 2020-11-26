Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C0B2C4E39
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 06:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387746AbgKZFW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 00:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387735AbgKZFW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 00:22:57 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E2BC0613D4;
        Wed, 25 Nov 2020 21:22:57 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4ChR3b6Z6pz9sTv;
        Thu, 26 Nov 2020 16:22:51 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1606368172;
        bh=5qXyp906ZkdpWVuTRjT+MKJ/gkNv6GNhdDY5IWnW8KE=;
        h=Date:From:To:Cc:Subject:From;
        b=FJs5XeMZRGcMrCJfkoepCRB0q9akJ+po2U9iBugFAN0hFlILjEWD3A7a4KiobsJRp
         n7POCsCNXpYrLXotu2bmaniChimTnHSi4e4u7qcJ6q7YQJzH719wxyspO5FECsVBDk
         mVBeg+0CBFOlmItoUrtJJbqW2gspya9cPQ+buyxLOW6eOh7rJoWxxgxkifn/LeFqdN
         l0J/ZNwQc3wT78MVF401uEPoGIo1qyS+PAGxBRW5fLk+D4ey7uxU1rwQOAqbpJG1QT
         UYaK4RuD/ZwCO7GaQBpSzG2q+GvG1UvwMPmsQPce45pVgmnS6vrOFSmkmsnVMKaleY
         oQ58XV3iHws8A==
Date:   Thu, 26 Nov 2020 16:22:48 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>
Subject: linux-next: manual merge of the userns tree with the bpf-next tree
Message-ID: <20201126162248.7e7963fe@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/D_a4snb_.UIVWOd2syNDGQv";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/D_a4snb_.UIVWOd2syNDGQv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the userns tree got a conflict in:

  kernel/bpf/task_iter.c

between commit:

  91b2db27d3ff ("bpf: Simplify task_file_seq_get_next()")

from the bpf-next tree and commit:

  edc52f17257a ("bpf/task_iter: In task_file_seq_get_next use task_lookup_n=
ext_fd_rcu")

from the userns tree.

I fixed it up (I think, see below) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc kernel/bpf/task_iter.c
index 0458a40edf10,4ec63170c741..000000000000
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@@ -136,41 -135,29 +135,30 @@@ struct bpf_iter_seq_task_file_info=20
  };
 =20
  static struct file *
 -task_file_seq_get_next(struct bpf_iter_seq_task_file_info *info,
 -		       struct task_struct **task)
 +task_file_seq_get_next(struct bpf_iter_seq_task_file_info *info)
  {
  	struct pid_namespace *ns =3D info->common.ns;
- 	u32 curr_tid =3D info->tid, max_fds;
- 	struct files_struct *curr_files;
+ 	u32 curr_tid =3D info->tid;
  	struct task_struct *curr_task;
- 	int curr_fd =3D info->fd;
+ 	unsigned int curr_fd =3D info->fd;
 =20
  	/* If this function returns a non-NULL file object,
- 	 * it held a reference to the task/files_struct/file.
+ 	 * it held a reference to the task/file.
  	 * Otherwise, it does not hold any reference.
  	 */
  again:
 -	if (*task) {
 -		curr_task =3D *task;
 +	if (info->task) {
 +		curr_task =3D info->task;
- 		curr_files =3D info->files;
  		curr_fd =3D info->fd;
  	} else {
  		curr_task =3D task_seq_get_next(ns, &curr_tid, true);
 -		if (!curr_task)
 +		if (!curr_task) {
 +			info->task =3D NULL;
- 			info->files =3D NULL;
  			return NULL;
 +		}
 =20
- 		curr_files =3D get_files_struct(curr_task);
- 		if (!curr_files) {
- 			put_task_struct(curr_task);
- 			curr_tid =3D ++(info->tid);
- 			info->fd =3D 0;
- 			goto again;
- 		}
-=20
- 		info->files =3D curr_files;
+ 		/* set *task and info->tid */
 -		*task =3D curr_task;
 +		info->task =3D curr_task;
  		if (curr_tid =3D=3D info->tid) {
  			curr_fd =3D info->fd;
  		} else {
@@@ -198,10 -183,8 +184,8 @@@
 =20
  	/* the current task is done, go to the next task */
  	rcu_read_unlock();
- 	put_files_struct(curr_files);
  	put_task_struct(curr_task);
 -	*task =3D NULL;
 +	info->task =3D NULL;
- 	info->files =3D NULL;
  	info->fd =3D 0;
  	curr_tid =3D ++(info->tid);
  	goto again;
@@@ -210,13 -193,18 +194,12 @@@
  static void *task_file_seq_start(struct seq_file *seq, loff_t *pos)
  {
  	struct bpf_iter_seq_task_file_info *info =3D seq->private;
 -	struct task_struct *task =3D NULL;
  	struct file *file;
 =20
 -	file =3D task_file_seq_get_next(info, &task);
 -	if (!file) {
 -		info->task =3D NULL;
 -		return NULL;
 -	}
 -
 -	if (*pos =3D=3D 0)
 +	info->task =3D NULL;
- 	info->files =3D NULL;
 +	file =3D task_file_seq_get_next(info);
 +	if (file && *pos =3D=3D 0)
  		++*pos;
 -	info->task =3D task;
 =20
  	return file;
  }

--Sig_/D_a4snb_.UIVWOd2syNDGQv
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl+/O6kACgkQAVBC80lX
0Gzrggf/VpiznQ4Zk4fDSOLKmXhy26KEC9CD9lgBvHomviB358nv1viil985EKj+
gGFsFlalZgHrdFC5ovsSK1uThZOvFgPzKGFy8ybcb2F276L9lmFmmFiBjnBBfxr2
70vQ/yPqXEvO2U0LIj6iGRx/lUirnO0gxnVbPBlea+5IvaUDk9caBb9DNF1RfRaK
TGMNQ52HKuSl1Tm/LbpHMMZmGPii7dl1Xn75tfoUgPeo5uVrB7Af15oN8dbhv6ZB
dFRiZQWgKMlrZxuzcZ1WWRH7Wfl5/JukK1gtsdDqWhrpymSmHHphBsdBse4u/zfe
8+7NjkP4Unk6K1MfEPl8WKzj8Xs2YQ==
=pnHp
-----END PGP SIGNATURE-----

--Sig_/D_a4snb_.UIVWOd2syNDGQv--
