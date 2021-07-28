Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27FB93D8B07
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 11:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235607AbhG1JpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 05:45:05 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:39346 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbhG1JpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 05:45:03 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id D0A3220192;
        Wed, 28 Jul 2021 09:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1627465500;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2V2BZGwQx38O4MS3PRn5zsVNMTv9yCXn2m+qCzLq9X8=;
        b=qISOv7ZY9hulXEAWirIGv076VG+Fy6/bFjd1f4ypkccP1xm9nEv8+TAb68zuXNUPMQy0cU
        /rfLtmn9f3OAEwizZKY+rLIPDTqNf5cyvxLkj5zm0TqSvqnoOA8NGUWehu0f8+QJqJceZe
        oGP2ijInSIdmaUrT8lpYfEcXl7p/oUo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1627465500;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2V2BZGwQx38O4MS3PRn5zsVNMTv9yCXn2m+qCzLq9X8=;
        b=Ha0E1f8zdnFNiVa3aeBcp0nZudDEJp4IhJRHzPeiXA+AIOODgJaOEUN3U5kyeT8py1qjno
        mgxJ85JZdbFf0eDA==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id BC57DA3B81;
        Wed, 28 Jul 2021 09:45:00 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id F10E9DA952; Wed, 28 Jul 2021 11:42:15 +0200 (CEST)
Date:   Wed, 28 Jul 2021 11:42:15 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 47/64] btrfs: Use memset_after() to clear end of struct
Message-ID: <20210728094215.GX5047@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Kees Cook <keescook@chromium.org>,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-48-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727205855.411487-48-keescook@chromium.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 01:58:38PM -0700, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memset(), avoid intentionally writing across
> neighboring fields.
> 
> Use memset_after() so memset() doesn't get confused about writing
> beyond the destination member that is intended to be the starting point
> of zeroing through the end of the struct.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  fs/btrfs/root-tree.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
> index 702dc5441f03..ec9e78f65fca 100644
> --- a/fs/btrfs/root-tree.c
> +++ b/fs/btrfs/root-tree.c
> @@ -39,10 +39,7 @@ static void btrfs_read_root_item(struct extent_buffer *eb, int slot,
>  		need_reset = 1;
>  	}
>  	if (need_reset) {
> -		memset(&item->generation_v2, 0,
> -			sizeof(*item) - offsetof(struct btrfs_root_item,
> -					generation_v2));
> -

Please add
		/* Clear all members from generation_v2 onwards */

> +		memset_after(item, 0, level);
>  		generate_random_guid(item->uuid);

Acked-by: David Sterba <dsterba@suse.com>
