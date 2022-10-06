Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 277C25F65D5
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 14:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbiJFMVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 08:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbiJFMVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 08:21:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DDEA9C23F
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 05:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665058868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BjyJOEHOd3ekNKQuzZrYggio0SWwIcFnXCp3Am/JLm8=;
        b=DWR8Ky1Y7rS7arVai1oiY0dsu9kREySfXV+RiZsf/idSp2zlgv8cL1IzfIpwOkJLviipnS
        2vhl17S3+KdtoTg2ZS09CK/y6G3aKTHilAcqyTbwqAunPWIicMGfw9a4G0sUEiTLfKuPB3
        50zMsr0osEugu/R32ObeFBdzWwjmKS0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-267-tM7mGP-jMb6agoJ9CVf2SQ-1; Thu, 06 Oct 2022 08:21:07 -0400
X-MC-Unique: tM7mGP-jMb6agoJ9CVf2SQ-1
Received: by mail-wr1-f70.google.com with SMTP id d22-20020adfa356000000b0022e224b21c0so465773wrb.9
        for <netdev@vger.kernel.org>; Thu, 06 Oct 2022 05:21:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=BjyJOEHOd3ekNKQuzZrYggio0SWwIcFnXCp3Am/JLm8=;
        b=ztad+RvRuGK0p0cYDfT47pKSXM2mnycvzL2GYmcSbsVXzvetrCKdJwmUvEG+5BxMTI
         i6017rEq7lbePH+TZm6ybzb/dG0AIW54tgtF7CkQsKGApVyhKtLJBDMhPbb9B+F5pFfR
         OJ8bWYbBy9NJfkME4U2Bp1tmVJvcoI50g4s6hudwyYcsYQz52lI737Xgu2E7Oa7pr1UQ
         QZRO6HwgXZlZ9BpXV8VFqdJO8qDjvbolNUWVq4bkC/a3rJrK94IunH36J++Pg1F0YlYg
         5NuYxlNbf09hWufDZYuLt3+g2YRN7Ue91AK5Cigwm0v6GguKRXZzoxS7ls/qfiXr2Uoc
         XqjQ==
X-Gm-Message-State: ACrzQf2fqzttsYc4F6akO+8jXZGwmd1HuuYLDUUlKXXtSdC+tJ1jGHRM
        3zU0tXEEi5WP967ku/kJZUxyupErm0vkR9zUexW2yCB/anBwAoW0Hd7pEYhJe06Uf8KR5/lyEwZ
        RfSCZZ2WkmT9unMVk
X-Received: by 2002:a5d:5691:0:b0:22c:db35:7939 with SMTP id f17-20020a5d5691000000b0022cdb357939mr2910610wrv.102.1665058865631;
        Thu, 06 Oct 2022 05:21:05 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4O12GayFYcl3Vew2JdkBFoqZT7XrgH6LaqVmqcsi7V+lCcvwYKm2pXMPk0vhzgiVEFjmBVWg==
X-Received: by 2002:a5d:5691:0:b0:22c:db35:7939 with SMTP id f17-20020a5d5691000000b0022cdb357939mr2910601wrv.102.1665058865431;
        Thu, 06 Oct 2022 05:21:05 -0700 (PDT)
Received: from localhost.localdomain ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id z15-20020a056000110f00b0022e0580b7a9sm9101752wrw.17.2022.10.06.05.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 05:21:04 -0700 (PDT)
Date:   Thu, 6 Oct 2022 14:21:01 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Wojciech Drewek <wojciech.drewek@intel.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Subject: Re: [PATCH iproute2-next v2 3/3] f_flower: Introduce L2TPv3 support
Message-ID: <20221006122101.GD3328@localhost.localdomain>
References: <20221005104432.369341-1-wojciech.drewek@intel.com>
 <20221005104432.369341-4-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221005104432.369341-4-wojciech.drewek@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 05, 2022 at 12:44:32PM +0200, Wojciech Drewek wrote:
> @@ -291,11 +293,16 @@ entry.
>  .I TTL
>  is an unsigned 8 bit value in decimal format.
>  .TP
> +.BI l2tpv3_sid " LSID"
> +Match on L2TPv3 session id field transported over IP or IPv6.

I'd rather say either just 'over IP.' (any version), or
'over IPv4 or IPv6.' (both versions written explicitly).

> +static int flower_parse_l2tpv3(char *str, __be16 eth_type, __u8 ip_proto,
> +			       struct nlmsghdr *n)
> +{
> +	__be32 sid;
> +	int ret;
> +
> +	if ((eth_type != htons(ETH_P_IP) && eth_type != htons(ETH_P_IPV6)) ||

Testing eth_type shouldn't be necessary here, since
flower_parse_ip_proto() should have already verified that eth_type is
compatible with IPPROTO_L2TP. So eth_type can even be dropped from
the function parameters. Also the error message probably doesn't need
to talk about the ethertype as flower_parse_ip_proto() should have
already complained.

Apart from that,

Reviewed-by: Guillaume Nault <gnault@redhat.com>

