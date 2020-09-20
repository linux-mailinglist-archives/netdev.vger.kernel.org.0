Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2BDE271727
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 20:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgITSmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 14:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgITSmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 14:42:06 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B81C061755;
        Sun, 20 Sep 2020 11:42:05 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kK4Hd-002cE4-T4; Sun, 20 Sep 2020 18:41:58 +0000
Date:   Sun, 20 Sep 2020 19:41:57 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
Message-ID: <20200920184157.GP3421308@ZenIV.linux.org.uk>
References: <20200918124533.3487701-1-hch@lst.de>
 <20200918124533.3487701-2-hch@lst.de>
 <20200920151510.GS32101@casper.infradead.org>
 <20200920180742.GN3421308@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200920180742.GN3421308@ZenIV.linux.org.uk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 20, 2020 at 07:07:42PM +0100, Al Viro wrote:

> /proc/bus/input/devices (fucked bitmap-to-text representation)

To illustrate the, er, beauty of that stuff:

; cat32 /proc/bus/input/devices >/tmp/a
; cat /proc/bus/input/devices >/tmp/b
; diff -u /tmp/a /tmp/b|grep '^[-+]'
--- /tmp/a      2020-09-20 14:28:43.442560691 -0400
+++ /tmp/b      2020-09-20 14:28:49.018543230 -0400
-B: KEY=1100f 2902000 8380307c f910f001 feffffdf ffefffff ffffffff fffffffe
+B: KEY=1100f02902000 8380307cf910f001 feffffdfffefffff fffffffffffffffe
-B: KEY=70000 0 0 0 0 0 0 0 0
+B: KEY=70000 0 0 0 0
-B: KEY=420 0 70000 0 0 0 0 0 0 0 0
+B: KEY=420 70000 0 0 0 0
-B: KEY=100000 0 0 0
+B: KEY=10000000000000 0
-B: KEY=4000 0 0 0 0
+B: KEY=4000 0 0
-B: KEY=8000 0 0 0 0 0 1100b 800 2 200000 0 0 0 0
+B: KEY=800000000000 0 0 1100b00000800 200200000 0 0
-B: KEY=3e000b 0 0 0 0 0 0 0
+B: KEY=3e000b00000000 0 0 0
-B: KEY=ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff fffffffe
+B: KEY=ffffffffffffffff ffffffffffffffff ffffffffffffffff fffffffffffffffe
; 
(cat32 being a 32bit binary of cat)
All the differences are due to homegrown bitmap-to-text conversion.

Note that feeding that into a pipe leaves the recepient with a lovely problem -
you can't go by the width of words (they are not zero-padded) and you can't
go by the number of words either - it varies from device to device.

And there's nothing we can do with that - it's a userland ABI, can't be
changed without breaking stuff.  I would prefer to avoid additional examples
like that, TYVM...
