Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 827831C9D15
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 23:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgEGVTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 17:19:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:50014 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726218AbgEGVTD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 17:19:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4D2F5ACFE;
        Thu,  7 May 2020 21:19:03 +0000 (UTC)
From:   NeilBrown <neilb@suse.de>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date:   Fri, 08 May 2020 07:18:53 +1000
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 26/35] SUNRPC: defer slow parts of rpc_free_client() to a workqueue.
In-Reply-To: <20200507142830.26239-26-sashal@kernel.org>
References: <20200507142830.26239-1-sashal@kernel.org> <20200507142830.26239-26-sashal@kernel.org>
Message-ID: <878si3cuki.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, May 07 2020, Sasha Levin wrote:

> From: NeilBrown <neilb@suse.de>
>
> [ Upstream commit 7c4310ff56422ea43418305d22bbc5fe19150ec4 ]

This one is buggy - it introduces a use-after-free.  Best delay it for
now.

NeilBrown

>
> The rpciod workqueue is on the write-out path for freeing dirty memory,
> so it is important that it never block waiting for memory to be
> allocated - this can lead to a deadlock.
>
> rpc_execute() - which is often called by an rpciod work item - calls
> rcp_task_release_client() which can lead to rpc_free_client().
>
> rpc_free_client() makes two calls which could potentially block wating
> for memory allocation.
>
> rpc_clnt_debugfs_unregister() calls into debugfs and will block while
> any of the debugfs files are being accessed.  In particular it can block
> while any of the 'open' methods are being called and all of these use
> malloc for one thing or another.  So this can deadlock if the memory
> allocation waits for NFS to complete some writes via rpciod.
>
> rpc_clnt_remove_pipedir() can take the inode_lock() and while it isn't
> obvious that memory allocations can happen while the lock it held, it is
> safer to assume they might and to not let rpciod call
> rpc_clnt_remove_pipedir().
>
> So this patch moves these two calls (together with the final kfree() and
> rpciod_down()) into a work-item to be run from the system work-queue.
> rpciod can continue its important work, and the final stages of the free
> can happen whenever they happen.
>
> I have seen this deadlock on a 4.12 based kernel where debugfs used
> synchronize_srcu() when removing objects.  synchronize_srcu() requires a
> workqueue and there were no free workther threads and none could be
> allocated.  While debugsfs no longer uses SRCU, I believe the deadlock
> is still possible.
>
> Signed-off-by: NeilBrown <neilb@suse.de>
> Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  include/linux/sunrpc/clnt.h |  8 +++++++-
>  net/sunrpc/clnt.c           | 21 +++++++++++++++++----
>  2 files changed, 24 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/sunrpc/clnt.h b/include/linux/sunrpc/clnt.h
> index abc63bd1be2b5..d99d39d45a494 100644
> --- a/include/linux/sunrpc/clnt.h
> +++ b/include/linux/sunrpc/clnt.h
> @@ -71,7 +71,13 @@ struct rpc_clnt {
>  #if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
>  	struct dentry		*cl_debugfs;	/* debugfs directory */
>  #endif
> -	struct rpc_xprt_iter	cl_xpi;
> +	/* cl_work is only needed after cl_xpi is no longer used,
> +	 * and that are of similar size
> +	 */
> +	union {
> +		struct rpc_xprt_iter	cl_xpi;
> +		struct work_struct	cl_work;
> +	};
>  	const struct cred	*cl_cred;
>  };
>=20=20
> diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
> index f7f78566be463..a7430b66c7389 100644
> --- a/net/sunrpc/clnt.c
> +++ b/net/sunrpc/clnt.c
> @@ -877,6 +877,20 @@ EXPORT_SYMBOL_GPL(rpc_shutdown_client);
>  /*
>   * Free an RPC client
>   */
> +static void rpc_free_client_work(struct work_struct *work)
> +{
> +	struct rpc_clnt *clnt =3D container_of(work, struct rpc_clnt, cl_work);
> +
> +	/* These might block on processes that might allocate memory,
> +	 * so they cannot be called in rpciod, so they are handled separately
> +	 * here.
> +	 */
> +	rpc_clnt_debugfs_unregister(clnt);
> +	rpc_clnt_remove_pipedir(clnt);
> +
> +	kfree(clnt);
> +	rpciod_down();
> +}
>  static struct rpc_clnt *
>  rpc_free_client(struct rpc_clnt *clnt)
>  {
> @@ -887,17 +901,16 @@ rpc_free_client(struct rpc_clnt *clnt)
>  			rcu_dereference(clnt->cl_xprt)->servername);
>  	if (clnt->cl_parent !=3D clnt)
>  		parent =3D clnt->cl_parent;
> -	rpc_clnt_debugfs_unregister(clnt);
> -	rpc_clnt_remove_pipedir(clnt);
>  	rpc_unregister_client(clnt);
>  	rpc_free_iostats(clnt->cl_metrics);
>  	clnt->cl_metrics =3D NULL;
>  	xprt_put(rcu_dereference_raw(clnt->cl_xprt));
>  	xprt_iter_destroy(&clnt->cl_xpi);
> -	rpciod_down();
>  	put_cred(clnt->cl_cred);
>  	rpc_free_clid(clnt);
> -	kfree(clnt);
> +
> +	INIT_WORK(&clnt->cl_work, rpc_free_client_work);
> +	schedule_work(&clnt->cl_work);
>  	return parent;
>  }
>=20=20
> --=20
> 2.20.1

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAl60ez0ACgkQOeye3VZi
gbkTlxAAhHKw2SYW5PnmU2uD/cyIddjxyuhSkumoo6COwdVY0602KufdxCiP5mfe
vSOjHjYICTnZMcbaSYEd3PHZEzezAh3DZggn7sXc+8I3cJb1JU2EcZeVArClZv0n
b/5jvqW525cmCpg1XIUGwbOZcgMsSVE4N6FmfMD/JMNrp3pA/k4NLvyS//Qd+/8P
OG+TPIljq8lermJmhVyckBVSBojXtUuEkR9kG0+o87JJwR8JaeIKeR+CFTKuIMub
E9ql7aDYQrPQzfKiiE4jPNSl1cqO5qQUkuEIsc/ziKHdRJR1E8txD2IvKsL6zL2y
yV9ptqTmDT+o7M2qf7irjxamriaPM5xUMPibHUSOhdVILPY6strqeWSRqblf8C+D
9DLpk3KM0t9oeQwiG2ODLImkzZJ3SdXXKH2oL0HwFdl/GYqb6pY5xbSF2QbX6uda
+52AZka4B4TxIwe+SBi5W0jh6wrrJqWL02djWQWLFT2WXwVgh2gSgstUwD1+y0hg
BvAcs8Zj+RXFq1/yUz5JSQ6EbjQaMSXD7hZ6ponFXLlODy8YkesWvsHLJVDoFu+v
3okAx1WOUgSqujM/qeWzrYKYEYopi14fhlJeN7qY2vaSKCAJUGxChMC314nGLHrH
unLW37ThQF4XTp9LhwgaIj9LVNhzkWHPlN5L88ff5Ai/q5XhkIk=
=cDQC
-----END PGP SIGNATURE-----
--=-=-=--
