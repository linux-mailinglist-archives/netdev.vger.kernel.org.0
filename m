Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E15C669907
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 14:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241314AbjAMNto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 08:49:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241246AbjAMNtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 08:49:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638806951C
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 05:43:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673617392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xEcj62aqKt61jDmKL3bwgKQd7r4WsbGK9BYk28bldaY=;
        b=hDsebKX7gQte/ZTtQ+im6PW68lNFpdmEL3SaAmPSD+7PiBtK2NfeZhnmMo2WbjGaEhh6qU
        X3CSXUVs3ZhQVF2kXPYA2F50uRLwSiVCqowaqIyH+gTDtcW/Jn/7Tkfd+SAq5fAIrwGuSW
        H3t641w7zOOz2hywPHaVb6eYOmLkWZ0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-362-Fu4tfghSO8iX9uIQ_VBbyw-1; Fri, 13 Jan 2023 08:43:03 -0500
X-MC-Unique: Fu4tfghSO8iX9uIQ_VBbyw-1
Received: by mail-ed1-f69.google.com with SMTP id y21-20020a056402359500b0048123f0f8deso14745814edc.23
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 05:43:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xEcj62aqKt61jDmKL3bwgKQd7r4WsbGK9BYk28bldaY=;
        b=MHSBzoeXOOmKCAkK/a0m5YM/gZWGGMtum/B9Dy2s2RPD+ps/QIItrWEysRN2a1Y4Gp
         2dBJDSA1lsimOYZuiMYGhq2eJ58DKXqFrvHI3Jvsxe4ixflmyEGbHYL2aPTYMHzEqq+j
         6LPUQSTWa+Kp561I7ofHevn8+dc5XDzxzU7mJboW9Kpxq1gANs8yL+AEwhAq0XjI8UwY
         2OoYeNahScxHWlGHbneoBDD+p65KUfshk7LL36pWQo1SrmOdKkCHxRluAxcCv2FevuP6
         HZrTan98dA3mMywBCifWC6WUma6bziF70MLpFevaiR6cwAxx+Vp2U3BLzkkxupBgsU0o
         TaaQ==
X-Gm-Message-State: AFqh2kros3iOiuDoWUxIFBAriEqY56A61YCt6/D3Q8ijy5pQYlFrHKgF
        TuXz9kveotvM1g3lb5dwg2LhXgoNlJQCVKLgBn+4CL9rmRmgpBXR7mIr+DK7vE10K/oSW5JwlH/
        GKg6Vueg/qHd4bNYG
X-Received: by 2002:a17:906:fad5:b0:847:410:ecf0 with SMTP id lu21-20020a170906fad500b008470410ecf0mr70458879ejb.20.1673617381673;
        Fri, 13 Jan 2023 05:43:01 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtS/zlu2eveerVPVciVgwVxNxUOEY1bDaQEGIqmvbYrq0Onwz0bgxVWYc7ulaA3Rf3qOW2NSg==
X-Received: by 2002:a17:906:fad5:b0:847:410:ecf0 with SMTP id lu21-20020a170906fad500b008470410ecf0mr70458866ejb.20.1673617381515;
        Fri, 13 Jan 2023 05:43:01 -0800 (PST)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id v17-20020a170906293100b007be301a1d51sm8515743ejd.211.2023.01.13.05.43.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 05:43:00 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <35b8fd87-3478-7df3-3e55-bb48bf7d294f@redhat.com>
Date:   Fri, 13 Jan 2023 14:42:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, Alexander H Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next 2/2] net: kfree_skb_list use kmem_cache_free_bulk
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
References: <167293333469.249536.14941306539034136264.stgit@firesoul>
 <167293336786.249536.14237439594457105125.stgit@firesoul>
 <20230106143310.699197bd@kernel.org>
 <fa1c57de-52f6-719f-7298-c606c119d1ab@redhat.com>
 <20230109113409.2d5fab44@kernel.org>
 <fa307736d5448733f08a5a700bc9c647b383a553.camel@gmail.com>
 <adf92243-689e-6013-293f-5464af317594@redhat.com>
 <20230110122058.60672695@kernel.org>
In-Reply-To: <20230110122058.60672695@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/01/2023 21.20, Jakub Kicinski wrote:
> On Tue, 10 Jan 2023 15:52:48 +0100 Jesper Dangaard Brouer wrote:
>>> Rather than defer_local would it maybe make more sense to look at
>>> naming it something like "kfree_skb_add_bulk"? Basically we are
>>> building onto the list of buffers to free so I figure something like an
>>> "add" or "append" would make sense.
>>
>> I agree with Alex
> 
> Alex's suggestion (kfree_skb_add_bulk) sgtm.

Okay, great I'll use that and send a V2.

--Jesper

