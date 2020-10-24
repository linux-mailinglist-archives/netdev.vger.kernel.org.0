Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC024297DC6
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 19:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762630AbgJXRgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Oct 2020 13:36:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:45310 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762594AbgJXRgo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Oct 2020 13:36:44 -0400
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 09OHTAUE029400;
        Sat, 24 Oct 2020 12:29:10 -0500
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 09OHT4g2029397;
        Sat, 24 Oct 2020 12:29:04 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Sat, 24 Oct 2020 12:29:03 -0500
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        David Hildenbrand <david@redhat.com>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "'Greg KH'" <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: Buggy commit tracked to: "Re: [PATCH 2/9] iov_iter: move rw_copy_check_uvector() into lib/iov_iter.c"
Message-ID: <20201024172903.GK2672@gate.crashing.org>
References: <20201022104805.GA1503673@kroah.com> <20201022121849.GA1664412@kroah.com> <98d9df88-b7ef-fdfb-7d90-2fa7a9d7bab5@redhat.com> <20201022125759.GA1685526@kroah.com> <20201022135036.GA1787470@kroah.com> <134f162d711d466ebbd88906fae35b33@AcuMS.aculab.com> <935f7168-c2f5-dd14-7124-412b284693a2@redhat.com> <20201023175857.GA3576660@ZenIV.linux.org.uk> <20201023182713.GG2672@gate.crashing.org> <e9a3136ead214186877804aabde74b38@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9a3136ead214186877804aabde74b38@AcuMS.aculab.com>
User-Agent: Mutt/1.4.2.3i
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 09:28:59PM +0000, David Laight wrote:
> From: Segher Boessenkool
> > Sent: 23 October 2020 19:27
> > On Fri, Oct 23, 2020 at 06:58:57PM +0100, Al Viro wrote:
> > > On Fri, Oct 23, 2020 at 03:09:30PM +0200, David Hildenbrand wrote:
> > > On arm64 when callee expects a 32bit argument, the caller is *not* responsible
> > > for clearing the upper half of 64bit register used to pass the value - it only
> > > needs to store the actual value into the lower half.  The callee must consider
> > > the contents of the upper half of that register as undefined.  See AAPCS64 (e.g.
> > > https://github.com/ARM-software/abi-aa/blob/master/aapcs64/aapcs64.rst#parameter-passing-rules
> > > ); AFAICS, the relevant bit is
> > > 	"Unlike in the 32-bit AAPCS, named integral values must be narrowed by
> > > the callee rather than the caller."
> > 
> > Or the formal rule:
> > 
> > C.9 	If the argument is an Integral or Pointer Type, the size of the
> > 	argument is less than or equal to 8 bytes and the NGRN is less
> > 	than 8, the argument is copied to the least significant bits in
> > 	x[NGRN]. The NGRN is incremented by one. The argument has now
> > 	been allocated.
> 
> So, in essence, if the value is in a 64bit register the calling
> code is independent of the actual type of the formal parameter.
> Clearly a value might need explicit widening.

No, this says that if you pass a 32-bit integer in a 64-bit register,
then the top 32 bits of that register hold an undefined value.

> I've found a copy of the 64 bit arm instruction set.
> Unfortunately it is alpha sorted and repetitive so shows none
> of the symmetry and makes things difficult to find.

All of this is ABI, not ISA.  Look at the AAPCS64 pointed to above.

> But, contrary to what someone suggested most register writes
> (eg from arithmetic) seem to zero/extend the high bits.

Everything that writes a "w" does, yes.  But that has nothing to do with
the parameter passing rules, that is ABI.  It just means that very often
a 32-bit integer will be passed zero-extended in a 64-bit register, but
that is just luck (or not, it makes finding bugs harder ;-) )


Segher
