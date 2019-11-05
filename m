Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C691EFF02
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 14:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389349AbfKENvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 08:51:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:38298 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389227AbfKENvW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 08:51:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5C698B1BD;
        Tue,  5 Nov 2019 13:51:20 +0000 (UTC)
Message-ID: <1572961879.2921.13.camel@suse.com>
Subject: Re: KMSAN: uninit-value in cdc_ncm_set_dgram_size
From:   Oliver Neukum <oneukum@suse.com>
To:     =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     syzbot <syzbot+0631d878823ce2411636@syzkaller.appspotmail.com>,
        davem@davemloft.net, glider@google.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Date:   Tue, 05 Nov 2019 14:51:19 +0100
In-Reply-To: <875zjy33z2.fsf@miraculix.mork.no>
References: <00000000000013c4c1059625a655@google.com>
         <87ftj32v6y.fsf@miraculix.mork.no> <1572952516.2921.6.camel@suse.com>
         <875zjy33z2.fsf@miraculix.mork.no>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Dienstag, den 05.11.2019, 13:25 +0100 schrieb Bjørn Mork:
> Oliver Neukum <oneukum@suse.com> writes:
> > Am Montag, den 04.11.2019, 22:22 +0100 schrieb Bjørn Mork:

> Ah, OK. So that could be fixed with e.g.
> 
>   if (err < 2)
>        goto out;
> 
> 
> Or would it be better to add a strict length checking variant of this
> API?  There are probably lots of similar cases where we expect a

We would lose flexibilty and the check needs to be there anyway.

> Right.  And probably all 16 or 32 bit integer reads...
> 
> Looking at the NCM spec, I see that the wording is annoyingly flexible
> wrt length - both ways.  E.g for GetNetAddress:
> 
>   To get the entire network address, the host should set wLength to at
>   least 6. The function shall never return more than 6 bytes in response
>   to this command.
> 
> Maybe the correct fix is simply to let usbnet_read_cmd() initialize the
> full buffer regardless of what the device returns?  I.e.

This issue has never been observed in the wild. We are defending
against a possible attack. It is better to react drastically.

> at do you think?
> 
> Personally, I don't think it makes sense for a device to return a 1-byte
> mtu or 3-byte mac address. But the spec allows it and this would at
> least make it safe.

Hence we should ignore such a reply. The support is optional anyway.
For usbnet as such, however, we cannot really hardcode the size of
a MAC.

	Regards
		Oliver

