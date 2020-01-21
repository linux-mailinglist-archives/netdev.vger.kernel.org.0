Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A37431442A5
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 17:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbgAUQ7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 11:59:22 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:33834 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726555AbgAUQ7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 11:59:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579625960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uMuAJ3TB0mOpbUT+MSY4zWWJKcXu5CKQpuR+2BIRckY=;
        b=MLmR9u1SKqZ+7aZYRiA7nEyry2sfPRS472PWXF0Jt7U/ZGZW67YWFZN1DbNrKR7mIg3cU4
        JRRFaXySFwM14AzsSE0sFqCk1jbjSRikVj69I/iSv0wUntNjCpNmbWLiidiqV4oC0eT/TX
        zIFhvw/DhEKHZIZuo6IwmTe1HK+Yo/c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-YlmaHteSNomdeauex8M1zg-1; Tue, 21 Jan 2020 11:59:16 -0500
X-MC-Unique: YlmaHteSNomdeauex8M1zg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E70119057C5;
        Tue, 21 Jan 2020 16:59:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 045C05D9E2;
        Tue, 21 Jan 2020 16:59:15 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id ED9618197B;
        Tue, 21 Jan 2020 16:59:14 +0000 (UTC)
Date:   Tue, 21 Jan 2020 11:59:14 -0500 (EST)
From:   Vladis Dronov <vdronov@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        George Shuklin <george.shuklin@gmail.com>
Message-ID: <1671392030.4223005.1579625954850.JavaMail.zimbra@redhat.com>
In-Reply-To: <20200120093404.172208c2@hermes.lan>
References: <20200119011251.7153-1-vdronov@redhat.com> <20200120093404.172208c2@hermes.lan>
Subject: Re: [PATCH iproute2] ip: fix link type and vlan oneline output
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.2.123, 10.4.195.26]
Thread-Topic: fix link type and vlan oneline output
Thread-Index: 4qr13m+2R86IuhIhHioBnqx9aryrhQ==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello,

> The change to ipaddress.c was incorrect. You can't change the order of things
> in the output.

i still believe it is bad to break a single link layers options line with
a multi-line piece:

5: veth90.4000@veth90: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 26:9a:05:af:db:00 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 0 maxmtu 65535
    vlan protocol 802.1Q id 4000 <REORDER_HDR>               the option line is broken ^^^ by \n in print_linktype()
      ingress-qos-map { 1:2 }
      egress-qos-map { 2:1 } addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
                             ^^^ the option line continues here

print_linktype() has an unconditional \n so it always breaks a link layer
options line. this output is assumed to be human-readable, so i believe,
proper indentation is more important that an order of fields. a machine-
readable format is another one, as far as i understand.

i'm not sure how "an order of things" is supposed to be stable, if
print_linktype() outputs a variable number of variable fields (depending
on a link type) in the middle of a link layer options.

surely, if an order of things in this understanding is above all, please,
ignore my rant.

also, with the change a commit message should be different. i understand,
it is too late to change it, but still. let a proper message be at least
here, in the mail thread:

>>> begin >>>
Add oneline support for vlan's ingress and egress qos maps.

Before the fix:

# ip -oneline -details link show veth90.4000
5: veth90.4000@veth90: ... maxmtu 65535 \    vlan protocol 802.1Q id 4000 <REORDER_HDR>
      ingress-qos-map { 1:2 }   <<< a multiline output despite -oneline
      egress-qos-map { 2:1 } addrgenmode eui64 numtxqueues 1 ...

After the fix:

# ip -details link show veth90.4000
5: veth90.4000@veth90: ... maxmtu 65535 \    vlan protocol 802.1Q id 4000 <REORDER_HDR> \      ingress-qos-map { 1:2 } \      egress-qos-map { 2:1 } addrgenmode eui64 numtxqueues 1 ...
<<< end <<<

> Second, you needed to have a Fixes tag. In this case, it went back to
> original vlan support.

indeed, this is my mistake, thank you for correcting this in the patch
submitted.

Best regards,
Vladis Dronov | Red Hat, Inc. | The Core Kernel | Senior Software Engineer

----- Original Message -----
> From: "Stephen Hemminger" <stephen@networkplumber.org>
> To: "Vladis Dronov" <vdronov@redhat.com>
> Cc: netdev@vger.kernel.org, "David Ahern" <dsahern@gmail.com>, "George Shuklin" <george.shuklin@gmail.com>
> Sent: Monday, January 20, 2020 6:34:04 PM
> Subject: Re: [PATCH iproute2] ip: fix link type and vlan oneline output
>
> The change to ipaddress.c was incorrect. You can't change the order of things
> in the output.
> 
> Second, you needed to have a Fixes tag. In this case, it went back to
> original vlan support.

