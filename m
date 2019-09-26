Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2299BEA14
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 03:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389054AbfIZB2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 21:28:51 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45489 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388786AbfIZB2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 21:28:50 -0400
Received: by mail-pf1-f194.google.com with SMTP id y72so676541pfb.12
        for <netdev@vger.kernel.org>; Wed, 25 Sep 2019 18:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=j12YR8Sz7lqAWk3kVJllB0GpgeIbUZ8LPBlsVactf4o=;
        b=MT974R0a+7BOZEwbuehQtp8dBN4m9x82wscvv6hWcyd5Vz/4vnx3Wk+7Gs6qtKLzBC
         CxDEIKCBB+/MvaFjA0jVW2eWjbtY7fL5u0P6FfbLWSdG8HQUewhfMsft18SOo7RaGsL6
         hJYxUcpEB1qLwaWv3s6Vir6AWd0Zx+k7VzGS49BPb+XV7EovyKrWxgtyvkM0HyHmskuP
         swRXdYKd2XVAlvN+psnPqQuZh5c0n5ukyzBQnyy1opB0bBXw6LyKDrJXuJQvEAKYHLGB
         t8y0EaKcQULXzpOZZ1FnfzhF0kRunBD6phEhpTKgWoIHSMxw6iREXSFyRvpJ8B4Gw3QL
         WHvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=j12YR8Sz7lqAWk3kVJllB0GpgeIbUZ8LPBlsVactf4o=;
        b=RdmatCwM+Rtu98ljQFrDOd8mPsMxILqJjVHbWykFKixdTVCb93AmWrEPtQVTV3a5jZ
         giI3eDqK1CYQspYVD7SrwShQhtoHLwdiPgmZpLURyBcOxKdZQZxWKLJbuAV4wQ/J+c/P
         gOelGzPPCXPmjLsZ6ue/JanEC0kMDzEF9ZuhKiyx51S73LxDa2jbPCyYxptZoDsjO3gC
         XMudnDupkiCRxLt+GvJxQGscIFrsnx3D84tPDgN3wsjHqGOhAflZFKTehJ8UTnOVQNfd
         r/WjoCq45jbj8i2js7oIBBc9/H3uFSd6tkLkP+yg2CyxQx3h/4q7XKpD3iANozh+QhLP
         yfpQ==
X-Gm-Message-State: APjAAAVP1zAvS3yLN6MHmSp+kOqX/g/9SEVC9jjhO85VPw6V8i92sCs2
        iWpFN5bRgsA+e2RQ5wRAArx09g==
X-Google-Smtp-Source: APXvYqxQITLNcTLpSM0rs0YOxV402EPnexB569vCYoV1pb+klZRhrOQFOyV97JvHUqc6+fXJsVTpTg==
X-Received: by 2002:a62:1e82:: with SMTP id e124mr789701pfe.136.1569461330070;
        Wed, 25 Sep 2019 18:28:50 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id h4sm256255pfg.159.2019.09.25.18.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 18:28:49 -0700 (PDT)
Date:   Wed, 25 Sep 2019 18:28:46 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Colin Ian King <colin.king@canonical.com>,
        oss-drivers@netronome.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: flow_offload: fix memory leak in
 nfp_abm_u32_knode_replace
Message-ID: <20190925182846.69a261e8@cakuba.netronome.com>
In-Reply-To: <20190925183457.32695-1-navid.emamdoost@gmail.com>
References: <20190925183457.32695-1-navid.emamdoost@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Sep 2019 13:34:46 -0500, Navid Emamdoost wrote:
> In nfp_abm_u32_knode_replace if the allocation for match fails it should
> go to the error handling instead of returning.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> ---
>  drivers/net/ethernet/netronome/nfp/abm/cls.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/abm/cls.c b/drivers/net/ethernet/netronome/nfp/abm/cls.c
> index 23ebddfb9532..32eaab99d96c 100644
> --- a/drivers/net/ethernet/netronome/nfp/abm/cls.c
> +++ b/drivers/net/ethernet/netronome/nfp/abm/cls.c
> @@ -174,7 +174,7 @@ nfp_abm_u32_knode_replace(struct nfp_abm_link *alink,
>  	struct nfp_abm_u32_match *match = NULL, *iter;
>  	unsigned int tos_off;
>  	u8 mask, val;
> -	int err;
> +	int err, ret = -EOPNOTSUPP;

You can use the err variable for the return. Please don't break the
reverse christmas tree ordering. Please initialize the err variable 
in the branch where failure occurred, not at the start of the function.

>  	if (!nfp_abm_u32_check_knode(alink->abm, knode, proto, extack))
>  		goto err_delete;
> @@ -204,8 +204,11 @@ nfp_abm_u32_knode_replace(struct nfp_abm_link *alink,
>  
>  	if (!match) {
>  		match = kzalloc(sizeof(*match), GFP_KERNEL);
> -		if (!match)
> -			return -ENOMEM;
> +		if (!match) {
> +			ret = -ENOMEM;
> +			goto err_delete;
> +		}
> +
>  		list_add(&match->list, &alink->dscp_map);
>  	}
>  	match->handle = knode->handle;
> @@ -221,7 +224,7 @@ nfp_abm_u32_knode_replace(struct nfp_abm_link *alink,
>  
>  err_delete:
>  	nfp_abm_u32_knode_delete(alink, knode);
> -	return -EOPNOTSUPP;
> +	return ret;
>  }
>  
>  static int nfp_abm_setup_tc_block_cb(enum tc_setup_type type,

