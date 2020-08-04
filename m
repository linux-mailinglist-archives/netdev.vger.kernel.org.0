Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB4023BC4B
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 16:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729057AbgHDOgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 10:36:17 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:51895 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728962AbgHDOgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 10:36:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596551765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Q3uWJlCD+eCisEMMd+WGBW9b2k4TwVWGp2K9q/yugI=;
        b=M/KQhI54dU9jSLARYJqees3+EEYz6sWDbgpIJFRcTtdhWIyLKU6HYaN0kYNFGnpNuYJIll
        9Wcl+v9JgrkVk/SKuMHHmswumbyrLUcSRaZuO38XzPtAS9kPJXEPxuRD1aEqIAR3ntgkK1
        7TA53Iz5+OW3q4bZx+RuUOuO382Gxjc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-XCfMZMCjP9GGxKRwsBaitw-1; Tue, 04 Aug 2020 10:36:01 -0400
X-MC-Unique: XCfMZMCjP9GGxKRwsBaitw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 335E2800476;
        Tue,  4 Aug 2020 14:36:00 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F3D97B902;
        Tue,  4 Aug 2020 14:35:54 +0000 (UTC)
Date:   Tue, 4 Aug 2020 16:35:37 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Westphal <fw@strlen.de>, Aaron Conole <aconole@redhat.com>,
        Numan Siddique <nusiddiq@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Lourdes Pedrajas <lu@pplo.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 5/6] selftests: pmtu.sh: Add tests for
 bridged UDP tunnels
Message-ID: <20200804163537.0ec908ae@elisabeth>
In-Reply-To: <baf285cf-5f58-e36d-abf9-32a8414bada7@gmail.com>
References: <cover.1596520062.git.sbrivio@redhat.com>
        <6b2a52ca59d791dfd5547acb62e710e61e646588.1596520062.git.sbrivio@redhat.com>
        <baf285cf-5f58-e36d-abf9-32a8414bada7@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Aug 2020 08:00:19 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 8/3/20 11:53 PM, Stefano Brivio wrote:
> > @@ -497,12 +529,19 @@ setup_vxlan_or_geneve() {
> >  	run_cmd ${ns_a} ip link add ${type}_a type ${type} id 1 ${opts_a} remote ${b_addr} ${opts} || return 1
> >  	run_cmd ${ns_b} ip link add ${type}_b type ${type} id 1 ${opts_b} remote ${a_addr} ${opts}
> >  
> > -	run_cmd ${ns_a} ip addr add ${tunnel4_a_addr}/${tunnel4_mask} dev ${type}_a
> > -	run_cmd ${ns_b} ip addr add ${tunnel4_b_addr}/${tunnel4_mask} dev ${type}_b
> > +	if [ -n "${br_if_a}" ]; then
> > +		run_cmd ${ns_a} ip addr add ${tunnel4_a_addr}/${tunnel4_mask} dev ${br_if_a}
> > +		run_cmd ${ns_a} ip addr add ${tunnel6_a_addr}/${tunnel6_mask} dev ${br_if_a}
> > +		run_cmd ${ns_a} ip link set ${type}_a master ${br_if_a}
> > +	else
> > +		run_cmd ${ns_a} ip addr add ${tunnel4_a_addr}/${tunnel4_mask} dev ${type}_a
> > +		run_cmd ${ns_a} ip addr add ${tunnel6_a_addr}/${tunnel6_mask} dev ${type}_a
> > +	fi
> >  
> > -	run_cmd ${ns_a} ip addr add ${tunnel6_a_addr}/${tunnel6_mask} dev ${type}_a
> > +	run_cmd ${ns_b} ip addr add ${tunnel4_b_addr}/${tunnel4_mask} dev ${type}_b
> >  	run_cmd ${ns_b} ip addr add ${tunnel6_b_addr}/${tunnel6_mask} dev ${type}_b
> >  
> > +  
> 
> extra newline snuck in

Hm, that was actually intentional because in this function now we
(mostly) have:

  do something with a
  do something with b
  			# something else I don't focus on at a glance

  do something with a
  do something with b

  # do something with a here? No, on the next line.
  # do something with b

But now that you mention it, I see it might be a questionable practice,
and I guess we could drop it.

> other than that:
> Reviewed-by: David Ahern <dsahern@gmail.com>

Dave, let me know if I should resend the series. Thanks.

-- 
Stefano

