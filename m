Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6345B50972E
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 08:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349384AbiDUGLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 02:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346144AbiDUGLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 02:11:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2BC5D10FE9
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 23:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650521337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TvwZYEzGE28eFsMv32GXOw2P+ELmPfx1FLDUwPNPBUQ=;
        b=VcNwUFcGMQrHfqx95O45WaDjCLg7jbxPbuwmkW+4HtB/Qc0Twn0yL/+NTsCvnaQUB3Bn3a
        Y1s5hhyB+3xwVlR1RfpP04+fHIp6iX9Wm7TeN9XezV0gg+Cvq59oWVJdEL5ukopNjwRDE7
        exK+GxIRvO2f8FYHJvKRv3tppu0TdcE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-cVR6gPhKOiKhLOalCY4_Ew-1; Thu, 21 Apr 2022 02:08:53 -0400
X-MC-Unique: cVR6gPhKOiKhLOalCY4_Ew-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 731023806650;
        Thu, 21 Apr 2022 06:08:52 +0000 (UTC)
Received: from ceranb (unknown [10.40.194.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7490B2024CB7;
        Thu, 21 Apr 2022 06:08:49 +0000 (UTC)
Date:   Thu, 21 Apr 2022 08:08:48 +0200
From:   Ivan Vecera <ivecera@redhat.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, poros@redhat.com, mschmidt@redhat.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] ice: Fix race during aux device (un)plugging
Message-ID: <20220421080848.41bed123@ceranb>
In-Reply-To: <YmDn2ptpRHasOQag@unreal>
References: <20220420150300.1062689-1-ivecera@redhat.com>
        <YmDn2ptpRHasOQag@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Apr 2022 08:12:58 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> >  static struct iidc_auxiliary_drv *ice_get_auxiliary_drv(struct ice_pf *pf)
> >  {
> >  	struct auxiliary_device *adev;
> >  
> > +	BUG_ON(!mutex_is_locked(&pf->adev_mutex));  
> 
> Please don't add BUG_ON() in driver code.
> 
> I think that you are looking for lockdep_assert_held(&pf->adev_mutex).

Will fix.

I.

