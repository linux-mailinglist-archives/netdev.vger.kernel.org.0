Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A29567757
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 02:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbfGMAum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 20:50:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35388 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727236AbfGMAum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 20:50:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 67C7214E32590;
        Fri, 12 Jul 2019 17:50:41 -0700 (PDT)
Date:   Fri, 12 Jul 2019 17:50:38 -0700 (PDT)
Message-Id: <20190712.175038.755685144649934618.davem@davemloft.net>
To:     cai@lca.pw
Cc:     sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        arnd@arndb.de, dhowells@redhat.com, hpa@zytor.com,
        netdev@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] be2net: fix adapter->big_page_size miscaculation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <EFD25845-097A-46B1-9C1A-02458883E4DA@lca.pw>
References: <1562959401-19815-1-git-send-email-cai@lca.pw>
        <20190712.154606.493382088615011132.davem@davemloft.net>
        <EFD25845-097A-46B1-9C1A-02458883E4DA@lca.pw>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Jul 2019 17:50:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qian Cai <cai@lca.pw>
Date: Fri, 12 Jul 2019 20:27:09 -0400

> Actually, GCC would consider it a const with -O2 optimized level because it found that it was never modified and it does not understand it is a module parameter. Considering the following code.
> 
> # cat const.c 
> #include <stdio.h>
> 
> static int a = 1;
> 
> int main(void)
> {
> 	if (__builtin_constant_p(a))
> 		printf("a is a const.\n");
> 
> 	return 0;
> }
> 
> # gcc -O2 const.c -o const

That's not a complete test case, and with a proper test case that
shows the externalization of the address of &a done by the module
parameter macros, gcc should not make this optimization or we should
define the module parameter macros in a way that makes this properly
clear to the compiler.

It makes no sense to hack around this locally in drivers and other
modules.

Thank you.
