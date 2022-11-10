Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE6396244D9
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 15:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiKJOwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 09:52:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiKJOwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 09:52:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9371663E8
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 06:51:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668091915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=omYoFDdizbothqM1y6x7ltgbHGFmerjPUiCe70Zk9cs=;
        b=PdRMNZ8fPY0ZfdlG1v8LYb2cDmRxKNwNQpe+ei0X68Hmtme5vNWN1j+ugI+rjm2bu1VRUe
        9YoZsG6aYcrzO1nHi1uDDB3Ed6HXP9ebQmEaE95guGcC2wbTxiBre1QgQVINvT4kF9Qzuh
        FK81Vn9eBokrgim2gX0MzjPhwqWEk7k=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-fovA9puiPdCfkCA7I0Rovg-1; Thu, 10 Nov 2022 09:51:51 -0500
X-MC-Unique: fovA9puiPdCfkCA7I0Rovg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2ACFC381078F;
        Thu, 10 Nov 2022 14:51:51 +0000 (UTC)
Received: from p1.luc.cera.cz (ovpn-193-136.brq.redhat.com [10.40.193.136])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 15BAE2166B29;
        Thu, 10 Nov 2022 14:51:47 +0000 (UTC)
Date:   Thu, 10 Nov 2022 15:51:47 +0100
From:   Ivan Vecera <ivecera@redhat.com>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Piotrowski, Patryk" <patryk.piotrowski@intel.com>,
        SlawomirX Laba <slawomirx.laba@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] iavf: Do not restart Tx queues after reset task
 failure
Message-ID: <20221110155147.1a2c57f6@p1.luc.cera.cz>
In-Reply-To: <CO1PR11MB508996B0D00B5FE6187AF085D63E9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20221108102502.2147389-1-ivecera@redhat.com>
        <Y2vvbwkvAIOdtZaA@unreal>
        <CO1PR11MB508996B0D00B5FE6187AF085D63E9@CO1PR11MB5089.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

On Wed, 9 Nov 2022 20:11:55 +0000
"Keller, Jacob E" <jacob.e.keller@intel.com> wrote:

> > Sorry for my naive question, I see this pattern a lot (including RDMA),
> > so curious. Everyone checks netif_running() outside of rtnl_lock, while
> > dev_close() changes state bit __LINK_STATE_START. Shouldn't rtnl_lock()
> > placed before netif_running()?  
> 
> Yes I think you're right. A ton of people check it without the lock but I think thats not strictly safe. Is dev_close safe to call when netif_running is false? Why not just remove the check and always call dev_close then.
> 
> Thanks,
> Jake

Check for a bit value (like netif_runnning()) is much cheaper than unconditionally
taking global lock like RTNL.

Ivan

