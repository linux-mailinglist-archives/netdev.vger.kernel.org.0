Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40A2B17B230
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 00:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgCEXWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 18:22:09 -0500
Received: from ozlabs.org ([203.11.71.1]:43211 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726128AbgCEXWJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 18:22:09 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48YRbd5SFrz9sNg;
        Fri,  6 Mar 2020 10:22:05 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1583450526;
        bh=PvR3xvSSafUOmuGnnxb06iTcgtURZdFSYRFughwx4Jc=;
        h=Date:From:To:Cc:Subject:From;
        b=psMUlKTkLtxWgoN1IA50NGPWdGS3hB3HdMRoe5FDUpSOS1fIY6HWjZYAyHKKzxF3D
         9NRhvJfHINFTJlf/SEKKty3sKJso2RH/4AMJez+pTVPVImvYfGyhM5YSyz8famnEvr
         obKpExYXgAU0g+ek1XBiV2G8bTZ2+BgByr/cqdOD9Qy03CYWfR2c9/9m40GVsUpy+4
         G4DuKxrduayZUIizWVcBReAfCIj4MaMf+v0ehJqTivyZRB3FXxbDAVqDQqXh7kOdtD
         CSd8iwgoQ159AM0f1MOW29lgknQmmrVG4ayd2iMxg+hAo1r5LtulZwr0GCbpc4BGqW
         xh62PJw55My3Q==
Date:   Fri, 6 Mar 2020 10:21:58 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        PowerPC <linuxppc-dev@lists.ozlabs.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sourabh Jain <sourabhjain@linux.ibm.com>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: linux-next: manual merge of the net-next tree with the powerpc tree
Message-ID: <20200306102158.0b88e0a0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/MiD=6dX41diOlbdUFdeLJ7D";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/MiD=6dX41diOlbdUFdeLJ7D
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  fs/sysfs/group.c

between commit:

  9255782f7061 ("sysfs: Wrap __compat_only_sysfs_link_entry_to_kobj functio=
n to change the symlink name")

from the powerpc tree and commit:

  303a42769c4c ("sysfs: add sysfs_group{s}_change_owner()")

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

diff --cc fs/sysfs/group.c
index 1e2a096057bc,5afe0e7ff7cd..000000000000
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@@ -478,4 -457,118 +479,118 @@@ int compat_only_sysfs_link_entry_to_kob
  	kernfs_put(target);
  	return PTR_ERR_OR_ZERO(link);
  }
 -EXPORT_SYMBOL_GPL(__compat_only_sysfs_link_entry_to_kobj);
 +EXPORT_SYMBOL_GPL(compat_only_sysfs_link_entry_to_kobj);
+=20
+ static int sysfs_group_attrs_change_owner(struct kernfs_node *grp_kn,
+ 					  const struct attribute_group *grp,
+ 					  struct iattr *newattrs)
+ {
+ 	struct kernfs_node *kn;
+ 	int error;
+=20
+ 	if (grp->attrs) {
+ 		struct attribute *const *attr;
+=20
+ 		for (attr =3D grp->attrs; *attr; attr++) {
+ 			kn =3D kernfs_find_and_get(grp_kn, (*attr)->name);
+ 			if (!kn)
+ 				return -ENOENT;
+=20
+ 			error =3D kernfs_setattr(kn, newattrs);
+ 			kernfs_put(kn);
+ 			if (error)
+ 				return error;
+ 		}
+ 	}
+=20
+ 	if (grp->bin_attrs) {
+ 		struct bin_attribute *const *bin_attr;
+=20
+ 		for (bin_attr =3D grp->bin_attrs; *bin_attr; bin_attr++) {
+ 			kn =3D kernfs_find_and_get(grp_kn, (*bin_attr)->attr.name);
+ 			if (!kn)
+ 				return -ENOENT;
+=20
+ 			error =3D kernfs_setattr(kn, newattrs);
+ 			kernfs_put(kn);
+ 			if (error)
+ 				return error;
+ 		}
+ 	}
+=20
+ 	return 0;
+ }
+=20
+ /**
+  * sysfs_group_change_owner - change owner of an attribute group.
+  * @kobj:	The kobject containing the group.
+  * @grp:	The attribute group.
+  * @kuid:	new owner's kuid
+  * @kgid:	new owner's kgid
+  *
+  * Returns 0 on success or error code on failure.
+  */
+ int sysfs_group_change_owner(struct kobject *kobj,
+ 			     const struct attribute_group *grp, kuid_t kuid,
+ 			     kgid_t kgid)
+ {
+ 	struct kernfs_node *grp_kn;
+ 	int error;
+ 	struct iattr newattrs =3D {
+ 		.ia_valid =3D ATTR_UID | ATTR_GID,
+ 		.ia_uid =3D kuid,
+ 		.ia_gid =3D kgid,
+ 	};
+=20
+ 	if (!kobj->state_in_sysfs)
+ 		return -EINVAL;
+=20
+ 	if (grp->name) {
+ 		grp_kn =3D kernfs_find_and_get(kobj->sd, grp->name);
+ 	} else {
+ 		kernfs_get(kobj->sd);
+ 		grp_kn =3D kobj->sd;
+ 	}
+ 	if (!grp_kn)
+ 		return -ENOENT;
+=20
+ 	error =3D kernfs_setattr(grp_kn, &newattrs);
+ 	if (!error)
+ 		error =3D sysfs_group_attrs_change_owner(grp_kn, grp, &newattrs);
+=20
+ 	kernfs_put(grp_kn);
+=20
+ 	return error;
+ }
+ EXPORT_SYMBOL_GPL(sysfs_group_change_owner);
+=20
+ /**
+  * sysfs_groups_change_owner - change owner of a set of attribute groups.
+  * @kobj:	The kobject containing the groups.
+  * @groups:	The attribute groups.
+  * @kuid:	new owner's kuid
+  * @kgid:	new owner's kgid
+  *
+  * Returns 0 on success or error code on failure.
+  */
+ int sysfs_groups_change_owner(struct kobject *kobj,
+ 			      const struct attribute_group **groups,
+ 			      kuid_t kuid, kgid_t kgid)
+ {
+ 	int error =3D 0, i;
+=20
+ 	if (!kobj->state_in_sysfs)
+ 		return -EINVAL;
+=20
+ 	if (!groups)
+ 		return 0;
+=20
+ 	for (i =3D 0; groups[i]; i++) {
+ 		error =3D sysfs_group_change_owner(kobj, groups[i], kuid, kgid);
+ 		if (error)
+ 			break;
+ 	}
+=20
+ 	return error;
+ }
+ EXPORT_SYMBOL_GPL(sysfs_groups_change_owner);

--Sig_/MiD=6dX41diOlbdUFdeLJ7D
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl5hiZYACgkQAVBC80lX
0GwNjgf+NR8vXKVJAOj4wfPbS7Z86o+CKOI/QhegsGe9hQhSVkfAPt2iQ44y3B4c
8zSfBQW5uYRwXALv7eiFKnIBw1rFg66smu7svvbEIFE/siwIMqGZJW0gOpVwIAF7
qgO7qyQJlRa7G3+vZsA8VDA/1ti+juHCJHikLmzHRZOB6hF2QQTGLodXuD0ReJHQ
D0seqE0uNkN5DO/5KifBic8SHGRMAv0P28MC2SH8Si/YmF4CwN4E9gp9fKsQ4vo5
dBpZvDO345/zQO7p31mIV/exmvQZ68ttELulIYglGLY2d3c245eBf432lqT9EIIk
SlGc8Nxd/I8v17zpel/hCzWN1KrnxQ==
=ApLk
-----END PGP SIGNATURE-----

--Sig_/MiD=6dX41diOlbdUFdeLJ7D--
