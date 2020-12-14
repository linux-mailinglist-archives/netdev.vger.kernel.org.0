Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE5F2DA113
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 21:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502880AbgLNUF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 15:05:59 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:42849 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502885AbgLNUFd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 15:05:33 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Cvsmw4KZ8z9sSC;
        Tue, 15 Dec 2020 07:04:48 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1607976289;
        bh=oL63cv0DHfgA/xVGOOVPl/zQ1j5ovfcaXlp1rfCYqOk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m5tnWk4oJzcI9ElSUjTDGZMbsFL57PwSL0HNbykqW08wkujRBJvQ9hcRXLJlmXWbE
         nq0BrmJzkcLNWcZFydWHX2r9p3uIJajEGWnJa+f4lSC2bIqUMGmWz21uk68wQiyTwO
         QrGDYiAEVGRcOaeujf+kispoFPeOmGHChI4o56q6JeBWkXHenMKQx17SUM17LDNjxA
         aQhPsu5M+qz20kQv1kr2ntiBeMKtg0XDRdXwmM2O9E67smfNF3woKir3qsDQgpLADE
         K7Tlc0x4x8LJLwhCn04KObaPyP1Pu3i8yVH9LICO5xFd+YOXYit/tlI8G2wcUZgQ0r
         8NlV6I0selKFA==
Date:   Tue, 15 Dec 2020 07:04:47 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>
Subject: Re: linux-next: manual merge of the userns tree with the bpf-next
 tree
Message-ID: <20201215070447.6b1f8bd9@canb.auug.org.au>
In-Reply-To: <20201126162248.7e7963fe@canb.auug.org.au>
References: <20201126162248.7e7963fe@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/gJkgLvE2aGolAWX_AKyXp3F";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/gJkgLvE2aGolAWX_AKyXp3F
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 26 Nov 2020 16:22:48 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the userns tree got a conflict in:
>=20
>   kernel/bpf/task_iter.c
>=20
> between commit:
>=20
>   91b2db27d3ff ("bpf: Simplify task_file_seq_get_next()")
>=20
> from the bpf-next tree and commit:
>=20
>   edc52f17257a ("bpf/task_iter: In task_file_seq_get_next use task_lookup=
_next_fd_rcu")
>=20
> from the userns tree.
>=20
> I fixed it up (I think, see below) and can carry the fix as
> necessary. This is now fixed as far as linux-next is concerned, but any
> non trivial conflicts should be mentioned to your upstream maintainer
> when your tree is submitted for merging.  You may also want to consider
> cooperating with the maintainer of the conflicting tree to minimise any
> particularly complex conflicts.
>=20
> --=20
> Cheers,
> Stephen Rothwell
>=20
> diff --cc kernel/bpf/task_iter.c
> index 0458a40edf10,4ec63170c741..000000000000
> --- a/kernel/bpf/task_iter.c
> +++ b/kernel/bpf/task_iter.c
> @@@ -136,41 -135,29 +135,30 @@@ struct bpf_iter_seq_task_file_info=20
>   };
>  =20
>   static struct file *
>  -task_file_seq_get_next(struct bpf_iter_seq_task_file_info *info,
>  -		       struct task_struct **task)
>  +task_file_seq_get_next(struct bpf_iter_seq_task_file_info *info)
>   {
>   	struct pid_namespace *ns =3D info->common.ns;
> - 	u32 curr_tid =3D info->tid, max_fds;
> - 	struct files_struct *curr_files;
> + 	u32 curr_tid =3D info->tid;
>   	struct task_struct *curr_task;
> - 	int curr_fd =3D info->fd;
> + 	unsigned int curr_fd =3D info->fd;
>  =20
>   	/* If this function returns a non-NULL file object,
> - 	 * it held a reference to the task/files_struct/file.
> + 	 * it held a reference to the task/file.
>   	 * Otherwise, it does not hold any reference.
>   	 */
>   again:
>  -	if (*task) {
>  -		curr_task =3D *task;
>  +	if (info->task) {
>  +		curr_task =3D info->task;
> - 		curr_files =3D info->files;
>   		curr_fd =3D info->fd;
>   	} else {
>   		curr_task =3D task_seq_get_next(ns, &curr_tid, true);
>  -		if (!curr_task)
>  +		if (!curr_task) {
>  +			info->task =3D NULL;
> - 			info->files =3D NULL;
>   			return NULL;
>  +		}
>  =20
> - 		curr_files =3D get_files_struct(curr_task);
> - 		if (!curr_files) {
> - 			put_task_struct(curr_task);
> - 			curr_tid =3D ++(info->tid);
> - 			info->fd =3D 0;
> - 			goto again;
> - 		}
> -=20
> - 		info->files =3D curr_files;
> + 		/* set *task and info->tid */
>  -		*task =3D curr_task;
>  +		info->task =3D curr_task;
>   		if (curr_tid =3D=3D info->tid) {
>   			curr_fd =3D info->fd;
>   		} else {
> @@@ -198,10 -183,8 +184,8 @@@
>  =20
>   	/* the current task is done, go to the next task */
>   	rcu_read_unlock();
> - 	put_files_struct(curr_files);
>   	put_task_struct(curr_task);
>  -	*task =3D NULL;
>  +	info->task =3D NULL;
> - 	info->files =3D NULL;
>   	info->fd =3D 0;
>   	curr_tid =3D ++(info->tid);
>   	goto again;
> @@@ -210,13 -193,18 +194,12 @@@
>   static void *task_file_seq_start(struct seq_file *seq, loff_t *pos)
>   {
>   	struct bpf_iter_seq_task_file_info *info =3D seq->private;
>  -	struct task_struct *task =3D NULL;
>   	struct file *file;
>  =20
>  -	file =3D task_file_seq_get_next(info, &task);
>  -	if (!file) {
>  -		info->task =3D NULL;
>  -		return NULL;
>  -	}
>  -
>  -	if (*pos =3D=3D 0)
>  +	info->task =3D NULL;
> - 	info->files =3D NULL;
>  +	file =3D task_file_seq_get_next(info);
>  +	if (file && *pos =3D=3D 0)
>   		++*pos;
>  -	info->task =3D task;
>  =20
>   	return file;
>   }

Just a reminder that this conflict still exists.  Commit 91b2db27d3ff
is now in the net-next tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/gJkgLvE2aGolAWX_AKyXp3F
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/XxV8ACgkQAVBC80lX
0GxgRwf/aZijf0vP/9l9ZObx8C3NOh1EJQG2Nw0WU+YVp3JaCf/JntvagICq7F4A
pGap0QaPA5ze1YNPldJCX7n5S3mJ+CGj7NTVYM6QE123r0ppcMB1p004HJPZinBK
DSIfdu7qrN6ENHChnDL6ahUM/xgwMEeflzpwBiwzajg0HeFQC8sMu4jYoyGb73VR
jO32N2nC8YYMZLuskivHiF00cqXl5SnOuVEQSsLXoAomtfW4lzifTmTHpSsu+1G8
Bvrwg6OQQM2C20R3vn5bY/ovHpBtdhBqKH6BAeT1MyoCtRue4ppcO5LVV0MwDVMt
Tx20JUe1ZvUEABwiiIKUYASaPJfEiQ==
=aohr
-----END PGP SIGNATURE-----

--Sig_/gJkgLvE2aGolAWX_AKyXp3F--
