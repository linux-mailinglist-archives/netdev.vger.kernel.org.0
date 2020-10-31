Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01F8E2A1A46
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 20:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728402AbgJaTcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 15:32:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbgJaTcb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 15:32:31 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A868F206D5;
        Sat, 31 Oct 2020 19:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604172750;
        bh=lKG4qxBnXK/Jqf1CaFvvYJoxmuwssr1+n5QOZM9FPjI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BXLiEnnKgJbBMLLAtfl6hskGkeOnNxf3uHbhNj108y9ur7ifvZ1gy0DaeJTzlF7Gf
         FmtQh/TMX+ppxNfOPyTRYVAgvgjM5PlzDgKPvTB8GqDZEgvtphKBA6f2j204xDIrAD
         Og5z+LpzkvI62as+L8o4jmipNSG1iHiusmm+29uo=
Date:   Sat, 31 Oct 2020 12:32:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: atm: fix update of position index in lec_seq_next
Message-ID: <20201031123228.5040bd7b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201027114925.21843-1-colin.king@canonical.com>
References: <20201027114925.21843-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020 11:49:25 +0000 Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The position index in leq_seq_next is not updated when the next
> entry is fetched an no more entries are available. This causes
> seq_file to report the following error:
> 
> "seq_file: buggy .next function lec_seq_next [lec] did not update
>  position index"
> 
> Fix this by always updating the position index.
> 
> [ Note: this is an ancient 2002 bug, the sha is from the
>   tglx/history repo ]
> 
> Fixes 4aea2cbff417 ("[ATM]: Move lan seq_file ops to lec.c [1/3]")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied, very sneaky there with the lack of a colon on the Fixes tag :)


BTW looking at seq_read() it seems to eat the potential error code from
->next, doesn't it?

@@ -254,9 +254,11 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
        }
        m->op->stop(m, p);
        n = min(m->count, size);
-       err = copy_to_user(buf, m->buf, n);
-       if (err)
-               goto Efault;
+       if (n) {
+               err = copy_to_user(buf, m->buf, n);
+               if (err)
+                       goto Efault;
+       }
        copied += n;
        m->count -= n;
        m->from = n;

Maybe? Or at least:

@@ -239,10 +239,8 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
                                            m->op->next);
                        m->index++;
                }
-               if (!p || IS_ERR(p)) {
-                       err = PTR_ERR(p);
+               if (!p || IS_ERR(p))
                        break;
-               }
                if (m->count >= size)
                        break;
                err = m->op->show(m, p);
