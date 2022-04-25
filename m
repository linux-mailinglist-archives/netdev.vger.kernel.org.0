Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A216F50E139
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 15:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240176AbiDYNNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 09:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237923AbiDYNNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 09:13:48 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5360A35DCE;
        Mon, 25 Apr 2022 06:10:40 -0700 (PDT)
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1niyU8-0000Nh-Gz; Mon, 25 Apr 2022 15:10:36 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1niyU8-000QLz-8p; Mon, 25 Apr 2022 15:10:36 +0200
Subject: Re: [PATCH net v3] virtio_net: fix wrong buf address calculation when
 using xdp
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
References: <20220425103703.3067292-1-razor@blackwall.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <00a5d84e-298e-3ca4-c6da-826e6fe586de@iogearbox.net>
Date:   Mon, 25 Apr 2022 15:10:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220425103703.3067292-1-razor@blackwall.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26523/Mon Apr 25 10:20:35 2022)
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/25/22 12:37 PM, Nikolay Aleksandrov wrote:
> We received a report[1] of kernel crashes when Cilium is used in XDP
> mode with virtio_net after updating to newer kernels. After
> investigating the reason it turned out that when using mergeable bufs
> with an XDP program which adjusts xdp.data or xdp.data_meta page_to_buf()
> calculates the build_skb address wrong because the offset can become less
> than the headroom so it gets the address of the previous page (-X bytes
> depending on how lower offset is):
>   page_to_skb: page addr ffff9eb2923e2000 buf ffff9eb2923e1ffc offset 252 headroom 256
[...]
> CC: stable@vger.kernel.org
> CC: Jason Wang <jasowang@redhat.com>
> CC: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> CC: Daniel Borkmann <daniel@iogearbox.net>
> CC: "Michael S. Tsirkin" <mst@redhat.com>
> CC: virtualization@lists.linux-foundation.org
> Fixes: 8fb7da9e9907 ("virtio_net: get build_skb() buf by data ptr")
> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>

Thanks everyone!

Acked-by: Daniel Borkmann <daniel@iogearbox.net>
