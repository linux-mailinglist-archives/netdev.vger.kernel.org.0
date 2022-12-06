Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F227564415A
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 11:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234278AbiLFKh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 05:37:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233849AbiLFKhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 05:37:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36DCFDF5A
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 02:36:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670323018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D9WTzI07B2T90FQ6MBF1oIvNELJRpqkR308N9NI9I8E=;
        b=SB99WnPf9f6kGafyfbOktewcGCfDrvcu1b3i+msWfAh+WL2/ZLbSJftHUFpPXrwWlvWiHD
        VQalX8SMAnKeBXwj2I4WB1uDi0i5qjXclc60Vne+orHeg7cGwVbrexfyAdgV/BsFE7EDTP
        WCqgqL0YpDw22/YC62jYIB/P6Hzd8/0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-107-O1l6qiGiNrKUl_vOdWgySw-1; Tue, 06 Dec 2022 05:36:57 -0500
X-MC-Unique: O1l6qiGiNrKUl_vOdWgySw-1
Received: by mail-wm1-f72.google.com with SMTP id v125-20020a1cac83000000b003cfa148576dso8251814wme.3
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 02:36:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D9WTzI07B2T90FQ6MBF1oIvNELJRpqkR308N9NI9I8E=;
        b=ZePwIhD0yL3+lcZ4qFnCvGfA4pvKGvnsdGufyM0TFZlxTR6QtKI8n35qFjOVHVwGYL
         hlV3nH00BqHtol7YLeKs07B/0WL4kN9Oe9fh9TpOBVCs8ECf2bVitsGOlGRIH1QaXKcK
         TCuPpek443Bv3TUQClif+8beX0lIdU06SpdQwFmihCFPZwpvDyJHDWpqdHYVu6OSWbda
         izxTFtMQvhpUMYzJ1BDOW//42/HZW7xEagr9iNFfIIa5TZ1MfHGXGWsfN/wodGv6n01o
         2tnXFoKOvLsiJl+qwN8ByEaMcW3eMa3T5Ed6fO424PwoCtpWXLpl7BgUqiscai5nwXWi
         /MAg==
X-Gm-Message-State: ANoB5pkn0vfxaxJDqCwP9uYVFmw6W5nxYB9nQx1ZIgwu8q3W4JjtfUcl
        enPUYpMq/pH/GiKdksfv4X93yQulW3cJ9OqmhdoAIXwbn+uALLNY8+jWGYWsDofvLrB1DSdt2Cc
        rNVq5Ppz9FyojNI2f
X-Received: by 2002:a5d:6101:0:b0:242:46d0:3ee1 with SMTP id v1-20020a5d6101000000b0024246d03ee1mr10075200wrt.315.1670323015970;
        Tue, 06 Dec 2022 02:36:55 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4hdCTFiVaTLif2boeNw/kxGbQScPuaS1un/J2RGjn40Favi8QTQ0cVDhBrer5EXpUMnibKEw==
X-Received: by 2002:a5d:6101:0:b0:242:46d0:3ee1 with SMTP id v1-20020a5d6101000000b0024246d03ee1mr10075190wrt.315.1670323015747;
        Tue, 06 Dec 2022 02:36:55 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-106-100.dyn.eolo.it. [146.241.106.100])
        by smtp.gmail.com with ESMTPSA id v128-20020a1cac86000000b003cfa80443a0sm20734164wme.35.2022.12.06.02.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 02:36:55 -0800 (PST)
Message-ID: <abd1a8e98d8b6d19520ae41d164ee905a40b3c42.camel@redhat.com>
Subject: Re: [PATCH] net/ncsi: Silence runtime memcpy() false positive
 warning
From:   Paolo Abeni <pabeni@redhat.com>
To:     Kees Cook <keescook@chromium.org>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>
Cc:     Joel Stanley <joel@jms.id.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Date:   Tue, 06 Dec 2022 11:36:54 +0100
In-Reply-To: <20221202212418.never.837-kees@kernel.org>
References: <20221202212418.never.837-kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, 2022-12-02 at 13:24 -0800, Kees Cook wrote:
> The memcpy() in ncsi_cmd_handler_oem deserializes nca->data into a
> flexible array structure that overlapping with non-flex-array members
> (mfr_id) intentionally. Since the mem_to_flex() API is not finished,
> temporarily silence this warning, since it is a false positive, using
> unsafe_memcpy().
> 
> Reported-by: Joel Stanley <joel@jms.id.au>
> Link: https://lore.kernel.org/netdev/CACPK8Xdfi=OJKP0x0D1w87fQeFZ4A2DP2qzGCRcuVbpU-9=4sQ@mail.gmail.com/
> Cc: Samuel Mendoza-Jonas <sam@mendozajonas.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Is this for the -net or the -net-next tree? It applies to both...

It you are targetting the -net tree, I think it would be nicer adding a
suitable Fixes tag.

Thanks!

Paolo

