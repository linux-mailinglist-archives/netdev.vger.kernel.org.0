Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2753FDE4B
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 17:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245735AbhIAPPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 11:15:02 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:39614 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245569AbhIAPPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 11:15:01 -0400
Received: from mua.local.altlinux.org (mua.local.altlinux.org [192.168.1.14])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 1641472C8F8;
        Wed,  1 Sep 2021 18:14:03 +0300 (MSK)
Received: by mua.local.altlinux.org (Postfix, from userid 508)
        id 01A497CF769; Wed,  1 Sep 2021 18:14:02 +0300 (MSK)
Date:   Wed, 1 Sep 2021 18:14:02 +0300
From:   "Dmitry V. Levin" <ldv@altlinux.org>
To:     Antony Antony <antony.antony@secunet.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Christian Langrock <christian.langrock@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 ipsec-next] xfrm: Add possibility to set the default
 to block if we have no policy
Message-ID: <20210901151402.GA2557@altlinux.org>
References: <20210331144843.GA25749@moon.secunet.de>
 <fc1364604051d6be5c4c14817817a004aba539eb.1626592022.git.antony.antony@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc1364604051d6be5c4c14817817a004aba539eb.1626592022.git.antony.antony@secunet.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, Jul 18, 2021 at 09:11:06AM +0200, Antony Antony wrote:
> From: Steffen Klassert <steffen.klassert@secunet.com>
> 
> As the default we assume the traffic to pass, if we have no
> matching IPsec policy. With this patch, we have a possibility to
> change this default from allow to block. It can be configured
> via netlink. Each direction (input/output/forward) can be
> configured separately. With the default to block configuered,
> we need allow policies for all packet flows we accept.
> We do not use default policy lookup for the loopback device.
> 
> v1->v2
>  - fix compiling when XFRM is disabled
>  - Reported-by: kernel test robot <lkp@intel.com>
> 
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> Co-developed-by: Christian Langrock <christian.langrock@secunet.com>
> Signed-off-by: Christian Langrock <christian.langrock@secunet.com>
> Co-developed-by: Antony Antony <antony.antony@secunet.com>
> Signed-off-by: Antony Antony <antony.antony@secunet.com>
[...]

The following part of this patch is ABI break:

> diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
> index ffc6a5391bb7..6e8095106192 100644
> --- a/include/uapi/linux/xfrm.h
> +++ b/include/uapi/linux/xfrm.h
> @@ -213,6 +213,11 @@ enum {
>  	XFRM_MSG_GETSPDINFO,
>  #define XFRM_MSG_GETSPDINFO XFRM_MSG_GETSPDINFO
> 
> +	XFRM_MSG_SETDEFAULT,
> +#define XFRM_MSG_SETDEFAULT XFRM_MSG_SETDEFAULT
> +	XFRM_MSG_GETDEFAULT,
> +#define XFRM_MSG_GETDEFAULT XFRM_MSG_GETDEFAULT
> +
>  	XFRM_MSG_MAPPING,
>  #define XFRM_MSG_MAPPING XFRM_MSG_MAPPING
>  	__XFRM_MSG_MAX

After this change, strace no longer builds with the following diagnostics:

../../../src/xlat/nl_xfrm_types.h:162:1: error: static assertion failed: "XFRM_MSG_MAPPING != 0x26"
  162 | static_assert((XFRM_MSG_MAPPING) == (0x26), "XFRM_MSG_MAPPING != 0x26");


-- 
ldv
