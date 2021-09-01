Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8863FD144
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 04:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241574AbhIACWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 22:22:38 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:49374 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241408AbhIACWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 22:22:37 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Ump9hix_1630462887;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0Ump9hix_1630462887)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 01 Sep 2021 10:21:27 +0800
Subject: Re: [PATCH] Revert "net: fix NULL pointer reference in
 cipso_v4_doi_free"
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
To:     Paul Moore <paul@paul-moore.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
References: <c6864908-d093-1705-76ce-94d6af85e092@linux.alibaba.com>
 <18f0171e-0cc8-6ae6-d04a-a69a2a3c1a39@linux.alibaba.com>
 <7f239a0e-7a09-3dc0-43ce-27c19c7a309d@linux.alibaba.com>
Message-ID: <4c000115-4069-5277-ce82-946f2fdb790a@linux.alibaba.com>
Date:   Wed, 1 Sep 2021 10:21:27 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <7f239a0e-7a09-3dc0-43ce-27c19c7a309d@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paul, it confused me since it's the first time I face
such situation, but I just realized what you're asking is
actually this revert, correct?

Regards,
Michael Wang

On 2021/9/1 上午10:18, 王贇 wrote:
> This reverts commit 733c99ee8be9a1410287cdbb943887365e83b2d6.
> 
> Since commit e842cb60e8ac ("net: fix NULL pointer reference in
> cipso_v4_doi_free") also applied to fix the root cause, we can
> just revert the old version now.
> 
> Suggested-by: Paul Moore <paul@paul-moore.com>
> Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
> ---
>  net/ipv4/cipso_ipv4.c | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
> index 7fbd0b5..099259f 100644
> --- a/net/ipv4/cipso_ipv4.c
> +++ b/net/ipv4/cipso_ipv4.c
> @@ -465,16 +465,14 @@ void cipso_v4_doi_free(struct cipso_v4_doi *doi_def)
>  	if (!doi_def)
>  		return;
> 
> -	if (doi_def->map.std) {
> -		switch (doi_def->type) {
> -		case CIPSO_V4_MAP_TRANS:
> -			kfree(doi_def->map.std->lvl.cipso);
> -			kfree(doi_def->map.std->lvl.local);
> -			kfree(doi_def->map.std->cat.cipso);
> -			kfree(doi_def->map.std->cat.local);
> -			kfree(doi_def->map.std);
> -			break;
> -		}
> +	switch (doi_def->type) {
> +	case CIPSO_V4_MAP_TRANS:
> +		kfree(doi_def->map.std->lvl.cipso);
> +		kfree(doi_def->map.std->lvl.local);
> +		kfree(doi_def->map.std->cat.cipso);
> +		kfree(doi_def->map.std->cat.local);
> +		kfree(doi_def->map.std);
> +		break;
>  	}
>  	kfree(doi_def);
>  }
> 
