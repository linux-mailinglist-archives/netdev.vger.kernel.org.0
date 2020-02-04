Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3CE5151594
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 06:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgBDFzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 00:55:24 -0500
Received: from mail-vs1-f68.google.com ([209.85.217.68]:35961 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbgBDFzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 00:55:24 -0500
Received: by mail-vs1-f68.google.com with SMTP id a2so10616469vso.3
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 21:55:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=E9hlqVe03UfbNd2bzTBcpRirmc2GRaEJbKPr9L4dfrY=;
        b=moFrcj1541CCqHeEDAAYJGGtwIKVj4/Pyhk7sQyah9UKQI+X76d3NUPI0rEbA4QZXh
         2tY78ORQGQPzGIOClnogUtBHg0/wnA9W9Bo5YLmnDd/Wm8Efw5b8eY2dFYRCr6l4TIHR
         YeI+O0yOIKNqH2iZBNjbjcL9cdrkWh/Hc9xg+kmmt2K7jW67F/c9ZzZC9rnDmttH2wXq
         p1bc0at5OD7sum0eBRQhu3Z82q8um7s0lksaEPudoAmhPZpIdnjU5JqOflUe8MoS+U1S
         BM/hO9hHqERSBBCDRTe46LVm/8PvmWkUd7MtAqdA3cUgPJzQYrhJx/0aDKfSNpziaJ25
         ha0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=E9hlqVe03UfbNd2bzTBcpRirmc2GRaEJbKPr9L4dfrY=;
        b=d642HSlDyrlghIt7zK6TTivATmbxbTLgvNtryW36zlSzro5uft1g3HxB6jIsrm2cCS
         78OurLAdZ7wP1lV7YSV5XO1mF0tR1tPlEum5kxWUJGfvpRoSLsz9MX7S5IQ8mzwlJe/v
         fhc5NTuEexpWYiFeI8rzSLAsWcMp0FErQ2VR/uNrBKQMd+h+O45Y1qcqLuJmlM3nw4al
         Jo8BBTEIPdsAOUExzt1z6180qreaAMcHqsDcTzQc+8mWeymBlhOUoJ84NvCU+mQ3xS7M
         AxyR08V1A5f29STq/2E0wSHfb3h/DbubaBJQwtPJ7zZlEGYOuuPnV1Jq1vU8M3EKleQP
         31CQ==
X-Gm-Message-State: APjAAAW2p5luUNKuKcjUG+Jd77RZ4BZucqvV/TIwGSjvOtgqVmzFnIQH
        BjeKruoWZ68ahJ0id0O9SpPWsAJFlS+RqpVpmVfLTsJgD0g=
X-Google-Smtp-Source: APXvYqxhIKv4N+wmKuJa8l7Mo88ttpmSxXvx4nKcSxITS5QGszVzBZIokZdkhBOUPDG4lvFZ+nEFlSSDYNHR7ZoR68E=
X-Received: by 2002:a67:ec88:: with SMTP id h8mr17572997vsp.65.1580795723036;
 Mon, 03 Feb 2020 21:55:23 -0800 (PST)
MIME-Version: 1.0
From:   Yadu Kishore <kyk.segfault@gmail.com>
Date:   Tue, 4 Feb 2020 11:25:12 +0530
Message-ID: <CABGOaVTY6BrzJTYEtVXwawzP7-D8sb1KASDWFk15v0QFaJVbUg@mail.gmail.com>
Subject: TCP checksum not offloaded during GSO
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm working on enhancing a driver for a Network Controller that
supports "Checksum Offloads".
So I'm offloading TCP/UDP checksum computation in the network driver
using NETIF_F_HW_CSUM on
linux kernel version 4.19.23 aarch64 for hikey android platform. The
Network Controller does not support scatter-gather (SG) DMA.
Hence I'm not enabling the NETIF_IF_SG feature.
I see that GSO for TCP is enabled by default in the kernel 4.19.23
When running iperf TCP traffic I observed that the TCP checksum is not
offloaded for the majority
of the TCP packets. Most of the skbs received in the output path in
the driver have skb->ip_summed
set to CHECKSUM_NONE.
The csum is offloaded only for the initial TCP connection establishment packets.
For UDP I do not observe this problem.
It appears that a decision was taken not to offload TCP csum (during GSO)
if the network driver does not support SG :

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 02c638a643ea..9c065ac72e87 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3098,8 +3098,9 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
  if (nskb->len == len + doffset)
  goto perform_csum_check;

- if (!sg && !nskb->remcsum_offload) {
- nskb->ip_summed = CHECKSUM_NONE;
+ if (!sg) {
+ if (!nskb->remcsum_offload)
+ nskb->ip_summed = CHECKSUM_NONE;
  SKB_GSO_CB(nskb)->csum =
  skb_copy_and_csum_bits(head_skb, offset,
        skb_put(nskb, len),

The above is a code snippet from the actual commit :

commit 7fbeffed77c130ecf64e8a2f7f9d6d63a9d60a19
Author: Alexander Duyck <aduyck@mirantis.com>
Date:   Fri Feb 5 15:27:43 2016 -0800

    net: Update remote checksum segmentation to support use of GSO checksum

    This patch addresses two main issues.

    First in the case of remote checksum offload we were avoiding dealing with
    scatter-gather issues.  As a result it would be possible to assemble a
    series of frames that used frags instead of being linearized as they should
    have if remote checksum offload was enabled.

    Second I have updated the code so that we now let GSO take care of doing
    the checksum on the data itself and drop the special case that was added
    for remote checksum offload.

    Signed-off-by: Alexander Duyck <aduyck@mirantis.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

However it appears that even before the above commit the original
condition did seem to indicate
that if the network driver does not support SG, the csum would be
computed by the kernel itself (in case of GSO).
We would like to know the reason for this design decision (to NOT
offload checksum computation to the HW in case of GSO).
Our intention is to find out a way to enable/offload CSUM computation
to the HW even when GSO is active (TCP).

Thanks,
Yadu Kishore
