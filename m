Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5B24E647C
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 14:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344870AbiCXN4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 09:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242799AbiCXN4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 09:56:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4C8914B84B
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 06:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648130115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jN9ZXxxaxvUNrOGbnMyP+TSXSOuww55tdZertHPVKPc=;
        b=gmg7KCCvd02gPC7rmzEXp06jpkmHsR/tAyU3Z46qlvYXMAAMcCqqiEVA6xJNxzefBd1WyA
        92sA3BVl3WoDrM99QQymlhKGDc00rSf5PY9kmiOPcgnu4k4HqsZwYDvCxqWoEt419MpIzO
        70N9BPWQTokcwGPEs6kJZdMV1dZbJ7A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-465-QLn3KwR4Ns2mi3SZ1vYFYQ-1; Thu, 24 Mar 2022 09:55:10 -0400
X-MC-Unique: QLn3KwR4Ns2mi3SZ1vYFYQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11F57811E81;
        Thu, 24 Mar 2022 13:55:10 +0000 (UTC)
Received: from localhost (unknown [10.43.135.229])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D1DC5698CFA;
        Thu, 24 Mar 2022 13:55:08 +0000 (UTC)
Date:   Thu, 24 Mar 2022 14:55:07 +0100
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org,
        vinicius.gomes@intel.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 2/6] ptp: Request cycles for TX timestamp
Message-ID: <Yjx4O/nOwriKKoNj@localhost>
References: <20220322210722.6405-1-gerhard@engleder-embedded.com>
 <20220322210722.6405-3-gerhard@engleder-embedded.com>
 <20220324134934.GB27824@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324134934.GB27824@hoboy.vegasvil.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 24, 2022 at 06:49:34AM -0700, Richard Cochran wrote:
> On Tue, Mar 22, 2022 at 10:07:18PM +0100, Gerhard Engleder wrote:
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -578,6 +578,9 @@ enum {
> >  	/* device driver is going to provide hardware time stamp */
> >  	SKBTX_IN_PROGRESS = 1 << 2,
> >  
> > +	/* generate hardware time stamp based on cycles if supported */
> > +	SKBTX_HW_TSTAMP_USE_CYCLES = 1 << 3,
> 
> Bit 4 used, but 3 was unused... interesting!

It seems the bit 3 and 5 were removed in commit 06b4feb37e64
("net: group skb_shinfo zerocopy related bits together.").

-- 
Miroslav Lichvar

