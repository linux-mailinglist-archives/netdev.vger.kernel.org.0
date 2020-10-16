Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC903290D55
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 23:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411367AbgJPVgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 17:36:32 -0400
Received: from mga03.intel.com ([134.134.136.65]:43499 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732639AbgJPVgc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 17:36:32 -0400
IronPort-SDR: +tNWiiJpiEnT+WH+WX7C6LpBO2gQ2XtoUMYjwYOGNGJc0CHW3XX8mCoU2uyuUXkZs9NOmjSCIG
 D+KkutOPPxow==
X-IronPort-AV: E=McAfee;i="6000,8403,9776"; a="166773507"
X-IronPort-AV: E=Sophos;i="5.77,384,1596524400"; 
   d="scan'208";a="166773507"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2020 14:36:26 -0700
IronPort-SDR: Qws0padkh2pmd3z9Iz0eZd2j9ZpJmmELrbkmQL5oMz0ktY2ByZVjSlr1Zr8H/eYNGHtyUmfbGa
 EnKwk8KLLJZw==
X-IronPort-AV: E=Sophos;i="5.77,384,1596524400"; 
   d="scan'208";a="531877716"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.117.85])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2020 14:36:26 -0700
Date:   Fri, 16 Oct 2020 14:36:25 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     zhudi <zhudi21@huawei.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <rose.chen@huawei.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] rtnetlink: fix data overflow in rtnl_calcit()
Message-ID: <20201016143625.00005f4e@intel.com>
In-Reply-To: <20201016020238.22445-1-zhudi21@huawei.com>
References: <20201016020238.22445-1-zhudi21@huawei.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zhudi wrote:

> "ip addr show" command execute error when we have a physical
> network card with number of VFs larger than 247.

Oh man, this bug has been hurting us forever and I've tried to fix it
several times without much luck, so thanks for working on it!

CC: David Ahern <dsahern@gmail.com>

As he's mentioned this bug.
 
> The return value of if_nlmsg_size() in rtnl_calcit() will exceed
> range of u16 data type when any network cards has a larger number of
> VFs. rtnl_vfinfo_size() will significant increase needed dump size when
> the value of num_vfs is larger.
> 
> Eventually we get a wrong value of min_ifinfo_dump_size because of overflow
> which decides the memory size needed by netlink dump and netlink_dump()
> will return -EMSGSIZE because of not enough memory was allocated.
> 
> So fix it by promoting  min_dump_alloc data type to u32 to
> avoid data overflow and it's also align with the data type of
> struct netlink_callback{}.min_dump_alloc which is assigned by
> return value of rtnl_calcit()

I defer to others here on whether this is an acceptable API change.

> Signed-off-by: zhudi <zhudi21@huawei.com>

Kernel documentation says for you to use your real name, please do so,
unless you're a rock star and have officially changed your name to
zhudi.

> ---
>  include/linux/netlink.h | 2 +-
>  net/core/rtnetlink.c    | 8 ++++----
>  2 files changed, 5 insertions(+), 5 deletions(-)

Does it work without any changes to iproute2?


> 
> diff --git a/include/linux/netlink.h b/include/linux/netlink.h
> index e3e49f0e5c13..0a7db41b9e42 100644
> --- a/include/linux/netlink.h
> +++ b/include/linux/netlink.h
> @@ -230,7 +230,7 @@ struct netlink_dump_control {
>  	int (*done)(struct netlink_callback *);
>  	void *data;
>  	struct module *module;
> -	u16 min_dump_alloc;
> +	u32 min_dump_alloc;
>  };

As long as nothing in the API depends on the length of this struct, it
should work.

