Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76DC3F008B
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 11:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbhHRJc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 05:32:59 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:39800 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233703AbhHRJcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 05:32:20 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 6BDC422065;
        Wed, 18 Aug 2021 09:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1629279084;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MjEVLCKBlTSswofPN1pNmxlP19qpFPg2jUD4se0XdyA=;
        b=Vce+IAwmUDcfv2b7QGyi2Dv7EKo/Co6jwhdkPnVadZs3PhYLf7tUr6B9fRUUxtOcBZk6+N
        B9XQg+cRWkemeBBWnWGk1wfHVQuq5Xnz4OC/hrrv7YBobuFDHB3iZwPRwWeZB5fMRC+UY8
        0ZVGoxSYWv4akI4SI4AnM5BUhMcP4k4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1629279084;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MjEVLCKBlTSswofPN1pNmxlP19qpFPg2jUD4se0XdyA=;
        b=SFOFKtThDem3M1F/rOZMlyJlFmdOZ4+c7ISuV48nRhjMQ1VbfvtT61ULNqlr3zoJHsVSVM
        ACnXbdzsW0b8HLBQ==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 4E36EA3B94;
        Wed, 18 Aug 2021 09:31:24 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B0437DA72C; Wed, 18 Aug 2021 11:28:27 +0200 (CEST)
Date:   Wed, 18 Aug 2021 11:28:27 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-staging@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 49/63] btrfs: Use memset_startat() to clear end of
 struct
Message-ID: <20210818092827.GO5047@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-staging@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
References: <20210818060533.3569517-1-keescook@chromium.org>
 <20210818060533.3569517-50-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818060533.3569517-50-keescook@chromium.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021 at 11:05:19PM -0700, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memset(), avoid intentionally writing across
> neighboring fields.
> 
> Use memset_startat() so memset() doesn't get confused about writing
> beyond the destination member that is intended to be the starting point
> of zeroing through the end of the struct.
> 
> Cc: Chris Mason <clm@fb.com>
> Cc: Josef Bacik <josef@toxicpanda.com>
> Cc: David Sterba <dsterba@suse.com>
> Cc: linux-btrfs@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: David Sterba <dsterba@suse.com>
