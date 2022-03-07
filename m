Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2B454D011E
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 15:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243151AbiCGOZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 09:25:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243163AbiCGOZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 09:25:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 28A5C79392
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 06:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646663048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cppypvAs3psbfXolygHDRONBSorAINZdMrPRXwq2/qI=;
        b=TuGyyv5bUq5Ut3sCaM9t33h7hDlsB4P1xUT8DLAqu3fJfBKBAFbCPyPxOQGdLzrxWPeCia
        EF38n8hhxFaXZnkiZ5cRfJCuwBSK3z7ugh5Bh5u2uqTGAua1iVz/TPg3WU9TOcPa5hsgv8
        Yq6oxgAf7trGUMPKU0pgDCpPbcn0ciY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-600-nCAFmBz_P_2Vmjg300j0Sw-1; Mon, 07 Mar 2022 09:24:04 -0500
X-MC-Unique: nCAFmBz_P_2Vmjg300j0Sw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A490A1006AAA;
        Mon,  7 Mar 2022 14:24:02 +0000 (UTC)
Received: from localhost (unknown [10.43.135.229])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 967081038AAA;
        Mon,  7 Mar 2022 14:24:00 +0000 (UTC)
Date:   Mon, 7 Mar 2022 15:23:58 +0100
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Michael Walle <michael@walle.cc>, gerhard@engleder-embedded.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        vinicius.gomes@intel.com, yangbo.lu@nxp.com
Subject: Re: [RFC PATCH net-next 0/6] ptp: Support hardware clocks with
 additional free running time
Message-ID: <YiYVfrulOJ5RtWOy@localhost>
References: <20220306085658.1943-1-gerhard@engleder-embedded.com>
 <20220307120751.3484125-1-michael@walle.cc>
 <20220307140531.GA29247@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307140531.GA29247@hoboy.vegasvil.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 07, 2022 at 06:05:31AM -0800, Richard Cochran wrote:
> On Mon, Mar 07, 2022 at 01:07:51PM +0100, Michael Walle wrote:
> > Richard Cochran wrote:
> > > You are adding eight bytes per frame for what is arguably an extreme
> > > niche case.
> > 
> > I don't think it is a niche case, btw. I was always wondering why
> > NXP introduced the vclock thingy. And apparently it is for
...
> 
> Niche is relative.
> 
> Believe it or not, the overwhelmingly great majority of people using
> Linux have no interest in TSN.

Is this not the same issue as what was recently discussed about some
devices being able to provide two (e.g. PHY+MAC) or even more
timestamps at the same time?

There is a need to have multiple PHCs per device and for that to work
the drivers need to be able to save multiple timestamps per packet.

In this series it is an additional freerunning clock. That seems too
specific. I think we need a more general approach that will support
two and more physical PHCs per device. Virtual clocks are not involved
here.

-- 
Miroslav Lichvar

