Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDB0B15055
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 17:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfEFPez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 11:34:55 -0400
Received: from mail-pf1-f179.google.com ([209.85.210.179]:45322 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbfEFPey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 11:34:54 -0400
Received: by mail-pf1-f179.google.com with SMTP id e24so6954246pfi.12
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 08:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=04KuFliRIMkRaq3aw61/Zs0gOsbjSuG7+KK5dQGAkEI=;
        b=rJ+USSp35ohA612AbW739e8ts/n27OK8aunZU6MDfnqDfX3mJViE7sBmusk/nbEaWH
         z2/0Uqk8U2oywgqyQU0LBi2jeFAeQjgG8+F5m/0brVHb/RYMBiMFRY43uwk8YEmAuPqI
         V8o9bROZKqT4agh3p4Dp07htnlZSseOg4sIObg7F5FPUVAQzKBfKzkq0sDtoY2EWrf7L
         1C8h5p3KPSomRSVFUr0Vn1qSTXB8a8ms9PMKYF9bTUtOgeDoO/Q+ZYO12xc3Dsm5l/u1
         gt4+o9itp+SnMFnf+TRt6k+s9h9Ygip/Sk39FCmBxWSmt+6WPdWlm2Jx3uIKQt1H5+WY
         i9hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=04KuFliRIMkRaq3aw61/Zs0gOsbjSuG7+KK5dQGAkEI=;
        b=JnKjbG9fwslBGHEdSpepeKK14C0+DVOixmX/brATxU3cjK4phRlLfzoKNHnVDCIesm
         U8O43UV2fw8KqlGWLK+wTvAgUFDu/61laDD3HPk1QlOgV+pKjLQ/8v3KzMnpVswPOywe
         uzcV3+Ydr0a07S9pme/a+5jdM65WWjtzmcVbpMAQte7q9kXM+LxKWTbkFPwmT5E6GHJC
         yzz35lLikz5LPzRuNn8xmE+DB8aM1r9zMJKsq/5KsAUOy0haciJm3IadIfPu38dc+V+W
         R0AY0SgYhvngpzf1KPmsUaeqpniM1woCMGYC1Do72yrthO/ui8ISLtuv9l7eDfgZGdxj
         F9gQ==
X-Gm-Message-State: APjAAAVvAki6fIZu6f4Y8ve8VCcHC/ochJWG2pl+gMoweMlHgGsW5p8F
        DjcqFSw+bDcP0tvrFm8AYwnC17fNZM0=
X-Google-Smtp-Source: APXvYqyrBrF/fIqbV212IkfvnavjwS1vi+f2+I7rXrtM1Ou0uxZQK040uTITnJPk6y4n6U72IdUpPw==
X-Received: by 2002:a63:6604:: with SMTP id a4mr33178420pgc.104.1557156893798;
        Mon, 06 May 2019 08:34:53 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id j19sm13121953pfh.41.2019.05.06.08.34.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 06 May 2019 08:34:53 -0700 (PDT)
Date:   Mon, 6 May 2019 08:34:46 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netdev@vger.kernel.org
Subject: Re: [iproute PATCH] ip-xfrm: Respect family in deleteall and list
 commands
Message-ID: <20190506083446.07431727@hermes.lan>
In-Reply-To: <20190429122424.28196-1-phil@nwl.cc>
References: <20190429122424.28196-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Apr 2019 14:24:24 +0200
Phil Sutter <phil@nwl.cc> wrote:

> Allow to limit 'ip xfrm {state|policy} list' output to a certain address
> family and to delete all states/policies by family.
> 
> Although preferred_family was already set in filters, the filter
> function ignored it. To enable filtering despite the lack of other
> selectors, filter.use has to be set if family is not AF_UNSPEC.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  ip/xfrm_policy.c   | 6 +++++-
>  ip/xfrm_state.c    | 6 +++++-
>  man/man8/ip-xfrm.8 | 6 +++---
>  3 files changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/ip/xfrm_policy.c b/ip/xfrm_policy.c
> index 4a63e9ab602d7..c6dfe836c5374 100644
> --- a/ip/xfrm_policy.c
> +++ b/ip/xfrm_policy.c
> @@ -410,6 +410,10 @@ static int xfrm_policy_filter_match(struct xfrm_userpolicy_info *xpinfo,
>  	if (!filter.use)
>  		return 1;
>  
> +	if (filter.xpinfo.sel.family != AF_UNSPEC &&
> +	    filter.xpinfo.sel.family != xpinfo->sel.family)
> +			return 0;
> +
>  	if ((xpinfo->dir^filter.xpinfo.dir)&filter.dir_mask)
>  		return 0;
>  

WARNING: suspect code indent for conditional statements (8, 24)
#68: FILE: ip/xfrm_policy.c:413:
+	if (filter.xpinfo.sel.family != AF_UNSPEC &&
[...]
+			return 0;

total: 0 errors, 1 warnings, 60 lines checked
