Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2C26D2883
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 21:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbjCaTN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 15:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbjCaTNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 15:13:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBA62293F
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 12:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680289952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=673XRyizobae774kUu5nrXw20qs2InjIWxuBx9XJVCI=;
        b=GwJRySSTpl9Weht9L8JZLCMa1nGUyemu/+Oo3w0w6KN6gPmLIVIedH1BbRsWNim5AXkIjG
        eRDFLDUDbhT2gNR0yCX7ZzMEx57b1qjlURlxVAJCJv5gJzSLJI2flM6nM4ja6zRevSEuEd
        HfEQXoPY8yy3IjUn1Ud2lU4EX2PEk9Q=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-88-hh6RAodVNNmwIKsFWzHykA-1; Fri, 31 Mar 2023 15:12:30 -0400
X-MC-Unique: hh6RAodVNNmwIKsFWzHykA-1
Received: by mail-lf1-f72.google.com with SMTP id g33-20020a0565123ba100b004dc6259b7acso9011596lfv.6
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 12:12:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680289949;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=673XRyizobae774kUu5nrXw20qs2InjIWxuBx9XJVCI=;
        b=NSXJvk0r/gwDsEip1Aqa3kveXXTFcq+xhA8c0X4P+vgl6ysashr8ppVO5e9SZ/zMId
         O6BDCEKcBNad13D3XH9/kMaiBQvVxJP4YEES+6FEU0kQbnzO+Grv+EsRa+N5ZKv+Xp6p
         hpN0lWTI0wIrMEeaCp8KkSDjM6nIpymZjQ/2Uj0CdDLU45tfD8XSrfHkIiD9FHVd0Toa
         ZbSYoeMyH8p6Zwu8j4QQ16MIdqfuB2Agnrc/xpzQh1etYpOBAH+ckNPRNlHYnRWea2t/
         lhiBlB4sL5rQlFEmq7uuq3XNjnZY7SrIyuY3DlqqoRxHHZ6DWARpNC5R/jRcUaCNLk8i
         ouFA==
X-Gm-Message-State: AAQBX9dFWuLgQPROcOQzONiwact6vpv3b+6cRqkHXiWGuHOE1qpK8Z1d
        WcQU9OMykY6cZjKgBP2lwcUyVfeFhFEaJ9JsnElvXUWZORw5C+nLjjZvoW/sdQHIiYpWwyi/Sae
        EDVfYLS0quDEebh+E
X-Received: by 2002:ac2:57d0:0:b0:4e9:ad85:aa09 with SMTP id k16-20020ac257d0000000b004e9ad85aa09mr7874043lfo.68.1680289949152;
        Fri, 31 Mar 2023 12:12:29 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZTs7xrb3JbT2oC5qnyecTLJcHIrhwpbP+I6d+Wfo3Jaci9tWwy1Iq+Ij3x13faw8d7dCIp5A==
X-Received: by 2002:ac2:57d0:0:b0:4e9:ad85:aa09 with SMTP id k16-20020ac257d0000000b004e9ad85aa09mr7874032lfo.68.1680289948804;
        Fri, 31 Mar 2023 12:12:28 -0700 (PDT)
Received: from [192.168.42.100] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id v16-20020ac25610000000b004caf992bba9sm485353lfd.268.2023.03.31.12.12.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 12:12:28 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <3de525f4-096b-b0fe-aaf3-7992acb2451f@redhat.com>
Date:   Fri, 31 Mar 2023 21:12:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, oe-kbuild-all@lists.linux.dev,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        alexandr.lobakin@intel.com, larysa.zaremba@intel.com,
        xdp-hints@xdp-project.net, anthony.l.nguyen@intel.com,
        yoong.siang.song@intel.com, boon.leong.ong@intel.com,
        intel-wired-lan@lists.osuosl.org, pabeni@redhat.com,
        jesse.brandeburg@intel.com, kuba@kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, hawk@kernel.org, davem@davemloft.net,
        tariqt@nvidia.com
Subject: Re: [PATCH bpf V4 1/5] xdp: rss hash types representation
Content-Language: en-US
To:     kernel test robot <lkp@intel.com>, bpf@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>
References: <168027498690.3941176.99100635661990098.stgit@firesoul>
 <202304010239.Jw6bKkWC-lkp@intel.com>
In-Reply-To: <202304010239.Jw6bKkWC-lkp@intel.com>
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


Hopefully addressed in V5.

I obviously need to change function signature for all driver xmo_rx_hash
calls in patch 1/5 to make this compile.  I kept the RSS type
implementations for each driver as separate patches as this is more
reasonable to review and handle.


On 31/03/2023 20.23, kernel test robot wrote:
>
[...]
> All errors (new ones prefixed by >>):
> 
>>> drivers/net/veth.c:1685:43: error: initialization of 'int (*)(const struct xdp_md *, u32 *, enum xdp_rss_hash_type *)' {aka 'int (*)(const struct xdp_md *, unsigned int *, enum xdp_rss_hash_type *)'} from incompatible pointer type 'int (*)(const struct xdp_md *, u32 *)' {aka 'int (*)(const struct xdp_md *, unsigned int *)'} [-Werror=incompatible-pointer-types]
>      1685 |         .xmo_rx_hash                    = veth_xdp_rx_hash,
>           |                                           ^~~~~~~~~~~~~~~~
>     drivers/net/veth.c:1685:43: note: (near initialization for 'veth_xdp_metadata_ops.xmo_rx_hash')
>     cc1: some warnings being treated as errors

