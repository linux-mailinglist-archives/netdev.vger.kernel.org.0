Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CED308F4A6
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732410AbfHOTch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:32:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49012 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728762AbfHOTcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 15:32:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 176741400EC64;
        Thu, 15 Aug 2019 12:32:36 -0700 (PDT)
Date:   Thu, 15 Aug 2019 12:32:35 -0700 (PDT)
Message-Id: <20190815.123235.516041583959546572.davem@davemloft.net>
To:     terry.s.duncan@linux.intel.com
Cc:     sam@mendozajonas.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org,
        wak@google.com, joel@jms.id.au
Subject: Re: [PATCH] net/ncsi: Ensure 32-bit boundary for data cksum
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190814011840.9387-1-terry.s.duncan@linux.intel.com>
References: <20190814011840.9387-1-terry.s.duncan@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 Aug 2019 12:32:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Terry S. Duncan" <terry.s.duncan@linux.intel.com>
Date: Tue, 13 Aug 2019 18:18:40 -0700

> The NCSI spec indicates that if the data does not end on a 32 bit
> boundary, one to three padding bytes equal to 0x00 shall be present to
> align the checksum field to a 32-bit boundary.
> 
> Signed-off-by: Terry S. Duncan <terry.s.duncan@linux.intel.com>
> ---
>  net/ncsi/internal.h |  1 +
>  net/ncsi/ncsi-cmd.c |  2 +-
>  net/ncsi/ncsi-rsp.c | 12 ++++++++----
>  3 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h
> index 0b3f0673e1a2..468a19fdfd88 100644
> --- a/net/ncsi/internal.h
> +++ b/net/ncsi/internal.h
> @@ -185,6 +185,7 @@ struct ncsi_package;
>  #define NCSI_TO_CHANNEL(p, c)	(((p) << NCSI_PACKAGE_SHIFT) | (c))
>  #define NCSI_MAX_PACKAGE	8
>  #define NCSI_MAX_CHANNEL	32
> +#define NCSI_ROUND32(x)		(((x) + 3) & ~3) /* Round to 32 bit boundary */

I think we have enough of a proliferation of alignment macros, let's not add more.

Either define this to "ALIGN(x, 4)" or expand that into each of the locations:

>  	pchecksum = (__be32 *)((void *)h + sizeof(struct ncsi_pkt_hdr) +
> -		    nca->payload);
> +		    NCSI_ROUND32(nca->payload));

		     ALIGN(nca->payload, 4)

> -	pchecksum = (__be32 *)((void *)(h + 1) + payload - 4);
> +	pchecksum = (__be32 *)((void *)(h + 1) + NCSI_ROUND32(payload) - 4);

						 ALIGN(payload, 4)


etc.
