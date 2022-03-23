Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 882614E5369
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 14:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241718AbiCWNoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 09:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbiCWNox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 09:44:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B051E9FF2
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 06:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648043001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IJHOsMD+p/TxrB7WMAz/bVsoyRgqHIkadq0oUUT9qqg=;
        b=NvL9xY8V51sUmwyuqcFMrtHswAkvSJe3ag2Rr8u3WCq+FFht78T+aAavpLn59yn6u5Whzr
        RV7vp11LgBzPg/afTZhyL8Yb+pLSF/+uqgKU5ufmTr1ddyJy65ZFNYraijr4ab6VA7D/5b
        7dKmhhsvtejwEInuls3hPNZ+1sIc3m8=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-1XwLKJGlO3Ss_XTO4G5F1A-1; Wed, 23 Mar 2022 09:43:20 -0400
X-MC-Unique: 1XwLKJGlO3Ss_XTO4G5F1A-1
Received: by mail-qt1-f197.google.com with SMTP id x9-20020ac81209000000b002e0659131baso1183061qti.11
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 06:43:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IJHOsMD+p/TxrB7WMAz/bVsoyRgqHIkadq0oUUT9qqg=;
        b=Qzz7DVnXlw1WxN0SDNfvjJ0i30D7EvHCFkysqSE8KA1k1t0aLKfiA/Zkjpy/azJWFE
         iI7KD5whaK/5poFQdtVvwnfA5wzag+0OOcuVROzQaW29ssyuuwYsRJL7NM+MWGEKVD0b
         C9zRWt35t31YZLgQdY7VvEmQQDXPCcrFD+0/QOFkBpgJLPA80xZwfhaKsY8J+XHvc2q5
         XcgrpfDXyqzgTinoT0lCrQm93VatHWSnfGsci/2Zt+fbwLBEovssySsB+XECLqJqYfaa
         fW3BELIH1wRmYvtrXii5KNKq65DFIarX7f7tKjPBVSB7ZGlecueaxXk0dD7r9v27DBBR
         +hVw==
X-Gm-Message-State: AOAM532vKicHumWcjH3Cg5yekuBvZd7q2dWlQacCxspjZBCoy0KIf7RA
        tVUo1/kOzFwpCQ888lKaiHjq8cEodcyITciAoByfHquW40hlx4gXSnyyLH3WqwcXrDeh1g3T6im
        B0iqe7FU2pWp88Gkb
X-Received: by 2002:a05:622a:1111:b0:2e1:e831:2ee2 with SMTP id e17-20020a05622a111100b002e1e8312ee2mr23861909qty.264.1648043000030;
        Wed, 23 Mar 2022 06:43:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzn19Zj7+5jT24adJG336cYAb3ONCKQCObx38/CuWziIHD5QGZCRUCxyzDDeqQ7YzreKx5W0Q==
X-Received: by 2002:a05:622a:1111:b0:2e1:e831:2ee2 with SMTP id e17-20020a05622a111100b002e1e8312ee2mr23861884qty.264.1648042999740;
        Wed, 23 Mar 2022 06:43:19 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-114.business.telecomitalia.it. [87.12.25.114])
        by smtp.gmail.com with ESMTPSA id 20-20020ac84e94000000b002e1d5505fb6sm54700qtp.63.2022.03.23.06.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 06:43:19 -0700 (PDT)
Date:   Wed, 23 Mar 2022 14:43:13 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        "David S. Miller" <davem@davemloft.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Asias He <asias@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net v2 0/3] vsock/virtio: enable VQs early on probe and
 finish the setup before using them
Message-ID: <20220323134313.rmx24o3534rmgp3u@sgarzare-redhat>
References: <20220323084954.11769-1-sgarzare@redhat.com>
 <20220323092118-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220323092118-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 23, 2022 at 09:22:02AM -0400, Michael S. Tsirkin wrote:
>On Wed, Mar 23, 2022 at 09:49:51AM +0100, Stefano Garzarella wrote:
>> The first patch fixes a virtio-spec violation. The other two patches
>> complete the driver configuration before using the VQs in the probe.
>>
>> The patch order should simplify backporting in stable branches.
>
>Ok but I think the order is wrong. It should be 2-3-1,
>otherwise bisect can pick just 1 and it will have
>the issues previous reviw pointed out.

Right, I prioritized simplifying the backport, but obviously 
bisectability is priority!

I'll send v3 changing the order in 2-3-1

Thanks,
Stefano

