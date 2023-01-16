Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A90D66D291
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 00:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233684AbjAPXIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 18:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232611AbjAPXIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 18:08:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E855E9EE6
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 15:08:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673910490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=C0JW58nBSMHYj9bsnV2rJ7yxCnH8Mz39Aj6dzwUznZA=;
        b=DsCnx5TtXFC2YVo/FWZMqEv7zmUWf3vKMAGBMY6ONugxSG75GzF2NXmf3e4tDUVrBxX3id
        6j5ZZg8lXEC1ezMO4bDuR3/6ODii/8jTzJaZ/hFHRwxBwEa7p58Ysx6/uROphujiRFMvbu
        sqFFPqpG0ZnjMs7KWCWm3JjKQsHOTp0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-235-GJYj0EjBM4qvyti9d-2JNA-1; Mon, 16 Jan 2023 18:08:06 -0500
X-MC-Unique: GJYj0EjBM4qvyti9d-2JNA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B588C3815EE7;
        Mon, 16 Jan 2023 23:08:04 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 08299C15BA0;
        Mon, 16 Jan 2023 23:07:57 +0000 (UTC)
Subject: [PATCH v6 00/34] iov_iter: Improve page extraction (ref,
 pin or just list)
From:   David Howells <dhowells@redhat.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Paolo Abeni <pabeni@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Paulo Alcantara <pc@cjr.nz>,
        linux-scsi@vger.kernel.org, Steve French <sfrench@samba.org>,
        Stefan Metzmacher <metze@samba.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Jeff Layton <jlayton@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Anna Schumaker <anna@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Tom Talpey <tom@talpey.com>, linux-rdma@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org,
        linux-nfs@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        Latchesar Ionkov <lucho@ionkov.net>,
        linux-fsdevel@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Long Li <longli@microsoft.com>, Jan Kara <jack@suse.cz>,
        linux-cachefs@redhat.com, linux-block@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, dhowells@redhat.com,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
        Jeff Layton <jlayton@kernel.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 16 Jan 2023 23:07:57 +0000
Message-ID: <167391047703.2311931.8115712773222260073.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Al, Christoph,

Here are patches clean up some use of READ/WRITE and ITER_SOURCE/DEST,
patches to provide support for extracting pages from an iov_iter and a
patch to use the primary extraction function in the block layer bio code.
I've also added a bunch of other conversions and had a tentative stab at
the networking code.

The patches make the following changes:

 (1) Deal with switching from using the iterator data_source to indicate
     the I/O direction to deriving this from other information, eg.:
     IOCB_WRITE, IOMAP_WRITE and the REQ_OP_* number.  This allows
     iov_iter_rw() to be removed eventually.

 (2) Define FOLL_SOURCE_BUF and FOLL_DEST_BUF and pass these into
     iov_iter_get_pages*() to indicate the I/O direction with regards to
     how the buffer described by the iterator is to be used.  This is
     included in the gup_flags passed in with Logan's patches.

     Calls to iov_iter_get_pages*2() are replaced with calls to
     iov_iter_get_pages*() and the former is removed.

 (3) Add a function, iov_iter_extract_pages() to replace
     iov_iter_get_pages*() that gets refs, pins or just lists the pages as
     appropriate to the iterator type and the I/O direction.

     Add a function, iov_iter_extract_mode() that will indicate from the
     iterator type and the I/O direction how the cleanup is to be
     performed, returning FOLL_GET, FOLL_PIN or 0.

     Add a function, folio_put_unpin(), and a wrapper, page_put_unpin(),
     that take a page and the return from iov_iter_extract_mode() and do
     the right thing to clean up the page.

 (4) Make the bio struct carry a pair of flags to indicate the cleanup
     mode.  BIO_NO_PAGE_REF is replaced with BIO_PAGE_REFFED (equivalent to
     FOLL_GET) and BIO_PAGE_PINNED (equivalent to BIO_PAGE_PINNED) is
     added.  These are forced to have the same value as the FOLL_* flags so
     they can be passed to the previously mentioned cleanup function.

 (5) Make the iter-to-bio code use iov_iter_extract_pages() to
     appropriately retain the pages and clean them up later.

 (6) Fix bio_flagged() so that it doesn't prevent a gcc optimisation.

 (7) Add a function in netfslib, netfs_extract_user_iter(), to extract a
     UBUF- or IOVEC-type iterator to a page list in a BVEC-type iterator,
     with all the pages suitably ref'd or pinned.

 (8) Add a function in netfslib, netfs_extract_iter_to_sg(), to extract a
     UBUF-, IOVEC-, BVEC-, XARRAY- or KVEC-type iterator to a scatterlist.
     The first two types appropriately ref or pin pages; the latter three
     don't perform any retention, leaving that to the caller.

     Note that I can make use of this in the SCSI and AF_ALG code and
     possibly the networking code, so this might merit being moved to core
     code.

 (9) Make AF_ALG use iov_iter_extract_pages() and possibly go further and
     make it use netfs_extract_iter_to_sg() instead.

