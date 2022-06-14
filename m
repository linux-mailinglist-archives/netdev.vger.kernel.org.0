Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6AA54B100
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 14:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243022AbiFNM3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 08:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239570AbiFNM2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 08:28:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 912BB22B02
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655209687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BkMN5GdsQ3TnUHYhHsdxvG0oToXV41wpPoaVs946Umc=;
        b=EIvDVoUNmrGfZ094mGCNluzqTbeSlA+XnkgLJv3OVVBVN/whrQ6bCZDh7jtD7Uo3Wgrl7F
        IkvqcNE5SDdIC3M+ZgMEJzEBXr6dkpDcrDzrIDobOzb0YyCqBHkF+tDyoQxXs4X7bN+qMH
        Kw+sVGsGudHjPzTocJJrFwhZezn5Yhw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-35-Wbnn9UbCOPyz3KW422Z_2Q-1; Tue, 14 Jun 2022 08:28:02 -0400
X-MC-Unique: Wbnn9UbCOPyz3KW422Z_2Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 664EF811767;
        Tue, 14 Jun 2022 12:28:01 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.40.208.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E20929D7F;
        Tue, 14 Jun 2022 12:28:00 +0000 (UTC)
Date:   Tue, 14 Jun 2022 14:27:37 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Kaustubh Pandey <quic_kapandey@quicinc.com>
Cc:     <davem@davemloft.net>, <dsahern@kernel.org>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>,
        Sean Tranchetti <quic_stranche@quicinc.com>
Subject: Re: [PATCH net v2 1/2] ipv6: Honor route mtu if it is within limit
 of dev mtu
Message-ID: <20220614142737.73fffc9d@elisabeth>
In-Reply-To: <1655182915-12897-2-git-send-email-quic_subashab@quicinc.com>
References: <1655182915-12897-1-git-send-email-quic_subashab@quicinc.com>
        <1655182915-12897-2-git-send-email-quic_subashab@quicinc.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kaustubh,

On Mon, 13 Jun 2022 23:01:54 -0600
Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com> wrote:

> From: Kaustubh Pandey <quic_kapandey@quicinc.com>
> 
> When netdevice MTU is increased via sysfs, NETDEV_CHANGEMTU is raised.
> 
> addrconf_notify -> rt6_mtu_change -> rt6_mtu_change_route ->
> fib6_nh_mtu_change
> 
> As part of handling NETDEV_CHANGEMTU notification we land up on a
> condition where if route mtu is less than dev mtu and route mtu equals
> ipv6_devconf mtu, route mtu gets updated.
> 
> Due to this v6 traffic end up using wrong MTU then configured earlier.

I read this a few times but I still fail to understand what issue
you're actually fixing -- what makes this new MTU "wrong"?

The idea behind the original implementation is that, when an interface
MTU is administratively updated, we should allow PMTU updates, if the
old PMTU was matching the interface MTU, because the old MTU setting
might have been the one limiting the MTU on the whole path.

That is, if you lower the MTU on an interface, and then increase it
back, a permanently lower PMTU is somewhat unexpected. As far as I can
see, this behaviour persists with this patch, but:

> This commit fixes this by removing comparison with ipv6_devconf
> and updating route mtu only when it is greater than incoming dev mtu.

...I'm not sure what you really mean by "incoming dev mtu". Is it the
newly configured one?

-- 
Stefano

