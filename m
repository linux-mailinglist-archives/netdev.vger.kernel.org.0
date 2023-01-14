Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92AB866A99C
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 07:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjANGZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 01:25:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjANGZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 01:25:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF5A4EC9;
        Fri, 13 Jan 2023 22:25:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9844B80122;
        Sat, 14 Jan 2023 06:25:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D619C433EF;
        Sat, 14 Jan 2023 06:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673677501;
        bh=BxbY2iPC00wCDK4obIhGuz2z/2bIbAxjqwRqPKY7e48=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VLDXUZoJg3IBpYQccVAqXKsVtXq4KVhqFot0w/aNudWED3/9ABkV6IVcP4fbPkDDS
         b/Tsb5Nj81U+3o1NMSoQWfA+iv1nLwofTqUKQL/WbWU9j34m0bBeS+LCrYP+XQHqen
         jx+R9n+lbY4fp5a+k3ieEjd98MVsuwan2eqrjfo8TcpnQQlONKhaeTx55EEuuPIqbc
         dPfp0mWL6GTxbrcKXnxpzG4m9okWVGJxEq+X055oNT42qf+K04Q+rN3ayhn5o9s+oZ
         SWm20HOaHgafKEnD7mIYwyptDtVRejKKjPX6yQAyWjEkCISyVU6/OOBsnwucdgLCl8
         VWEjcpoD6sODg==
Date:   Fri, 13 Jan 2023 22:24:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heng Qi <hengqi@linux.alibaba.com>
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
Subject: Re: [PATCH net-next v4 02/10] virtio-net: fix calculation of MTU
 for single buffer xdp
Message-ID: <20230113222459.3f7b21df@kernel.org>
In-Reply-To: <20230113080016.45505-3-hengqi@linux.alibaba.com>
References: <20230113080016.45505-1-hengqi@linux.alibaba.com>
        <20230113080016.45505-3-hengqi@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Jan 2023 16:00:08 +0800 Heng Qi wrote:
> When single-buffer xdp is loaded, the size of the buffer filled each time
> is 'sz = (PAGE_SIZE - headroom - tailroom)', which is the maximum packet
> length that the driver allows the device to pass in. Otherwise, the packet
> with a length greater than sz will come in, so num_buf will be greater than
> or equal to 2, and then xdp_linearize_page() will be performed and the
> packet will be dropped because the total length is greater than PAGE_SIZE.
> So the maximum value of MTU for single-buffer xdp is 'max_sz = sz - ETH_HLEN'.

drivers/net/virtio_net.c:3111:56: warning: format specifies type 'unsigned long' but the argument has type 'unsigned int' [-Wformat]
                netdev_warn(dev, "XDP requires MTU less than %lu\n", max_sz);
                                                             ~~~     ^~~~~~
                                                             %u
