Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC51271531
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 17:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgITPDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 11:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgITPC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 11:02:58 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77085C061755;
        Sun, 20 Sep 2020 08:02:58 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kK0rT-002VoG-Vd; Sun, 20 Sep 2020 15:02:44 +0000
Date:   Sun, 20 Sep 2020 16:02:43 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        David Howells <dhowells@redhat.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>, io-uring@vger.kernel.org,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Networking <netdev@vger.kernel.org>, keyrings@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
Message-ID: <20200920150243.GM3421308@ZenIV.linux.org.uk>
References: <20200918124533.3487701-1-hch@lst.de>
 <20200918124533.3487701-2-hch@lst.de>
 <20200918134012.GY3421308@ZenIV.linux.org.uk>
 <20200918134406.GA17064@lst.de>
 <20200918135822.GZ3421308@ZenIV.linux.org.uk>
 <20200918151615.GA23432@lst.de>
 <20200919220920.GI3421308@ZenIV.linux.org.uk>
 <CAK8P3a3QApj3isPu3TkLahArsfb5jaABb7DJ7EKMxey1T1YPbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a3QApj3isPu3TkLahArsfb5jaABb7DJ7EKMxey1T1YPbA@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 20, 2020 at 03:55:47PM +0200, Arnd Bergmann wrote:
> On Sun, Sep 20, 2020 at 12:09 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Fri, Sep 18, 2020 at 05:16:15PM +0200, Christoph Hellwig wrote:
> > > On Fri, Sep 18, 2020 at 02:58:22PM +0100, Al Viro wrote:
> > > > Said that, why not provide a variant that would take an explicit
> > > > "is it compat" argument and use it there?  And have the normal
> > > > one pass in_compat_syscall() to that...
> > >
> > > That would help to not introduce a regression with this series yes.
> > > But it wouldn't fix existing bugs when io_uring is used to access
> > > read or write methods that use in_compat_syscall().  One example that
> > > I recently ran into is drivers/scsi/sg.c.
> >
> > So screw such read/write methods - don't use them with io_uring.
> > That, BTW, is one of the reasons I'm sceptical about burying the
> > decisions deep into the callchain - we don't _want_ different
> > data layouts on read/write depending upon the 32bit vs. 64bit
> > caller, let alone the pointer-chasing garbage that is /dev/sg.
> 
> Would it be too late to limit what kind of file descriptors we allow
> io_uring to read/write on?
> 
> If io_uring can get changed to return -EINVAL on trying to
> read/write something other than S_IFREG file descriptors,
> that particular problem space gets a lot simpler, but this
> is of course only possible if nobody actually relies on it yet.

S_IFREG is almost certainly too heavy as a restriction.  Looking through
the stuff sensitive to 32bit/64bit, we seem to have
	* /dev/sg - pointer-chasing horror
	* sysfs files for efivar - different layouts for compat and native,
shitty userland ABI design (
struct efi_variable {
        efi_char16_t  VariableName[EFI_VAR_NAME_LEN/sizeof(efi_char16_t)];
        efi_guid_t    VendorGuid;
        unsigned long DataSize;
        __u8          Data[1024];
        efi_status_t  Status;
        __u32         Attributes;
} __attribute__((packed));
) is the piece of crap in question; 'DataSize' is where the headache comes
from.  Regular files, BTW...
	* uhid - character device, milder pointer-chasing horror.  Trouble
comes from this:
/* Obsolete! Use UHID_CREATE2. */
struct uhid_create_req {
        __u8 name[128];
        __u8 phys[64];
        __u8 uniq[64];
        __u8 __user *rd_data;
        __u16 rd_size;

        __u16 bus;
        __u32 vendor;
        __u32 product;
        __u32 version;
        __u32 country;
} __attribute__((__packed__));
and suggested replacement doesn't do any pointer-chasing (rd_data is an
embedded array in the end of struct uhid_create2_req).
	* evdev, uinput - bitness-sensitive layout, due to timestamps
	* /proc/bus/input/devices - weird crap with printing bitmap, different
_text_ layouts seen by 32bit and 64bit readers.  Binary structures are PITA,
but with sufficient effort you can screw the text just as hard...  Oh, and it's
a regular file.
	* similar in sysfs analogue

And AFAICS, that's it for read/write-related method instances.
