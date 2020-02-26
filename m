Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A66EB16F897
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 08:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgBZHhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 02:37:08 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:28161 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726823AbgBZHhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 02:37:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582702626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SJCa5xiiyY2OnxgizOmZdUb8UqwmQQAakMlyGyDuQpY=;
        b=AgjtmlXWVZ04zFSGEYhWc+0KxU7jbD93vmnsnPnfT+ixl4DUiBvUl7pfsAP5aBIQTXGpzb
        E53DUbSG5++JRcbFoIbYfspDC+q2DrCNnAUkUsQsVyLjXAhFmwYArwiefZWIOF72WYWxfM
        2q+s2axt4HAiEHGRijErUdKm2WVZ5GQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-17h0CxW0PV-GIJtfO5kUyg-1; Wed, 26 Feb 2020 02:37:03 -0500
X-MC-Unique: 17h0CxW0PV-GIJtfO5kUyg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 25DDF1882CD9;
        Wed, 26 Feb 2020 07:37:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1666C396;
        Wed, 26 Feb 2020 07:37:02 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id EF9771809565;
        Wed, 26 Feb 2020 07:37:01 +0000 (UTC)
Date:   Wed, 26 Feb 2020 02:37:01 -0500 (EST)
From:   Jason Wang <jasowang@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     David Ahern <dahern@digitalocean.com>, netdev@vger.kernel.org
Message-ID: <172688592.10687939.1582702621880.JavaMail.zimbra@redhat.com>
In-Reply-To: <20200226015113-mutt-send-email-mst@kernel.org>
References: <7df5bb7f-ea69-7673-642b-f174e45a1e64@digitalocean.com> <20200226015113-mutt-send-email-mst@kernel.org>
Subject: Re: virtio_net: can change MTU after installing program
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.68.5.20, 10.4.195.25]
Thread-Topic: virtio_net: can change MTU after installing program
Thread-Index: wA7kxSLVDBzZclUSllWvB8/6+6AUBw==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



----- Original Message -----
> On Tue, Feb 25, 2020 at 08:32:14PM -0700, David Ahern wrote:
> > Another issue is that virtio_net checks the MTU when a program is
> > installed, but does not restrict an MTU change after:
> > 
> > # ip li sh dev eth0
> > 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc fq_codel
> > state UP mode DEFAULT group default qlen 1000
> >     link/ether 5a:39:e6:01:a5:36 brd ff:ff:ff:ff:ff:ff
> >     prog/xdp id 13 tag c5595e4590d58063 jited
> > 
> > # ip li set dev eth0 mtu 8192
> > 
> > # ip li sh dev eth0
> > 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 8192 xdp qdisc fq_codel
> > state UP mode DEFAULT group default qlen 1000
> 
> Well the reason XDP wants to limit MTU is this:
>     the MTU must be less than a page
>     size to avoid having to handle XDP across multiple pages
> 

But even if we limit MTU is guest there's no way to limit the packet
size on host. It looks to me we need to introduce new commands to
change the backend MTU (e.g TAP) accordingly.

Thanks

