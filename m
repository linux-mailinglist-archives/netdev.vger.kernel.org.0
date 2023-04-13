Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D63A6E1110
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 17:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjDMP1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 11:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbjDMP0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 11:26:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B138A6F
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 08:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681399562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yMwKgVrqgF+9zzUQHsYccfd59YsRxoULj4ZO2AIHKTg=;
        b=Jx70MvJ9t9Q0fVqNqieLsmvVG07AGsX2hg+ph5niJyvTjrfpvW1mDo6s8XaLR1kdxR4blY
        nAj8ZBBggfmQFK9RAcIkmPOO7pjZsnOC2UQgKXkgkZ5Sg72WMic7WkOLRyoY9CO2CHPvME
        0WqnLzzAfkzR2qMI9H6r0JpKk3MsxpA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-76-fVkbTmMVNdaG5QRwmpDv1Q-1; Thu, 13 Apr 2023 11:25:58 -0400
X-MC-Unique: fVkbTmMVNdaG5QRwmpDv1Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B342280AA34;
        Thu, 13 Apr 2023 15:25:58 +0000 (UTC)
Received: from calimero.vinschen.de (unknown [10.39.192.39])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BB712492B00;
        Thu, 13 Apr 2023 15:25:57 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id 5ED6EA808C0; Thu, 13 Apr 2023 17:25:56 +0200 (CEST)
Date:   Thu, 13 Apr 2023 17:25:56 +0200
From:   Corinna Vinschen <vinschen@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        alexandre.torgue@foss.st.com, Jose Abreu <joabreu@synopsys.com>
Subject: Re: [PATCH net-next] net: stmmac: propagate feature flags to vlan
Message-ID: <ZDgfBEnxLWczPLQO@calimero.vinschen.de>
Mail-Followup-To: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        alexandre.torgue@foss.st.com, Jose Abreu <joabreu@synopsys.com>
References: <20230411130028.136250-1-vinschen@redhat.com>
 <20230412211513.2d6fc1f7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230412211513.2d6fc1f7@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Apr 12 21:15, Jakub Kicinski wrote:
> On Tue, 11 Apr 2023 15:00:28 +0200 Corinna Vinschen wrote:
> > stmmac_dev_probe doesn't propagate feature flags to VLANs.  So features
> > like TX offloading don't correspond with the general features and it's
> > not possible to manipulate features via ethtool -K to affect VLANs.
> 
> Actually, could you add to the commit message a sentence or two about
> the features that you tested and/or a mention of the manual indicating
> that they are supported over vlans? Especially TSO on a quick look.
> I just realized now that you didn't explicitly say that those features
> work, just that you can manipulate them...

I tested that I can, for instance, set and reset the tx-checksumming
flag with ethtool -K.  As for TSO, I checked the source code, and the
function stmmac_tso_xmit handles VLANs just fine.  While different
NICs supported by stmmac have different offload features, there's no
indication in the driver source that VLANs have less offloading features
than a non-VLAN connection on the same HW.  Admittedly, I never saw
documentation explicitely claiming this.

If that's not sufficient, testing will take another day or two, because
I have to ask for a remote test setup first.


Corinna

