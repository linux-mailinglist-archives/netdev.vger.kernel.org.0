Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9A95148B68
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 16:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389035AbgAXPp7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 24 Jan 2020 10:45:59 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:48564 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388998AbgAXPp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 10:45:58 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-238-yQyDz7T5ML2swfnlsqBw5A-1; Fri, 24 Jan 2020 15:45:55 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 24 Jan 2020 15:45:55 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 24 Jan 2020 15:45:55 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: [PATCH 0/3] Optimisation to the 'iovec' copying code.
Thread-Topic: [PATCH 0/3] Optimisation to the 'iovec' copying code.
Thread-Index: AdXSzLdCIXddClTYRDaPG9z9um5Vvg==
Date:   Fri, 24 Jan 2020 15:45:55 +0000
Message-ID: <d7ebb566c0ea4936aac5af2cea89efe2@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: yQyDz7T5ML2swfnlsqBw5A-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While looking at the difference between the costs of recvfrom()
and recvmsg() (which is more than one might hope) I noticed that
the code that handles user-space SG requests can be optimised.

Patch 0001 changes the definition of the on-stack cache for short
iovec[] from a variable sized array to a structure containing a
fixed size array.
This has a couple of advantages:
- It is no longer necessary to pass the array size through.
- The compiler (effectively) validates that the supplied buffer
  is of the specified size.
(Some of the existing code doesn't pass the size through all the
layers of function call.)

This lets patch 0002 xhange the code safey use _copy_from_user()
to read in the iovec[] array as the code has just verified it fits
in the (now fixed size) on-stack buffer or in the just-kmalloc()ed one.

Patch 0003 replaces the kfree(iov) in the callers of import_iovec()
with 'if (unlikely(iov)) kfree(iov)' since it is very unusual
for the iov to have actually been allocated and these are common paths.
It is independent of the other patches and could be split in three.

Additional improvements are possible:
- Change the success return value of import_iovec() to be the address
  of the iov[] to kfree() (not the total length).
  The total length can be got from iter->count, most callers ignore it.
- Inline rw_copy_check_uvector() into import_iovec.
  The only other user is in mm/process_vm_access.c (copying to/from
  another process) and the extra iov_iter_init() for the 'other'
  process buffer would do no harm.
- Replace a lot of the copy_to/from_user() in net/socket.c with the '_'
  variants to avoid the overheads of HARDENED_USERCOPY.
  Most of the copies are validated by the code, but are variable sized
  so HARDENED_USERCOPY does extra checks.
  These are definitely measurable.

The problem with patch 0001 (and any other changes to the interface to
import_iovec()) is I'm not sure who would take them?
I can 'cook up' a patch to change the return value of import_iovec()
to remove the 'pass pointer by reference' on top of path 0001
- if someone will take it.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

