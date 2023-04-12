Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B79196DF8FA
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 16:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbjDLOva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 10:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjDLOv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 10:51:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850135599
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 07:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681311041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sz+dn7CTipwEX2P2KkDHe7rOoIpoiR+uqIWNId6BW5s=;
        b=Z/HO9lGp6p+ohqWKDn/BayVt18u+so3A2xsNWznAMpj7TMDbp0dhNe3QDFZBfyWCTwP1Xf
        oZBveFE1dpYFOAUFb15pJFOp3I+gxbnxwR/qtavP92xd3IqNR3IrXTs1/l8MSMwsitV33f
        z98V2FQPMFxCFBkN5eAW/qRDKielIG8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-qgAiEcNEPn-vdPsBE0J2yg-1; Wed, 12 Apr 2023 10:50:39 -0400
X-MC-Unique: qgAiEcNEPn-vdPsBE0J2yg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 51580811E7C;
        Wed, 12 Apr 2023 14:50:39 +0000 (UTC)
Received: from calimero.vinschen.de (unknown [10.39.192.39])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E1C8C40C20FA;
        Wed, 12 Apr 2023 14:50:38 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id 83ACAA80BFF; Wed, 12 Apr 2023 16:50:37 +0200 (CEST)
Date:   Wed, 12 Apr 2023 16:50:37 +0200
From:   Corinna Vinschen <vinschen@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        alexandre.torgue@foss.st.com, Jose Abreu <joabreu@synopsys.com>
Subject: Re: [PATCH net-next] net: stmmac: propagate feature flags to vlan
Message-ID: <ZDbFPYBxejODjjDQ@calimero.vinschen.de>
Mail-Followup-To: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        alexandre.torgue@foss.st.com, Jose Abreu <joabreu@synopsys.com>
References: <20230411130028.136250-1-vinschen@redhat.com>
 <ZDauEGjbcT6uPfCp@calimero.vinschen.de>
 <20230412074534.15e2c82b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230412074534.15e2c82b@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Apr 12 07:45, Jakub Kicinski wrote:
> On Wed, 12 Apr 2023 15:11:44 +0200 Corinna Vinschen wrote:
> > On Apr 11 15:00, Corinna Vinschen wrote:
> > > stmmac_dev_probe doesn't propagate feature flags to VLANs.  So features
> > > like TX offloading don't correspond with the general features and it's
> > > not possible to manipulate features via ethtool -K to affect VLANs.  
> > 
> > On second thought, I wonder if this shouldn't go into net, rather then
> > net-next?  Does that make sense? And, do I have to re-submit, if so?
> 
> If it's not a regression it should go into net-next.
> "never worked, doesn't crash" category.

Ok, great, thanks!


Corinna

