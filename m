Return-Path: <netdev+bounces-6772-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 927F0717DAA
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 13:07:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4349228140B
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 11:07:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FB2AC8D6;
	Wed, 31 May 2023 11:07:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B5CBE64
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 11:07:23 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7770DE48;
	Wed, 31 May 2023 04:06:48 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 09C2E1F8C0;
	Wed, 31 May 2023 11:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1685531207; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Nr/NuqqGqgkwNG/KVEGuQftlK0/QlcBLem3DSmweM0=;
	b=u4i/y25BDJtdCciBJGt0FpRkA6Q9CFzrv8RvSS6lQ3u61+wuQjgwJqdvPz8b4hlim3lIIU
	cpWeqRP398cZ9ujtQgnsfvgf8BvMdJfy2BGPgT6bppf+tfOA+HCSJDOw8+MuwrFYvq5hGj
	KPU4lVr3vw5OK4zE/nz4UWH8l6PSUCk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1685531207;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Nr/NuqqGqgkwNG/KVEGuQftlK0/QlcBLem3DSmweM0=;
	b=BNmkYln0qzKkWE6LugNqCVtkJRUe7kppnH5XwdMtO1dS93hLotRQ6jjv2560XsacWccZKW
	hreSKU7RvPhjXrBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 69EA813488;
	Wed, 31 May 2023 11:06:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id MIeMB0Mqd2QCNwAAMHmgww
	(envelope-from <neilb@suse.de>); Wed, 31 May 2023 11:06:43 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "NeilBrown" <neilb@suse.de>
To: "Dan Carpenter" <dan.carpenter@linaro.org>
Cc: "Stanislav Kinsbursky" <skinsbursky@parallels.com>,
 "Chuck Lever" <chuck.lever@oracle.com>, "Jeff Layton" <jlayton@kernel.org>,
 "Trond Myklebust" <trond.myklebust@hammerspace.com>,
 "Anna Schumaker" <anna@kernel.org>, "J. Bruce Fields" <bfields@redhat.com>,
 linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
 kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] nfsd: fix double fget() bug in __write_ports_addfd()
In-reply-to: <58fd7e35-ba6c-432e-8e02-9c5476c854b4@kili.mountain>
References: <9c90e813-c7fb-4c90-b52b-131481640a78@kili.mountain>,
 <168548566376.23533.14778348024215909777@noble.neil.brown.name>,
 <58fd7e35-ba6c-432e-8e02-9c5476c854b4@kili.mountain>
Date: Wed, 31 May 2023 21:06:39 +1000
Message-id: <168553119969.627.10385222679537474034@noble.neil.brown.name>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, 31 May 2023, Dan Carpenter wrote:
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
> >  I'm not sure I agree with the removal of the svc_alien_sock() test.  It
> >  is best to perform sanity tests before allocation things, and
> >  nfsd_create_serv() can create a new 'serv' - though most often it just
> >  incs the refcount.
>=20
> That's true.  But the other philosophical rule is that we shouldn't
> optimize for the failure path.  If someone gives us bad data they
> deserve a slow down.
>=20
> I also think leaving svc_alien_sock() is a trap for the unwary because
> it will lead to more double fget() bugs.  The svc_alien_sock() function
> is weird because it returns false on success and false on failure and
> true for alien sock.

That's alien logic for you!

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

Thanks for trying it out.  Maybe it's not such a good idea after all.
I'm happy to accept your original.
  Revewied-by: NeilBrown <neilb@suse.com>

Thanks,
NeilBrown

>=20
> regards,
> dan carpenter
>=20
> diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
> index e0e98b40a6e5d..affcd44f03d6b 100644
> --- a/fs/nfsd/nfsctl.c
> +++ b/fs/nfsd/nfsctl.c
> @@ -689,6 +689,7 @@ static ssize_t __write_ports_names(char *buf, struct ne=
t *net)
>   */
>  static ssize_t __write_ports_addfd(char *buf, struct net *net, const struc=
t cred *cred)
>  {
> +	struct socket *so;
>  	char *mesg =3D buf;
>  	int fd, err;
>  	struct nfsd_net *nn =3D net_generic(net, nfsd_net_id);
> @@ -698,22 +699,30 @@ static ssize_t __write_ports_addfd(char *buf, struct =
net *net, const struct cred
>  		return -EINVAL;
>  	trace_nfsd_ctl_ports_addfd(net, fd);
> =20
> -	if (svc_alien_sock(net, fd)) {
> +	so =3D svc_get_earth_sock(net, fd);
> +	if (!so) {
>  		printk(KERN_ERR "%s: socket net is different to NFSd's one\n", __func__);
>  		return -EINVAL;
>  	}
> =20
>  	err =3D nfsd_create_serv(net);
>  	if (err !=3D 0)
> -		return err;
> +		goto out_put_sock;
> =20
> -	err =3D svc_addsock(nn->nfsd_serv, fd, buf, SIMPLE_TRANSACTION_LIMIT, cre=
d);
> +	err =3D svc_addsock(nn->nfsd_serv, so, buf, SIMPLE_TRANSACTION_LIMIT, cre=
d);
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
> diff --git a/include/linux/sunrpc/svcsock.h b/include/linux/sunrpc/svcsock.h
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
> @@ -1474,21 +1474,20 @@ static struct svc_sock *svc_setup_socket(struct svc=
_serv *serv,
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
> +int svc_addsock(struct svc_serv *serv, struct socket *so, char *name_retur=
n,
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
>  	if ((so->sk->sk_family !=3D PF_INET) && (so->sk->sk_family !=3D PF_INET6))
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
> @@ -1539,9 +1529,6 @@ int svc_addsock(struct svc_serv *serv, const int fd, =
char *name_return,
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
>=20


