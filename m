Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B105769091E
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 13:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjBIMnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 07:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjBIMnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 07:43:22 -0500
Received: from out0-203.mail.aliyun.com (out0-203.mail.aliyun.com [140.205.0.203])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76995C8AE
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 04:43:20 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047193;MF=amy.saq@antgroup.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---.RGw9Ado_1675946596;
Received: from localhost(mailfrom:amy.saq@antgroup.com fp:SMTPD_---.RGw9Ado_1675946596)
          by smtp.aliyun-inc.com;
          Thu, 09 Feb 2023 20:43:17 +0800
From:   "=?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?=" <amy.saq@antgroup.com>
To:     netdev@vger.kernel.org
Cc:     <willemdebruijn.kernel@gmail.com>, <mst@redhat.com>,
        <davem@davemloft.net>, <jasowang@redhat.com>,
        "=?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?=" <amy.saq@antgroup.com>
Subject: [PATCH 0/2] net/packet: support of specifying virtio net header size
Date:   Thu, 09 Feb 2023 20:43:13 +0800
Message-Id: <1675946595-103034-1-git-send-email-amy.saq@antgroup.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Raw socket, like tap, can be used as the backend for kernel vhost.
In raw socket, virtio net header size is currently hardcoded to be
the size of struct virtio_net_hdr, which is 10 bytes; however, it is not
always the case: some virtio features, such as mrg_rxbuf and VERSION_1,
need virtio net header to be 12-byte long.

These virtio features are worthy to support: for example, packets
that larger than one-mbuf size will be dropped in vhost worker's
handle_rx if mrg_rxbuf feature is not used, but large packets cannot be
avoided and increasing mbuf's size is not economical.

With these virtio features enabled, raw socket with hardcoded 10-byte
virtio net header will parse mac head incorrectly in packet_snd by taking
the last two bytes of virtio net header as part of mac header as well.
This incorrect mac header parsing will cause packet be dropped due to
invalid ether head checking in later under-layer device packet receiving.

By adding extra field vnet_hdr_sz in packet_sock to record current using
virtio net header size and supporting extra sockopt PACKET_VNET_HDR_SZ to
set specified vnet_hdr_sz, packet_sock can know the exact length of virtio
net header that virtio user gives. In packet_snd, tpacket_snd and
packet_recvmsg, instead of using hardcode virtio net header size, it can
get the exact vnet_hdr_sz from corresponding packet_sock, and parse mac
header correctly based on this information.

Anqi Shen (2):
  net/packet: add socketopt to set/get vnet_hdr_sz
  net/packet: send and receive pkt with given vnet_hdr_sz

 include/uapi/linux/if_packet.h |  1 +
 net/packet/af_packet.c         | 82 ++++++++++++++++++++++++++++++++++--------
 net/packet/internal.h          |  3 +-
 3 files changed, 70 insertions(+), 16 deletions(-)

-- 
1.8.3.1

