Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A093BC4E4
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 04:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhGFCrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 22:47:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41378 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229781AbhGFCro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 22:47:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625539506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vnJzjlN8Z9nx1OV1WylAv0Iuq/Q/DMpUOyYrHh4Ncmk=;
        b=VRPqUBCr2WxhrQif+Dy/SzR8bbxUypZdDjdDRECCbUMSBufepS305gFr2CowYNvFc8PUtL
        BTlMsgKqKZ611Av4wXa/IlqgdZt/K6niCITOBbX2uUOcZD/SVmLOL9LXOX7BL12UeXpKVR
        cdqOk9rPxzxB61jq+90BjITBlyO8vWw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-_gM-zSR5PTKpVcz4Xv4DDg-1; Mon, 05 Jul 2021 22:45:05 -0400
X-MC-Unique: _gM-zSR5PTKpVcz4Xv4DDg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F8C5802C80;
        Tue,  6 Jul 2021 02:45:04 +0000 (UTC)
Received: from fedora (ovpn-13-250.pek2.redhat.com [10.72.13.250])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 74DF419C79;
        Tue,  6 Jul 2021 02:44:59 +0000 (UTC)
Date:   Tue, 6 Jul 2021 10:44:55 +0800
From:   Hangbin Liu <haliu@redhat.com>
To:     Martynas Pumputis <m@lambda.lt>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com
Subject: Re: [PATCH iproute2] libbpf: fix attach of prog with multiple
 sections
Message-ID: <YOPDp/UqkbX8DM2+@fedora>
References: <20210705124307.201303-1-m@lambda.lt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210705124307.201303-1-m@lambda.lt>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 05, 2021 at 02:43:07PM +0200, Martynas Pumputis wrote:
> When BPF programs which consists of multiple executable sections via
> iproute2+libbpf (configured with LIBBPF_FORCE=on), we noticed that a
> wrong section can be attached to a device. E.g.:
> 
>     # tc qdisc replace dev lxc_health clsact
>     # tc filter replace dev lxc_health ingress prio 1 \
>         handle 1 bpf da obj bpf_lxc.o sec from-container
>     # tc filter show dev lxc_health ingress filter protocol all
>         pref 1 bpf chain 0 filter protocol all pref 1 bpf chain 0
>         handle 0x1 bpf_lxc.o:[__send_drop_notify] <-- WRONG SECTION
>         direct-action not_in_hw id 38 tag 7d891814eda6809e jited
> 
> After taking a closer look into load_bpf_object() in lib/bpf_libbpf.c,
> we noticed that the filter used in the program iterator does not check
> whether a program section name matches a requested section name
> (cfg->section). This can lead to a wrong prog FD being used to attach
> the program.
> 
> Fixes: 6d61a2b55799 ("lib: add libbpf support")
> Signed-off-by: Martynas Pumputis <m@lambda.lt>
> ---
>  lib/bpf_libbpf.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/bpf_libbpf.c b/lib/bpf_libbpf.c
> index d05737a4..f76b90d2 100644
> --- a/lib/bpf_libbpf.c
> +++ b/lib/bpf_libbpf.c
> @@ -267,10 +267,12 @@ static int load_bpf_object(struct bpf_cfg_in *cfg)
>  	}
>  
>  	bpf_object__for_each_program(p, obj) {
> +		bool prog_to_attach = !prog && cfg->section &&
> +			!strcmp(get_bpf_program__section_name(p), cfg->section);
> +
>  		/* Only load the programs that will either be subsequently
>  		 * attached or inserted into a tail call map */
> -		if (find_legacy_tail_calls(p, obj) < 0 && cfg->section &&
> -		    strcmp(get_bpf_program__section_name(p), cfg->section)) {
> +		if (find_legacy_tail_calls(p, obj) < 0 && !prog_to_attach) {
>  			ret = bpf_program__set_autoload(p, false);
>  			if (ret)
>  				return -EINVAL;
> @@ -279,7 +281,8 @@ static int load_bpf_object(struct bpf_cfg_in *cfg)
>  
>  		bpf_program__set_type(p, cfg->type);
>  		bpf_program__set_ifindex(p, cfg->ifindex);
> -		if (!prog)
> +
> +		if (prog_to_attach)
>  			prog = p;
>  	}
>  
> -- 
> 2.32.0
> 

Thanks for the fix.

Acked-by: Hangbin Liu <haliu@redhat.com>