(10) Make SCSI vhost use netfs_extract_iter_to_sg().

(11) Make fs/direct-io.c use iov_iter_extract_pages().

(13) Make splice-to-pipe use iov_iter_extract_pages(), but limit the usage
     to a cleanup mode of FOLL_GET.

(13) Make the 9P, FUSE and NFS filesystems use iov_iter_extract_pages().

(14) Make the CIFS filesystem use iterators from the top all the way down
     to the socket on the simple path.  Make it use
     netfs_extract_user_iter() to use an XARRAY-type iterator or to build a
     BVEC-type iterator in the top layers from a UBUF- or IOVEC-type
     iterator and attach the iterator to the operation descriptors.

     netfs_extract_iter_to_sg() is used to build scatterlists for doing
     transport crypto and a function, smb_extract_iter_to_rdma(), is
     provided to build an RDMA SGE list directly from an iterator without
     going via a page list and then a scatter list.

(15) A couple of work-in-progress patches to try and make sk_buff fragments
     record the information needed to clean them up in the lowest two bits
     of the page pointer in the fragment struct.

This leaves:

 (*) Four calls to iov_iter_get_pages() in CEPH.  That will be helped by
     patches to pass an iterator down to the transport layer instead of
     converting to a page list high up and passing that down, but the
     transport layer could do with some massaging so that it doesn't covert
     the iterator to a page list and then the pages individually back to
     iterators to pass to the socket.

 (*) One call to iov_iter_get_pages() each in the networking core, RDS and
     TLS, all related to zero-copy.  TLS seems to do zerocopy-read (or
     maybe decrypt-offload) and should be doing FOLL_PIN, not FOLL_GET for
     user-provided buffers.


Changes:
========
ver #6)
 - Fix write() syscall and co. not setting IOCB_WRITE.
 - Added iocb_is_read() and iocb_is_write() to check IOCB_WRITE.
 - Use op_is_write() in bio_copy_user_iov().
 - Drop the iterator direction checks from smbd_recv().
 - Define FOLL_SOURCE_BUF and FOLL_DEST_BUF and pass them in as part of
   gup_flags to iov_iter_get/extract_pages*().
 - Replace iov_iter_get_pages*2() with iov_iter_get_pages*() and remove.
 - Add back the function to indicate the cleanup mode.
 - Drop the cleanup_mode return arg to iov_iter_extract_pages().
 - Provide a helper to clean up a page.
 - Renumbered FOLL_GET and FOLL_PIN and made BIO_PAGE_REFFED/PINNED have
   the same numerical values, enforced with an assertion.
 - Converted AF_ALG, SCSI vhost, generic DIO, FUSE, splice to pipe, 9P and
   NFS.
 - Added in the patches to make CIFS do top-to-bottom iterators and use
   various of the added extraction functions.
 - Added a pair of work-in-progess patches to make sk_buff fragments store
   FOLL_GET and FOLL_PIN.

ver #5)
 - Replace BIO_NO_PAGE_REF with BIO_PAGE_REFFED and split into own patch.
 - Transcribe FOLL_GET/PIN into BIO_PAGE_REFFED/PINNED flags.
 - Add patch to allow bio_flagged() to be combined by gcc.

ver #4)
 - Drop the patch to move the FOLL_* flags to linux/mm_types.h as they're
   no longer referenced by linux/uio.h.
 - Add ITER_SOURCE/DEST cleanup patches.
 - Make iov_iter/netfslib iter extraction patches use ITER_SOURCE/DEST.
 - Allow additional gup_flags to be passed into iov_iter_extract_pages().
 - Add struct bio patch.

ver #3)
 - Switch to using EXPORT_SYMBOL_GPL to prevent indirect 3rd-party access
   to get/pin_user_pages_fast()[1].

ver #2)
 - Rolled the extraction cleanup mode query function into the extraction
   function, returning the indication through the argument list.
 - Fixed patch 4 (extract to scatterlist) to actually use the new
   extraction API.

I've pushed the patches (excluding the two WIP networking patches) here
also:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=iov-extract

