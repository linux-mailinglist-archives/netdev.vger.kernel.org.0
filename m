Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7114D5239
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 20:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243728AbiCJSpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 13:45:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236161AbiCJSpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 13:45:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 801B410BBE4
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 10:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646937860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C26Xd5SFA51JD8n7O4vVJ7Y+klB3lT6XQZ97SKJ4BDw=;
        b=jGEXdTLFg9vHsMlfI9rQrjF/NgfbTra/IOydOPdoaS1gZSq1bTEsVEwKKO6sdPMBeE3Uz7
        JErXc/5FlSviwajGa9AxsqZg7OfpjxPKWe0xv3A61QMFhONWiVcfCj03vEyxr+uazZHAc/
        lJqE+/W4UvN1c+jHCxvrSsItokQXotI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-252-unP1m22ZMr6noMVdO7thwA-1; Thu, 10 Mar 2022 13:44:16 -0500
X-MC-Unique: unP1m22ZMr6noMVdO7thwA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E85F31854E21;
        Thu, 10 Mar 2022 18:44:14 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.17.112])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C930841CF;
        Thu, 10 Mar 2022 18:44:12 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Roi Dayan <roid@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Pravin B Shelar <pshelar@ovn.org>,
        Toms Atteka <cpp.code.lv@gmail.com>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH net-next v2] net: openvswitch: fix uAPI incompatibility
 with existing user space
References: <20220309222033.3018976-1-i.maximets@ovn.org>
Date:   Thu, 10 Mar 2022 13:44:12 -0500
In-Reply-To: <20220309222033.3018976-1-i.maximets@ovn.org> (Ilya Maximets's
        message of "Wed, 9 Mar 2022 23:20:33 +0100")
Message-ID: <f7ty21hir5v.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ilya Maximets <i.maximets@ovn.org> writes:

> Few years ago OVS user space made a strange choice in the commit [1]
> to define types only valid for the user space inside the copy of a
> kernel uAPI header.  '#ifndef __KERNEL__' and another attribute was
> added later.
>
> This leads to the inevitable clash between user space and kernel types
> when the kernel uAPI is extended.  The issue was unveiled with the
> addition of a new type for IPv6 extension header in kernel uAPI.
>
> When kernel provides the OVS_KEY_ATTR_IPV6_EXTHDRS attribute to the
> older user space application, application tries to parse it as
> OVS_KEY_ATTR_PACKET_TYPE and discards the whole netlink message as
> malformed.  Since OVS_KEY_ATTR_IPV6_EXTHDRS is supplied along with
> every IPv6 packet that goes to the user space, IPv6 support is fully
> broken.
>
> Fixing that by bringing these user space attributes to the kernel
> uAPI to avoid the clash.  Strictly speaking this is not the problem
> of the kernel uAPI, but changing it is the only way to avoid breakage
> of the older user space applications at this point.
>
> These 2 types are explicitly rejected now since they should not be
> passed to the kernel.  Additionally, OVS_KEY_ATTR_TUNNEL_INFO moved
> out from the '#ifdef __KERNEL__' as there is no good reason to hide
> it from the userspace.  And it's also explicitly rejected now, because
> it's for in-kernel use only.
>
> Comments with warnings were added to avoid the problem coming back.
>
> (1 << type) converted to (1ULL << type) to avoid integer overflow on
> OVS_KEY_ATTR_IPV6_EXTHDRS, since it equals 32 now.
>
>  [1] beb75a40fdc2 ("userspace: Switching of L3 packets in L2 pipeline")
>
> Fixes: 28a3f0601727 ("net: openvswitch: IPv6: Add IPv6 extension header support")
> Link: https://lore.kernel.org/netdev/3adf00c7-fe65-3ef4-b6d7-6d8a0cad8a5f@nvidia.com
> Link: https://github.com/openvswitch/ovs/commit/beb75a40fdc295bfd6521b0068b4cd12f6de507c
> Reported-by: Roi Dayan <roid@nvidia.com>
> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
> ---

Acked-by: Aaron Conole <aconole@redhat.com>

