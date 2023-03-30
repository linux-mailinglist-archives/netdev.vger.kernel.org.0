Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0E3B6D0BCF
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 18:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbjC3QvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 12:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232446AbjC3QuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 12:50:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52DDE391
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 09:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680194907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=neu/sECqFA2HSyv8h+3G/ZG17uv3HJuES3DPHzqofUo=;
        b=YVxfQ0NUZ7TsnPH/4Q6xS3L/5U1WZYmX362kQdzb4QidKj+UofiZIsz0rW4fPFv6hDW7ZX
        /KGqeOwGgHkow/nEU1hKecaYfO3PtlDbtT/OGwDsc0AyzCWKNDmiCnLmX0wK4OMahM8Ena
        8gdQNanlWQUc+/luaDbteOGKU4U6+c4=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-ifQcdGwUOFOZQqMwL6M2xA-1; Thu, 30 Mar 2023 12:48:26 -0400
X-MC-Unique: ifQcdGwUOFOZQqMwL6M2xA-1
Received: by mail-qt1-f200.google.com with SMTP id e4-20020a05622a110400b003e4e915a164so8514975qty.4
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 09:48:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680194905;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=neu/sECqFA2HSyv8h+3G/ZG17uv3HJuES3DPHzqofUo=;
        b=m+YrZ6oDq7nZdpcEvCeWpQHAIpcYB8DQMzAuLqP6AUCUfv0OdcNkIt8sTUrIF0FBpD
         2FxjL6WjKL79xyrGswqrXsouWHugsLGrWgNaE4htHP6SPbjy9gELfR0o5btg2feXYWFT
         DOtS7TLsgwC4c07l7qFE6Sy9sxkYEKZhvEkOem1Xw3chSbeKzuZIRfucdSkyTU6r5/Gm
         Igt8xruDmt3ft7cUiDuECFsZjnzBz/JfcxDzVeP20xRG7ypY/bWCkE07/u/sjjm3WJeY
         omdrjeOilB8KF1IiYmfR/8Uf4xAm+yVVJCdRP4IVb6GFscibmYJLuTVar102iROvaAUk
         NqRA==
X-Gm-Message-State: AAQBX9eRiYnlvIvSaJ4oocSzGokkLs214q52y2e+KEXXHfh2AzlJoF8+
        sty2Lku6B/n+K2IfkaqvGCqQYssqhe0xoaIE1rHQ3WL1Ww5ofNuZXgfS0E8vB3VFf6yptbtmFSa
        uAWmc1gpRz5WkCvN2
X-Received: by 2002:ad4:5cc3:0:b0:5af:9276:b59d with SMTP id iu3-20020ad45cc3000000b005af9276b59dmr39432460qvb.18.1680194905628;
        Thu, 30 Mar 2023 09:48:25 -0700 (PDT)
X-Google-Smtp-Source: AKy350bsfJa7Ms7w6bWcuX2oumdzuYRH1ydqPdjNP7d2/rwFr2ZzatMkAeeGK44XcLRXrJ5D75/kNA==
X-Received: by 2002:ad4:5cc3:0:b0:5af:9276:b59d with SMTP id iu3-20020ad45cc3000000b005af9276b59dmr39432438qvb.18.1680194905417;
        Thu, 30 Mar 2023 09:48:25 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id f8-20020a05620a280800b0074269db4699sm12762620qkp.46.2023.03.30.09.48.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 09:48:23 -0700 (PDT)
Message-ID: <b87511b7-6840-3bc7-23e8-0cf4c6a95b63@redhat.com>
Date:   Thu, 30 Mar 2023 12:48:22 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net 3/3] selftests: bonding: add arp validate test
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Liang Li <liali@redhat.com>
References: <20230329101859.3458449-1-liuhangbin@gmail.com>
 <20230329101859.3458449-4-liuhangbin@gmail.com>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <20230329101859.3458449-4-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/29/23 06:18, Hangbin Liu wrote:
> This patch add bonding arp validate tests with mode active backup,
> monitor arp_ip_target and ns_ip6_target. It also checks mii_status
> to make sure all slaves are UP.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: Jonathan Toppins <jtoppins@redhat.com>

