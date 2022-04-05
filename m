Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58A114F3F11
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 22:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384198AbiDEOYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343999AbiDEOFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:05:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E38411563C9
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 05:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649163489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EJskeIBbl6yrirNy4s27VAVAl66Ihk5kHs4/ZyWSw3U=;
        b=UbmRSnN5ihLiD4mwE/K9Fr2UmJOoB9eaKTWS7/OU32IRr5vn91+yrTN/tOrqLDJHB/hnOW
        3UP7sedtYddLwf+/FFSt9WhBFUCoiA919qAsLgj/OdlFu/twHbNDnYCaUizKyju8NqrRC7
        oGUyC0LnLESJvYHI8IBp+lp83Gvbp0Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-173-rZe767cMN8euYMtdoUbPwA-1; Tue, 05 Apr 2022 08:58:06 -0400
X-MC-Unique: rZe767cMN8euYMtdoUbPwA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A52D805F65;
        Tue,  5 Apr 2022 12:58:06 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.17.196])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D25B34029DE;
        Tue,  5 Apr 2022 12:58:05 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ovs-dev] [PATCH net] net: openvswitch: don't send internal
 clone attribute to the userspace.
References: <20220404104150.2865736-1-i.maximets@ovn.org>
Date:   Tue, 05 Apr 2022 08:58:05 -0400
In-Reply-To: <20220404104150.2865736-1-i.maximets@ovn.org> (Ilya Maximets's
        message of "Mon, 4 Apr 2022 12:41:50 +0200")
Message-ID: <f7tzgkzznz6.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ilya Maximets <i.maximets@ovn.org> writes:

> 'OVS_CLONE_ATTR_EXEC' is an internal attribute that is used for
> performance optimization inside the kernel.  It's added by the kernel
> while parsing user-provided actions and should not be sent during the
> flow dump as it's not part of the uAPI.
>
> The issue doesn't cause any significant problems to the ovs-vswitchd
> process, because reported actions are not really used in the
> application lifecycle and only supposed to be shown to a human via
> ovs-dpctl flow dump.  However, the action list is still incorrect
> and causes the following error if the user wants to look at the
> datapath flows:
>
>   # ovs-dpctl add-dp system@ovs-system
>   # ovs-dpctl add-flow "<flow match>" "clone(ct(commit),0)"
>   # ovs-dpctl dump-flows
>   <flow match>, packets:0, bytes:0, used:never,
>     actions:clone(bad length 4, expected -1 for: action0(01 00 00 00),
>                   ct(commit),0)
>
> With the fix:
>
>   # ovs-dpctl dump-flows
>   <flow match>, packets:0, bytes:0, used:never,
>     actions:clone(ct(commit),0)
>
> Additionally fixed an incorrect attribute name in the comment.
>
> Fixes: b233504033db ("openvswitch: kernel datapath clone action")
> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
> ---

Acked-by: Aaron Conole <aconole@redhat.com>

