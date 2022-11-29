Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 078DE63C289
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 15:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234624AbiK2Obs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 09:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232924AbiK2Obq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 09:31:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6CA2FC2B
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 06:30:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669732252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+goulcWqTqjkFGhNVJrrZeOZ4jW3UE4cjV1o3g/9WTM=;
        b=NBMoVx4hkG+56xObVRrHyOktSxavRfbEnUtv2vU2wbzM5RJljhqsTDrdzZEMqQPa7fLs21
        SMz+Bz4lVrOPurmI+6AKC4x3BgHkauuMWKh+MRWOaLRsROua7ZxUNTThXiTUl0NdRllqoS
        rjfG0owOJIAx/oZO7Ts6ubz6rN/rjwc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-syVIxEU1Mx6Kn1ElpwKu-A-1; Tue, 29 Nov 2022 09:30:50 -0500
X-MC-Unique: syVIxEU1Mx6Kn1ElpwKu-A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D9614884368;
        Tue, 29 Nov 2022 14:30:41 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.34.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E68C2166B4F;
        Tue, 29 Nov 2022 14:30:41 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     netdev@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, dev@openvswitch.org,
        Eelco Chaudron <echaudro@redhat.com>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [RFC net-next 1/6] openvswitch: exclude kernel flow key from
 upcalls
References: <20221122140307.705112-1-aconole@redhat.com>
        <20221122140307.705112-2-aconole@redhat.com>
        <c04242ee-f125-6d95-e263-65470222d3cf@ovn.org>
Date:   Tue, 29 Nov 2022 09:30:38 -0500
In-Reply-To: <c04242ee-f125-6d95-e263-65470222d3cf@ovn.org> (Ilya Maximets's
        message of "Wed, 23 Nov 2022 22:22:23 +0100")
Message-ID: <f7ta649sui9.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ilya Maximets <i.maximets@ovn.org> writes:

> On 11/22/22 15:03, Aaron Conole wrote:
>> When processing upcall commands, two groups of data are available to
>> userspace for processing: the actual packet data and the kernel
>> sw flow key data.  The inclusion of the flow key allows the userspace
>> avoid running through the dissection again.
>> 
>> However, the userspace can choose to ignore the flow key data, as is
>> the case in some ovs-vswitchd upcall processing.  For these messages,
>> having the flow key data merely adds additional data to the upcall
>> pipeline without any actual gain.  Userspace simply throws the data
>> away anyway.
>
> Hi, Aaron.  While it's true that OVS in userpsace is re-parsing the
> packet from scratch and using the newly parsed key for the OpenFlow
> translation, the kernel-porvided key is still used in a few important
> places.  Mainly for the compatibility checking.  The use is described
> here in more details:
>   https://docs.kernel.org/networking/openvswitch.html#flow-key-compatibility
>
> We need to compare the key generated in userspace with the key
> generated by the kernel to know if it's safe to install the new flow
> to the kernel, i.e. if the kernel and OVS userpsace are parsing the
> packet in the same way.
>
> On the other hand, OVS today doesn't check the data, it only checks
> which fields are present.  So, if we can generate and pass the bitmap
> of fields present in the key or something similar without sending the
> full key, that might still save some CPU cycles and memory in the
> socket buffer while preserving the ability to check for forward and
> backward compatibility.  What do you think?

Maybe that can work.  I will try testing.  If so, then I would change
this semantic to send just the bitmap rather than omitting everything.

> The rest of the patch set seems useful even without patch #1 though.

I agree - but I didn't know if it made sense to submit the series
without adding something impactful (like a test).  I will work a bit
more on the flow area - maybe I can add enough actions and matches to
implement basic flow tests to submit while we think more about the feature.

> Nit: This patch #1 should probably be merged with the patch #6 and be
> at the end of a patch set, so the selftest and the main code are updated
> at the same time.

Okay - I can restructure them this way.

> Best regards, Ilya Maximets.

