Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2F9347B25
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 15:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236380AbhCXOvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 10:51:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31849 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236343AbhCXOvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 10:51:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616597462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qwqc010LQRL9qP/xrAIAyc+UAyyvJ/OsN6lHYuFZfWc=;
        b=N32mkmEwfqKyGXZDH1SLU//5HVTdBvN4vZx4qwjAI+20Ac/y3e2pNa4ZJFoskCLx0LvO9j
        jO4inKfMnEllNcWdx0DWIMA6XOtPJ0zJkxiPdISf73kNguA3FwJGK8vOvmEQG2QqtS9wGJ
        8v3l+D28gvW3WiiwJ+F7wV2REDMip84=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-578--Ayr5fs4Oc2_hS6JNCQVIg-1; Wed, 24 Mar 2021 10:51:00 -0400
X-MC-Unique: -Ayr5fs4Oc2_hS6JNCQVIg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8030E87A83A;
        Wed, 24 Mar 2021 14:50:59 +0000 (UTC)
Received: from ovpn-115-125.ams2.redhat.com (ovpn-115-125.ams2.redhat.com [10.36.115.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE77A196A8;
        Wed, 24 Mar 2021 14:50:57 +0000 (UTC)
Message-ID: <7974ce16adc27164afa63170483bb4371894c5e1.camel@redhat.com>
Subject: !
From:   Paolo Abeni <pabeni@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Date:   Wed, 24 Mar 2021 15:50:56 +0100
In-Reply-To: <CA+FuTScT9W5V-ak=Wq_7zswyDRo9rzjOK1SQNRxESBCL93BOVQ@mail.gmail.com>
References: <cover.1616345643.git.pabeni@redhat.com>
         <661b8bc7571c4619226fad9a00ca49352f43de45.1616345643.git.pabeni@redhat.com>
         <CA+FuTSc=V_=behQ0MKX3oYdDzZN=V7_CdeNOFXUAa-4TuU5ztA@mail.gmail.com>
         <efa5f117ad63064f7984655d46eb5140d23b0585.camel@redhat.com>
         <CA+FuTScT9W5V-ak=Wq_7zswyDRo9rzjOK1SQNRxESBCL93BOVQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-03-23 at 21:54 -0400, Willem de Bruijn wrote:
> > I did not look at that before your suggestion. Thanks for pointing out.
> > 
> > I think the problem is specific to UDP: when processing the outer UDP
> > header that is potentially eligible for both NETIF_F_GSO_UDP_L4 and
> > gro_receive aggregation and that is the root cause of the problem
> > addressed here.
> 
> Can you elaborate on the exact problem? The commit mentions "inner
> protocol corruption, as no overaly network parameters is taken in
> account at aggregation time."
> 
> My understanding is that these are udp gro aggregated GSO_UDP_L4
> packets forwarded to a udp tunnel device. They are not encapsulated
> yet. Which overlay network parameters are not, but should have been,
> taken account at aggregation time?

The scenario is as follow: 

* a NIC has NETIF_F_GRO_UDP_FWD or NETIF_F_GRO_FRAGLIST enabled
* an UDP tunnel is configured/enabled in the system
* the above NIC receives some UDP-tunneled packets, targeting the
mentioned tunnel
* the packets go through gro_receive and they reache
'udp_gro_receive()' while processing the outer UDP header.

without this patch, udp_gro_receive_segment() will kick in and the
outer UDP header will be aggregated according to SKB_GSO_FRAGLIST
or SKB_GSO_UDP_L4, even if this is really e.g. a vxlan packet.

Different vxlan ids will be ignored/aggregated to the same GSO packet.
Inner headers will be ignored, too, so that e.g. TCP over vxlan push
packets will be held in the GRO engine till the next flush, etc.

Please let me know if the above is more clear.

Thanks!

Paolo

