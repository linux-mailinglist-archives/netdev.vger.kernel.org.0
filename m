Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A93E1DD664
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 20:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbgEUS40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 14:56:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727985AbgEUS4Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 14:56:25 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53DDB20759;
        Thu, 21 May 2020 18:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590087385;
        bh=jd/vHbfe4q3AJoxdNeBjAsTug/F4UkRU4/nb26j79Oc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FhjYWQINDy0wZGPsV9Djsws4LrXEgHpYuIKgt6QRbeF8g8Ujeo+TJlh4daWl2dQ6E
         QA/kOh9oIawZU01jsACAGldxJPYMA52CNvjAzfv5B9M6C72zfHW4tHgT08qjZFJJd9
         N+9hVh3nwm9qcYCFTz3XwsQjrQG3UBN3tDh5lC9s=
Date:   Thu, 21 May 2020 11:56:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        secdev@chelsio.com
Subject: Re: [PATCH net-next] net/tls: fix race condition causing kernel
 panic
Message-ID: <20200521115623.134eeb83@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <0a5d0864-2830-6bc8-05e8-232d10c0f333@chelsio.com>
References: <20200519074327.32433-1-vinay.yadav@chelsio.com>
        <20200519.121641.1552016505379076766.davem@davemloft.net>
        <99faf485-2f28-0a45-7442-abaaee8744aa@chelsio.com>
        <20200520125844.20312413@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <0a5d0864-2830-6bc8-05e8-232d10c0f333@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 May 2020 14:28:27 +0530 Vinay Kumar Yadav wrote:
> Considering the lock in fix ("pending" is local variable), when writer reads
> pending == 0 [pending = atomic_read(&ctx->encrypt_pending); --> from tls_sw_sendmsg()],
> that means encrypt complete() [from tls_encrypt_done()] is already called.

Please indulge me with full sentences. I can't parse this.

> and if pending == 1 [pending = atomic_read(&ctx->encrypt_pending); --> from tls_sw_sendmsg()],
> that means writer is going to wait for atomic_dec_return(&ctx->decrypt_pending) and
> complete() [from tls_encrypt_done()]  to be called atomically.
> 
> This way, writer is not going to proceed to encrypt next record on CPU0 without complete().

