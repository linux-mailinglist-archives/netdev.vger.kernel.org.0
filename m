Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD55B50E2B6
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 16:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiDYONb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 10:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiDYONa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 10:13:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB0D21135
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 07:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650895823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bQqZOAGGz8cVHdnTZIYoAUITNiAmyVcVqVE5emNQD/c=;
        b=BqQQgBcJtByYbkTYkZr1w1y+QFts6erAVcluvqLcdT6OMt/F86k6V4xYrywdVYz+Rrwua+
        2KqWYIWPd6EwCKO47B9VgtyyK0es3J0Hb07DOUC6Hw4FZE5RVF8lq+uQDmNuHAuOW/6Vkz
        yY2s85iJsemk/sA80wMzF60OfiV4Ng0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-546-BWga3YOdOem8z4yuh6x95g-1; Mon, 25 Apr 2022 10:10:19 -0400
X-MC-Unique: BWga3YOdOem8z4yuh6x95g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D853E38337F6;
        Mon, 25 Apr 2022 14:10:18 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 075F5401E97;
        Mon, 25 Apr 2022 14:10:16 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <YmKp68xvZEjBFell@codewreck.org>
References: <YmKp68xvZEjBFell@codewreck.org> <YlySEa6QGmIHlrdG@codewreck.org> <YlyFEuTY7tASl8aY@codewreck.org> <1050016.1650537372@warthog.procyon.org.uk> <1817268.LulUJvKFVv@silver>
To:     asmadeus@codewreck.org
Cc:     dhowells@redhat.com,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        David Kahurani <k.kahurani@gmail.com>, davem@davemloft.net,
        ericvh@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lucho@ionkov.net, netdev@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, Greg Kurz <groug@kaod.org>
Subject: Re: 9p EBADF with cache enabled (Was: 9p fs-cache tests/benchmark (was: 9p fscache Duplicate cookie detected))
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3174157.1650895816.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 25 Apr 2022 15:10:16 +0100
Message-ID: <3174158.1650895816@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There may be a quick and dirty workaround.  I think the problem is that un=
less
the O_APPEND read starts at the beginning of a page, netfs is going to enf=
orce
a read.  Does the attached patch fix the problem?  (note that it's unteste=
d)

Also, can you get the contents of /proc/fs/fscache/stats from after
reproducing the problem?

David
---
diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index 501128188343..5f61fdb950b0 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -291,16 +291,25 @@ static int v9fs_write_end(struct file *filp, struct =
address_space *mapping,
 	struct folio *folio =3D page_folio(subpage);
 	struct inode *inode =3D mapping->host;
 	struct v9fs_inode *v9inode =3D V9FS_I(inode);
+	size_t fsize =3D folio_size(folio);
+	size_t offset =3D pos & (fsize - 1);
+	/* With multipage folio support, we may be given len > fsize */
+	size_t copy_size =3D min_t(size_t, len, fsize - offset);
 =

 	p9_debug(P9_DEBUG_VFS, "filp %p, mapping %p\n", filp, mapping);
 =

 	if (!folio_test_uptodate(folio)) {
-		if (unlikely(copied < len)) {
+		if (unlikely(copied < copy_size)) {
 			copied =3D 0;
 			goto out;
 		}
-
-		folio_mark_uptodate(folio);
+		if (offset =3D=3D 0) {
+			if (copied =3D=3D fsize)
+				folio_mark_uptodate(folio);
+			/* Could clear to end of page if last_pos =3D=3D new EOF
+			 * and then mark uptodate
+			 */
+		}
 	}
 =

 	/*
diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 281a88a5b8dc..78439f628c23 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -364,6 +364,12 @@ int netfs_write_begin(struct file *file, struct addre=
ss_space *mapping,
 	if (folio_test_uptodate(folio))
 		goto have_folio;
 =

+	if (!netfs_is_cache_enabled(ctx) &&
+	    (file->f_flags & (O_APPEND | O_ACCMODE)) =3D=3D (O_APPEND | O_WRONLY=
)) {
+		netfs_stat(&netfs_n_rh_write_append);
+		goto have_folio_no_wait;
+	}
+
 	/* If the page is beyond the EOF, we want to clear it - unless it's
 	 * within the cache granule containing the EOF, in which case we need
 	 * to preload the granule.
diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index b7b0e3d18d9e..a1cd649197dc 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -67,6 +67,7 @@ extern atomic_t netfs_n_rh_read_failed;
 extern atomic_t netfs_n_rh_zero;
 extern atomic_t netfs_n_rh_short_read;
 extern atomic_t netfs_n_rh_write;
+extern atomic_t netfs_n_rh_write_append;
 extern atomic_t netfs_n_rh_write_begin;
 extern atomic_t netfs_n_rh_write_done;
 extern atomic_t netfs_n_rh_write_failed;
diff --git a/fs/netfs/stats.c b/fs/netfs/stats.c
index 5510a7a14a40..fce87f86f950 100644
--- a/fs/netfs/stats.c
+++ b/fs/netfs/stats.c
@@ -23,6 +23,7 @@ atomic_t netfs_n_rh_read_failed;
 atomic_t netfs_n_rh_zero;
 atomic_t netfs_n_rh_short_read;
 atomic_t netfs_n_rh_write;
+atomic_t netfs_n_rh_write_append;
 atomic_t netfs_n_rh_write_begin;
 atomic_t netfs_n_rh_write_done;
 atomic_t netfs_n_rh_write_failed;
@@ -37,10 +38,11 @@ void netfs_stats_show(struct seq_file *m)
 		   atomic_read(&netfs_n_rh_write_zskip),
 		   atomic_read(&netfs_n_rh_rreq),
 		   atomic_read(&netfs_n_rh_sreq));
-	seq_printf(m, "RdHelp : ZR=3D%u sh=3D%u sk=3D%u\n",
+	seq_printf(m, "RdHelp : ZR=3D%u sh=3D%u sk=3D%u wa=3D%u\n",
 		   atomic_read(&netfs_n_rh_zero),
 		   atomic_read(&netfs_n_rh_short_read),
-		   atomic_read(&netfs_n_rh_write_zskip));
+		   atomic_read(&netfs_n_rh_write_zskip),
+		   atomic_read(&netfs_n_rh_write_append));
 	seq_printf(m, "RdHelp : DL=3D%u ds=3D%u df=3D%u di=3D%u\n",
 		   atomic_read(&netfs_n_rh_download),
 		   atomic_read(&netfs_n_rh_download_done),

