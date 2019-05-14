Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB611CA04
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 16:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfENOFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 10:05:52 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36250 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbfENOFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 10:05:52 -0400
Received: by mail-wr1-f66.google.com with SMTP id s17so2916082wru.3
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 07:05:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HFrxKRJ5HNStlbUTQZyFY7J10wCh/Ba3Wo5fQJBjPyQ=;
        b=GS3pZxdIURHPf8w/COarHAYYPyZNOGpYNUhNBpnKrH56Pq4TKJKmu4rDAz0qHOm493
         ujSgJeZELeDRlg5Bzen736+xXwfei+JY8RCNGANmPWFYL+0hiApN5dHpLXqTZSu6y8bv
         c4Py00SIGhk9lnH0sulLvwp1I0Dug6D8uMUXY+L/DHzLvzmTOtvqfXak4JQZB/EjRzXl
         ldFGRuwmgFkcJMBH1CzKF32Okd3f8mKnf3V8LB/hKCmhsWbswb8Y5BhPlKk2Ndixgtfp
         GmepfBsKPKlsxnkc3TsVMS1xvdlFwdc/LOCVCfn7OfdKvYCWlo99wiGfROK3T4bsQGWn
         mKuA==
X-Gm-Message-State: APjAAAU2ShRrtgWGRZ38H+t1U/AEjdkEq/ZeFb5Gi9gxbGEDZZNsB2MJ
        2gzvbNwJkDpMwVXA+gOfKtG6gw==
X-Google-Smtp-Source: APXvYqw125K8xwI4XsobgwXdSL1K0hlf2aXA2HtrmE4RRFWiK7i4AUBOj5YqSNVzCFCZhGhmte/4UQ==
X-Received: by 2002:adf:eb44:: with SMTP id u4mr22038936wrn.83.1557842751050;
        Tue, 14 May 2019 07:05:51 -0700 (PDT)
Received: from linux.home (2a01cb05850ddf00045dd60e6368f84b.ipv6.abo.wanadoo.fr. [2a01:cb05:850d:df00:45d:d60e:6368:f84b])
        by smtp.gmail.com with ESMTPSA id x187sm3488139wmb.33.2019.05.14.07.05.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 May 2019 07:05:50 -0700 (PDT)
Date:   Tue, 14 May 2019 16:05:48 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, paulus@samba.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] ppp: deflate: Fix possible crash in deflate_init
Message-ID: <20190514140547.GA25993@linux.home>
References: <20190514074300.42588-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514074300.42588-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 14, 2019 at 03:43:00PM +0800, YueHaibing wrote:
> 
> If ppp_deflate fails to register in deflate_init,
> module initialization failed out, however
> ppp_deflate_draft may has been regiestred and not
> unregistered before return.
> Then the seconed modprobe will trigger crash like this.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/ppp/ppp_deflate.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ppp/ppp_deflate.c b/drivers/net/ppp/ppp_deflate.c
> index b5edc7f..2829efe 100644
> --- a/drivers/net/ppp/ppp_deflate.c
> +++ b/drivers/net/ppp/ppp_deflate.c
> @@ -610,12 +610,16 @@ static void z_incomp(void *arg, unsigned char *ibuf, int icnt)
>  
>  static int __init deflate_init(void)
>  {
> -        int answer = ppp_register_compressor(&ppp_deflate);
> -        if (answer == 0)
> -                printk(KERN_INFO
> -		       "PPP Deflate Compression module registered\n");
> +	int answer;
> +
> +	answer = ppp_register_compressor(&ppp_deflate);
> +	if (answer)
> +		return answer;
> +
> +	pr_info("PPP Deflate Compression module registered\n");
>  	ppp_register_compressor(&ppp_deflate_draft);
> -        return answer;
> +
> +	return 0;
>  }
>  
I'd be cleaner to also check for ppp_deflate_draft registration failure
IMHO (and print the log line only if both compressors get registered
successfully).
