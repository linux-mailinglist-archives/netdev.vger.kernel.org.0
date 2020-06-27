Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC74F20BD67
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 02:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgF0AWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 20:22:52 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:39781 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbgF0AWw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 20:22:52 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id c5afc5ad
        for <netdev@vger.kernel.org>;
        Sat, 27 Jun 2020 00:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=b3z1Ika2k053NuwPALZ4Q3Qk8T8=; b=CwMDh4
        rxvTQgpb9t6lziCaFwrNb/7JezXYQHwj4QSrFcOBj1AEnRC16GKZwRUw2lQA/hNe
        Y/0kir+65lSe1daWTKLjh0lnzeXi9qrg5pgy3lUWu2EJUoHLZ0U8r2d/F7wq0VdT
        WW5MEcFeCkxDxx9A6bcnNDCzOPtZYAKKAl9IDYGPNlmWq5651dbOFojolpb4d3QZ
        4yLpKq6bif/Kl09jeCLoVBBHcuC3q0Yzmy49XBGpOC9sLaX/IBxOF7Pn0/imbftw
        iLtChHkSGdlziUyZp9GgBo6CtS/RZV7TBl+f3uQSTKudGlQhI53Sds2mS64Bzas3
        G425+/gFd/peTnrA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 33d2ae6f (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Sat, 27 Jun 2020 00:03:30 +0000 (UTC)
Received: by mail-io1-f51.google.com with SMTP id i25so11704590iog.0
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 17:22:50 -0700 (PDT)
X-Gm-Message-State: AOAM531I9zhMIlV1NbRwG2KtLfCd4j9NDv00mhHCT9iR9LCRBOxfMN56
        deRWmNjMDnk4DBskA9xokn/mU9VfpRRk8nUoGeM=
X-Google-Smtp-Source: ABdhPJxv/V/0OszkpnGrACe/mfK5KNydokuhRm+uvVI9TJgTN7xJoU9T/KW/6g0gls3bi7Svdc/1qUTAY36VYL3FYPI=
X-Received: by 2002:a6b:c80a:: with SMTP id y10mr6109433iof.67.1593217369913;
 Fri, 26 Jun 2020 17:22:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200626201330.325840-1-ndev@hwipl.net> <CAHmME9r7Q_+_3ePj4OzxZOkkrSdKA_THNjk6YjHxTQyNA2iaAw@mail.gmail.com>
In-Reply-To: <CAHmME9r7Q_+_3ePj4OzxZOkkrSdKA_THNjk6YjHxTQyNA2iaAw@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 26 Jun 2020 18:22:38 -0600
X-Gmail-Original-Message-ID: <CAHmME9pX30q1oWY3hpjK4u-1ApQP7RCA07BmhtRQx=dR85MS9A@mail.gmail.com>
Message-ID: <CAHmME9pX30q1oWY3hpjK4u-1ApQP7RCA07BmhtRQx=dR85MS9A@mail.gmail.com>
Subject: Re: wireguard: problem sending via libpcap's packet socket
To:     Hans Wippel <ndev@hwipl.net>
Cc:     WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hans,

Your test program appears to be doing:

socket(AF_PACKET, SOCK_RAW, htons(ETH_P_ALL)) = 3
sendto(3, "E\0\0+\0\0@\0@\21\267o\300\250\1\1\300\250\1\1\4\322\4\322\0\0272\221\1\2\3\4"...,
43, 0, NULL, 0) = 43

This means we're calling into af_packet's packet_sendmsg->packet_snd,
which appears to call     packet_parse_headers(skb, sock):

static void packet_parse_headers(struct sk_buff *skb, struct socket *sock)
{
    if ((!skb->protocol || skb->protocol == htons(ETH_P_ALL)) &&
        sock->type == SOCK_RAW) {
        skb_reset_mac_header(skb);
        skb->protocol = dev_parse_header_protocol(skb);
    }

    skb_probe_transport_header(skb);
}

So the question is, why isn't skb->protocol set on the packet that
makes it to wg_xmit?

Adding some printks, it looks like the result of:

    pr_err("SARU %s:%d\n", __FILE__, __LINE__);
    skb_reset_mac_header(skb);
    skb->protocol = dev_parse_header_protocol(skb);
    pr_err("%d\n", skb->protocol);

is:

    [    0.430754] SARU net/packet/af_packet.c:1864
    [    0.431454] 0

So digging a bit further, dev_parse_header_protocol:

static inline __be16 dev_parse_header_protocol(const struct sk_buff *skb)
{
    const struct net_device *dev = skb->dev;

    if (!dev->header_ops || !dev->header_ops->parse_protocol)
        return 0;
    return dev->header_ops->parse_protocol(skb);
}

Apparently the issue is that wireguard doesn't implement any
header_ops. I fixed that in this commit here:
https://git.zx2c4.com/wireguard-linux/commit/?id=73b20c384a8bc498c6b8950672003410ed6016da

In my tests, that commit appears to fix the problem exposed by your
test case. I'll probably wait a few days to think about this some more
and make sure this is correct before submitting, but it seems likely
that this will take care of the issue.

Thanks for the report and easy test case!

Jason
