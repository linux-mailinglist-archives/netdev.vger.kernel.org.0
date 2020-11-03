Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6E82A3AC3
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 04:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgKCDAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 22:00:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:58596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbgKCDAh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 22:00:37 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00B0620731;
        Tue,  3 Nov 2020 03:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604372436;
        bh=IrhgMCzPwSmcG8yWpUcKQQEKsZFIxY/jLHPR40BxrqM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UnkFZ8bX9G55p6vthKTHDRECJDKpHElDBCPbKMsMoYoi4qJvzWkG3i2ewKHNOpQRA
         Zfl2zBU9acIppP7/WQXgsspw/iD2Z+3bG4LZfTUv6CeetF2//qUxjoRqeYekWl4xou
         aYbszuclq90nJCOJnTXkZBWqyaFcY9wfXS3RLlK8=
Date:   Mon, 2 Nov 2020 19:00:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aleksandr Nogikh <aleksandrnogikh@gmail.com>
Cc:     davem@davemloft.net, johannes@sipsolutions.net,
        edumazet@google.com, andreyknvl@google.com, dvyukov@google.com,
        elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        willemdebruijn.kernel@gmail.com,
        Aleksandr Nogikh <nogikh@google.com>
Subject: Re: [PATCH v5 0/3] net, mac80211, kernel: enable KCOV remote
 coverage collection for 802.11 frame handling
Message-ID: <20201102190035.2c1c65ce@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201029173620.2121359-1-aleksandrnogikh@gmail.com>
References: <20201029173620.2121359-1-aleksandrnogikh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 17:36:17 +0000 Aleksandr Nogikh wrote:
> From: Aleksandr Nogikh <nogikh@google.com>
> 
> This patch series enables remote KCOV coverage collection during
> 802.11 frames processing. These changes make it possible to perform
> coverage-guided fuzzing in search of remotely triggerable bugs.
> 
> Normally, KCOV collects coverage information for the code that is
> executed inside the system call context. It is easy to identify where
> that coverage should go and whether it should be collected at all by
> looking at the current process. If KCOV was enabled on that process,
> coverage will be stored in a buffer specific to that process.
> Howerever, it is not always enough as handling can happen elsewhere
> (e.g. in separate kernel threads).
> 
> When it is impossible to infer KCOV-related info just by looking at
> the currently running process, one needs to manually pass some
> information to the code that should be instrumented. The information
> takes the form of 64 bit integers (KCOV remote handles). Zero is the
> special value that corresponds to an empty handle. More details on
> KCOV and remote coverage collection can be found in
> Documentation/dev-tools/kcov.rst.
> 
> The series consists of three commits.
> 1. Apply a minor fix to kcov_common_handle() so that it returns a
> valid handle (zero) when called in an interrupt context.
> 2. Take the remote handle from KCOV and attach it to newly allocated
> SKBs as an skb extension. If the allocation happens inside a system
> call context, the SKB will be tied to the process that issued the
> syscall (if that process is interested in remote coverage collection).
> 3. Annotate the code that processes incoming 802.11 frames with
> kcov_remote_start()/kcov_remote_stop().

Applied, thanks.
