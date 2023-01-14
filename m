Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5D766A9EF
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 08:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjANHQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 02:16:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjANHQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 02:16:22 -0500
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6369E9E;
        Fri, 13 Jan 2023 23:16:20 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R581e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VZX-iYl_1673680575;
Received: from 30.236.53.80(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VZX-iYl_1673680575)
          by smtp.aliyun-inc.com;
          Sat, 14 Jan 2023 15:16:16 +0800
Message-ID: <fb4e9ec4-9ad2-ab64-1bca-579727fec8e0@linux.alibaba.com>
Date:   Sat, 14 Jan 2023 15:16:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:109.0)
 Gecko/20100101 Thunderbird/109.0
Subject: Re: [PATCH net-next v4 02/10] virtio-net: fix calculation of MTU for
 single buffer xdp
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
References: <20230113080016.45505-1-hengqi@linux.alibaba.com>
 <20230113080016.45505-3-hengqi@linux.alibaba.com>
 <20230113222459.3f7b21df@kernel.org>
From:   Heng Qi <hengqi@linux.alibaba.com>
In-Reply-To: <20230113222459.3f7b21df@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2023/1/14 下午2:24, Jakub Kicinski 写道:
> On Fri, 13 Jan 2023 16:00:08 +0800 Heng Qi wrote:
>> When single-buffer xdp is loaded, the size of the buffer filled each time
>> is 'sz = (PAGE_SIZE - headroom - tailroom)', which is the maximum packet
>> length that the driver allows the device to pass in. Otherwise, the packet
>> with a length greater than sz will come in, so num_buf will be greater than
>> or equal to 2, and then xdp_linearize_page() will be performed and the
>> packet will be dropped because the total length is greater than PAGE_SIZE.
>> So the maximum value of MTU for single-buffer xdp is 'max_sz = sz - ETH_HLEN'.
> drivers/net/virtio_net.c:3111:56: warning: format specifies type 'unsigned long' but the argument has type 'unsigned int' [-Wformat]
>                  netdev_warn(dev, "XDP requires MTU less than %lu\n", max_sz);
>                                                               ~~~     ^~~~~~
>                                                               %u

The corresponding netdev_warn are split into [PATCH net-next v4 03/10], 
and I will reorganize the patches [PATCH net-next v4 02/10] and [PATCH 
net-next v4 03/10] to be more independent.

Thanks.
