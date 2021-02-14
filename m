Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C428A31B1B0
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 18:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhBNRx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 12:53:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbhBNRxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 12:53:53 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087A2C061756;
        Sun, 14 Feb 2021 09:53:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6eDzsMVYwupeCX4Qk3KisD8eSo5kOICuWVyDL4sF11o=; b=yhL7m6buGH9tujVqPbEPvFohLA
        Ib//hYBaSFwSJstxdChCuXAFoITUA/1UmehUKdApxlj7ON6pU7RJOHCPDjT8oehQqX8xmETkDlPlD
        0Ap3JCr31qgzLViR4NOby/cGgom3ATbU69Lc9IENobKLzL8aLctgTlu3sEAH8XbC09MEbaNrLKpXU
        jhdIyoVCO5AGRkkWos3LJiSBl8F9y9sIBQl9+zQnqAoThAC5+ts62AMFuBiVz4zRQWg8B6xn3bJwR
        xDwdwnKdM/x1KWCa6Y/WTS7lVTCmuJ4auTfgQ1B5GWVx11PqlZObX3Vqyst7Labmm3c3TgM00mq45
        uYenX46w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1lBLZx-0005mj-TD; Sun, 14 Feb 2021 17:53:06 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 5E7E13019CE;
        Sun, 14 Feb 2021 18:53:01 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 2E40320299B4B; Sun, 14 Feb 2021 18:53:01 +0100 (CET)
Date:   Sun, 14 Feb 2021 18:53:01 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     mingo@redhat.com, will@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] lockdep: add lockdep_assert_not_held()
Message-ID: <YCljfeNr4m5mZa4N@hirez.programming.kicks-ass.net>
References: <cover.1613171185.git.skhan@linuxfoundation.org>
 <37a29c383bff2fb1605241ee6c7c9be3784fb3c6.1613171185.git.skhan@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37a29c383bff2fb1605241ee6c7c9be3784fb3c6.1613171185.git.skhan@linuxfoundation.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 04:28:42PM -0700, Shuah Khan wrote:

> +#define lockdep_assert_not_held(l)	do {			\
> +		WARN_ON(debug_locks && lockdep_is_held(l));	\
> +	} while (0)
> +

This thing isn't as straight forward as you might think, but it'll
mostly work.

Notably this thing will misfire when lockdep_off() is employed. It
certainyl needs a comment to explain the subtleties.
