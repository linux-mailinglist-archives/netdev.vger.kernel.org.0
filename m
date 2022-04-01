Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE2614EEF22
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 16:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346695AbiDAOVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244595AbiDAOVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:21:24 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F091235AB2;
        Fri,  1 Apr 2022 07:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=yYfe4IqnQCFjezJJ1yDBKTdU4r3OcolI7hkf/x5tgk8=; b=Mp7i96VGoyqOYdy5qeSb3ChSiX
        A88sWHETy4JZT1B07buCALf5bDh2sXpAVKAR3rROkv2OOuH+zKonNSxQXjVrISFWEspAekCAcfVMQ
        qfPuiC6uL9RxxjzgNL2ZCdJyJfGuh88/1NPZg4MLqAWxD6Y32inIAGbVe3T2aTcCzHa20EIZ71C1r
        wACHpSB/cWHswObK9b3hkQp8IjcGylAqcrqxkVHXYddcGuiyuND1OA0lD0WZuaPo5U5Mun5Kp6sdG
        BrgJoTPmWeTLHR+7ihyCTYqWw855IvFcbqpM8BOr8E15BfJ6jffweL8SZ7oPhDoW+OaQwLu8JGYkf
        zJ/p3BNGcyChk7zk+gsAQdGAHzbHnsfQxZf8K2VHT09PlYnx2wLPaIpwn4X1SpB3l8g4Z/unLgI8C
        0CfttKLBfccPvY19/xaBiV4xEBNPs8Ay+PCsaYnLRIjcOELGctHDPAg84VVko9sr0EMyEwiVzVk2A
        yGxxI6sDqA5eh/JO/eQIvWriFFwXmOe82fYZDV6Ifd36j4HAf2ihYxmQnYhIuk7cCUqTqsC6VuF63
        idR/gS+7pIsoorea5Pq7J0Gaif1McJGwIzBG1q6lkgnYbclDRAMAiYgfgO8C5ruQMiGYiB9htqF+T
        p1lExoY6g2b7/13gj0waM82BdkAd2zORjbJxA6elE=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     asmadeus@codewreck.org
Cc:     David Kahurani <k.kahurani@gmail.com>, davem@davemloft.net,
        ericvh@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lucho@ionkov.net, netdev@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        David Howells <dhowells@redhat.com>, Greg Kurz <groug@kaod.org>
Subject: Re: 9p fs-cache tests/benchmark (was: 9p fscache Duplicate cookie detected)
Date:   Fri, 01 Apr 2022 16:19:20 +0200
Message-ID: <1866935.Y7JIjT2MHT@silver>
In-Reply-To: <YkTP/Talsy3KQBbf@codewreck.org>
References: <CAAZOf26g-L2nSV-Siw6mwWQv1nv6on8c0fWqB4bKmX73QAFzow@mail.gmail.com>
 <3791738.ukkqOL8KQD@silver> <YkTP/Talsy3KQBbf@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mittwoch, 30. M=E4rz 2022 23:47:41 CEST asmadeus@codewreck.org wrote:
> Thanks Christian!
>=20
> Christian Schoenebeck wrote on Wed, Mar 30, 2022 at 02:21:16PM +0200:
[...]
> > > Christian Schoenebeck wrote on Sat, Mar 26, 2022 at 01:36:31PM +0100:
> > > hm, fscache code shouldn't be used for cache=3Dmmap, I'm surprised yo=
u can
> > > hit this...
> >=20
> > I assume that you mean that 9p driver does not explicitly ask for fs-ca=
che
> > being used for mmap. I see that 9p uses the kernel's generalized mmap
> > implementation:
> >=20
> > https://github.com/torvalds/linux/blob/d888c83fcec75194a8a48ccd283953bd=
ba7
> > b2550/fs/9p/vfs_file.c#L481
> >=20
> > I haven't dived further into this, but the kernel has to use some kind =
of
> > filesystem cache anyway to provide the mmap functionality, so I guess it
> > makes sense that I got those warning messages from the FS-Cache
> > subsystem?
> It uses the generic mmap which has vfs caching, but definitely not
> fs-cache.
> fs-cache adds more hooks for cachefilesd (writing file contents to disk
> for bigger cache) and things like that cache=3Dloose/mmap shouldn't be
> caring about. cache=3Dloose actually just disables some key parts so I'm
> not surprised it shares bugs with the new code, but cache=3Dmmap is really
> independant and I need to trace where these come from...

