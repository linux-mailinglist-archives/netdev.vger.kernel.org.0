Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 108D35FDD9B
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 17:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiJMPxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 11:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiJMPxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 11:53:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 055D037F8F;
        Thu, 13 Oct 2022 08:53:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CA40B81F2C;
        Thu, 13 Oct 2022 15:53:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A35DC433D6;
        Thu, 13 Oct 2022 15:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665676414;
        bh=YzdQzqYCyfET0fM/MNECfwA8EB9VdQS1H3xHN/FUVCY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n5kZt9IxNwbFUJ7uTABKjvmucrBVtjDy3GQq6abjckutI9UxKNkCf0Xmpo1ZDw4kv
         3ktI08DHgw1SGNL2ZTVIaQl2lcKuB7OgrafTbYNRIQvOk5tq6DsavmE5bQeYKpVaQy
         M6WqbH3G+1GzTVxYS3p6b3s6Ryrao+txpPVMb0wE42ZwwCtYto2y6O42zJZibi2tbw
         pOWxM1NEHUze5sJ0IzF4ud5vfJc7vwtvtxACRUSuAQ/YEFk/O0Mkf/8IlUXHqs2zlV
         WigK1WS6pGfeYMOxrsq3WzQIAhbE58TIZHOqyJddPosgbrKrDV5h0zuP1EPRK+5yh5
         S+cfxsnhndmGA==
Date:   Thu, 13 Oct 2022 08:53:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paul Moore <paul@paul-moore.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        netdev@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH] lsm: make security_socket_getpeersec_stream() sockptr_t
 safe
Message-ID: <20221013085333.26288e44@kernel.org>
In-Reply-To: <166543910984.474337.2779830480340611497.stgit@olly>
References: <166543910984.474337.2779830480340611497.stgit@olly>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Oct 2022 17:58:29 -0400 Paul Moore wrote:
> Commit 4ff09db1b79b ("bpf: net: Change sk_getsockopt() to take the
> sockptr_t argument") made it possible to call sk_getsockopt()
> with both user and kernel address space buffers through the use of
> the sockptr_t type.  Unfortunately at the time of conversion the
> security_socket_getpeersec_stream() LSM hook was written to only
> accept userspace buffers, and in a desire to avoid having to change
> the LSM hook the commit author simply passed the sockptr_t's
> userspace buffer pointer.  Since the only sk_getsockopt() callers
> at the time of conversion which used kernel sockptr_t buffers did
> not allow SO_PEERSEC, and hence the
> security_socket_getpeersec_stream() hook, this was acceptable but
> also very fragile as future changes presented the possibility of
> silently passing kernel space pointers to the LSM hook.
> 
> There are several ways to protect against this, including careful
> code review of future commits, but since relying on code review to
> catch bugs is a recipe for disaster and the upstream eBPF maintainer
> is "strongly against defensive programming", this patch updates the
> LSM hook, and all of the implementations to support sockptr_t and
> safely handle both user and kernel space buffers.

Code seems sane, FWIW, but the commit message sounds petty,
which is likely why nobody is willing to ack it.
