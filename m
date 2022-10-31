Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A43D1613AC7
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 16:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbiJaP4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 11:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiJaPz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 11:55:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549C4120A6
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 08:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667231698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U9YGPQD32fRro4th7mGhD/Vc9gWK+/5NPR/hXFGVq6g=;
        b=ekop7b32WJoJo1Zkq57TnSvlddbo7rL2gr3DtzA9wHtYYduV7K+pMRYE0/IHFuTc3KUEFR
        6ipHHeR1/f8edvUT/KxpAWVVRHROvbyPu1oT2TOUHbEklVYR2P8LuGVbp9KCX8fooMJ6Tv
        w81dJ3V/TBC1+ZtPXZWJElANIyNkDqs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-vRos5upwN22HuFBiSLFJdQ-1; Mon, 31 Oct 2022 11:54:53 -0400
X-MC-Unique: vRos5upwN22HuFBiSLFJdQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 79E173C3C960;
        Mon, 31 Oct 2022 15:54:52 +0000 (UTC)
Received: from griffin (ovpn-208-21.brq.redhat.com [10.40.208.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 820A61121314;
        Mon, 31 Oct 2022 15:54:50 +0000 (UTC)
Date:   Mon, 31 Oct 2022 16:54:48 +0100
From:   Jiri Benc <jbenc@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Shmulik Ladkani <shmulik@metanetworks.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tomas Hruby <tomas@tigera.io>,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        alexanderduyck@meta.com, willemb@google.com,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net] net: gso: fix panic on frag_list with mixed head
 alloc types
Message-ID: <20221031165448.48533b8e@griffin>
In-Reply-To: <20221028214123.1ac0fc87@kernel.org>
References: <559cea869928e169240d74c386735f3f95beca32.1666858629.git.jbenc@redhat.com>
        <20221028214123.1ac0fc87@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Oct 2022 21:41:23 -0700, Jakub Kicinski wrote:
> On Thu, 27 Oct 2022 10:20:56 +0200 Jiri Benc wrote:
> > It turns out this assumption does not hold. We've seen BUG_ON being hit
> > in skb_segment when skbs on the frag_list had differing head_frag. That
> > particular case was with vmxnet3; looking at the driver, it indeed uses
> > different skb allocation strategies based on the packet size.  
> 
> Where are you looking? I'm not seeing it TBH.

Looking at the code again, I think I misread it.

> I don't think the driver is that important, tho, __napi_alloc_skb() 
> will select page backing or kmalloc, all by itself.

In this case, it was __netdev_alloc_skb. I'll fix the description.

Thanks!

 Jiri

