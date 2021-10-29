Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E63643FB11
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 12:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbhJ2KyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 06:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbhJ2KyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 06:54:09 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F080C061714
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 03:51:41 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id l16-20020a9d6a90000000b0054e7ab56f27so13005755otq.12
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 03:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=kflZes77kLfnlCXKdc+UCQADCH6ZjAkhe/mo65ZE/wM=;
        b=Gi6eidgdNeD0ClGpAJBadEe5ljRNwtExYShhmhFkuxFIuUXbTrDGhq6UJ0ofV1gE9g
         OALyfkNEwKdLBX5auNN2UbMKIdRQJwpDvhDUvLFb7njwQsF036lFjz9CZs8vtXAQoUBl
         feTJrtBAGpo+VZ1BbmPs4uLH6/cUIR3mkoL2WxeQLCTUNiGFAtvS55PrFOurP24qqMz2
         YSuk72McNxJVNEXcTo5Hr5N47hPjgKbG1bMXgrl+oBEiDZUO0JShrn5/BVxjbwocNrIJ
         cij6QXGin0whqXRUHwuKGwvoEjTrBdVuzqdcuH1CJqMHXKYL3HJw5E04tz3n3swKRSZE
         cLNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=kflZes77kLfnlCXKdc+UCQADCH6ZjAkhe/mo65ZE/wM=;
        b=PCCgjIjo6n1lyXvnYAk2ML7gKG8XtTcCannuvSHBZ8y9+RIozXkTSfso3fkBEetP3B
         Ep+uJecmGP6ix6I3swhwxHKBrQVc3KYONFg1kM+31BZ3AyEW0KiNGD9WBXzyjdhY0dJZ
         bElIHGZAeAsVa9G0GOTxbbMhDTO8xFnMghFPKvrueJ4C/uLwNNdeKESgr2IpPsuADfy/
         8QHqKEZ0HRlpjl2uGcuI7bXiqPqczpX0NWBEYRo8zC+XfQuFHL/9GKk78RvXGN8WQWj0
         loFZjeKctUeuiUehL//qXnwnADX+oJwOrUy/jVVQMblRi94UI6izftNyi6i2on/KUZxa
         GVjg==
X-Gm-Message-State: AOAM533DddPzmWYl4CoBlT4mEwAneyA8An95YvEovR/G7jAPQBiSz/j/
        x0x6qB0TmuRTsYuDu9P68RU++gwo2tInnxBnxBVH30Pv8iLtQA==
X-Google-Smtp-Source: ABdhPJzYwFoiV2YSJqvDZsql4f/iae+jbf5XapOqXSoOGN9AUXlM/JlpvfwvQBBljMRPUtOmcCnpd742EQKTT5chJRw=
X-Received: by 2002:a9d:7f81:: with SMTP id t1mr7800995otp.376.1635504700905;
 Fri, 29 Oct 2021 03:51:40 -0700 (PDT)
MIME-Version: 1.0
From:   Andrew Melnichenko <andrew@daynix.com>
Date:   Fri, 29 Oct 2021 13:51:30 +0300
Message-ID: <CABcq3pG9GRCYqFDBAJ48H1vpnnX=41u+MhQnayF1ztLH4WX0Fw@mail.gmail.com>
Subject: VirtioNet L3 protocol patch advice request.
To:     davem@davemloft.net, willemb@google.com, bnemeth@redhat.com,
        gregkh@linuxfoundation.org
Cc:     Yan Vugenfirer <yan@daynix.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,
Recently I've discovered a patch that added an additional check for the
protocol in VirtioNet.
(https://www.spinics.net/lists/kernel/msg3866319.html)
Currently, that patch breaks UFOv6 support and possible USOv6 support in
upcoming patches.
The issue is the code next to the patch expects failure of
skb_flow_dissect_flow_keys_basic()
for IPv6 packets to retry it with protocol IPv6.
I'm not sure about the goals of the patch and propose the next solution:

static inline int virtio_net_hdr_set_proto(struct sk_buff *skb,
>                      const struct virtio_net_hdr *hdr)
> {
>     __be16 protocol;
>
>     protocol = dev_parse_header_protocol(skb);
>     switch (hdr->gso_type & ~VIRTIO_NET_HDR_GSO_ECN) {
>     case VIRTIO_NET_HDR_GSO_TCPV4:
>         skb->protocol = cpu_to_be16(ETH_P_IP);
>         break;
>     case VIRTIO_NET_HDR_GSO_TCPV6:
>         skb->protocol = cpu_to_be16(ETH_P_IPV6);
>         break;
>     case VIRTIO_NET_HDR_GSO_UDP:
>     case VIRTIO_NET_HDR_GSO_UDP_L4:
>         skb->protocol = protocol;
>     default:
>         return -EINVAL;
>     }
>
>     return protocol && protocol == skb->protocol ? 0 : -EINVAL;
> }
>

And in virtio_net_hdr_to_skb():

            if (!skb->protocol) {
>                 if(virtio_net_hdr_set_proto(skb, hdr))
>                     return -EINVAL;
>             }
>
>             if (!skb_flow_dissect_flow_keys_basic(NULL, skb, &keys,
>                              NULL, 0, 0, 0,
>                              0)) {
>                 return -EINVAL;
>             }
>

Would such changes suit the goals of the initial patch?
