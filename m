Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9832496CB2
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 15:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233896AbiAVOPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 09:15:49 -0500
Received: from kylie.crudebyte.com ([5.189.157.229]:57167 "EHLO
        kylie.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233792AbiAVOPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 09:15:48 -0500
X-Greylist: delayed 2479 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Jan 2022 09:15:48 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=7tVvPw1gbjN1VQGvs1wPWPfPeY44jYM8vCN3iw8Q8mY=; b=YG2T92gSjy+9+Cr1l2pEg96PqR
        wdnblpAX9r7DdwUX0H2932PXncxDoVmjkBRj7lyk4MYltQqsL7Vunl5dUuCysWPnpHSm0I4p05W2q
        C/F8XcrDr4WDDViTQziHwY9E2ig4yi38HFaOZuoRHPzjhxYrQnQ747Z6havpuTqS09WjQpm4BY4uW
        PZjNhi47rWkP5SzQ6EwORGTLxmQPYFg9oLjlv4TKyE+LwH7UElwe7KHQY2kqjCSIOcGe3jwWNL6tW
        OD0imTgWnjXZ9ddxbSMPP1KwSBURhTJiJ4GDcR7f/ahteL2VyQQvMEM0DdUp+9dPt4vj7uADBvETh
        mr25wlrUiStenSnOmJTm5I9QgJfVV2O+nJxR1FyX1yyC7L7Zd4jkCzPQn3eOXoUBZpOjcRyhVWM4P
        EI7+swDZG4xad/3/G/H50TyIIRCZp9Br+4GWuIg1gZcyoITpA6dgsKPRa0oCMwlurhauiUtaK+Nwe
        MFa7d23OJfJBf3/aPqvxNyo0Al53ZWBN2pajyfZa3qSoMFXSmyMc23jCMh75IQnHOcQ6O7to11hzb
        SdKeks++Z7D4Q+P5NweXRJotLW/z1r6ksoQInKUc/NelApP8DaJeTXIuFopJu0T8PNFF+1If+HEuU
        gAZdKavfGy3HFtymHBOfBd73s1g6nj519aR+Ecdzk=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Nikolay Kichukov <nikolay@oldum.net>
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v4 00/12] remove msize limit in virtio transport
Date:   Sat, 22 Jan 2022 14:34:24 +0100
Message-ID: <1835287.xbJIPCv9Fc@silver>
In-Reply-To: <29a54acefd1c37d9612613d5275e4bf51e62a704.camel@oldum.net>
References: <cover.1640870037.git.linux_oss@crudebyte.com> <29a54acefd1c37d9612613d5275e4bf51e62a704.camel@oldum.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Donnerstag, 20. Januar 2022 23:43:46 CET Nikolay Kichukov wrote:
> Thanks for the patches. I've applied them on top of 5.16.2 kernel and it
> works for msize=1048576. Performance-wise, same throughput as the
> previous patches, basically limiting factor is the backend block
> storage.

Depends on how you were testing exactly. I assume you just booted a guest and 
then mounted a humble 9p directory in guest to perform some isolated I/O 
throughput tests on a single file. In this test scenario yes, you would not 
see much of a difference between v3 vs. v4 of this series.

However in my tests I went much further than that by running an entire guest 
on top of 9p as its root filesystem:
https://wiki.qemu.org/Documentation/9p_root_fs
With this 9p rootfs setup you get a completely different picture. For instance 
you'll notice with v3 that guest boot time *increases* with rising msize, 
whereas with v4 it shrinks. And also when you benchmark throughput on a file 
in this 9p rootfs setup with v3 you get worse results than with v4, sometimes 
with v3 even worse than without patches at all. With v4 applied though it 
clearly outperforms any other kernel version in all aspects.

I highly recommend this 9p rootfs setup as a heterogenous 9p test environment, 
as it is a very good real world test scenario for all kinds of aspects.

> However, when I mount with msize=4194304, the system locks up upon first
> try to traverse the directory structure, ie 'ls'. Only solution is to
> 'poweroff' the guest. Nothing in the logs.

I've described this in detail in the cover letter under "KNOWN LIMITATIONS" 
already. Use max. msize 4186112.

> Qemu 6.0.0 on the host has the following patches:
> 
> 01-fix-wrong-io-block-size-Rgetattr.patch
> 02-dedupe-iounit-code.patch
> 03-9pfs-simplify-blksize_to_iounit.patch

I recommend just using QEMU 6.2. It is not worth to patch that old QEMU 
version. E.g. you would have a lousy readdir performance with that QEMU 
version and what not.

You don't need to install QEMU. You can directly run it from the build 
directory.

> The kernel patches were applied on the guest kernel only.
> 
> I've generated them with the following command:
> git diff
> 783ba37c1566dd715b9a67d437efa3b77e3cd1a7^..8c305df4646b65218978fc6474aa0f5f
> 29b216a0 > /tmp/kernel-5.16-9p-virtio-drop-msize-cap.patch
> 
> The host runs 5.15.4 kernel.

Host kernel version currently does not matter for this series.

Best regards,
Christian Schoenebeck


