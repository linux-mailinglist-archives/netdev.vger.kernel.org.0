Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48B8D5186B1
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 16:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237069AbiECOdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 10:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234523AbiECOdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 10:33:35 -0400
X-Greylist: delayed 353 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 03 May 2022 07:30:03 PDT
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4F931513;
        Tue,  3 May 2022 07:30:03 -0700 (PDT)
Received: from quatroqueijos (unknown [179.93.188.62])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 8E4D43F615;
        Tue,  3 May 2022 14:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1651587848;
        bh=urSSftn1EDj1knk1ElcHxdDohl86j8X4oe+aGlRIn7k=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=JSAFGChvVRJlWhFtOmDSUzU5iPEg9jxJVJ3EoTxrT7uemarA2MVaPJppywZa9+vRx
         laRmYY3qofSKi55S/K3TVGlVie7O9aYMeRQcrmf3iuF6uodAnVA4Nhg+Y7+YO3+Vwz
         zjvtVRIZyrdlji3rh+drhei3GDDrj3GmUyrR/5s9IW2dsKKg59uZmnA14+4j0iHGhC
         kxqRZsAyPsVNJn1ZoM0yOe9d9vJVT9Iz5flbS6VcwbCKvWU7jaWJD5/8Rx6ATe4hRz
         D9PTohYTT/WS4WQnAuEzn4rD+AyhkaS8ACslsqNaBFq2YzIdB71BGBtHkFohBXcjC7
         y77rJJ2wHuF0g==
Date:   Tue, 3 May 2022 11:24:01 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        davem@davemloft.net, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, vladbu@mellanox.com
Subject: Re: [PATCH 4.9.y] net: sched: prevent UAF on tc_ctl_tfilter when
 temporarily dropping rtnl_lock
Message-ID: <YnE7AbD1eYTBBVeE@quatroqueijos>
References: <20220502204924.3456590-1-cascardo@canonical.com>
 <YnEy2726cz98I6YC@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnEy2726cz98I6YC@kroah.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 03, 2022 at 03:49:15PM +0200, Greg KH wrote:
> On Mon, May 02, 2022 at 05:49:24PM -0300, Thadeu Lima de Souza Cascardo wrote:
> > When dropping the rtnl_lock for looking up for a module, the device may be
> > removed, releasing the qdisc and class memory. Right after trying to load
> > the module, cl_ops->put is called, leading to a potential use-after-free.
> > 
> > Though commit e368fdb61d8e ("net: sched: use Qdisc rcu API instead of
> > relying on rtnl lock") fixes this, it involves a lot of refactoring of the
> > net/sched/ code, complicating its backport.
> 
> What about 4.14.y?  We can not take a commit for 4.9.y with it also
> being broken in 4.14.y, and yet fixed in 4.19.y, right?  Anyone who
> updates from 4.9 to 4.14 will have a regression.
> 
> thanks,
> 
> greg k-h

4.14.y does not call cl_ops->put (the get/put and class refcount has been done
with on 4.14.y). However, on the error path after the lock has been dropped,
tcf_chain_put is called. But it does not touch the qdisc, but only the chain
and block objects, which cannot be released on a race condition, as far as I
was able to investigate.

Cascardo.
