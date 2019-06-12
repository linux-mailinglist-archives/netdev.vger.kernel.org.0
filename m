Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8C7542E4D
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 20:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727373AbfFLSFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 14:05:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39342 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfFLSFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 14:05:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7591F152788C1;
        Wed, 12 Jun 2019 11:05:48 -0700 (PDT)
Date:   Wed, 12 Jun 2019 11:05:47 -0700 (PDT)
Message-Id: <20190612.110547.28991361423569318.davem@davemloft.net>
To:     john.fastabend@gmail.com
Cc:     steinar+kernel@gunderson.no, daniel@iogearbox.net, andre@tomt.net,
        netdev@vger.kernel.org, ast@kernel.org
Subject: Re: [net PATCH v2] net: tls, correctly account for copied bytes
 with multiple sk_msgs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <156036023770.7273.14464005268434910852.stgit@ubuntu-kvm1>
References: <156036023770.7273.14464005268434910852.stgit@ubuntu-kvm1>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Jun 2019 11:05:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>
Date: Wed, 12 Jun 2019 17:23:57 +0000

> tls_sw_do_sendpage needs to return the total number of bytes sent
> regardless of how many sk_msgs are allocated. Unfortunately, copied
> (the value we return up the stack) is zero'd before each new sk_msg
> is allocated so we only return the copied size of the last sk_msg used.
> 
> The caller (splice, etc.) of sendpage will then believe only part
> of its data was sent and send the missing chunks again. However,
> because the data actually was sent the receiver will get multiple
> copies of the same data.
> 
> To reproduce this do multiple sendfile calls with a length close to
> the max record size. This will in turn call splice/sendpage, sendpage
> may use multiple sk_msg in this case and then returns the incorrect
> number of bytes. This will cause splice to resend creating duplicate
> data on the receiver. Andre created a C program that can easily
> generate this case so we will push a similar selftest for this to
> bpf-next shortly.
> 
> The fix is to _not_ zero the copied field so that the total sent
> bytes is returned.
> 
> Reported-by: Steinar H. Gunderson <steinar+kernel@gunderson.no>
> Reported-by: Andre Tomt <andre@tomt.net>
> Tested-by: Andre Tomt <andre@tomt.net>
> Fixes: d829e9c4112b ("tls: convert to generic sk_msg interface")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Applied and queued up for -stable.
