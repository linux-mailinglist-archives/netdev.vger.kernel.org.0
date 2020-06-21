Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C06202881
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 06:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgFUEcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 00:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgFUEcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 00:32:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FF3C061794;
        Sat, 20 Jun 2020 21:32:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 446421274A81F;
        Sat, 20 Jun 2020 21:32:41 -0700 (PDT)
Date:   Sat, 20 Jun 2020 21:32:40 -0700 (PDT)
Message-Id: <20200620.213240.344394880607292689.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org,
        syzbot+d3eccef36ddbd02713e9@syzkaller.appspotmail.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] rxrpc: Fix notification call on completion of
 discarded calls
From:   David Miller <davem@davemloft.net>
In-Reply-To: <159260629601.2218121.13958646181773576175.stgit@warthog.procyon.org.uk>
References: <159260629601.2218121.13958646181773576175.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 20 Jun 2020 21:32:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Fri, 19 Jun 2020 23:38:16 +0100

> When preallocated service calls are being discarded, they're passed to
> ->discard_new_call() to have the caller clean up any attached higher-layer
> preallocated pieces before being marked completed.  However, the act of
> marking them completed now invokes the call's notification function - which
> causes a problem because that function might assume that the previously
> freed pieces of memory are still there.
> 
> Fix this by setting a dummy notification function on the socket after
> calling ->discard_new_call().
> 
> This results in the following kasan message when the kafs module is
> removed.
 ...
> Reported-by: syzbot+d3eccef36ddbd02713e9@syzkaller.appspotmail.com
> Fixes: 5ac0d62226a0 ("rxrpc: Fix missing notification")
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied, thanks David.