=46rom looking at the sources, the call stack for emitting "FS-Cache: Dupli=
cate
cookie detected" error messages with 9p "cache=3Dmmap" option seems to be:

1. v9fs_vfs_lookup [fs/9p/vfs_inode.c, 788]:

	inode =3D v9fs_get_new_inode_from_fid(v9ses, fid, dir->i_sb);

2. v9fs_get_new_inode_from_fid [fs/9p/v9fs.h, 228]:

	return v9fs_inode_from_fid_dotl(v9ses, fid, sb, 1);

3. v9fs_inode_from_fid_dotl [fs/9p/vfs_inode_dotl.c, 157]:

	inode =3D v9fs_qid_iget_dotl(sb, &st->qid, fid, st, new);

4. v9fs_qid_iget_dotl [fs/9p/vfs_inode_dotl.c, 133]:

	v9fs_cache_inode_get_cookie(inode);
	^--- Called independent of function argument "new"'s value here
   https://github.com/torvalds/linux/blob/e8b767f5e04097aaedcd6e06e2270f9fe=
5282696/fs/9p/vfs_inode_dotl.c#L133

5. v9fs_cache_inode_get_cookie [fs/9p/cache.c, 68]:

	v9inode->fscache =3D
		fscache_acquire_cookie(v9fs_session_cache(v9ses),
				       0,
				       &path, sizeof(path),
				       &version, sizeof(version),
				       i_size_read(&v9inode->vfs_inode));

6. fscache_acquire_cookie [include/linux/fscache.h, 251]:

	return __fscache_acquire_cookie(volume, advice,
					index_key, index_key_len,
					aux_data, aux_data_len,
					object_size);

7. __fscache_acquire_cookie [fs/fscache/cookie.c, 472]:

	if (!fscache_hash_cookie(cookie)) {
		fscache_see_cookie(cookie, fscache_cookie_discard);
		fscache_free_cookie(cookie);
		return NULL;
	}

8. fscache_hash_cookie [fs/fscache/cookie.c, 430]:

	pr_err("Duplicate cookie detected\n");

> > With QEMU >=3D 5.2 you should see the following QEMU warning with your
> > reproducer:
> >=20
> > "
> > qemu-system-x86_64: warning: 9p: Multiple devices detected in same Virt=
=46S
> > export, which might lead to file ID collisions and severe misbehaviours=
 on
> > guest! You should either use a separate export for each device shared f=
rom
> > host or use virtfs option 'multidevs=3Dremap'!
> > "
>=20
> oh, I wasn't aware of the new option. Good job there!
>=20
> It's the easiest way to reproduce but there are also harder to fix
> collisions, file systems only guarantee unicity for (fsid,inode
> number,version) which is usually bigger than 128 bits (although version
> is often 0), but version isn't exposed to userspace easily...
> What we'd want for unicity is handle from e.g. name_to_handle_at but
> that'd add overhead, wouldn't fit in qid path and not all fs are capable
> of providing one... The 9p protocol just doesn't want bigger handles
> than qid path.

No bigger qid.path on 9p protocol level in future? Why?

> And, err, looking at the qemu code
>=20
>   qidp->version =3D stbuf->st_mtime ^ (stbuf->st_size << 8);
>=20
> so the qid is treated as "data version",
> but on kernel side we've treated it as inode version (i_version, see
> include/linux/iversion.h)
>=20
> (v9fs_test_inode_dotl checks the version is the same when comparing two
> inodes) so it will incorrectly identify two identical inodes as
> different.
> That will cause problems...
> Since you'll be faster than me could you try keeping it at 0 there?

I tried with your suggested change on QEMU side:

diff --git a/hw/9pfs/9p.c b/hw/9pfs/9p.c
index a6d6b3f835..5d9be87758 100644
=2D-- a/hw/9pfs/9p.c
+++ b/hw/9pfs/9p.c
@@ -981,7 +981,7 @@ static int stat_to_qid(V9fsPDU *pdu, const struct stat =
*stbuf, V9fsQID *qidp)
         memcpy(&qidp->path, &stbuf->st_ino, size);
     }
=20
=2D    qidp->version =3D stbuf->st_mtime ^ (stbuf->st_size << 8);
+    qidp->version =3D 0;
     qidp->type =3D 0;
     if (S_ISDIR(stbuf->st_mode)) {
         qidp->type |=3D P9_QID_TYPE_DIR;

Unfortunately it did not make any difference for these 2 Linux kernel fs-ca=
che
issues at least; still same errors, and same suboptimal performance.

Best regards,
Christian Schoenebeck


