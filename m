Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6B422E8F5
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgG0J11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbgG0J10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 05:27:26 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3ACC061794;
        Mon, 27 Jul 2020 02:27:26 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BFZG315Vtz9sPf;
        Mon, 27 Jul 2020 19:27:23 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1595842044;
        bh=HjZ6HWlM+TvsH3PGn+uqnFohYSwGdbHy00hry1c1fkk=;
        h=Date:From:To:Cc:Subject:From;
        b=gimK/+kaNDoRsZWOXMGLIW9JUBka/I2FtlfghSswBw1awmeGw4lx+I4fBmkmZDn5d
         WFLjE+tviOyETb0frEl5KOqOH7VWLZh6Gp7Lqhv/omE+Vw3oc59oYA8FRk7UxZRzcp
         f1B2eoOHy/n5pJTZWp6odr240Mhitgc4S2v+ztYqy1QrgLgxrfWxEpB/yqOZQHs7OL
         VheC5WvV1wAsh+KepoINrGvJNHC99qykWfn4NrohODkQN+8psmkdqvGsM+tC50CK0O
         CcP1+cNROPYTRxdPNCODAf7T/vNW3zsiXj+Fo/ofo6tguJX48ciEA92i/tcToNKZrf
         DlGooCSFux6xg==
Date:   Mon, 27 Jul 2020 19:27:21 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Kees Cook <keescook@chromium.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: linux-next: manual merge of the kspp tree with the net-next tree
Message-ID: <20200727192721.53af345a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/iCvjBwzwkCS1yF7RQlxGqTH";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/iCvjBwzwkCS1yF7RQlxGqTH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kspp tree got a conflict in:

  net/ipv6/ip6_flowlabel.c

between commit:

  ff6a4cf214ef ("net/ipv6: split up ipv6_flowlabel_opt")

from the net-next tree and commit:

  3f649ab728cd ("treewide: Remove uninitialized_var() usage")