David

Link: https://lore.kernel.org/r/Y3zFzdWnWlEJ8X8/@infradead.org/ [1]
Link: https://lore.kernel.org/r/166697254399.61150.1256557652599252121.stgit@warthog.procyon.org.uk/ # rfc
Link: https://lore.kernel.org/r/166722777223.2555743.162508599131141451.stgit@warthog.procyon.org.uk/ # rfc
Link: https://lore.kernel.org/r/166732024173.3186319.18204305072070871546.stgit@warthog.procyon.org.uk/ # rfc
Link: https://lore.kernel.org/r/166869687556.3723671.10061142538708346995.stgit@warthog.procyon.org.uk/ # rfc
Link: https://lore.kernel.org/r/166920902005.1461876.2786264600108839814.stgit@warthog.procyon.org.uk/ # v2
Link: https://lore.kernel.org/r/166997419665.9475.15014699817597102032.stgit@warthog.procyon.org.uk/ # v3
Link: https://lore.kernel.org/r/167305160937.1521586.133299343565358971.stgit@warthog.procyon.org.uk/ # v4
Link: https://lore.kernel.org/r/167344725490.2425628.13771289553670112965.stgit@warthog.procyon.org.uk/ # v5

Previous versions of the CIFS patch sets can be found here:
Link: https://lore.kernel.org/r/164311902471.2806745.10187041199819525677.stgit@warthog.procyon.org.uk/ # rfc
Link: https://lore.kernel.org/r/164928615045.457102.10607899252434268982.stgit@warthog.procyon.org.uk/ # v1
Link: https://lore.kernel.org/r/165211416682.3154751.17287804906832979514.stgit@warthog.procyon.org.uk/ # v1
Link: https://lore.kernel.org/r/165348876794.2106726.9240233279581920208.stgit@warthog.procyon.org.uk/ # v1
Link: https://lore.kernel.org/r/165364823513.3334034.11209090728654641458.stgit@warthog.procyon.org.uk/ # v3
Link: https://lore.kernel.org/r/166126392703.708021.14465850073772688008.stgit@warthog.procyon.org.uk/ # v1
Link: https://lore.kernel.org/r/166697254399.61150.1256557652599252121.stgit@warthog.procyon.org.uk/ # rfc
Link: https://lore.kernel.org/r/166732024173.3186319.18204305072070871546.stgit@warthog.procyon.org.uk/ # rfc


