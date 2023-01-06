Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E989066017A
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 14:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbjAFNoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 08:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbjAFNoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 08:44:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659FE26F8
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 05:43:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673012616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l4yUr58Gr3KR+ZKIYhInNDOstlMt4WX153i12M0qjek=;
        b=hpjiuOZkrEaQucflB8iT9mAOu0uih870fTaU6d2CVRCDwJkevya0C0bC+9pAg0jbQIO2a+
        XutN/7SmmtVSQ4qGycUL6twbB2qO5OMSydOZf3O+VEMIb53UgcRSHzDwYG+LpyfxdwtZHf
        IfT/pON6s8mRIZgetDGAWSgDFquS650=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-17-rltL0p6AN5GqCdc_GAISiw-1; Fri, 06 Jan 2023 08:43:35 -0500
X-MC-Unique: rltL0p6AN5GqCdc_GAISiw-1
Received: by mail-ed1-f72.google.com with SMTP id q10-20020a056402518a00b0048e5bc8cb74so1260580edd.5
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 05:43:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l4yUr58Gr3KR+ZKIYhInNDOstlMt4WX153i12M0qjek=;
        b=ZAes2X3YStjakWosZVJ5nEZ5MHGOX7p8QV3UJlFRmLx+484e22740/SYLZQm3N27Hb
         DNlmAqihYuVUXRhYnKSxOf3dtwpnlY9nUndopxFs50HZO+jSvtKSUO+E7WSYET4x9bBS
         w4DQ1swM5L/GgvWIFWKtAY5k0wpPgScz+Tq/43lS2ovELTUjz8sX6/eYxiKJJcMyU2Jb
         dE7ZFt7gKqOlVVu/Sr6YkkC0CoosCy4NvSpZMapWQ7BF2cr12vYmzntoGbzD/o+jSJS/
         s51qPGj/403gHnbGT1Dqf3PiIyVWY7mWP/qrpzztyMHwcaaOAwGahA2RjPX+Bk1L7koE
         RyMA==
X-Gm-Message-State: AFqh2krdwBTpU615CWJFhMzF00vooAp99nXJLZIqEz9dWUf7s7CWze7V
        WPVTt9UgbicmaL3yb5dfTTz3Cr/UZv/WNOrYcBJHJXyXTNJB0h7r0Yir61YTBwEiFq3z01ywqaq
        ZOCzobZj8B/zv+IEj
X-Received: by 2002:a17:906:5012:b0:7c1:2e19:ba3f with SMTP id s18-20020a170906501200b007c12e19ba3fmr52405766ejj.57.1673012614034;
        Fri, 06 Jan 2023 05:43:34 -0800 (PST)
X-Google-Smtp-Source: AMrXdXty5DgzSmmfcPgiK52aFS8+rrPclcZxZfS1w1epaj4ab2VOCne4hfoWlRAeRw/Upjv3wGLpGw==
X-Received: by 2002:a17:906:5012:b0:7c1:2e19:ba3f with SMTP id s18-20020a170906501200b007c12e19ba3fmr52405756ejj.57.1673012613891;
        Fri, 06 Jan 2023 05:43:33 -0800 (PST)
Received: from [192.168.42.222] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id t27-20020a17090616db00b0084d223af5b9sm335287ejd.94.2023.01.06.05.43.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 05:43:33 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <1b071a57-ec8a-79e2-86e2-85dd28bce6fb@redhat.com>
Date:   Fri, 6 Jan 2023 14:43:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 03/24] page_pool: Add netmem_set_dma_addr() and
 netmem_get_dma_addr()
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-4-willy@infradead.org>
In-Reply-To: <20230105214631.3939268-4-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 05/01/2023 22.46, Matthew Wilcox (Oracle) wrote:
> Turn page_pool_set_dma_addr() and page_pool_get_dma_addr() into
> wrappers.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>   include/net/page_pool.h | 22 ++++++++++++++++------
>   1 file changed, 16 insertions(+), 6 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

