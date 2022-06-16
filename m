Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 832ED54E8F6
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 19:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244537AbiFPR6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 13:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235648AbiFPR5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 13:57:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 15B5863BA
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 10:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655402272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yaAVFcKP1qsk5ZUQPpoI9PsdEl44hEsW+CZIZb2W4tY=;
        b=cfmgAOdy5Xguu14QwdAi5rI4Gj6nfQR78g3rlpLNNZ+Y7YE4J/U2hjXX73Tc0sepB+sdmu
        ZTzMAGn39GUTDP7P76Ov8ZmTZgDCXIW7VHubIu0Fq9q2CTUI5jn6+OTX3AIjzNfv2FPAwW
        ulR6e4vgxdl8ytMrtZCiOij87VqnzHI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-378-EF7-WY2JP9iC6OYnGJjx0w-1; Thu, 16 Jun 2022 13:57:49 -0400
X-MC-Unique: EF7-WY2JP9iC6OYnGJjx0w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A080685A582;
        Thu, 16 Jun 2022 17:57:48 +0000 (UTC)
Received: from p1.luc.cera.cz (unknown [10.40.193.216])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D08C0492CA6;
        Thu, 16 Jun 2022 17:57:47 +0000 (UTC)
Date:   Thu, 16 Jun 2022 19:57:46 +0200
From:   Ivan Vecera <ivecera@redhat.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        Daniel Juarez <djuarezg@cern.ch>
Subject: Re: [PATCH ethtool] sff-8079/8472: Fix missing sff-8472 output in
 netlink path
Message-ID: <20220616195746.2a3feb92@p1.luc.cera.cz>
In-Reply-To: <Yqtpl+DLpH/YDnxy@shredder>
References: <20220616155009.3609572-1-ivecera@redhat.com>
        <Yqtpl+DLpH/YDnxy@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jun 2022 20:34:15 +0300
Ido Schimmel <idosch@nvidia.com> wrote:

> On Thu, Jun 16, 2022 at 05:50:09PM +0200, Ivan Vecera wrote:
> > Commit 5b64c66f58d ("ethtool: Add netlink handler for
> > getmodule  
>  (-m)") provided a netlink variant for getmodule
> > but also introduced a regression as netlink output is different
> > from ioctl output that provides information from A2h page
> > via sff8472_show_all().
> > 
> > To fix this the netlink path should check a presence of A2h page
> > by value of bit 6 in byte 92 of page A0h and if it is set then
> > get A2h page and call sff8472_show_all().
> > 
> > Fixes: 5b64c66f58d ("ethtool: Add netlink handler for getmodule  
>  (-m)")
> > Tested-by: Daniel Juarez <djuarezg@cern.ch>
> > Co-authored-by: Ido Schimmel <idosch@nvidia.com>
> > Signed-off-by: Ivan Vecera <ivecera@redhat.com>  
> 
> With Michal's comment:
> 
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Tested-by: Ido Schimmel <idosch@nvidia.com>
> 
> Tested with both netlink and ioctl, but only with SFP modules that lack
> diagnostic information, as I don't have these at hand.

I have tested this with SFP modules with diag info...
(together with kernel fix: https://patchwork.kernel.org/project/netdevbpf/patch/20220616160856.3623273-1-ivecera@redhat.com/)

> Michal, note that for ethtool-next we plan to get rid of sfpdiag.c and
> fold it into sfpid.c, so that the latter will be able to handle both
> SFF-8079 and SFF-8472 using the same memory map. We felt that it's too
> big of a change for the main branch.
+1

Ivan

