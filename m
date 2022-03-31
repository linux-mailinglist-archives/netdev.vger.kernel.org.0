Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6554ED97F
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 14:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235974AbiCaMS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 08:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235965AbiCaMS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 08:18:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 35D66419B9
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 05:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648729028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f5/8+4RwHAMD/KHypXq8zvLNL9+H5+MYFtmie7z/yWo=;
        b=EmclXzI2RAYSzx9PUSoVJjr54KbsY11lZOzbfpEYwI5UXMd8QwvdCyJ/pXzo3R1oBFd1NM
        phzpYooJqB+9FhW2cxjPVdpJ9fIz9et9GGNzqjGDzFy9mAkysPPETeBSIsAivNXQ9vDHMr
        c0o8ZQvAiYnAzLlRPiYOw9lkAXHZdis=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-290-v7RIh1xtMi-XLByMpu-iUA-1; Thu, 31 Mar 2022 08:17:04 -0400
X-MC-Unique: v7RIh1xtMi-XLByMpu-iUA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7914801E95;
        Thu, 31 Mar 2022 12:16:58 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8AC852026D64;
        Thu, 31 Mar 2022 12:16:54 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <4de651adc35341c5fa99db54b9295d4845648563.camel@redhat.com>
References: <4de651adc35341c5fa99db54b9295d4845648563.camel@redhat.com> <164865013439.2941502.8966285221215590921.stgit@warthog.procyon.org.uk>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        Xiaolong Huang <butterflyhuangxx@gmail.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] rxrpc: fix some null-ptr-deref bugs in server_key.c
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3114596.1648729013.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 31 Mar 2022 13:16:53 +0100
Message-ID: <3114597.1648729013@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paolo Abeni <pabeni@redhat.com> wrote:

> It looks like we can add a couple of fixes tag to help stable teams:
> =

> Fixes: d5953f6543b5 ("rxrpc: Allow security classes to give more info on=
 server keys")

Not this one.  This includes a check for the one op it adds:

	+       if (sec && sec->describe_server_key)
	+               sec->describe_server_key(key, m);


> Fixes: 12da59fcab5a ("xrpc: Hand server key parsing off to the security =
class")

There's a missing 'r' in "rxrpc:" in the patch subject, but otherwise this=
 one
looks like the right one.

Thanks,
David

