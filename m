Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBEA6A0458
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 10:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233651AbjBWJBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 04:01:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232983AbjBWJBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 04:01:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141AF4A1ED;
        Thu, 23 Feb 2023 01:01:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2DF5B81989;
        Thu, 23 Feb 2023 09:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACC5C433EF;
        Thu, 23 Feb 2023 09:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677142902;
        bh=Sqm+O0PmVNyXzbcLj9XMuRpnN5N0OhkW/sR83qhecQs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s+L+w60zshYwMGKK9VtHFuwPkYT7uzkTESziRDYkI5ix0VyZExVWcww99vw8DNVip
         MiPpd0YA/kSmKNhIBevqmxF9hNKrEnBOAIyenqAG7S8SV5/7RBv4x5ACSpBflnnK2I
         S12TLflhFaw1vHuOHxB+OxNt7r8LUW7//xDNz5nE=
Date:   Thu, 23 Feb 2023 10:01:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Edward Liaw <edliaw@google.com>
Cc:     stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>, bpf@vger.kernel.org,
        kernel-team@android.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: Re: [PATCH 4.14 v2 1/4] bpf: Do not use ax register in interpreter
 on div/mod
Message-ID: <Y/crdG+quVvKMF0m@kroah.com>
References: <20230222192925.1778183-1-edliaw@google.com>
 <20230222192925.1778183-2-edliaw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222192925.1778183-2-edliaw@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 07:29:21PM +0000, Edward Liaw wrote:
> From: Daniel Borkmann <daniel@iogearbox.net>
> 
> Partially undo old commit 144cd91c4c2b ("bpf: move tmp variable into ax
> register in interpreter"). The reason we need this here is because ax
> register will be used for holding temporary state for div/mod instruction
> which otherwise interpreter would corrupt. This will cause a small +8 byte
> stack increase for interpreter, but with the gain that we can use it from
> verifier rewrites as scratch register.
> 
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Reviewed-by: John Fastabend <john.fastabend@gmail.com>
> [cascardo: This partial revert is needed in order to support using AX for
> the following two commits, as there is no JMP32 on 4.19.y]
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> [edliaw: Removed redeclaration of tmp]
> Signed-off-by: Edward Liaw <edliaw@google.com>
> ---
>  kernel/bpf/core.c | 31 ++++++++++++++-----------------
>  1 file changed, 14 insertions(+), 17 deletions(-)

What is the git commit id in Linus's tree of this commit?

thanks,

greg k-h
