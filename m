Return-Path: <netdev+bounces-6752-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C5A59717CCA
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 12:06:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 618E31C20DB5
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 10:06:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E743B13AC6;
	Wed, 31 May 2023 10:06:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD4E12B99
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 10:06:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F36EC433EF;
	Wed, 31 May 2023 10:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685527575;
	bh=CAfGkoCX7jrzOItNlPZnfGyufMo84Rg7e0vHaI13f/A=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=KhgoJxyih2pvUkn5EDeCJabDLgTI9qwBerUzpsc4EWFHjvRrVUQksByMzWn0cVimH
	 ZuHKgD1UhMpG/Fk+mDPa5MeNmUPri96kGJDZFxm0poacVcWm6LAyChH7i0c7zQ6tRY
	 gcM6UiphUXy8IV/j/u0pTAngJf4RvgeG5yNOXHvsmXshlOSzsyl0Bb+VF1yD2aAKLi
	 08cfkMucNYsgO4pBza8WtkarrFbSFyuf8v+/Ev0rCDvuK5UdiFPYwUUCyfCK4ZyLN2
	 J+6O0aQAduDPwnsr79YAn64sU8xpRn8+F9dqdjhlawFkq8Sh5Z1WJDGxjO5fSsOmAK
	 aasB4l9pPtMKA==
Message-ID: <655a378d4b71942e19473caa00ba7d44e12641a5.camel@kernel.org>
Subject: Re: [PATCH] nfsd: fix double fget() bug in __write_ports_addfd()
From: Jeff Layton <jlayton@kernel.org>
To: Dan Carpenter <dan.carpenter@linaro.org>, NeilBrown <neilb@suse.de>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>, Chuck Lever
 <chuck.lever@oracle.com>, Trond Myklebust
 <trond.myklebust@hammerspace.com>,  Anna Schumaker <anna@kernel.org>, "J.
 Bruce Fields" <bfields@redhat.com>,  linux-nfs@vger.kernel.org,
 netdev@vger.kernel.org,  kernel-janitors@vger.kernel.org
Date: Wed, 31 May 2023 06:06:12 -0400
In-Reply-To: <58fd7e35-ba6c-432e-8e02-9c5476c854b4@kili.mountain>
References: <9c90e813-c7fb-4c90-b52b-131481640a78@kili.mountain>
	 <168548566376.23533.14778348024215909777@noble.neil.brown.name>
	 <58fd7e35-ba6c-432e-8e02-9c5476c854b4@kili.mountain>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.2 (3.48.2-1.fc38) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2023-05-31 at 10:48 +0300, Dan Carpenter wrote:
> On Wed, May 31, 2023 at 08:27:43AM +1000, NeilBrown wrote:
> > On Mon, 29 May 2023, Dan Carpenter wrote:
> > > The bug here is that you cannot rely on getting the same socket
> > > from multiple calls to fget() because userspace can influence
> > > that.  This is a kind of double fetch bug.
> > >=20
> > > The fix is to delete the svc_alien_sock() function and insted do
> > > the checking inside the svc_addsock() function.
> >=20
> > Hi,
> >  I definitely agree with the change to pass the 'net' into
> >  svc_addsock(), and check the the fd has the correct net.
> >=20
> >  I'm not sure I agree with the removal of the svc_alien_sock() test.  I=
t
> >  is best to perform sanity tests before allocation things, and
> >  nfsd_create_serv() can create a new 'serv' - though most often it just
> >  incs the refcount.
>=20
> That's true.  But the other philosophical rule is that we shouldn't
> optimize for the failure path.  If someone gives us bad data they
> deserve a slow down.

> I also think leaving svc_alien_sock() is a trap for the unwary because
> it will lead to more double fget() bugs.  The svc_alien_sock() function
> is weird because it returns false on success and false on failure and
> true for alien sock.
>=20
> >=20
> >  Maybe instead svc_alien_sock() could return the struct socket (if
> >  successful), and it could be passed to svc_addsock()???
> >=20
> >  I would probably then change the name of svc_alien_sock()
>=20
> Yeah, because we don't want alien sockets, we want Earth sockets.
> Doing this is much more complicated...  The name svc_get_earth_sock()
> is just a joke.  Tell me what name to use if we decide to go this
> route.
>=20
> To be honest, I would probably still go with my v1 patch.
>=20

+1.  I don't see a need to do this check twice. Let's optimize for the
success case and if someone sends down bogus data, then they just go
slower.

I too suggest we just go with Dan's original patch.



