Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF5275A7704
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 09:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbiHaHFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 03:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiHaHFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 03:05:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E445A2D9
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 00:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661929548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mg8FDivTjK0Fno47rCTZSDZ/G71sgK45gh5D1Ko2fqs=;
        b=OsLC/xIzzQSrh163TngvKjY92ZkvhNe6CDYEba43XgQc7pfZ+TwDZfKcpnwBVbLIF297df
        IAFikKoEyfCPF7wmnQ9RPhYc2fXCRb+7JcoGuVWhDMCblrPzH+HBjhnBHvcPUq1furrFj+
        ly1I0WB2wjACi8gymJXhaokrCPSQO0o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-dFBVqmFwO4yY4rhIp3n_XA-1; Wed, 31 Aug 2022 03:05:45 -0400
X-MC-Unique: dFBVqmFwO4yY4rhIp3n_XA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D6063800C30;
        Wed, 31 Aug 2022 07:05:45 +0000 (UTC)
Received: from p1.luc.cera.cz (unknown [10.40.195.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E5091C15BB3;
        Wed, 31 Aug 2022 07:05:41 +0000 (UTC)
Date:   Wed, 31 Aug 2022 09:05:40 +0200
From:   Ivan Vecera <ivecera@redhat.com>
To:     "Laba, SlawomirX" <slawomirx.laba@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "Piotrowski, Patryk" <patryk.piotrowski@intel.com>,
        Vitaly Grinberg <vgrinber@redhat.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] iavf: Detach device during reset task
Message-ID: <20220831090540.53e324af@p1.luc.cera.cz>
In-Reply-To: <DM6PR11MB31134AD7D5D1CB5382A5052887799@DM6PR11MB3113.namprd11.prod.outlook.com>
References: <20220830081627.1205872-1-ivecera@redhat.com>
        <DM6PR11MB31134AD7D5D1CB5382A5052887799@DM6PR11MB3113.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Aug 2022 20:49:54 +0000
"Laba, SlawomirX" <slawomirx.laba@intel.com> wrote:

> Ivan, what do you think about this flow [1]? Shouldn't it also goto reset_finish label?
> 
> 	if (i == IAVF_RESET_WAIT_COMPLETE_COUNT) {
> 		dev_err(&adapter->pdev->dev, "Reset never finished (%x)\n",
> 			reg_val);
> 		iavf_disable_vf(adapter);
> 		mutex_unlock(&adapter->client_lock);
> 		mutex_unlock(&adapter->crit_lock);
> 		return; /* Do not attempt to reinit. It's dead, Jim. */
> 	}
> 
> I am concerned that if the reset never finishes and iavf goes into disabled state, and then for example if driver reload operation is performed, bad things can happen.

I think we should not re-attach device back as the VF is disabled. Detached device causes that userspace (user) won't be able to configure associated interface
that is correct. Driver reload won't cause anything special in this situation because during module removal the interface is unregistered.

Thanks,
Ivan

