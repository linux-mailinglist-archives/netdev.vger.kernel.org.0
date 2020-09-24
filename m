Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94EC2276598
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 03:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgIXBGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 21:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIXBGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 21:06:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80AD0C0613CE;
        Wed, 23 Sep 2020 18:06:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3419B126BAF37;
        Wed, 23 Sep 2020 17:49:29 -0700 (PDT)
Date:   Wed, 23 Sep 2020 18:06:15 -0700 (PDT)
Message-Id: <20200923.180615.357823799741297427.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, kuba@kernel.org,
        tuong.t.lien@dektech.com.au, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        keescook@chromium.org
Subject: Re: [PATCH net-next] tipc: potential memory corruption in
 tipc_crypto_key_rcv()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200923083017.GA1454948@mwanda>
References: <20200923083017.GA1454948@mwanda>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 23 Sep 2020 17:49:29 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 23 Sep 2020 11:30:17 +0300

> This code uses "skey->keylen" as an memcpy() size and then checks that
> it is valid on the next line.  The other problem is that the check has
> a potential integer overflow, it's better to use struct_size() for this.
> 
> Fixes: 23700da29b83 ("tipc: add automatic rekeying for encryption key")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Hey Kees and Julia,
> 
> It would be nice to change tipc_aead_key_size() but I'm not sure how the
> UAPI stuff works.  My first attempt at to change it to
> 
> 	return struct_size(key, key, key->keylen);
> 
> broke the build.  I think you guys used Coccinelle to automatically
> update these calculations.  Probably this wasn't updated because you
> didn't want to break the build either?

If it is subject to overflows, the tipc_aead_key_size() helper
shouldn't be used as-is by userspace either.

Right?

Please find a way to fix that inline function instead without breaking
UAPI, thank you.
