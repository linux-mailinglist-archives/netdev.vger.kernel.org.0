Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9036C30198B
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 05:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbhAXEz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 23:55:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:45572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726367AbhAXEzZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Jan 2021 23:55:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48FA722581;
        Sun, 24 Jan 2021 04:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611464085;
        bh=5iREiP7b6NQqTLbtBlScI0etVnZxxOEG5LmZaJgsXC8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gAqYmSoFJlXuJU9jhAqQkrIV0Wwn8YkUNJp74mxK+iOlG0njy+qknVF+guG9ZwgfO
         pbqP+m0sR9R8FtKN9+xc295mxbIYO/21TLhyZV2r53bGCIWW1YitZfTfW9RuOrB4+M
         g7INK4ach47ZjUprCKHo9Om7nydVRpAvmn+xQ49Hi+Uu31eVL4Z50TQr1FCggCKf0Y
         1lKJipf+NQ180KQXBfYYGziOxtUPp/+mDOunwjDu1amS7WS5qyQBJOFzHx6C1mcCIi
         2pmfbAlcm1MOvB8cruTjnpJ8BEhYUwdobTi8LBDj38wYioUa5pa+ovDdAzPMj4Ym6g
         M9tuetOa+J3Ww==
Date:   Sat, 23 Jan 2021 20:54:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, alex.aring@gmail.com
Subject: Re: [PATCH net 1/1] uapi: fix big endian definition of
 ipv6_rpl_sr_hdr
Message-ID: <20210123205444.5e1df187@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210121220044.22361-2-justin.iurman@uliege.be>
References: <20210121220044.22361-1-justin.iurman@uliege.be>
        <20210121220044.22361-2-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jan 2021 23:00:44 +0100 Justin Iurman wrote:
> Following RFC 6554 [1], the current order of fields is wrong for big
> endian definition. Indeed, here is how the header looks like:
> 
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> |  Next Header  |  Hdr Ext Len  | Routing Type  | Segments Left |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> | CmprI | CmprE |  Pad  |               Reserved                |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> 
> This patch reorders fields so that big endian definition is now correct.
> 
>   [1] https://tools.ietf.org/html/rfc6554#section-3
> 
> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>

Are you sure? This looks right to me.

> diff --git a/include/uapi/linux/rpl.h b/include/uapi/linux/rpl.h
> index 1dccb55cf8c6..708adddf9f13 100644
> --- a/include/uapi/linux/rpl.h
> +++ b/include/uapi/linux/rpl.h
> @@ -28,10 +28,10 @@ struct ipv6_rpl_sr_hdr {
>  		pad:4,
>  		reserved1:16;
>  #elif defined(__BIG_ENDIAN_BITFIELD)
> -	__u32	reserved:20,
> +	__u32	cmpri:4,
> +		cmpre:4,
>  		pad:4,
> -		cmpri:4,
> -		cmpre:4;
> +		reserved:20;
>  #else
>  #error  "Please fix <asm/byteorder.h>"
>  #endif

