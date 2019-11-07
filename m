Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28467F28F2
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 09:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbfKGISk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 03:18:40 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:44595 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726800AbfKGISj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 03:18:39 -0500
Received: by mail-lf1-f66.google.com with SMTP id v4so864177lfd.11;
        Thu, 07 Nov 2019 00:18:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jADw1Ub15ip6TZv8Btimu9F+3zScCWJmjUZMm+FL7DA=;
        b=UQHYj64Y6csMMpoQebO1M2SaZf1u51eXHob46GR7H9RN4blGdOounDNeGtmWQB8Sax
         +dCcwfVjA+pEmgIP3xmT2rSe7T6+T5NZbuERXGFCDUnIbx5s0F5H+Hy5HOAH37xmBBQr
         cqFWFqvtA4TLjjfqjfXQtP4OmoP4s9Z7pexTDNE/Bl5bMHlYSZuKf695VocIQpGRs3gH
         wmcudz2txqJHWPQicHeC86uhp+80XIt2MN8TdMx5+u+YltNezGfEe/0GivVC49jLTib0
         g0oeUasFadoVi6q1AFUgzCipH7w7LtdHmQJzhHBMWWSwYJCPi7iieZj8IcOnu+4FnQiD
         f5Yw==
X-Gm-Message-State: APjAAAX6z7OKDT3m6JB/ZEeXiWkVeTUxFnOzRbzKClO6iDFSnVZ3a1VT
        rnVyOvnEhABbdE57gAZ7NOg=
X-Google-Smtp-Source: APXvYqyzAB1JQTvdRbAXpNyoBpPRjsDxJNFmC4MDIRKqKzrkv0XiJ0wimNnFwdnU46zYNtQyhli/Xw==
X-Received: by 2002:ac2:4ace:: with SMTP id m14mr1456777lfp.130.1573114717581;
        Thu, 07 Nov 2019 00:18:37 -0800 (PST)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id u2sm1100217ljg.34.2019.11.07.00.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 00:18:36 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1iSd01-0002Ck-FV; Thu, 07 Nov 2019 09:18:37 +0100
Date:   Thu, 7 Nov 2019 09:18:37 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Pan Bian <bianpan2016@163.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes.berg@intel.com>,
        Steve Winslow <swinslow@gmail.com>,
        Young Xiao <92siuyang@gmail.com>,
        Allison Randal <allison@lohutok.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrey Konovalov <andreyknvl@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] nfc: netlink: fix double device reference drop
Message-ID: <20191107081837.GF11035@localhost>
References: <1573108190-30836-1-git-send-email-bianpan2016@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573108190-30836-1-git-send-email-bianpan2016@163.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 07, 2019 at 02:29:50PM +0800, Pan Bian wrote:
> The function nfc_put_device(dev) is called twice to drop the reference
> to dev when there is no associated local llcp. Remove one of them to fix
> the bug.
> 
> Signed-off-by: Pan Bian <bianpan2016@163.com>
> ---
> v2: change subject of the patch
> ---
>  net/nfc/netlink.c | 2 --
>  1 file changed, 2 deletions(-)

Reviewed-by: Johan Hovold <johan@kernel.org>

In the future, please try to track down the commits introducing the bugs
you fix. That will help not only reviewers, but also the stable
maintainers.

In this case you could have added:

Fixes: 52feb444a903 ("NFC: Extend netlink interface for LTO, RW, and MIUX parameters support")
Fixes: d9b8d8e19b07 ("NFC: llcp: Service Name Lookup netlink interface")

> diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
> index 17e6ca62f1be..afde0d763039 100644
> --- a/net/nfc/netlink.c
> +++ b/net/nfc/netlink.c
> @@ -1099,7 +1099,6 @@ static int nfc_genl_llc_set_params(struct sk_buff *skb, struct genl_info *info)
>  
>  	local = nfc_llcp_find_local(dev);
>  	if (!local) {
> -		nfc_put_device(dev);
>  		rc = -ENODEV;
>  		goto exit;
>  	}
> @@ -1159,7 +1158,6 @@ static int nfc_genl_llc_sdreq(struct sk_buff *skb, struct genl_info *info)
>  
>  	local = nfc_llcp_find_local(dev);
>  	if (!local) {
> -		nfc_put_device(dev);
>  		rc = -ENODEV;
>  		goto exit;
>  	}

Johan
