Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F36B3F3C16
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 00:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbfKGXVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 18:21:20 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49756 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725924AbfKGXVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 18:21:20 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 579D415370B6A;
        Thu,  7 Nov 2019 15:21:19 -0800 (PST)
Date:   Thu, 07 Nov 2019 15:21:18 -0800 (PST)
Message-Id: <20191107.152118.922830217121663373.davem@davemloft.net>
To:     tranmanphong@gmail.com
Cc:     syzbot+7dc7c28d4577bbe55b10@syzkaller.appspotmail.com,
        gregkh@linuxfoundation.org, glider@google.com,
        hslester96@gmail.com, kstewart@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] usb: asix: Fix uninit-value in asix_mdio_write
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191107004404.23707-1-tranmanphong@gmail.com>
References: <0000000000009763320594f993ee@google.com>
        <20191107004404.23707-1-tranmanphong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 15:21:19 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phong Tran <tranmanphong@gmail.com>
Date: Thu,  7 Nov 2019 07:44:04 +0700

> The local variables use without initilization value.
> This fixes the syzbot report.
> 
> Reported-by: syzbot+7dc7c28d4577bbe55b10@syzkaller.appspotmail.com
> 
> Test result:
> 
> https://groups.google.com/d/msg/syzkaller-bugs/3H_n05x_sPU/sUoHhxgAAgAJ
> 
> Signed-off-by: Phong Tran <tranmanphong@gmail.com>

There are several more situations in this file where the data blob passed
to asix_read_cmd() is read without pre-initialization not checking the
return value from asix_read_cmd().

So, syzbot can see some of them but not all of them, yet all of them
are buggy and should be fixed.

These kinds of patches drive me absolutely crazy :-)

Really, one of two things needs to happen, either asix_read_cmd() clears
the incoming buffer unconditionally, or these call sites strictly must
check the return value always before accessing the buffer after the call.

I'm not applying this, sorry.
