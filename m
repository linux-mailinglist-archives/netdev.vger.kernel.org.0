Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD34D26F55D
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 07:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgIRFYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 01:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbgIRFYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 01:24:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433B4C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 22:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=Czbz0aoh0swP875YOAd9tbl/HMp4jFjWDxStb9FAf9g=; b=QGjIydtz5QY0pDEY+8GeREqGR6
        cSyvEFuPN1IgbS9EieTK/biqdntWP9vYvoixXPTmUkQX1KlczTN3zGZF3RfK57kVaM+rqvVosGiMz
        gPMmnVE+eAL+lJ4/el9oEnCBgTg9Xqp+JsK8pMZZX4vtt3WwZRJzFp4r61mn+NK/raO+a+/t+FcrP
        MRPupYDJdQtw63UjKSRr81tVZC0ip4ez5W3OklZWXL+Mm+3h0TFqERdmWBTUc3ioqTlFyyyY1eulB
        mmSutLiL0VjYeQSCEzwcLrC1f4vUbpBTJD4uVO/NdjVUuI99UZAq5n+k5PGTR6MgJvQh5gQwYGXHW
        OWkfSSzQ==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJ8so-0005i6-GJ; Fri, 18 Sep 2020 05:24:30 +0000
Subject: Re: [PATCH next] net: fix build without CONFIG_SYSCTL definition
To:     Mahesh Bandewar <maheshb@google.com>,
        Netdev <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        kernel test robot <lkp@intel.com>
References: <20200918050832.1556691-1-maheshb@google.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <e8e62e21-c9b7-d30e-a85d-b58467251e81@infradead.org>
Date:   Thu, 17 Sep 2020 22:24:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200918050832.1556691-1-maheshb@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/20 10:08 PM, Mahesh Bandewar wrote:
> Earlier commit 316cdaa1158a ("net: add option to not create fall-back
> tunnels in root-ns as well") removed the CONFIG_SYSCTL to enable the
> kernel-commandline to work. However, this variable gets defined only
> when CONFIG_SYSCTL option is selected.
> 
> With this change the behavior would default to creating fall-back
> tunnels in all namespaces when CONFIG_SYSCTL is not selected and
> the kernel commandline option will be ignored.
> 
> Fixes: 316cdaa1158a ("net: add option to not create fall-back tunnels in root-ns as well")
> Signed-off-by: Mahesh Bandewar <maheshb@google.com>
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

Thanks.


> ---
>  include/linux/netdevice.h | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 909b1fbb0481..fef0eb96cf69 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -634,8 +634,9 @@ extern int sysctl_devconf_inherit_init_net;
>   */
>  static inline bool net_has_fallback_tunnels(const struct net *net)
>  {
> -	return (net == &init_net && sysctl_fb_tunnels_only_for_init_net == 1) ||
> -	       !sysctl_fb_tunnels_only_for_init_net;
> +	return !IS_ENABLED(CONFIG_SYSCTL) ||
> +	       !sysctl_fb_tunnels_only_for_init_net ||
> +	       (net == &init_net && sysctl_fb_tunnels_only_for_init_net == 1);
>  }
>  
>  static inline int netdev_queue_numa_node_read(const struct netdev_queue *q)
> 


-- 
~Randy
