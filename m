Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEBA9688481
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 17:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbjBBQeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 11:34:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbjBBQeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 11:34:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A77E66EFC
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 08:33:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675355606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/IbsYLWerjuvj1wG8JDg+bx1+wcKZ9y8w11203bWhVs=;
        b=dtqBhzn2irA2zaJKA9BcxAlluStrJGH67kwZOpLNWF4YrhqlYNEpySWGLR2Bf9474awiYr
        dYLaYr++VT8WC+LW2AAqsqxqUlfwZJ7T0H0PFGnSyaUJU8LhU/I3/NWXESxCnouGpW23sd
        +FA0YsQnw74j0OOByiggDmCq9GQDPEU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-wOVACXDQOEG1lCANDrAbuw-1; Thu, 02 Feb 2023 11:33:24 -0500
X-MC-Unique: wOVACXDQOEG1lCANDrAbuw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1C013C025D8;
        Thu,  2 Feb 2023 16:33:20 +0000 (UTC)
Received: from localhost (unknown [10.43.135.229])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E7F61404CD80;
        Thu,  2 Feb 2023 16:33:16 +0000 (UTC)
Date:   Thu, 2 Feb 2023 17:33:15 +0100
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        yangbo.lu@nxp.com, gerhard@engleder-embedded.com,
        habetsm.xilinx@gmail.com, ecree.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, alex.maftei@amd.com,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: PTP vclock: BUG: scheduling while atomic
Message-ID: <Y9vly2QNCxl3d2QL@localhost>
References: <69d0ff33-bd32-6aa5-d36c-fbdc3c01337c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <69d0ff33-bd32-6aa5-d36c-fbdc3c01337c@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 05:02:07PM +0100, Íñigo Huguet wrote:
> Our QA team was testing PTP vclocks, and they've found this error with sfc NIC/driver:
>   BUG: scheduling while atomic: ptp5/25223/0x00000002
> 
> The reason seems to be that vclocks disable interrupts with `spin_lock_irqsave` in
> `ptp_vclock_gettime`, and then read the timecounter, which in turns ends calling to
> the driver's `gettime64` callback.

The same issue was observed with the ice driver:
https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20221107/030633.html

I tried to fix it generally in the vclock support, but was not
successful. There was a hint it would be fixed in the driver. I'm not
sure what is the best approach here.

-- 
Miroslav Lichvar

