Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89EE526A797
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 16:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbgIOOyk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 15 Sep 2020 10:54:40 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:36670 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727270AbgIOOyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 10:54:15 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-170-Vmfa8msMO7ujZNhOLACOTA-1; Tue, 15 Sep 2020 15:53:56 +0100
X-MC-Unique: Vmfa8msMO7ujZNhOLACOTA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 15 Sep 2020 15:53:55 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 15 Sep 2020 15:53:55 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 0/9 next] Changes to code that reads iovec from userspace
Thread-Topic: [PATCH 0/9 next] Changes to code that reads iovec from userspace
Thread-Index: AdaLbm9Qca9t5oGhTxOmCTQi7ZvXMg==
Date:   Tue, 15 Sep 2020 14:53:55 +0000
Message-ID: <a7d3fd12c89241ebba0310d1e65d2449@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0.003
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


The canonical code to read iov[] from userspace is currently:
	struct iovec iovstack[UIO_FASTIOV];
	struct iovec *iov;
	...
	iov = iovstack;
	rc = import_iovec(..., UIO_FASTIOV, &iov, &iter);
	if (rc < 0)
		return rc;
	...
	kfree(iov);

Note that the 'iov' parameter is used for two different things.
On input it is an iov[] that can be used.
On output it is an iov[] array that must be freed.

If 'iovstack' is passed, the count is actually always UIO_FASTIOV (8)
although in some places the array definition is in a different file
(never mind function) from the constant used.

import_iovec() itself is just a wrapper to rw_copy_check_uvector().
So everything is passed through to a second function.
Several items are 'passed by reference' - adding to the code paths.

On success import_iovec() returned the transfer count.
Only one caller looks at it, the count is also in iter.count.

The new canonical code is:
	struct iov_cache cache;
	struct iovec *iov;
	...
	iov = iovec_import(..., &cache, &iter);
	if (IS_ERR(iov))
		return PTR_ERR(iov);
	...
	kfree(iov);

Since 'struct iov_cache' is a fixed size there is no need to pass in
a length (correct or not!). It can still be NULL (used by the scsi code).

iovec_import() contains the code that used to be in rw_copy_check_uvector()
and then sets up the iov_iter.

rw_copy_check_uvector() is no more.
The only other caller was in mm/process_vm_access.c when reading the
iov[] for the target process addresses when copying from a different process.
This can extract the iov[] from an extra 'struct iov_iter'.

In passing I noticed an access_ok() call on each fragment.
I hope this is just there to bail out early!
It is also skipped in process_vm_rw(). I did a quick look but couldn't
see an obvious equivalent check.

I've only done minimal changes to fs/io_uring.c
Once it has been converted to use iovec_import() the import_iovec()
functions can be deleted.

Patches 1, 2 and 3 need to be applied first.
Patches 4 to 9 can be applied in any order.

There should be measurable (if small) improvements to the recvmmsg() and
sendmmsg() system calls.

David Laight (9):
  1) mm:process_vm_access Call import_iovec() instead of rw_copy_check_uvector()
  2) fs: Move rw_copy_check_uvector() into lib/iov_iter.c and make static.
  3) lib/iov_iter: Improved function for importing iovec[] from userpace.
  4) fs/io_uring Don't use the return value from import_iovec().
  5) scsi: Use iovec_import() instead of import_iovec().
  6) security/keys: Use iovec_import() instead of import_iovec().
  7) mm/process_vm_access: Use iovec_import() instead of import_iovec().
  8) fs: Use iovec_import() instead of import_iovec().
  9) net/socket: Use iovec_import() instead of import_iovec().

 block/scsi_ioctl.c     |  14 ++-
 drivers/scsi/sg.c      |  14 +--
 fs/aio.c               |  34 +++---
 fs/io_uring.c          |  21 ++--
 fs/read_write.c        | 248 ++++++-----------------------------------
 fs/splice.c            |  22 ++--
 include/linux/compat.h |   6 -
 include/linux/fs.h     |   5 -
 include/linux/socket.h |  15 +--
 include/linux/uio.h    |  14 +++
 include/net/compat.h   |   5 +-
 lib/iov_iter.c         | 200 +++++++++++++++++++++++++++++----
 mm/process_vm_access.c |  82 +++++++-------
 net/compat.c           |  17 ++-
 net/socket.c           |  66 +++++------
 security/keys/compat.c |  11 +-
 security/keys/keyctl.c |  10 +-
 17 files changed, 386 insertions(+), 398 deletions(-)

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

