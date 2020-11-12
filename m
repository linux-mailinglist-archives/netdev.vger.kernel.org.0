Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF1F2B0E86
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgKLTyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:54:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59326 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726702AbgKLTyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:54:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605210881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CFQzTySwNt2NOoQnXqVc/FjTwpXdtzoCtvmyjrkFsF0=;
        b=ETNNxEOpt4vlcRupVUcFnfvRcbOk3pNRDiOvx50kiiZb52UfgSkk3wF9FQ9AErqDObjIcJ
        1tWj3wsRSe9oneXS3na8e32t81EOs6xSVPAqZ9j166jOC1j9vcCkgxujbBNGibheUCwD8T
        CErhZIszHgwoaJ2zJgwjMsZ2AhyHo4I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-I2W0luy2PhO-4mHubwvvgg-1; Thu, 12 Nov 2020 14:54:37 -0500
X-MC-Unique: I2W0luy2PhO-4mHubwvvgg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 480511087D7B;
        Thu, 12 Nov 2020 19:54:36 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.10.110.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E21586198C;
        Thu, 12 Nov 2020 19:54:29 +0000 (UTC)
Message-ID: <5616ee6f15c2b9da73d23bcc23eca5befc824abe.camel@redhat.com>
Subject: Re: [PATCH net-next] net-loopback: allow lo dev initial state to be
 controlled
From:   Dan Williams <dcbw@redhat.com>
To:     Andrew Lunn <andrew@lunn.ch>, Jian Yang <jianyang.kernel@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Mahesh Bandewar <maheshb@google.com>,
        Jian Yang <jianyang@google.com>
Date:   Thu, 12 Nov 2020 13:54:28 -0600
In-Reply-To: <20201112160832.GB1456319@lunn.ch>
References: <20201111204308.3352959-1-jianyang.kernel@gmail.com>
         <20201112160832.GB1456319@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-11-12 at 17:08 +0100, Andrew Lunn wrote:
> On Wed, Nov 11, 2020 at 12:43:08PM -0800, Jian Yang wrote:
> > From: Mahesh Bandewar <maheshb@google.com>
> > 
> > Traditionally loopback devices comes up with initial state as DOWN
> > for
> > any new network-namespace. This would mean that anyone needing this
> > device (which is mostly true except sandboxes where networking in
> > not
> > needed at all), would have to bring this UP by issuing something
> > like
> > 'ip link set lo up' which can be avoided if the initial state can
> > be set
> > as UP.
> 
> How useful is lo if it is up, but has no IP address? I don't think
> this change adds the IP addresses does it? So you still need
> something
> inside your netns to add the IP addresses? Which seems to make this
> change pointless?

lo gets addresses automatically these days, no?

$ ip netns add blue
$ ip netns exec blue ip addr
1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
$ ip netns exec blue ip link set lo up
$ ip netns exec blue ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever

Dan

