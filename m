Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9F43573FF
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 20:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348450AbhDGSMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 14:12:03 -0400
Received: from sender4-of-o53.zoho.com ([136.143.188.53]:21310 "EHLO
        sender4-of-o53.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbhDGSMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 14:12:01 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1617819092; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=hIET+vkP5dmPn97NsbURGt6u/P5innZOqqCiUyBxr6tHUn0wvDh8ElyaRDDUfHM/SQhn0cXJV/IrFNQTz0/25tm8ZYNbxcxI87yTSVMEZSITH9oNvyVbst99k2/ngB4U4WeZt34g42twllDgY5DUfuXnt0/+kMHFXhe6tgu7WQ4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1617819092; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=HPDfbglZ/V3I5C8pnFpRA/NpXSyDn76KwGMQFvjN01Y=; 
        b=nkD+RTNmr1O8hKLcy2Z/e2rfs2dzE5Dv53g0SkiMx4bAiLEs2I5ICnIVQ2kSDfBQCZaNcpXAt+jmfRYmBF4phhHOSwG0f2geuAZSIwe2GAfqKCr25ApPTxv+nosFFigwSRYI+EGvifPZtkjW6R/dVxhfm3JKnz4yn/7B15XlfDY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=anirudhrb.com;
        spf=pass  smtp.mailfrom=mail@anirudhrb.com;
        dmarc=pass header.from=<mail@anirudhrb.com> header.from=<mail@anirudhrb.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1617819092;
        s=zoho; d=anirudhrb.com; i=mail@anirudhrb.com;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To;
        bh=HPDfbglZ/V3I5C8pnFpRA/NpXSyDn76KwGMQFvjN01Y=;
        b=WGVbPQYU9xwZvXX5jVZMvLz3ue/8BXrbu7I2UCo2lrhxarIrRYon4NajhRFqxIM3
        bYjiBfttFB9JxZGu8sC/JwGJRmTYNYMB7BEKp8kByWjbmo1631QkagbRr3vRzigQjx6
        bwOQ7f+VAwMcMZ70w+bH1pUl+PprqFHIa6H8udeY=
Received: from anirudhrb.com (106.51.107.10 [106.51.107.10]) by mx.zohomail.com
        with SMTPS id 1617819090287293.28816811560955; Wed, 7 Apr 2021 11:11:30 -0700 (PDT)
Date:   Wed, 7 Apr 2021 23:41:21 +0530
From:   Anirudh Rayabharam <mail@anirudhrb.com>
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, oneukum@suse.com, kernel@esmil.dk,
        geert@linux-m68k.org, zhengyongjun3@huawei.com, rkovhaev@gmail.com,
        gregkh@linuxfoundation.org,
        syzbot+c49fe6089f295a05e6f8@syzkaller.appspotmail.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: hso: fix null-ptr-deref during tty device
 unregistration
Message-ID: <YG31yQ+SZLyl/iZJ@anirudhrb.com>
References: <20210406124402.20930-1-mail@anirudhrb.com>
 <20210406.163921.1678926610292877597.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210406.163921.1678926610292877597.davem@davemloft.net>
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 04:39:21PM -0700, David Miller wrote:
> From: Anirudh Rayabharam <mail@anirudhrb.com>
> Date: Tue,  6 Apr 2021 18:13:59 +0530
> 
> > Multiple ttys try to claim the same the minor number causing a double
> > unregistration of the same device. The first unregistration succeeds
> > but the next one results in a null-ptr-deref.
> > 
> > The get_free_serial_index() function returns an available minor number
> > but doesn't assign it immediately. The assignment is done by the caller
> > later. But before this assignment, calls to get_free_serial_index()
> > would return the same minor number.
> > 
> > Fix this by modifying get_free_serial_index to assign the minor number
> > immediately after one is found to be and rename it to obtain_minor()
> > to better reflect what it does. Similary, rename set_serial_by_index()
> > to release_minor() and modify it to free up the minor number of the
> > given hso_serial. Every obtain_minor() should have corresponding
> > release_minor() call.
> > 
> > Reported-by: syzbot+c49fe6089f295a05e6f8@syzkaller.appspotmail.com
> > Tested-by: syzbot+c49fe6089f295a05e6f8@syzkaller.appspotmail.com
> > 
> > Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
> 
> This adds a new build warning:
> 
>   CC [M]  drivers/net/usb/hso.o
> drivers/net/usb/hso.c: In function ‘hso_serial_common_create’:
> drivers/net/usb/hso.c:2256:6: warning: unused variable ‘minor’ [-Wunused-variable]
> 
> Please fix this and add an appropriate Fixes: tag, thank you.

I have sent out a v2 with these changes.

Thanks!

	- Anirudh.
