Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBCC6355606
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 16:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344891AbhDFOFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 10:05:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:38714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344879AbhDFOFP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 10:05:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 525E56120E;
        Tue,  6 Apr 2021 14:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617717906;
        bh=lw4vTBvaD2dSp+I5hbwJFvQTjPmOaXrvQxrqmXgTIVo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h0bnLoci3nn5HDWPukyy+6INDZ9bbURogfPOtRQ1+besCutUHlJ2tWHgaWQaiEraQ
         6ncUGupbBwfilL5xJcEC+qzZGzxEn0yadao2B3y7ebeacg6UGdOYxfGu410DLpeYUZ
         LSeeODNJ2ZJcgn+y2VJtcmLHyRGCUr0Sawn7GaGs=
Date:   Tue, 6 Apr 2021 16:05:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Anirudh Rayabharam <mail@anirudhrb.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Rustam Kovhaev <rkovhaev@gmail.com>,
        syzbot+c49fe6089f295a05e6f8@syzkaller.appspotmail.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: hso: fix null-ptr-deref during tty device
 unregistration
Message-ID: <YGxqj1ow9F7kWi98@kroah.com>
References: <20210406124402.20930-1-mail@anirudhrb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406124402.20930-1-mail@anirudhrb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 06:13:59PM +0530, Anirudh Rayabharam wrote:
> Multiple ttys try to claim the same the minor number causing a double
> unregistration of the same device. The first unregistration succeeds
> but the next one results in a null-ptr-deref.
> 
> The get_free_serial_index() function returns an available minor number
> but doesn't assign it immediately. The assignment is done by the caller
> later. But before this assignment, calls to get_free_serial_index()
> would return the same minor number.
> 
> Fix this by modifying get_free_serial_index to assign the minor number
> immediately after one is found to be and rename it to obtain_minor()
> to better reflect what it does. Similary, rename set_serial_by_index()
> to release_minor() and modify it to free up the minor number of the
> given hso_serial. Every obtain_minor() should have corresponding
> release_minor() call.
> 
> Reported-by: syzbot+c49fe6089f295a05e6f8@syzkaller.appspotmail.com
> Tested-by: syzbot+c49fe6089f295a05e6f8@syzkaller.appspotmail.com
> 
> Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
