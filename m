Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0FED51BD8A
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 12:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356228AbiEEK4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 06:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356242AbiEEK4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 06:56:48 -0400
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.129.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 835E553A5C
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 03:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651747988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eJGAS4yaoQAPtBZfRd2dIQspF+HuuXpMPNUHRNX3r20=;
        b=FI/397i1beNFK9fkGvjFHBhIYNhhW/pu3OObsUhG43RU8JTwvYjuQs3naUssJ/pm/oYQCq
        DBNVKLct8OHjmhhvocGGBkOvJ/gGYJ5nuP2SYG+OvEo5CRw25Eznm9l6Donq4dkPiVZpAf
        l3qWXxtLff+dTXbrh3H2WWW2jY1nUBo=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-o-sbjZhFNcWtZvgxlFwkWQ-1; Thu, 05 May 2022 06:52:59 -0400
X-MC-Unique: o-sbjZhFNcWtZvgxlFwkWQ-1
Received: by mail-qk1-f197.google.com with SMTP id s63-20020a372c42000000b0069ec0715d5eso2586403qkh.10
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 03:52:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=eJGAS4yaoQAPtBZfRd2dIQspF+HuuXpMPNUHRNX3r20=;
        b=HsTJNHFIcDCXoRLU3Z5uNcFPnjY3dB6vfn7rUxsMPJeXnPzKtP0IdtDLZRGZpSqG3G
         K/FSPVG9pSzLGKwLYYl+Z0n3FNp1t2ZFKtp4nDq4EKmRwica3dflOpXHeJkMJ37FlrpL
         6Mrej1k3P6yG1GNZnyo8UHCfoJz08M+fVIzB9DnAwvbr38mIl4Z45JsbBrsoypPie+2k
         lIQVFgz2K1ZLW6AiQJdapxEjcmXZKyi/8uZHn37zzXShfGxfU3qYbByZUijVtuV3Z9dq
         PEr+Aau/x7hc+Bv6ZZW7uyhfUjELsCwqf1PLxTFo/p6XjCUPwRUfMa/zyA4IKbKEQ3y2
         jgIQ==
X-Gm-Message-State: AOAM5332KpGvxNvHC3oIdD59ahUyU7g2gzMpVyJgQRADTyWO1Q4V5PkZ
        48k5PPAN9TfpR4E8C/EyUTVIaLTvgY6ELtbnmSYJCZRQSF/H1PNUjkKucbR75/vBI1bYkf1WOxS
        CB5VnVzPG4CaGc7iA
X-Received: by 2002:a05:622a:1747:b0:2f3:88ca:54fa with SMTP id l7-20020a05622a174700b002f388ca54famr23564531qtk.237.1651747979215;
        Thu, 05 May 2022 03:52:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/6WiWQvw4OPuKQs3GHenMOQSASZd72+xzwxrckb0rTZy1KvqZsiIfUN22yrNar0fhkWVQbg==
X-Received: by 2002:a05:622a:1747:b0:2f3:88ca:54fa with SMTP id l7-20020a05622a174700b002f388ca54famr23564521qtk.237.1651747978982;
        Thu, 05 May 2022 03:52:58 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-115-66.dyn.eolo.it. [146.241.115.66])
        by smtp.gmail.com with ESMTPSA id h6-20020ac87446000000b002f39b99f6acsm603384qtr.70.2022.05.05.03.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 03:52:58 -0700 (PDT)
Message-ID: <4c2a15271887aa3f5d759771ddedac04e11db743.camel@redhat.com>
Subject: Re: [PATCH net-next v3 2/6] ptp: Request cycles for TX timestamp
From:   Paolo Abeni <pabeni@redhat.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        richardcochran@gmail.com, vinicius.gomes@intel.com,
        yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     mlichvar@redhat.com, netdev@vger.kernel.org
Date:   Thu, 05 May 2022 12:52:55 +0200
In-Reply-To: <20220501111836.10910-3-gerhard@engleder-embedded.com>
References: <20220501111836.10910-1-gerhard@engleder-embedded.com>
         <20220501111836.10910-3-gerhard@engleder-embedded.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2022-05-01 at 13:18 +0200, Gerhard Engleder wrote:
> The free running cycle counter of physical clocks called cycles shall be
> used for hardware timestamps to enable synchronisation.
> 
> Introduce new flag SKBTX_HW_TSTAMP_USE_CYCLES, which signals driver to
> provide a TX timestamp based on cycles if cycles are supported.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  include/linux/skbuff.h |  5 +++++
>  net/core/skbuff.c      |  5 +++++
>  net/socket.c           | 11 ++++++++++-
>  3 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 3270cb72e4d8..fa03e02b761d 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -615,6 +615,11 @@ enum {
>  	/* device driver is going to provide hardware time stamp */
>  	SKBTX_IN_PROGRESS = 1 << 2,
>  
> +	/* generate hardware time stamp based on cycles if supported, flag is
> +	 * used only for TX path
> +	 */
> +	SKBTX_HW_TSTAMP_USE_CYCLES = 1 << 3,
> +
>  	/* generate wifi status information (where possible) */
>  	SKBTX_WIFI_STATUS = 1 << 4,

Don't you need to update accordingly SKBTX_ANY_TSTAMP, so that this
flags is preserved on segmentation?


Thanks!

Paolo

