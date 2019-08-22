Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22BCB99F8C
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 21:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403892AbfHVTMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 15:12:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47444 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbfHVTMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 15:12:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 66853153410DC;
        Thu, 22 Aug 2019 12:12:08 -0700 (PDT)
Date:   Thu, 22 Aug 2019 12:12:07 -0700 (PDT)
Message-Id: <20190822.121207.731320146177703787.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/9] rxrpc: Fix use of skb_cow_data()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <156647655350.10908.12081183247715153431.stgit@warthog.procyon.org.uk>
References: <156647655350.10908.12081183247715153431.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 Aug 2019 12:12:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Thu, 22 Aug 2019 13:22:33 +0100

> Here's a series of patches that fixes the use of skb_cow_data() in rxrpc.
> The problem is that skb_cow_data() indirectly requires that the maximum
> usage count on an sk_buff be 1, and it may generate an assertion failure in
> pskb_expand_head() if not.

It sounds like you are effectively doing a late unshare when you have to
do in-place encryption.

Why don't you just do an skb_unshare() at the beginning when you know that
you'll need to do that?
