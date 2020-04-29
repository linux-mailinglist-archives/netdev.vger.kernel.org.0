Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED5081BE5DB
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 20:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgD2SKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 14:10:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbgD2SKh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 14:10:37 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87F8022207;
        Wed, 29 Apr 2020 18:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588183836;
        bh=QsGMWokoEeF6AA9IlkwNMEPKv28ahqr2xwOje9PtsrI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NBjg6McJm8xLM2GJxjzeVN/0ypzjIxoKYF0I/ik0rDoozqdDxWmUQrHSTxzqlMBPB
         5Tb86xkOSgy9ftzwyTvOaSt7uKvebC9GOfX7C49pbVeNNoio6M8yi78aLvjBGIHh1T
         IbEImFQXGuFfeheObiS0i5AlKcKTTHWZZ5DTwxEs=
Date:   Wed, 29 Apr 2020 11:10:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, Antonio Quartulli <ordex@autistici.org>,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 4/7] netlink: extend policy range validation
Message-ID: <20200429111034.71ab2443@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200429154836.b86f45043a5e.I7b46d9c85e4d7a99c0b5e0c2f54bb89b5750e6dc@changeid>
References: <20200429134843.42224-1-johannes@sipsolutions.net>
        <20200429154836.b86f45043a5e.I7b46d9c85e4d7a99c0b5e0c2f54bb89b5750e6dc@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Apr 2020 15:48:40 +0200 Johannes Berg wrote:
> diff --git a/lib/nlattr.c b/lib/nlattr.c
> index 7f7ebd89caa4..bb66d06cc6f9 100644
> --- a/lib/nlattr.c
> +++ b/lib/nlattr.c
> @@ -111,17 +111,33 @@ static int nla_validate_array(const struct nlattr *head, int len, int maxtype,
>  	return 0;
>  }
>  
> -static int nla_validate_int_range(const struct nla_policy *pt,
> -				  const struct nlattr *nla,
> -				  struct netlink_ext_ack *extack)
> +static int nla_validate_int_range_unsigned(const struct nla_policy *pt,
> +					   const struct nlattr *nla,
> +					   struct netlink_ext_ack *extack)
>  {
> -	bool validate_min, validate_max;
> -	s64 value;
> +	struct netlink_range_validation _range = {
> +		.min = 0,
> +		.max = U64_MAX,
> +	}, *range = &_range;
> +	u64 value;
>  
> -	validate_min = pt->validation_type == NLA_VALIDATE_RANGE ||
> -		       pt->validation_type == NLA_VALIDATE_MIN;
> -	validate_max = pt->validation_type == NLA_VALIDATE_RANGE ||
> -		       pt->validation_type == NLA_VALIDATE_MAX;
> +	WARN_ON_ONCE(pt->min < 0 || pt->max < 0);

I'm probably missing something, but in case of NLA_VALIDATE_RANGE_PTR
aren't min and max invalid (union has the range pointer set, so this
will read 2 bytes of the pointer).

> +	switch (pt->validation_type) {
> +	case NLA_VALIDATE_RANGE:
> +		range->min = pt->min;
> +		range->max = pt->max;
> +		break;
> +	case NLA_VALIDATE_RANGE_PTR:
> +		range = pt->range;
> +		break;
> +	case NLA_VALIDATE_MIN:
> +		range->min = pt->min;
> +		break;
> +	case NLA_VALIDATE_MAX:
> +		range->max = pt->max;
> +		break;
> +	}

