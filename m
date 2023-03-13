Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03ABE6B83FC
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 22:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjCMVbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 17:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjCMVa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 17:30:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A23DBCB;
        Mon, 13 Mar 2023 14:30:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52B29B8136B;
        Mon, 13 Mar 2023 21:30:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 968C2C433EF;
        Mon, 13 Mar 2023 21:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678743056;
        bh=R+WwqoKh0zISD9Xarl/rtQ2nfnBou/E1Hvs+a5wGQK8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ek1s+QMFPSxstNjHuSAf7o9BoIcjKgs5XDMvqzEzyL0xU12gtqkUh3qcKt0k/alG8
         ZRyttzce25fyEKBTbtxN9wWweFxLRVZl+VaPRF4QjkURQthDTBOZidy0sly29/tWWw
         zcR1ZSQLJFGtS0EDx1YebEXzP9FGAuu34zX0QlEPnCsSGNTtQHQttEA0awmF8X9sc9
         78Pe/+HLEx/7hQDm9Q7rYHJERcC8Y2jpX5kXOIwQtapoz1tTVADyaDPMZqIQaHLXpo
         fdxPP3EJndSemVi7QoqKN2yyVL4qUFt4eKz1C2GP2wmetfkLSPCe3ws1G0u+656llD
         yh3kT9QC7bAnw==
Date:   Mon, 13 Mar 2023 14:30:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Cc:     Zheng Wang <zyytlz.wz@163.com>, ericvh@gmail.com, lucho@ionkov.net,
        asmadeus@codewreck.org, linux_oss@crudebyte.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hackerzheng666@gmail.com,
        1395428693sheep@gmail.com, alex000young@gmail.com
Subject: Re: [PATCH net v2] 9p/xen : Fix use after free bug in
 xen_9pfs_front_remove due  to race condition
Message-ID: <20230313143054.538565ac@kernel.org>
In-Reply-To: <ZA8rDCw+mJmyETEx@localhost.localdomain>
References: <20230313090002.3308025-1-zyytlz.wz@163.com>
        <ZA8rDCw+mJmyETEx@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Mar 2023 14:54:20 +0100 Michal Swiatkowski wrote:
> > @@ -274,12 +274,17 @@ static const struct xenbus_device_id xen_9pfs_front_ids[] = {
> >  static void xen_9pfs_front_free(struct xen_9pfs_front_priv *priv)
> >  {
> >  	int i, j;
> > +	struct xen_9pfs_dataring *ring = NULL;  
> Move it before int i, j to have RCT.
> 
> >  
> >  	write_lock(&xen_9pfs_lock);
> >  	list_del(&priv->list);
> >  	write_unlock(&xen_9pfs_lock);
> >  
> >  	for (i = 0; i < priv->num_rings; i++) {
> > +		/*cancel work*/  
> It isn't needed I think, the function cancel_work_sync() tells everything
> here.

Note that 9p is more storage than networking, so this patch is likely
to go via a different tree than us.
