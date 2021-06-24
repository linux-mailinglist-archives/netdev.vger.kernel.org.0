Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F113B33B3
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 18:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbhFXQRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 12:17:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49725 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232033AbhFXQQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 12:16:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624551276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wE3C8fAY2Ke4f8GlbED3jZxKdHMupZo0qHgep6Jpwjw=;
        b=W39kIwqf1rdihPTb9VtEfKSdfyq8VAaXVX+iFQ60maw1/ysAxhtbSN6NTlqc+AwrbTRsrO
        H0XE5qbypr4NIMA9gw9q0+uyN//IrB/4cKGa1KPX+fpDkO6NUCtqgr1Oj+0FlZXT0zDQYE
        IYUXTGRlBl1MrxwH1Rr7wx2+aDXQllk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-kn1rgtX5OaScVNH41hFkNw-1; Thu, 24 Jun 2021 12:14:32 -0400
X-MC-Unique: kn1rgtX5OaScVNH41hFkNw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3FA39801596;
        Thu, 24 Jun 2021 16:14:29 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.10.110.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E91A19C66;
        Thu, 24 Jun 2021 16:14:24 +0000 (UTC)
Message-ID: <0548d1daa7e1eee9d8202481668bbe4975c9b33d.camel@redhat.com>
Subject: Re: [PATCH 1/4] net: if_arp: add ARPHRD_PUREIP type
From:   Dan Williams <dcbw@redhat.com>
To:     Rocco Yue <rocco.yue@mediatek.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        David Ahern <dsahern@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, bpf@vger.kernel.org,
        wsd_upstream@mediatek.com, chao.song@mediatek.com,
        kuohong.wang@mediatek.com
Date:   Thu, 24 Jun 2021 11:14:24 -0500
In-Reply-To: <20210624061310.12315-1-rocco.yue@mediatek.com>
References: <YNQYHfE09Dx5kWyg@kroah.com>
         <20210624061310.12315-1-rocco.yue@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-06-24 at 14:13 +0800, Rocco Yue wrote:
> On Thu, 2021-06-24 at 07:29 +0200, Greg KH wrote:
> > 
> > Thanks for the explaination, why is this hardware somehow "special"
> > in
> > this way that this has never been needed before?
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Before kernel-4.18, RAWIP was the same as PUREIP, neither of them
> automatically generates an IPv6 link-local address, and the way to
> generate an IPv6 global address is the same.

This distinction seems confusing from a kernel standpoint if it only
changes how v6 IIDs are determined. Do we really need something that's
also reflected to userspace (in struct ifinfomsg -> ifi_type) if the
kernel is handling the behavior that's different? Why should userspace
care?

I'm also curious why this isn't an issue for the ipa/rmnet (Qualcomm)
modem drivers. There's probably a good reason, but would be good to
know what that is from Alex Elder or Loic or Bjorn...

Dan

> 
> After kernel-4.18 (include 4.18 version), the behavior of RAWIP had
> changed due to the following patch:
> @@  static int ipv6_generate_eui64(u8 *eui, struct net_device *dev)
> +       case ARPHRD_RAWIP:
> +               return addrconf_ifid_rawip(eui, dev);
>         }
>         return -1;
> }
> 
> the reason why the kernel doesn't need to generate the link-local
> address automatically is as follows:
> 
> In the 3GPP 29.061, here is some description as follows:
> "in order to avoid any conflict between the link-local address of
> MS and that of the GGSN, the Interface-Identifier used by the MS to
> build its link-local address shall be assigned by the GGSN. The GGSN
> ensures the uniqueness of this Interface-Identifier. Then MT shall
> then enforce the use of this Interface-Identifier by the TE"
> 
> In other words, in the cellular network, GGSN determines whether to
> reply to the Router Solicitation message of UE by identifying the
> low 64bits of UE interface's ipv6 link-local address.
> 
> When using a new kernel and RAWIP, kernel will generate an EUI64
> format ipv6 link-local address, and if the device uses this address
> to send RS, GGSN will not reply RA message.
> 
> Therefore, in that background, we came up with PUREIP to make kernel
> doesn't generate a ipv6 link-local address in any address generate
> mode.
> 
> Thanks,
> Rocco
> 


