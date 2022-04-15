Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C11B5502DCE
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 18:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355867AbiDOQlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 12:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355858AbiDOQlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 12:41:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1414EC6B46
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 09:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650040732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yY1XpQLOJF8SRfLRiRImiId98yLUwf4ACq4UfHXrlTM=;
        b=Ep+eRWJyXssOITUA3LT57x5CP/a77KNcLAJHgr0Q6fwjN1geFQAw9Em4rJ/ZSGSro/zEyX
        ODtkLjqPkhsSTnOCkdZ/jaeBQ9UAGfpHQ29xDDSzJ6TzlxkMyBwM8wRdUjyDNOUnUMlzDX
        BD/agJb5N1ri8C/7UhbKa4792xmrGcw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-448-nA3M0pSZOp6RRNd-FabZnw-1; Fri, 15 Apr 2022 12:38:48 -0400
X-MC-Unique: nA3M0pSZOp6RRNd-FabZnw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3CA6C811E7A;
        Fri, 15 Apr 2022 16:38:48 +0000 (UTC)
Received: from ceranb (unknown [10.40.194.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D74A2167D68;
        Fri, 15 Apr 2022 16:38:46 +0000 (UTC)
Date:   Fri, 15 Apr 2022 18:38:45 +0200
From:   Ivan Vecera <ivecera@redhat.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     netdev@vger.kernel.org, Fei Liu <feliu@redhat.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>, mschmidt@redhat.com,
        Brett Creeley <brett.creeley@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [Intel-wired-lan] [PATCH net] ice: Protect vf_state check by
 cfg_lock in ice_vc_process_vf_msg()
Message-ID: <20220415183845.51a326fe@ceranb>
In-Reply-To: <YlldFriBVkKEgbBs@boxer>
References: <20220413072259.3189386-1-ivecera@redhat.com>
        <YlldFriBVkKEgbBs@boxer>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Apr 2022 13:55:02 +0200
Maciej Fijalkowski <maciej.fijalkowski@intel.com> wrote:

> On Wed, Apr 13, 2022 at 09:22:59AM +0200, Ivan Vecera wrote:
> > Previous patch labelled "ice: Fix incorrect locking in
> > ice_vc_process_vf_msg()"  fixed an issue with ignored messages  
> 
> tiny tiny nit: double space after "
> Also, has mentioned patch landed onto some tree so that we could provide
> SHA-1 of it? If not, then maybe squashing this one with the mentioned one
> would make sense?

Well, that commit were already tested and now it is present in Tony's queue
but not in upstream yet. It is not problem to squash together but the first
was about ignored VF messages and this one is about race and I didn't want
to make single patch with huge description that cover both issues.
But as I said, no problem to squash if needed.

Thx,
Ivan