> regards,
> dan carpenter
>=20
> diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
> index e0e98b40a6e5d..affcd44f03d6b 100644
> --- a/fs/nfsd/nfsctl.c
> +++ b/fs/nfsd/nfsctl.c
> @@ -689,6 +689,7 @@ static ssize_t __write_ports_names(char *buf, struct =
net *net)
>   */
>  static ssize_t __write_ports_addfd(char *buf, struct net *net, const str=
uct cred *cred)
>  {
> +	struct socket *so;
>  	char *mesg =3D buf;
>  	int fd, err;
>  	struct nfsd_net *nn =3D net_generic(net, nfsd_net_id);
> @@ -698,22 +699,30 @@ static ssize_t __write_ports_addfd(char *buf, struc=
t net *net, const struct cred
>  		return -EINVAL;
>  	trace_nfsd_ctl_ports_addfd(net, fd);
> =20
> -	if (svc_alien_sock(net, fd)) {
> +	so =3D svc_get_earth_sock(net, fd);
> +	if (!so) {
>  		printk(KERN_ERR "%s: socket net is different to NFSd's one\n", __func_=
_);
>  		return -EINVAL;
>  	}
> =20
>  	err =3D nfsd_create_serv(net);
>  	if (err !=3D 0)
> -		return err;
> +		goto out_put_sock;
> =20
> -	err =3D svc_addsock(nn->nfsd_serv, fd, buf, SIMPLE_TRANSACTION_LIMIT, c=
red);
> +	err =3D svc_addsock(nn->nfsd_serv, so, buf, SIMPLE_TRANSACTION_LIMIT, c=
red);
> +	if (err)
> +		goto out_put_net;
> =20
> -	if (err >=3D 0 &&
> -	    !nn->nfsd_serv->sv_nrthreads && !xchg(&nn->keep_active, 1))
> +	if (!nn->nfsd_serv->sv_nrthreads && !xchg(&nn->keep_active, 1))
>  		svc_get(nn->nfsd_serv);
> =20
>  	nfsd_put(net);
> +	return 0;
> +
> +out_put_net:
> +	nfsd_put(net);
> +out_put_sock:
> +	sockfd_put(so);
>  	return err;
>  }
> =20
> diff --git a/include/linux/sunrpc/svcsock.h b/include/linux/sunrpc/svcsoc=
k.h
> index d16ae621782c0..2422d260591bb 100644
> --- a/include/linux/sunrpc/svcsock.h
> +++ b/include/linux/sunrpc/svcsock.h
> @@ -61,8 +61,8 @@ int		svc_recv(struct svc_rqst *, long);
>  void		svc_send(struct svc_rqst *rqstp);
>  void		svc_drop(struct svc_rqst *);
>  void		svc_sock_update_bufs(struct svc_serv *serv);
> -bool		svc_alien_sock(struct net *net, int fd);
> -int		svc_addsock(struct svc_serv *serv, const int fd,
> +struct socket	*svc_get_earth_sock(struct net *net, int fd);
> +int		svc_addsock(struct svc_serv *serv, struct socket *so,
>  					char *name_return, const size_t len,
>  					const struct cred *cred);
>  void		svc_init_xprt_sock(void);
> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
> index 46845cb6465d7..78f6ae9fa42d4 100644
> --- a/net/sunrpc/svcsock.c
> +++ b/net/sunrpc/svcsock.c
> @@ -1474,21 +1474,20 @@ static struct svc_sock *svc_setup_socket(struct s=
vc_serv *serv,
>  	return svsk;
>  }
> =20
> -bool svc_alien_sock(struct net *net, int fd)
> +struct socket *svc_get_earth_sock(struct net *net, int fd)
>  {
>  	int err;
>  	struct socket *sock =3D sockfd_lookup(fd, &err);
> -	bool ret =3D false;
> =20
>  	if (!sock)
> -		goto out;
> -	if (sock_net(sock->sk) !=3D net)
> -		ret =3D true;
> -	sockfd_put(sock);
> -out:
> -	return ret;
> +		return NULL;
> +	if (sock_net(sock->sk) !=3D net) {
> +		sockfd_put(sock);
> +		return NULL;
> +	}
> +	return sock;
>  }
> -EXPORT_SYMBOL_GPL(svc_alien_sock);
> +EXPORT_SYMBOL_GPL(svc_get_earth_sock);
> =20
>  /**
>   * svc_addsock - add a listener socket to an RPC service
> @@ -1502,36 +1501,27 @@ EXPORT_SYMBOL_GPL(svc_alien_sock);
>   * Name is terminated with '\n'.  On error, returns a negative errno
>   * value.
>   */
> -int svc_addsock(struct svc_serv *serv, const int fd, char *name_return,
> +int svc_addsock(struct svc_serv *serv, struct socket *so, char *name_ret=
urn,
>  		const size_t len, const struct cred *cred)
>  {
> -	int err =3D 0;
> -	struct socket *so =3D sockfd_lookup(fd, &err);
>  	struct svc_sock *svsk =3D NULL;
>  	struct sockaddr_storage addr;
>  	struct sockaddr *sin =3D (struct sockaddr *)&addr;
>  	int salen;
> =20
> -	if (!so)
> -		return err;
> -	err =3D -EAFNOSUPPORT;
>  	if ((so->sk->sk_family !=3D PF_INET) && (so->sk->sk_family !=3D PF_INET=
6))
> -		goto out;
> -	err =3D  -EPROTONOSUPPORT;
> +		return -EAFNOSUPPORT;
>  	if (so->sk->sk_protocol !=3D IPPROTO_TCP &&
>  	    so->sk->sk_protocol !=3D IPPROTO_UDP)
> -		goto out;
> -	err =3D -EISCONN;
> +		return -EPROTONOSUPPORT;
>  	if (so->state > SS_UNCONNECTED)
> -		goto out;
> -	err =3D -ENOENT;
> +		return -EISCONN;
>  	if (!try_module_get(THIS_MODULE))
> -		goto out;
> +		return -ENOENT;
>  	svsk =3D svc_setup_socket(serv, so, SVC_SOCK_DEFAULTS);
>  	if (IS_ERR(svsk)) {
>  		module_put(THIS_MODULE);
> -		err =3D PTR_ERR(svsk);
> -		goto out;
> +		return PTR_ERR(svsk);
>  	}
>  	salen =3D kernel_getsockname(svsk->sk_sock, sin);
>  	if (salen >=3D 0)
> @@ -1539,9 +1529,6 @@ int svc_addsock(struct svc_serv *serv, const int fd=
, char *name_return,
>  	svsk->sk_xprt.xpt_cred =3D get_cred(cred);
>  	svc_add_new_perm_xprt(serv, &svsk->sk_xprt);
>  	return svc_one_sock_name(svsk, name_return, len);
> -out:
> -	sockfd_put(so);
> -	return err;
>  }
>  EXPORT_SYMBOL_GPL(svc_addsock);
> =20
>=20
>=20
>=20

--=20
Jeff Layton <jlayton@kernel.org>

