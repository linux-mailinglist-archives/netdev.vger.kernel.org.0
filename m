Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDA16DE49B
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 08:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbfJUGbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 02:31:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:54536 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726039AbfJUGbY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 02:31:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B54E2B387;
        Mon, 21 Oct 2019 06:31:22 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 64296E3C6D; Mon, 21 Oct 2019 08:31:22 +0200 (CEST)
Date:   Mon, 21 Oct 2019 08:31:22 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Maciej =?iso-8859-2?Q?=AFenczykowski?= <zenczykowski@gmail.com>,
        Maciej =?iso-8859-2?Q?=AFenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 02/33] fix unused parameter warnings in do_version() and
 show_usage()
Message-ID: <20191021063122.GC27784@unicorn.suse.cz>
References: <CAHo-Ooze4yTO_yeimV-XSD=AXvvd0BmbKdvUK4bKWN=+LXirYQ@mail.gmail.com>
 <20191017182121.103569-1-zenczykowski@gmail.com>
 <20191017182121.103569-2-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191017182121.103569-2-zenczykowski@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 17, 2019 at 11:20:50AM -0700, Maciej ¯enczykowski wrote:
> From: Maciej ¯enczykowski <maze@google.com>
> 
> This fixes:
>   external/ethtool/ethtool.c:473:43: error: unused parameter 'ctx' [-Werror,-Wunused-parameter]
>   static int do_version(struct cmd_context *ctx)
> 
>   external/ethtool/ethtool.c:5392:43: error: unused parameter 'ctx' [-Werror,-Wunused-parameter]
>   static int show_usage(struct cmd_context *ctx)
> 
> Signed-off-by: Maciej ¯enczykowski <maze@google.com>
> Change-Id: I0cc52f33bb0e8d7627f5e84bb4e3dfa821d17cc8
> ---
>  ethtool.c  | 4 ++--
>  internal.h | 2 ++
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/ethtool.c b/ethtool.c
> index 082e37f..5e0deda 100644
> --- a/ethtool.c
> +++ b/ethtool.c
> @@ -470,7 +470,7 @@ static int rxflow_str_to_type(const char *str)
>  	return flow_type;
>  }
>  
> -static int do_version(struct cmd_context *ctx)
> +static int do_version(struct cmd_context *ctx maybe_unused)
>  {

Considering how frequent this pattern (a callback where not all
instances use all parameters) is, maybe we could consider disabling the
warning with -Wno-unused-parameter instead of marking all places where
it is issued.

Michal Kubecek

>  	fprintf(stdout,
>  		PACKAGE " version " VERSION
> @@ -5484,7 +5484,7 @@ static const struct option {
>  	{}
>  };
>  
> -static int show_usage(struct cmd_context *ctx)
> +static int show_usage(struct cmd_context *ctx maybe_unused)
>  {
>  	int i;
>  
> diff --git a/internal.h b/internal.h
> index aecf1ce..ff52c6e 100644
> --- a/internal.h
> +++ b/internal.h
> @@ -23,6 +23,8 @@
>  #include <sys/ioctl.h>
>  #include <net/if.h>
>  
> +#define maybe_unused __attribute__((__unused__))
> +
>  /* ethtool.h expects these to be defined by <linux/types.h> */
>  #ifndef HAVE_BE_TYPES
>  typedef uint16_t __be16;
> -- 
> 2.23.0.866.gb869b98d4c-goog
> 
