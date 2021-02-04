Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6876A30F40F
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 14:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236423AbhBDNlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 08:41:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43726 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236324AbhBDNkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 08:40:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612445950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lk+0dsrM3CtpSxSKTTqUY2X0kFyHwnbxDEREaweSOBg=;
        b=ADvlxSOt0nzCJyLEzMRBRoBJkc4NZHydqk4jPOhc8/wH4ZarLp9E+WwG8cN8YxsrY3bKrn
        nSz0YfDIw8KH+7aDY7ikLvuPSyQA9gm7SAdPTgmi3Wrk7IWikJB8n545Ht+ERzUkGGDnNM
        4rb11OR8cQgouS+8gQetBVaC8zFM97A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-vdjcFdfEOqS1JVUlZWDUZw-1; Thu, 04 Feb 2021 08:39:06 -0500
X-MC-Unique: vdjcFdfEOqS1JVUlZWDUZw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76DDF1020C29;
        Thu,  4 Feb 2021 13:39:05 +0000 (UTC)
Received: from horizon.localdomain (ovpn-113-166.rdu2.redhat.com [10.10.113.166])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C6BC55D762;
        Thu,  4 Feb 2021 13:39:04 +0000 (UTC)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 0A2D0C2CDA; Thu,  4 Feb 2021 10:38:57 -0300 (-03)
Date:   Thu, 4 Feb 2021 10:38:56 -0300
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
To:     wenxu@ucloud.cn
Cc:     i.maximets@ovn.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] net/sched: cls_flower: Return invalid for unknown
 ct_state flags rules
Message-ID: <20210204133856.GH3399@horizon.localdomain>
References: <1612412244-26434-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612412244-26434-1-git-send-email-wenxu@ucloud.cn>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Feb 04, 2021 at 12:17:24PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Reject the unknown ct_state flags of cls flower rules. This also make
> the userspace like ovs to probe the ct_state flags support in the
> kernel.

That's a good start but it could also do some combination sanity
checks, like ovs does in validate_ct_state(). For example, it does:

      if (state && !(state & CS_TRACKED)) {
          ds_put_format(ds, "%s: invalid connection state: "
                        "If \"trk\" is unset, no other flags are set\n",

...
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -1403,6 +1403,10 @@ static int fl_set_key_ct(struct nlattr **tb,
>  		fl_set_key_val(tb, &key->ct_state, TCA_FLOWER_KEY_CT_STATE,
>  			       &mask->ct_state, TCA_FLOWER_KEY_CT_STATE_MASK,
>  			       sizeof(key->ct_state));
> +		if (TCA_FLOWER_KEY_CT_FLAGS_UNKNOWN(mask->ct_state)) {
> +			NL_SET_ERR_MSG(extack, "invalid ct_state flags");

cls_flower is inconsistent on this but please use NL_SET_ERR_MSG_MOD instead.

> +			return -EINVAL;
> +		}
>  	}
>  	if (tb[TCA_FLOWER_KEY_CT_ZONE]) {
>  		if (!IS_ENABLED(CONFIG_NF_CONNTRACK_ZONES)) {
> -- 
> 1.8.3.1
> 

