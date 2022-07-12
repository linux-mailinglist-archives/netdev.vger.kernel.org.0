Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F05205710EF
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 05:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbiGLDhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 23:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGLDhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 23:37:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414862DAB0
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 20:37:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB45DB81648
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E4AC341C8;
        Tue, 12 Jul 2022 03:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657597020;
        bh=2e1CD09763zKzDPjJc3Ti5skVtx0GNDay+Mv9kk5EDM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KNrZaqydiuJEW2fH4HHwdH/G7b/G4Z286WoEcXik6W9qUNDxt0y1pkLOuU26q1l88
         1H1D2KgsGYHfpXN3JTbW1MsuJLsRoxwEKBz6tPYnc5WQf0cNCOG93rK4rWhz4ihQ2M
         +j7eUMCgFHTSUZnP2141wDPfhFVI3qwIjOP5v2uX4l1mEdjqpk12FK5FDWtUA0224J
         YaXYIs/tBToSgzRgb2+LSo00gnLb9ovK/gLt10/V7rRRsgPbMIqxlRFh1awl2WV4Q1
         zNihoGT5S4uy6bwdLaZDm6gSQRUAQIrjsoful9VnJBpicC4qmIqIJPUPmYtVlWGmWJ
         iVJfwA+sE+8Vg==
Date:   Mon, 11 Jul 2022 20:36:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] net: virtio_net: notifications coalescing support
Message-ID: <20220711203659.012a79b8@kernel.org>
In-Reply-To: <20220711112832.2634312-1-alvaro.karsz@solid-run.com>
References: <20220711112832.2634312-1-alvaro.karsz@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jul 2022 14:28:32 +0300 Alvaro Karsz wrote:
> New VirtIO network feature: VIRTIO_NET_F_NOTF_COAL.
> 
> Control a Virtio network device notifications coalescing parameters
> using the control virtqueue.
> 
> A device that supports this fetature can receive
> VIRTIO_NET_CTRL_NOTF_COAL control commands.
> 
> - VIRTIO_NET_CTRL_NOTF_COAL_TX_SET:
>   Ask the network device to change the following parameters:
>   - tx_usecs: Maximum number of usecs to delay a TX notification.
>   - tx_max_packets: Maximum number of packets to send before a
>     TX notification.
> 
> - VIRTIO_NET_CTRL_NOTF_COAL_RX_SET:
>   Ask the network device to change the following parameters:
>   - rx_usecs: Maximum number of usecs to delay a RX notification.
>   - rx_max_packets: Maximum number of packets to receive before a
>     RX notification.
> 
> VirtIO spec. patch:
> https://lists.oasis-open.org/archives/virtio-comment/202206/msg00100.html
> 
> Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>

Try building with sparse -
https://www.kernel.org/doc/html/latest/dev-tools/sparse.html

+../drivers/net/virtio_net.c:2616:34: warning: incorrect type in assignment (different base types)
+../drivers/net/virtio_net.c:2616:34:    expected restricted __virtio32 [usertype] tx_usecs
+../drivers/net/virtio_net.c:2616:34:    got unsigned int [usertype] tx_coalesce_usecs
+../drivers/net/virtio_net.c:2617:40: warning: incorrect type in assignment (different base types)
+../drivers/net/virtio_net.c:2617:40:    expected restricted __virtio32 [usertype] tx_max_packets
+../drivers/net/virtio_net.c:2617:40:    got unsigned int [usertype] tx_max_coalesced_frames
+../drivers/net/virtio_net.c:2629:34: warning: incorrect type in assignment (different base types)
+../drivers/net/virtio_net.c:2629:34:    expected restricted __virtio32 [usertype] rx_usecs
+../drivers/net/virtio_net.c:2629:34:    got unsigned int [usertype] rx_coalesce_usecs
+../drivers/net/virtio_net.c:2630:40: warning: incorrect type in assignment (different base types)
+../drivers/net/virtio_net.c:2630:40:    expected restricted __virtio32 [usertype] rx_max_packets
+../drivers/net/virtio_net.c:2630:40:    got unsigned int [usertype] rx_max_coalesced_frames
