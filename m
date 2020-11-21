Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76EA22BC24D
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 22:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbgKUVkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 16:40:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:44532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728402AbgKUVkk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 16:40:40 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11FEB21D7A;
        Sat, 21 Nov 2020 21:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605994840;
        bh=Ovwoe+hlcKIY8SdSV622ELvlp3mbfc7w6Hr/DYwRing=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=inS7sVPD3LmeHiLYOlxWCFtEyeTDs3UtYN0OYPrOQ/s/JJVzioZbPIbqrkbMTiZOJ
         00fNSPy5wqFOciPfh/0PulvFhimTWnmOL/60u4ntBHIiSCEcW6M/vC2rnW+Dr+XiKl
         uLya/6wnv+HpdWqw5CmHk+TUfm7z4Yq2b5/qaGgI=
Date:   Sat, 21 Nov 2020 13:40:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <min.li.xe@renesas.com>
Cc:     <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net] ptp: clockmatrix: bug fix for idtcm_strverscmp
Message-ID: <20201121134039.42586c72@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1605757824-3292-1-git-send-email-min.li.xe@renesas.com>
References: <1605757824-3292-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 22:50:24 -0500 min.li.xe@renesas.com wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> Feed kstrtou8 with NULL terminated string.
> 
> Changes since v1:
> -Only strcpy 15 characters to leave 1 space for '\0'
> 
> Signed-off-by: Min Li <min.li.xe@renesas.com>

> -static int idtcm_strverscmp(const char *ver1, const char *ver2)
> +static int idtcm_strverscmp(const char *version1, const char *version2)
>  {
>  	u8 num1;
>  	u8 num2;
>  	int result = 0;
> +	char ver1[16];
> +	char ver2[16];
> +	char *cur1;
> +	char *cur2;
> +	char *next1;
> +	char *next2;
> +
> +	strncpy(ver1, version1, 15);
> +	strncpy(ver2, version2, 15);
> +	cur1 = ver1;
> +	cur2 = ver2;

Now there is no guarantee that the buffer is null terminated.

You need to use strscpy(ver... 16) or add ver[15] = '\0';

>  	/* loop through each level of the version string */
>  	while (result == 0) {
> +		next1 = strchr(cur1, '.');
> +		next2 = strchr(cur2, '.');
> +
> +		/* kstrtou8 could fail for dot */
> +		if (next1) {
> +			*next1 = '\0';
> +			next1++;
> +		}
> +
> +		if (next2) {
> +			*next2 = '\0';
> +			next2++;
> +		}
> +
>  		/* extract leading version numbers */
> -		if (kstrtou8(ver1, 10, &num1) < 0)
> +		if (kstrtou8(cur1, 10, &num1) < 0)
>  			return -1;
>  
> -		if (kstrtou8(ver2, 10, &num2) < 0)
> +		if (kstrtou8(cur2, 10, &num2) < 0)
>  			return -1;
>  
>  		/* if numbers differ, then set the result */
> -		if (num1 < num2)
> +		if (num1 < num2) {
>  			result = -1;

Why do you set the result to something instead of just returning that
value? The kstrtou8() checks above just return value directly...

If you use a return you can save yourself all the else branches.

> -		else if (num1 > num2)
> +		} else if (num1 > num2) {
>  			result = 1;
> -		else {
> +		} else {
>  			/* if numbers are the same, go to next level */
> -			ver1 = strchr(ver1, '.');
> -			ver2 = strchr(ver2, '.');
> -			if (!ver1 && !ver2)
> +			if (!next1 && !next2)
>  				break;
> -			else if (!ver1)
> +			else if (!next1) {
>  				result = -1;
> -			else if (!ver2)
> +			} else if (!next2) {
>  				result = 1;
> -			else {
> -				ver1++;
> -				ver2++;
> +			} else {
> +				cur1 = next1;
> +				cur2 = next2;
>  			}
>  		}
>  	}
> +
>  	return result;
>  }
>  

