Return-Path: <netdev+bounces-10564-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4223E72F136
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 02:59:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 674521C2096A
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 00:59:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D604537C;
	Wed, 14 Jun 2023 00:59:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859487F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 00:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1EEC433C0;
	Wed, 14 Jun 2023 00:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686704370;
	bh=zB9UYvCUrHct3KozJ6bR9E0Mk/Fg5bLPg/OkjHummI4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Qykmu0vn9edP7NBNd7yu54l+aXbTi13MJ5NiV5Lk0HQ3NHIxNlyQFFIzTY0U8bwjY
	 mknVyKxNYNdQuQk62Kx4kTgJB8/lC+9bhLJCwRz8c9amewBngXrpnbGBVoMe0Nvqpo
	 qy3DimYwxu+OGpyCUGYUJAa+bTWbMRDLk3+B1AZd14OmUZt2EbLDHWQWGZPcpK0u3l
	 1Ahmum00mYvW1hdrBXXMHz5UtJLn9aT+d9svXGyGKCOh1Acethz10YBpsDOW0FdS8Z
	 yz+jkgU7TzF8zfXkWLNkfZvZ3VlhoOYOeZiFrZuxDg0C+CP2phoLAhJc1fHR8/CHXr
	 Y5nh8+2yrbXmw==
Date: Tue, 13 Jun 2023 17:59:28 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 chuck.lever@oracle.com
Subject: Re: [PATCH net-next] tools: ynl-gen: generate docs for
 <name>_max/_mask enums
Message-ID: <20230613175928.4ea56833@kernel.org>
In-Reply-To: <20230613231709.150622-3-arkadiusz.kubalewski@intel.com>
References: <20230613231709.150622-1-arkadiusz.kubalewski@intel.com>
	<20230613231709.150622-3-arkadiusz.kubalewski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jun 2023 01:17:09 +0200 Arkadiusz Kubalewski wrote:
> Including ynl generated uapi header files into source kerneldocs
> (rst files in Documentation/) produces warnings during documentation
> builds (i.e. make htmldocs)
> 
> Prevent warnings by generating also description for enums where rander_max
> was selected.

Do you reckon that documenting the meta-values makes sense, or should
we throw a:

/* private: */

comment in front of them so that kdoc ignores them? Does user space
have any use for those? If we want to document them...

> diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
> index 639524b59930..d78f7ae95092 100644
> --- a/include/uapi/linux/netdev.h
> +++ b/include/uapi/linux/netdev.h
> @@ -24,6 +24,7 @@
>   *   XDP buffer support in the driver napi callback.
>   * @NETDEV_XDP_ACT_NDO_XMIT_SG: This feature informs if netdev implements
>   *   non-linear XDP buffer support in ndo_xdp_xmit callback.
> + * @NETDEV_XDP_ACT_MASK: valid values mask

... I think we need to include some sort of indication that the value
will change as the uAPI is extended. Unlike the other values which are
set in stone, so to speak. "mask of currently defines values" ? Dunno.

>   */
>  enum netdev_xdp_act {
>  	NETDEV_XDP_ACT_BASIC = 1,
> diff --git a/tools/include/uapi/linux/netdev.h b/tools/include/uapi/linux/netdev.h
> index 639524b59930..d78f7ae95092 100644
> --- a/tools/include/uapi/linux/netdev.h
> +++ b/tools/include/uapi/linux/netdev.h
> @@ -24,6 +24,7 @@
>   *   XDP buffer support in the driver napi callback.
>   * @NETDEV_XDP_ACT_NDO_XMIT_SG: This feature informs if netdev implements
>   *   non-linear XDP buffer support in ndo_xdp_xmit callback.
> + * @NETDEV_XDP_ACT_MASK: valid values mask
>   */
>  enum netdev_xdp_act {
>  	NETDEV_XDP_ACT_BASIC = 1,
> diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
> index 0b5e0802a9a7..0d396bf98c27 100755
> --- a/tools/net/ynl/ynl-gen-c.py
> +++ b/tools/net/ynl/ynl-gen-c.py
> @@ -2011,6 +2011,7 @@ def render_uapi(family, cw):
>          # Write kdoc for enum and flags (one day maybe also structs)
>          if const['type'] == 'enum' or const['type'] == 'flags':
>              enum = family.consts[const['name']]
> +            name_pfx = const.get('name-prefix', f"{family.name}-{const['name']}-")
>  
>              if enum.has_doc():
>                  cw.p('/**')
> @@ -2022,10 +2023,18 @@ def render_uapi(family, cw):
>                      if entry.has_doc():
>                          doc = '@' + entry.c_name + ': ' + entry['doc']
>                          cw.write_doc_line(doc)
> +                if const.get('render-max', False):
> +                    if const['type'] == 'flags':
> +                        doc = '@' + c_upper(name_pfx + 'mask') + ': valid values mask'
> +                        cw.write_doc_line(doc)
> +                    else:
> +                        doc = '@' + c_upper(name_pfx + 'max') + ': max valid value'
> +                        cw.write_doc_line(doc)
> +                        doc = '@__' + c_upper(name_pfx + 'max') + ': do not use'

This one is definitely a candidate for /* private: */

> +                        cw.write_doc_line(doc)
>                  cw.p(' */')
>  
>              uapi_enum_start(family, cw, const, 'name')
> -            name_pfx = const.get('name-prefix', f"{family.name}-{const['name']}-")
>              for entry in enum.entries.values():
>                  suffix = ','
>                  if entry.value_change:

-- 
pw-bot: cr

