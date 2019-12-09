Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0761170B3
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 16:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfLIPlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 10:41:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:40724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbfLIPlF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 10:41:05 -0500
Received: from localhost (unknown [89.205.132.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E023C2073D;
        Mon,  9 Dec 2019 15:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575906064;
        bh=xchqQrFdZC9lF1bCvucvR91oCh8m2y80Hp0P0ydGrDk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T6ptTT5Dvl7Ke0t4vlq8m8f4XwnvIcTx03hZ7ubXpADtuyaQreXvuWT/F3tAUw0iO
         nv0m8FLvmrHqSej/FKphn7MbmX/ckC1wKOZ9PaDgJOXkqAH1c+1QVOtZrqdxcZIKLV
         S5/fZKB6PwdMdpgk8HQYC1Tf4PzP6toHs+047CQY=
Date:   Mon, 9 Dec 2019 16:41:01 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Krzysztof Halasa <khc@pm.waw.pl>, devel@driverdev.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        linux-x25@vger.kernel.org, Kevin Curtis <kevin.curtis@farsite.com>,
        "R.J.Dunlop" <bob.dunlop@farsite.com>,
        Zhao Qiang <qiang.zhao@nxp.com>,
        syzbot+429c200ffc8772bfe070@syzkaller.appspotmail.com,
        syzbot+eec0c87f31a7c3b66f7b@syzkaller.appspotmail.com
Subject: Re: [PATCH 4/4] [RFC] staging/net: move AF_X25 into drivers/staging
Message-ID: <20191209154101.GB1284708@kroah.com>
References: <20191209151256.2497534-1-arnd@arndb.de>
 <20191209151256.2497534-4-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209151256.2497534-4-arnd@arndb.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 04:12:56PM +0100, Arnd Bergmann wrote:
> syzbot keeps finding issues in the X.25 implementation that nobody is
> interested in fixing.  Given that all the x25 patches of the past years
> that are not global cleanups tend to fix user-triggered oopses, is it
> time to just retire the subsystem?
> 
> I looked a bit closer and found:
> 
> - we used to support x25 hardware in linux, but with WAN_ROUTER
>   removed in linux-3.9 and isdn4linux removed in 5.3, there is only hdlc,
>   ethernet and the N_X25 tty ldisc left. Out of these, only HDLC_X25 made
>   it beyond the experimental stage, so this is probably what everyone
>   uses if there are users at all.
> 
> - The most common hdlc hardware that people seem to be using are
>   the "farsync" PCIe and USB adapters. Linux only has drivers for the
>   older PCI devices from that series, but no hardware that works on
>   modern systems.
> 
> - The manufacturer still updates their own kernel drivers and provides
>   support, but ships that with a fork or rewrite of the subsystem
>   code now.  Kevin Curtis is also listed as maintainer, but appears to
>   have given up in 2013 after [1].
> 
> - The most popular software implementation appears to be X25 over TCP
>   (XOT), which is supported by Farsite and other out-of-tree stacks but
>   never had an implementation in mainline.
> 
> - Most other supported HDLC hardware that we supoprt is for the ISA or
>   PCI buses. There are newer PCIe or USB devices, but those all require
>   a custom device driver and often a custom subsystem, none of which got
>   submitted for mainline inclusion. This includes hardware from Microgate
>   (SyncLink), Comtrol (RocketPort Express) and Sealevel (SeaMAC).
> 
> - The X.25 subsystem is listed as "odd fixes", but the last reply on
>   the netdev mailing list from the maintainer was also in 2013[2].
> 
> - The HDLC subsystem itself is listed as maintained by Krzysztof Halasa,
>   and there were new drivers merged for SoC based devices as late as
>   2016 by Zhao Qiang: Freescale/NXP QUICC Engine and Maxim ds26522.
>   There has not been much work on HDLC or drivers/net/wan recently,
>   but both developers are still responsive on the mailing list and
>   work on other parts of the kernel.
> 
> Based on the above, I would conclude that X.25 can probably get moved
> to staging as keeping it in the kernel seems to do more harm than good,
> but HDLC below it should probably stay as there it seems there are still
> users of a small subset of the mainline drivers.
> 
> Move all of X.25 into drivers/staging for now, with a projected removal
> date set for Linux-5.8.
> 
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Andrew Hendry <andrew.hendry@gmail.com>
> Cc: linux-x25@vger.kernel.org
> Cc: Kevin Curtis <kevin.curtis@farsite.com>
> Cc: "R.J.Dunlop" <bob.dunlop@farsite.com>
> Cc: Zhao Qiang <qiang.zhao@nxp.com>
> Cc: Krzysztof Halasa <khc@pm.waw.pl>
> Reported-by: syzbot+429c200ffc8772bfe070@syzkaller.appspotmail.com
> Reported-by: syzbot+eec0c87f31a7c3b66f7b@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?id=5b0ecf0386f56be7fe7210a14d0f62df765c0c39
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ----
> 
> If anyone has different views or additional information, let us know.
> 
> If you agree with the above, please Ack.

ACK!

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
