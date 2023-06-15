Return-Path: <netdev+bounces-10971-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9073730DFB
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 06:17:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF0D328165F
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 04:17:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2374F644;
	Thu, 15 Jun 2023 04:17:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E96625
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 04:17:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF432C433C0;
	Thu, 15 Jun 2023 04:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686802637;
	bh=Wf7Wd81kwURj9/QONfqCGAHz6JBdBCub1nSOGMdDMA4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VcZufbfQCdXJzbcHg9NKloFUyJfXTJBoos26D/HEYloKrBGr7N5O9FuhPL2ET4HhM
	 E1oCxT4LMBe00RplzvezqEHpXG39/ki0nUsMO+zGFuMJPAVXilKM64QoZfjya/uq8k
	 s0fTInSgOpQHrwtLj9nAl2dFCHD8YptM9mTi7v1rIr87LCgIsAJ6jsX44zYF+1+Hmy
	 uCf77Z1ze7nz6xzI7dK8j/L3niRaLjR4r0C/0pdVlKf79F0wVig25eGvI23tzRdqqE
	 uIF3fXywF8zlOVy6YJte6po3PJcI2B/QW/bGe7jbPXoG8W4C/KjWQr/+CfKIBrDeF+
	 kzwXTElbSH/ow==
Date: Wed, 14 Jun 2023 21:17:15 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>, Jonathan
 Corbet <corbet@lwn.net>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "davem@davemloft.net" <davem@davemloft.net>, "pabeni@redhat.com"
 <pabeni@redhat.com>, "edumazet@google.com" <edumazet@google.com>,
 "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
 linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] tools: ynl-gen: generate docs for
 <name>_max/_mask enums
Message-ID: <20230614211715.01940bbd@kernel.org>
In-Reply-To: <DM6PR11MB4657A5F161476B05C5F8B7569B5AA@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230613231709.150622-1-arkadiusz.kubalewski@intel.com>
	<20230613231709.150622-3-arkadiusz.kubalewski@intel.com>
	<20230613175928.4ea56833@kernel.org>
	<DM6PR11MB46570AEF7E10089E70CC1D019B5AA@DM6PR11MB4657.namprd11.prod.outlook.com>
	<20230614103852.3eb7fd02@kernel.org>
	<DM6PR11MB4657A5F161476B05C5F8B7569B5AA@DM6PR11MB4657.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jun 2023 22:11:38 +0000 Kubalewski, Arkadiusz wrote:
> Thanks for pointing this, but it doesn't work :/
> 
> I tried described format but still ./scripts/kernel-doc warns about it.
> Same as 'make htmldocs' does, as it uses ./scripts/kernel-doc
> 
> Also, if the enum is not described in the header, the docs produced by
> the 'make htmldocs' would list the enum with the comment "undescribed".

Oh, you're right :S Looks like private: does not work for enums.

> It seems we need fixing:
> - prevent warning from ./scripts/kernel-doc, so enums marked as "private:"
>   would not warn
> - generate __<ENUM_NAME>_MAX while marking them as "/* private: */"
> - add some kind of "pattern exclude" directive/mechanics for generating
>   docs with sphinx
> 
> Does it make sense?
> TBH, not yet sure if all above are possible..

Let's ask Jon, and wait for him to chime in, I don't think these
warnings should be a blocker for new families.

Jon, we have some "meta" entries in the uAPI enums in netlink 
to mark the number of attributes, eg:

enum {
	NETDEV_A_DEV_IFINDEX = 1,
	NETDEV_A_DEV_PAD,
	NETDEV_A_DEV_XDP_FEATURES,
/* private: */
	__NETDEV_A_DEV_MAX, // this
	NETDEV_A_DEV_MAX = (__NETDEV_A_DEV_MAX - 1) // and this
};

Also masks of all flags like:

enum netdev_xdp_act {
	NETDEV_XDP_ACT_BASIC = 1,
	NETDEV_XDP_ACT_REDIRECT = 2,
	NETDEV_XDP_ACT_NDO_XMIT = 4,
	NETDEV_XDP_ACT_XSK_ZEROCOPY = 8,
	NETDEV_XDP_ACT_HW_OFFLOAD = 16,
	NETDEV_XDP_ACT_RX_SG = 32,
	NETDEV_XDP_ACT_NDO_XMIT_SG = 64,
/* private: */
	NETDEV_XDP_ACT_MASK = 127, // this
};

which user space should not care about.

I was hoping we can mark them as /* private: */ but that doesn't
work, when we add kdocs without documenting those - there's a warning.
Is this a known problem? Is it worth fixing?
Do we need to fix both kernel-doc and sphinx or just the former?