---
David Howells (34):
      vfs: Unconditionally set IOCB_WRITE in call_write_iter()
      iov_iter: Use IOCB/IOMAP_WRITE/op_is_write rather than iterator direction
      iov_iter: Pass I/O direction into iov_iter_get_pages*()
      iov_iter: Remove iov_iter_get_pages2/pages_alloc2()
      iov_iter: Change the direction macros into an enum
      iov_iter: Use the direction in the iterator functions
      iov_iter: Add a function to extract a page list from an iterator
      mm: Provide a helper to drop a pin/ref on a page
      bio: Rename BIO_NO_PAGE_REF to BIO_PAGE_REFFED and invert the meaning
      mm, block: Make BIO_PAGE_REFFED/PINNED the same as FOLL_GET/PIN numerically
      iov_iter, block: Make bio structs pin pages rather than ref'ing if appropriate
      bio: Fix bio_flagged() so that gcc can better optimise it
      netfs: Add a function to extract a UBUF or IOVEC into a BVEC iterator
      netfs: Add a function to extract an iterator into a scatterlist
      af_alg: Pin pages rather than ref'ing if appropriate
      af_alg: [RFC] Use netfs_extract_iter_to_sg() to create scatterlists
      scsi: [RFC] Use netfs_extract_iter_to_sg()
      dio: Pin pages rather than ref'ing if appropriate
      fuse:  Pin pages rather than ref'ing if appropriate
      vfs: Make splice use iov_iter_extract_pages()
      9p: Pin pages rather than ref'ing if appropriate
      nfs: Pin pages rather than ref'ing if appropriate
      cifs: Implement splice_read to pass down ITER_BVEC not ITER_PIPE
      cifs: Add a function to build an RDMA SGE list from an iterator
      cifs: Add a function to Hash the contents of an iterator
      cifs: Add some helper functions
      cifs: Add a function to read into an iter from a socket
      cifs: Change the I/O paths to use an iterator rather than a page list
      cifs: Build the RDMA SGE list directly from an iterator
      cifs: Remove unused code
      cifs: Fix problem with encrypted RDMA data read
      cifs: DIO to/from KVEC-type iterators should now work
      net: [RFC][WIP] Mark each skb_frags as to how they should be cleaned up
      net: [RFC][WIP] Make __zerocopy_sg_from_iter() correctly pin or leave pages unref'd


 block/bio.c               |   48 +-
 block/blk-map.c           |   26 +-
 block/blk.h               |   25 +
 block/fops.c              |    8 +-
 crypto/af_alg.c           |   57 +-
 crypto/algif_hash.c       |   20 +-
 drivers/net/tun.c         |    2 +-
 drivers/vhost/scsi.c      |   75 +-
 fs/9p/vfs_addr.c          |    2 +-
 fs/affs/file.c            |    4 +-
 fs/ceph/addr.c            |    2 +-
 fs/ceph/file.c            |   16 +-
 fs/cifs/Kconfig           |    1 +
 fs/cifs/cifsencrypt.c     |  172 +++-
 fs/cifs/cifsfs.c          |   12 +-
 fs/cifs/cifsfs.h          |    6 +
 fs/cifs/cifsglob.h        |   66 +-
 fs/cifs/cifsproto.h       |   11 +-
 fs/cifs/cifssmb.c         |   13 +-
 fs/cifs/connect.c         |   16 +
 fs/cifs/file.c            | 1851 +++++++++++++++++--------------------
 fs/cifs/fscache.c         |   22 +-
 fs/cifs/fscache.h         |   10 +-
 fs/cifs/misc.c            |  132 +--
 fs/cifs/smb2ops.c         |  374 ++++----
 fs/cifs/smb2pdu.c         |   45 +-
 fs/cifs/smbdirect.c       |  511 ++++++----
 fs/cifs/smbdirect.h       |    4 +-
 fs/cifs/transport.c       |   57 +-
 fs/dax.c                  |    6 +-
 fs/direct-io.c            |   77 +-
 fs/exfat/inode.c          |    6 +-
 fs/ext2/inode.c           |    2 +-
 fs/f2fs/file.c            |   10 +-
 fs/fat/inode.c            |    4 +-
 fs/fuse/dax.c             |    2 +-
 fs/fuse/dev.c             |   24 +-
 fs/fuse/file.c            |   34 +-
 fs/fuse/fuse_i.h          |    1 +
 fs/hfs/inode.c            |    2 +-
 fs/hfsplus/inode.c        |    2 +-
 fs/iomap/direct-io.c      |    6 +-
 fs/jfs/inode.c            |    2 +-
 fs/netfs/Makefile         |    1 +
 fs/netfs/iterator.c       |  371 ++++++++
 fs/nfs/direct.c           |   32 +-
 fs/nilfs2/inode.c         |    2 +-
 fs/ntfs3/inode.c          |    2 +-
 fs/ocfs2/aops.c           |    2 +-
 fs/orangefs/inode.c       |    2 +-
 fs/reiserfs/inode.c       |    2 +-
 fs/splice.c               |   10 +-
 fs/udf/inode.c            |    2 +-
 include/crypto/if_alg.h   |    7 +-
 include/linux/bio.h       |   23 +-
 include/linux/blk_types.h |    3 +-
 include/linux/fs.h        |   11 +
 include/linux/mm.h        |   32 +-
 include/linux/netfs.h     |    6 +
 include/linux/skbuff.h    |  124 ++-
 include/linux/uio.h       |   83 +-
 io_uring/net.c            |    2 +-
 lib/iov_iter.c            |  428 ++++++++-
 mm/gup.c                  |   47 +
 mm/vmalloc.c              |    1 +
 net/9p/trans_common.c     |    6 +-
 net/9p/trans_common.h     |    3 +-
 net/9p/trans_virtio.c     |   91 +-
 net/bpf/test_run.c        |    2 +-
 net/core/datagram.c       |   23 +-
 net/core/gro.c            |    2 +-
 net/core/skbuff.c         |   16 +-
 net/core/skmsg.c          |    4 +-
 net/ipv4/ip_output.c      |    2 +-
 net/ipv4/tcp.c            |    4 +-
 net/ipv6/esp6.c           |    5 +-
 net/ipv6/ip6_output.c     |    2 +-
 net/packet/af_packet.c    |    2 +-
 net/rds/message.c         |    4 +-
 net/tls/tls_sw.c          |    5 +-
 net/xfrm/xfrm_ipcomp.c    |    2 +-
 81 files changed, 3006 insertions(+), 2126 deletions(-)
 create mode 100644 fs/netfs/iterator.c


