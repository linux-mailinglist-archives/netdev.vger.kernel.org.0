Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF58F3D09C5
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 09:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234953AbhGUGx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 02:53:26 -0400
Received: from verein.lst.de ([213.95.11.211]:57689 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234991AbhGUGwP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 02:52:15 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4BA0367373; Wed, 21 Jul 2021 09:32:50 +0200 (CEST)
Date:   Wed, 21 Jul 2021 09:32:50 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     netdev@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v5 3/4] net: socket: simplify dev_ifconf handling
Message-ID: <20210721073250.GC11257@lst.de>
References: <20210720142436.2096733-1-arnd@kernel.org> <20210720142436.2096733-4-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210720142436.2096733-4-arnd@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The implementation can be simplified further, based on the
> knowledge that the dynamic registration is only ever used
> > for IPv4.

I think dropping register_gifconf (which seems like a nice cleanup!)
needs to be a separate prep patch to not make this too confusing.


> index e6231837aff5..4727c7a3a988 100644
> --- a/include/linux/compat.h
> +++ b/include/linux/compat.h
> @@ -104,6 +104,11 @@ struct compat_ifmap {
>  	unsigned char port;
>  };
>  
> +struct compat_ifconf {
> +	compat_int_t	ifc_len;                /* size of buffer */
> +	compat_uptr_t	ifcbuf;
> +};
> +
>  #ifdef CONFIG_COMPAT
>  
>  #ifndef compat_user_stack_pointer
> @@ -326,12 +331,6 @@ typedef struct compat_sigevent {
>  	} _sigev_un;
>  } compat_sigevent_t;
>  
> -struct compat_if_settings {
> -	unsigned int type;	/* Type of physical device or protocol */
> -	unsigned int size;	/* Size of the data allocated by the caller */
> -	compat_uptr_t ifs_ifsu;	/* union of pointers */
> -};

Does this actually compile as-is?  It adds a second definition of
compat_ifconf but removes the still used compat_if_settings?

Maybe it would be a better idea to add a prep patch that makes as much
as possible of compat.h available unconditionally instead of all these
little moves.
