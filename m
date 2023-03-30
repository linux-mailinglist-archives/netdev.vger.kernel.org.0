Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0DD6D0E4E
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 21:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbjC3TF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 15:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbjC3TF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 15:05:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4012BBBA1
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 12:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680203104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AjWL/5ulXSBNWvEtpYPDT+pUxocHBbNGFxfjDnuHH+M=;
        b=ZXIvEA8xOHzc/0lT9hLiQl6yDBjgc1z3+LjloazkNQ7oNNbJL2+aZNKe9LPNLPAhJdoLDO
        TEc8RZUWF2nHSpura0PpDxzDOTsj7YtZSS5YuD0XrYMxlkwHmFvChHxVO1oqOhdvXxYaF6
        bT58zv5h0GFLIzAiY7XUohv+Y9ndgEE=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-XAhV0N8lPqWAZz6mdGjHtA-1; Thu, 30 Mar 2023 15:05:02 -0400
X-MC-Unique: XAhV0N8lPqWAZz6mdGjHtA-1
Received: by mail-lj1-f198.google.com with SMTP id t17-20020a05651c205100b0029f839410fcso4437882ljo.1
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 12:05:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680203101;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AjWL/5ulXSBNWvEtpYPDT+pUxocHBbNGFxfjDnuHH+M=;
        b=rNcJ3PSG09NSqW70SmJoDaVv1sLCtweKBmbgf/kXCTlim1ZDCdYJnY7LFcM9b1ukYk
         UzBJs8OYpFFYWj7O19sxteyCbXXGi5eTqNX1GCG3lXGvoBtAYNIrfzkMAxcgA+qbrAkU
         yHESxvuFJjlYkd3ixHLxqD4Wc1mvSfX2FCgVYdWR5X4SNHPNoiN3GN54sd7+hZCez5Oh
         pXfbm8zPJ729S0MzZTRghKNq/B5/VpmhHC+juySQQKCNISnJqyB3QGGHJTBZhlVEZ6Ma
         yVIyAs1EnfqSWFXd60sBDUNGG3KFC9M0u2TvVsjVqeyIASK6TScTDzTDTlrxf9RwZ0E/
         CNsA==
X-Gm-Message-State: AAQBX9dZ8OuOwriAZu/p1KNVSn9mhSJbP3evBBmu3aphD+PXaj7XHFyc
        Y5kWj42QWfUByeowGM9/35EIsYr2D7Kqn6UouItYVxX4DKEtGjx7RQJ+DitWUjeVOlO1QDgQ++P
        +VHVJ9bTdMQlMSKKD
X-Received: by 2002:ac2:596f:0:b0:4eb:e03:9e6c with SMTP id h15-20020ac2596f000000b004eb0e039e6cmr1997573lfp.33.1680203101215;
        Thu, 30 Mar 2023 12:05:01 -0700 (PDT)
X-Google-Smtp-Source: AKy350aLpoXMI1x1xPT2ugdceXR972Lacx2zk/SiRRmV+Uf/xnP2xCALcA41ZMbTbuQxJnhXH31Y/w==
X-Received: by 2002:ac2:596f:0:b0:4eb:e03:9e6c with SMTP id h15-20020ac2596f000000b004eb0e039e6cmr1997548lfp.33.1680203100914;
        Thu, 30 Mar 2023 12:05:00 -0700 (PDT)
Received: from [192.168.42.100] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id v28-20020ac2593c000000b004e9b42d778esm57581lfi.26.2023.03.30.12.04.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 12:05:00 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <3423b37b-43d7-e9ee-6b1b-768b255a2773@redhat.com>
Date:   Thu, 30 Mar 2023 21:04:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net,
        anthony.l.nguyen@intel.com, yoong.siang.song@intel.com,
        boon.leong.ong@intel.com, intel-wired-lan@lists.osuosl.org,
        pabeni@redhat.com, jesse.brandeburg@intel.com, kuba@kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, hawk@kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH bpf RFC-V3 0/5] XDP-hints: API change for RX-hash kfunc
 bpf_xdp_metadata_rx_hash
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
References: <168019602958.3557870.9960387532660882277.stgit@firesoul>
 <ZCXXIvvnTBch/0Oz@google.com>
In-Reply-To: <ZCXXIvvnTBch/0Oz@google.com>
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


On 30/03/2023 20.38, Stanislav Fomichev wrote:
> On 03/30, Jesper Dangaard Brouer wrote:
>> Notice targeted 6.3-rc kernel via bpf git tree.
> 
>> Current API for bpf_xdp_metadata_rx_hash() returns the raw RSS hash value,
>> but doesn't provide information on the RSS hash type (part of 6.3-rc).
> 
>> This patchset proposal is to change the function call signature via adding
>> a pointer value argument for provide the RSS hash type.
> 
>> Alternatively we disable bpf_xdp_metadata_rx_hash() in 6.3-rc, and have
>> more time to nitpick the RSS hash-type bits.
> 
> LGTM with one nit about EMIT_BTF.
> 

Great, others please review, so I can incorporate for tomorrow.
I will send a official patchset V4 tomorrow.

--Jesper