from the kspp tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc net/ipv6/ip6_flowlabel.c
index 215b6f5e733e,73bb047e6037..000000000000
--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@@ -534,184 -533,181 +534,184 @@@ int ipv6_flowlabel_opt_get(struct sock=20
  	return -ENOENT;
  }
 =20
 -int ipv6_flowlabel_opt(struct sock *sk, char __user *optval, int optlen)
 +#define socklist_dereference(__sflp) \
 +	rcu_dereference_protected(__sflp, lockdep_is_held(&ip6_sk_fl_lock))
 +
 +static int ipv6_flowlabel_put(struct sock *sk, struct in6_flowlabel_req *=
freq)
  {
 -	int err;
 -	struct net *net =3D sock_net(sk);
  	struct ipv6_pinfo *np =3D inet6_sk(sk);
 -	struct in6_flowlabel_req freq;
 -	struct ipv6_fl_socklist *sfl1 =3D NULL;
 -	struct ipv6_fl_socklist *sfl;
  	struct ipv6_fl_socklist __rcu **sflp;
 -	struct ip6_flowlabel *fl, *fl1 =3D NULL;
 +	struct ipv6_fl_socklist *sfl;
 =20
 +	if (freq->flr_flags & IPV6_FL_F_REFLECT) {
 +		if (sk->sk_protocol !=3D IPPROTO_TCP)
 +			return -ENOPROTOOPT;
 +		if (!np->repflow)
 +			return -ESRCH;
 +		np->flow_label =3D 0;
 +		np->repflow =3D 0;
 +		return 0;
 +	}
 =20
 -	if (optlen < sizeof(freq))
 -		return -EINVAL;
 +	spin_lock_bh(&ip6_sk_fl_lock);
 +	for (sflp =3D &np->ipv6_fl_list;
 +	     (sfl =3D socklist_dereference(*sflp)) !=3D NULL;
 +	     sflp =3D &sfl->next) {
 +		if (sfl->fl->label =3D=3D freq->flr_label)
 +			goto found;
 +	}
 +	spin_unlock_bh(&ip6_sk_fl_lock);
 +	return -ESRCH;
 +found:
 +	if (freq->flr_label =3D=3D (np->flow_label & IPV6_FLOWLABEL_MASK))
 +		np->flow_label &=3D ~IPV6_FLOWLABEL_MASK;
 +	*sflp =3D sfl->next;
 +	spin_unlock_bh(&ip6_sk_fl_lock);
 +	fl_release(sfl->fl);
 +	kfree_rcu(sfl, rcu);
 +	return 0;
 +}
 =20
 -	if (copy_from_user(&freq, optval, sizeof(freq)))
 -		return -EFAULT;
 +static int ipv6_flowlabel_renew(struct sock *sk, struct in6_flowlabel_req=
 *freq)
 +{
 +	struct ipv6_pinfo *np =3D inet6_sk(sk);
 +	struct net *net =3D sock_net(sk);
 +	struct ipv6_fl_socklist *sfl;
 +	int err;
 =20
 -	switch (freq.flr_action) {
 -	case IPV6_FL_A_PUT:
 -		if (freq.flr_flags & IPV6_FL_F_REFLECT) {
 -			if (sk->sk_protocol !=3D IPPROTO_TCP)
 -				return -ENOPROTOOPT;
 -			if (!np->repflow)
 -				return -ESRCH;
 -			np->flow_label =3D 0;
 -			np->repflow =3D 0;
 -			return 0;
 -		}
 -		spin_lock_bh(&ip6_sk_fl_lock);
 -		for (sflp =3D &np->ipv6_fl_list;
 -		     (sfl =3D rcu_dereference_protected(*sflp,
 -						      lockdep_is_held(&ip6_sk_fl_lock))) !=3D NULL;
 -		     sflp =3D &sfl->next) {
 -			if (sfl->fl->label =3D=3D freq.flr_label) {
 -				if (freq.flr_label =3D=3D (np->flow_label&IPV6_FLOWLABEL_MASK))
 -					np->flow_label &=3D ~IPV6_FLOWLABEL_MASK;
 -				*sflp =3D sfl->next;
 -				spin_unlock_bh(&ip6_sk_fl_lock);
 -				fl_release(sfl->fl);
 -				kfree_rcu(sfl, rcu);
 -				return 0;
 -			}
 +	rcu_read_lock_bh();
 +	for_each_sk_fl_rcu(np, sfl) {
 +		if (sfl->fl->label =3D=3D freq->flr_label) {
 +			err =3D fl6_renew(sfl->fl, freq->flr_linger,
 +					freq->flr_expires);
 +			rcu_read_unlock_bh();
 +			return err;
  		}
 -		spin_unlock_bh(&ip6_sk_fl_lock);
 -		return -ESRCH;
 +	}
 +	rcu_read_unlock_bh();
 =20
 -	case IPV6_FL_A_RENEW:
 -		rcu_read_lock_bh();
 -		for_each_sk_fl_rcu(np, sfl) {
 -			if (sfl->fl->label =3D=3D freq.flr_label) {
 -				err =3D fl6_renew(sfl->fl, freq.flr_linger, freq.flr_expires);
 -				rcu_read_unlock_bh();
 -				return err;
 -			}
 -		}
 -		rcu_read_unlock_bh();
 +	if (freq->flr_share =3D=3D IPV6_FL_S_NONE &&
 +	    ns_capable(net->user_ns, CAP_NET_ADMIN)) {
 +		struct ip6_flowlabel *fl =3D fl_lookup(net, freq->flr_label);
 =20
 -		if (freq.flr_share =3D=3D IPV6_FL_S_NONE &&
 -		    ns_capable(net->user_ns, CAP_NET_ADMIN)) {
 -			fl =3D fl_lookup(net, freq.flr_label);
 -			if (fl) {
 -				err =3D fl6_renew(fl, freq.flr_linger, freq.flr_expires);
 -				fl_release(fl);
 -				return err;
 -			}
 +		if (fl) {
 +			err =3D fl6_renew(fl, freq->flr_linger,
 +					freq->flr_expires);
 +			fl_release(fl);
 +			return err;
  		}
 -		return -ESRCH;
 -
 -	case IPV6_FL_A_GET:
 -		if (freq.flr_flags & IPV6_FL_F_REFLECT) {
 -			struct net *net =3D sock_net(sk);
 -			if (net->ipv6.sysctl.flowlabel_consistency) {
 -				net_info_ratelimited("Can not set IPV6_FL_F_REFLECT if flowlabel_cons=
istency sysctl is enable\n");
 -				return -EPERM;
 -			}
 +	}
 +	return -ESRCH;
 +}
 =20
 -			if (sk->sk_protocol !=3D IPPROTO_TCP)
 -				return -ENOPROTOOPT;
 +static int ipv6_flowlabel_get(struct sock *sk, struct in6_flowlabel_req *=
freq,
 +		sockptr_t optval, int optlen)
 +{
 +	struct ipv6_fl_socklist *sfl, *sfl1 =3D NULL;
 +	struct ip6_flowlabel *fl, *fl1 =3D NULL;
 +	struct ipv6_pinfo *np =3D inet6_sk(sk);
 +	struct net *net =3D sock_net(sk);
- 	int uninitialized_var(err);
++	int err;
 =20
 -			np->repflow =3D 1;
 -			return 0;
 +	if (freq->flr_flags & IPV6_FL_F_REFLECT) {
 +		if (net->ipv6.sysctl.flowlabel_consistency) {
 +			net_info_ratelimited("Can not set IPV6_FL_F_REFLECT if flowlabel_consi=
stency sysctl is enable\n");
 +			return -EPERM;
  		}
 =20
 -		if (freq.flr_label & ~IPV6_FLOWLABEL_MASK)
 -			return -EINVAL;
 +		if (sk->sk_protocol !=3D IPPROTO_TCP)
 +			return -ENOPROTOOPT;
 +		np->repflow =3D 1;
 +		return 0;
 +	}
 =20
 -		if (net->ipv6.sysctl.flowlabel_state_ranges &&
 -		    (freq.flr_label & IPV6_FLOWLABEL_STATELESS_FLAG))
 -			return -ERANGE;
 +	if (freq->flr_label & ~IPV6_FLOWLABEL_MASK)
 +		return -EINVAL;
 +	if (net->ipv6.sysctl.flowlabel_state_ranges &&
 +	    (freq->flr_label & IPV6_FLOWLABEL_STATELESS_FLAG))
 +		return -ERANGE;
 =20
 -		fl =3D fl_create(net, sk, &freq, optval, optlen, &err);
 -		if (!fl)
 -			return err;
 -		sfl1 =3D kmalloc(sizeof(*sfl1), GFP_KERNEL);
 +	fl =3D fl_create(net, sk, freq, optval, optlen, &err);
 +	if (!fl)
 +		return err;
 =20
 -		if (freq.flr_label) {
 -			err =3D -EEXIST;
 -			rcu_read_lock_bh();
 -			for_each_sk_fl_rcu(np, sfl) {
 -				if (sfl->fl->label =3D=3D freq.flr_label) {
 -					if (freq.flr_flags&IPV6_FL_F_EXCL) {
 -						rcu_read_unlock_bh();
 -						goto done;
 -					}
 -					fl1 =3D sfl->fl;
 -					if (!atomic_inc_not_zero(&fl1->users))
 -						fl1 =3D NULL;
 -					break;
 +	sfl1 =3D kmalloc(sizeof(*sfl1), GFP_KERNEL);
 +
 +	if (freq->flr_label) {
 +		err =3D -EEXIST;
 +		rcu_read_lock_bh();
 +		for_each_sk_fl_rcu(np, sfl) {
 +			if (sfl->fl->label =3D=3D freq->flr_label) {
 +				if (freq->flr_flags & IPV6_FL_F_EXCL) {
 +					rcu_read_unlock_bh();
 +					goto done;
  				}
 +				fl1 =3D sfl->fl;
 +				if (!atomic_inc_not_zero(&fl1->users))
 +					fl1 =3D NULL;
 +				break;
  			}
 -			rcu_read_unlock_bh();
 +		}
 +		rcu_read_unlock_bh();
 =20
 -			if (!fl1)
 -				fl1 =3D fl_lookup(net, freq.flr_label);
 -			if (fl1) {
 +		if (!fl1)
 +			fl1 =3D fl_lookup(net, freq->flr_label);
 +		if (fl1) {
  recheck:
 -				err =3D -EEXIST;
 -				if (freq.flr_flags&IPV6_FL_F_EXCL)
 -					goto release;
 -				err =3D -EPERM;
 -				if (fl1->share =3D=3D IPV6_FL_S_EXCL ||
 -				    fl1->share !=3D fl->share ||
 -				    ((fl1->share =3D=3D IPV6_FL_S_PROCESS) &&
 -				     (fl1->owner.pid !=3D fl->owner.pid)) ||
 -				    ((fl1->share =3D=3D IPV6_FL_S_USER) &&
 -				     !uid_eq(fl1->owner.uid, fl->owner.uid)))
 -					goto release;
 -
 -				err =3D -ENOMEM;
 -				if (!sfl1)
 -					goto release;
 -				if (fl->linger > fl1->linger)
 -					fl1->linger =3D fl->linger;
 -				if ((long)(fl->expires - fl1->expires) > 0)
 -					fl1->expires =3D fl->expires;
 -				fl_link(np, sfl1, fl1);
 -				fl_free(fl);
 -				return 0;
 +			err =3D -EEXIST;
 +			if (freq->flr_flags&IPV6_FL_F_EXCL)
 +				goto release;
 +			err =3D -EPERM;
 +			if (fl1->share =3D=3D IPV6_FL_S_EXCL ||
 +			    fl1->share !=3D fl->share ||
 +			    ((fl1->share =3D=3D IPV6_FL_S_PROCESS) &&
 +			     (fl1->owner.pid !=3D fl->owner.pid)) ||
 +			    ((fl1->share =3D=3D IPV6_FL_S_USER) &&
 +			     !uid_eq(fl1->owner.uid, fl->owner.uid)))
 +				goto release;
 +
 +			err =3D -ENOMEM;
 +			if (!sfl1)
 +				goto release;
 +			if (fl->linger > fl1->linger)
 +				fl1->linger =3D fl->linger;
 +			if ((long)(fl->expires - fl1->expires) > 0)
 +				fl1->expires =3D fl->expires;
 +			fl_link(np, sfl1, fl1);
 +			fl_free(fl);
 +			return 0;
 =20
  release:
 -				fl_release(fl1);
 -				goto done;
 -			}
 -		}
 -		err =3D -ENOENT;
 -		if (!(freq.flr_flags&IPV6_FL_F_CREATE))
 +			fl_release(fl1);
  			goto done;
 +		}
 +	}
 +	err =3D -ENOENT;
 +	if (!(freq->flr_flags & IPV6_FL_F_CREATE))
 +		goto done;
 =20
 -		err =3D -ENOMEM;
 -		if (!sfl1)
 -			goto done;
 +	err =3D -ENOMEM;
 +	if (!sfl1)
 +		goto done;
 =20
 -		err =3D mem_check(sk);
 -		if (err !=3D 0)
 -			goto done;
 +	err =3D mem_check(sk);
 +	if (err !=3D 0)
 +		goto done;
 =20
 -		fl1 =3D fl_intern(net, fl, freq.flr_label);
 -		if (fl1)
 -			goto recheck;
 +	fl1 =3D fl_intern(net, fl, freq->flr_label);
 +	if (fl1)
 +		goto recheck;
 =20
 -		if (!freq.flr_label) {
 -			if (copy_to_user(&((struct in6_flowlabel_req __user *) optval)->flr_la=
bel,
 -					 &fl->label, sizeof(fl->label))) {
 -				/* Intentionally ignore fault. */
 -			}
 +	if (!freq->flr_label) {
 +		sockptr_advance(optval,
 +				offsetof(struct in6_flowlabel_req, flr_label));
 +		if (copy_to_sockptr(optval, &fl->label, sizeof(fl->label))) {
 +			/* Intentionally ignore fault. */
  		}
 -
 -		fl_link(np, sfl1, fl);
 -		return 0;
 -
 -	default:
 -		return -EINVAL;
  	}
 =20
 +	fl_link(np, sfl1, fl);
 +	return 0;
  done:
  	fl_free(fl);
  	kfree(sfl1);

--Sig_/iCvjBwzwkCS1yF7RQlxGqTH
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8enfkACgkQAVBC80lX
0GxhHQf9FVG75lIKC5lYTC/EabOluGU4g8UwxVNwmHVDB/UiqaOC9/KJHGi69dtq
ME4WNDGz7yyhs7ZkyqCsflB14Ye6HQO6lzKHLt/k1m3x0DYJoxBBLn9ltygQ7IpT
DajliC9hXF2gX55QuZ8nzwYkO7ivnyO7Ugs6M+1V1OYQruvkUzLVXEFFKvBCUNUT
VAPunH3E2nX1gMq6XjbQeBXX1wVhA8pFnILPZyeedq9IG1mzjYuQRHlUqzKmn39g
dOoprRisDhIB6ZtkmX9tgMfP+9XyHySffU99Rdzmr5d9ONsRDrDLtvwqPl9u1ADk
V7wlsvWDmRC8GRE/gqhJx7LoiCC0OQ==
=leqJ
-----END PGP SIGNATURE-----

--Sig_/iCvjBwzwkCS1yF7RQlxGqTH--
