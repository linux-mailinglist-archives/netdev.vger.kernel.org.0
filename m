Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E274B510254
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 17:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352683AbiDZQAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 12:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352666AbiDZQAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 12:00:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 09407387A0
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 08:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650988663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TkKuUo32/J9DonHrfJ5BZUhvklozprERW7prdcPlnX0=;
        b=Ouj8iYo11/ZJpWQa3B3+8gyz/8iL3jUPj4T033El9J3HyzS8fEGn5P0nezkap4+5K+Rbme
        0RfC27qVydkoKByPsOOdnh8XbdP2XROmHLo6yjld5Ifqo3uhDORl39UlYfS/9lKeeAYBK4
        pOvCRVkwaCq7Q0hEdRURQWdM1OG7UTU=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-esZDktl9M7q28qjoTYO3fQ-1; Tue, 26 Apr 2022 11:57:41 -0400
X-MC-Unique: esZDktl9M7q28qjoTYO3fQ-1
Received: by mail-ej1-f71.google.com with SMTP id nc20-20020a1709071c1400b006f3726da7d3so4693608ejc.15
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 08:57:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TkKuUo32/J9DonHrfJ5BZUhvklozprERW7prdcPlnX0=;
        b=Eu1FpTKj1TuHQeoDbroq6QqijDwveRVFIOGxTLAPNCentnK6rWRsytPPdPNVpCBwLQ
         ztr2Kxx/vEpaW/im7XqDDfAoGOydAH00oSkteLVjVKtlOTVVSygnS+pwJvYZn8TvuS25
         BmtWBcuO/k7apn1vTZ8wWrEzhXn3xV9fqnYHIsqARHMAZXKGay8ziZdZtp7/nHSVOL29
         6K4TZlG411GroKf2HDUdIqED967+z/mTq3ywNp1pMGZQ2SGc/A81oeRlu0dSbFTHeaDE
         Sq0TBRH6K0pe6umebYmfyR5/AR/kZU+gKJzS2tdA3ATIOtjMD8uE854Kr0bvAw+B0qLx
         2BiA==
X-Gm-Message-State: AOAM531RloBDF5fxUVLME7/HQPrNt9AkULcCKk+J43TnYltJg4UWoCpW
        PtsZwCKkBJSeDdUE8tHqbADyN6dgjkd6v2WQXvzSQzhkufHo2av3xNkqu0IMZnLTS04yuOpV6fd
        rZsFcYnDJB/l6CKXB
X-Received: by 2002:a17:906:aed8:b0:6f3:7e6b:14d with SMTP id me24-20020a170906aed800b006f37e6b014dmr14313200ejb.451.1650988660404;
        Tue, 26 Apr 2022 08:57:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxLbkGySw9HKU9T5GClMyjg6GJ1qdgz4DT4v6q+yj+pA2eldbZaLN/GjYetj1UIwjjqKxbdtA==
X-Received: by 2002:a17:906:aed8:b0:6f3:7e6b:14d with SMTP id me24-20020a170906aed800b006f37e6b014dmr14313189ejb.451.1650988660176;
        Tue, 26 Apr 2022 08:57:40 -0700 (PDT)
Received: from localhost ([37.161.137.75])
        by smtp.gmail.com with ESMTPSA id u12-20020aa7d54c000000b00423e004bf9asm6490554edr.86.2022.04.26.08.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 08:57:39 -0700 (PDT)
Date:   Tue, 26 Apr 2022 17:57:35 +0200
From:   Andrea Claudi <aclaudi@redhat.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH iproute2 0/3] Fix some typos in doc and man pages
Message-ID: <YmgWb08vTOvF45yO@renaissance-vector>
References: <cover.1647955885.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1647955885.git.aclaudi@redhat.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 22, 2022 at 03:32:02PM +0100, Andrea Claudi wrote:
> As per description, this series contains some typo fixes on doc an man
> pages.
> 
> - patch 1/3 fixes a typo in a devlink example
> - patch 2/3 fixes typos on some man pages
> - patch 3/3 fixes a typo in the tc actions doc
> 
> Andrea Claudi (3):
>   man: devlink-region: fix typo in example
>   man: fix some typos
>   doc: fix 'infact' --> 'in fact' typo
> 
>  doc/actions/actions-general | 2 +-
>  man/man8/dcb-app.8          | 2 +-
>  man/man8/dcb-dcbx.8         | 2 +-
>  man/man8/devlink-dev.8      | 2 +-
>  man/man8/devlink-region.8   | 2 +-
>  5 files changed, 5 insertions(+), 5 deletions(-)
> 
> -- 
> 2.35.1
>

Hi Stephen, is there any issue with this series? Should I resend it?

Thanks,
Andrea

