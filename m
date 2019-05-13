Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F08841B733
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 15:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbfEMNlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 09:41:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:50576 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727413AbfEMNlZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 09:41:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 76755AC38;
        Mon, 13 May 2019 13:41:23 +0000 (UTC)
Message-ID: <1557754110.2793.7.camel@suse.com>
Subject: Re: KASAN: use-after-free Read in p54u_load_firmware_cb
From:   Oliver Neukum <oneukum@suse.com>
To:     syzbot <syzbot+200d4bb11b23d929335f@syzkaller.appspotmail.com>,
        kvalo@codeaurora.org, davem@davemloft.net, andreyknvl@google.com,
        syzkaller-bugs@googlegroups.com, chunkeey@googlemail.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Michael Wu <flamingice@sourmilk.net>
Date:   Mon, 13 May 2019 15:28:30 +0200
In-Reply-To: <00000000000073512b0588c24d09@google.com>
References: <00000000000073512b0588c24d09@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mo, 2019-05-13 at 03:23 -0700, syzbot wrote:
> syzbot has found a reproducer for the following crash on:
> 
> HEAD commit:    43151d6c usb-fuzzer: main usb gadget fuzzer driver
> git tree:       https://github.com/google/kasan.git usb-fuzzer
> console output: https://syzkaller.appspot.com/x/log.txt?x=16b64110a00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=4183eeef650d1234
> dashboard link: https://syzkaller.appspot.com/bug?extid=200d4bb11b23d929335f
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1634c900a00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+200d4bb11b23d929335f@syzkaller.appspotmail.com
> 
> usb 1-1: config 0 descriptor??
> usb 1-1: reset high-speed USB device number 2 using dummy_hcd
> usb 1-1: device descriptor read/64, error -71
> usb 1-1: Using ep0 maxpacket: 8
> usb 1-1: Loading firmware file isl3887usb
> usb 1-1: Direct firmware load for isl3887usb failed with error -2
> usb 1-1: Firmware not found.
> ==================================================================
> BUG: KASAN: use-after-free in p54u_load_firmware_cb.cold+0x97/0x13a  
> drivers/net/wireless/intersil/p54/p54usb.c:936
> Read of size 8 at addr ffff88809803f588 by task kworker/1:0/17

Hi,

it looks to me as if refcounting is broken.
You should have a usb_put_dev() in p54u_load_firmware_cb() or in
p54u_disconnect(), but not both.

	Regards
		Oliver

