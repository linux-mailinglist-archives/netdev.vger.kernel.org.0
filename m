Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612A1313E54
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 20:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235005AbhBHTAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 14:00:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57069 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233394AbhBHS6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 13:58:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612810630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=91LVHLBIRVHkk+T1rimEVrXl0vPO+hPWtAkdqhc2bi4=;
        b=JBmwFQB+lGkEYCn8xcY9MFqX+AGraWB6zYFcDyUa6aQoRWR7JkFjmyu7WebYoc5/d99wGr
        7RAGAntyTiyviz1jc67Du+zlBeQF4b8lGXjqCuv7AyhcKd/EBFKka6cXqMcIygRM4NwUgm
        py/+E+kUQvv7D71ZLLwV4InQ3aOBgpo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-Y89CsDOPPGO9p713aD96hw-1; Mon, 08 Feb 2021 13:57:09 -0500
X-MC-Unique: Y89CsDOPPGO9p713aD96hw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5962107ACF5;
        Mon,  8 Feb 2021 18:57:07 +0000 (UTC)
Received: from horizon.localdomain (ovpn-113-37.rdu2.redhat.com [10.10.113.37])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 710D95C3F8;
        Mon,  8 Feb 2021 18:57:07 +0000 (UTC)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 380B4C00A2; Mon,  8 Feb 2021 15:57:05 -0300 (-03)
Date:   Mon, 8 Feb 2021 15:57:05 -0300
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
To:     wenxu@ucloud.cn
Cc:     jhs@mojatatu.com, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net v4] net/sched: cls_flower: Reject invalid ct_state
 flags rules
Message-ID: <20210208185705.GE2953@horizon.localdomain>
References: <1612674803-7912-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612674803-7912-1-git-send-email-wenxu@ucloud.cn>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 07, 2021 at 01:13:23PM +0800, wenxu@ucloud.cn wrote:
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -30,6 +30,11 @@
>  
>  #include <uapi/linux/netfilter/nf_conntrack_common.h>
>  
> +#define TCA_FLOWER_KEY_CT_FLAGS_MASK (TCA_FLOWER_KEY_CT_FLAGS_NEW | \
> +				      TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED | \
> +				      TCA_FLOWER_KEY_CT_FLAGS_RELATED | \
> +				      TCA_FLOWER_KEY_CT_FLAGS_TRACKED)
> +

I know Jakub had said the calculations for _MASK were complicated, but
seeing this, they seem worth, otherwise we have to manually maintain
this duplicated list of entries here.

Maybe add just the __TCA_FLOWER_KEY_CT_FLAGS_MAX to the enum, and do
the calcs here? (to avoid having them in uapi)

>  struct fl_flow_key {
>  	struct flow_dissector_key_meta meta;
>  	struct flow_dissector_key_control control;
> @@ -687,7 +692,8 @@ static void *fl_get(struct tcf_proto *tp, u32 handle)
>  	[TCA_FLOWER_KEY_ENC_OPTS]	= { .type = NLA_NESTED },
>  	[TCA_FLOWER_KEY_ENC_OPTS_MASK]	= { .type = NLA_NESTED },
>  	[TCA_FLOWER_KEY_CT_STATE]	= { .type = NLA_U16 },

I wonder if this one should be protected by the flags mask as well.
It won't take action on unknown bits because of the mask below, but
still, it is accepting data that it doesn't know its meaning.

> -	[TCA_FLOWER_KEY_CT_STATE_MASK]	= { .type = NLA_U16 },
> +	[TCA_FLOWER_KEY_CT_STATE_MASK]	=
> +		NLA_POLICY_MASK(NLA_U16, TCA_FLOWER_KEY_CT_FLAGS_MASK),
>  	[TCA_FLOWER_KEY_CT_ZONE]	= { .type = NLA_U16 },
>  	[TCA_FLOWER_KEY_CT_ZONE_MASK]	= { .type = NLA_U16 },
>  	[TCA_FLOWER_KEY_CT_MARK]	= { .type = NLA_U32 },

