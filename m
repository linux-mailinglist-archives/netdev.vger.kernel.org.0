Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9FF624BDB
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 21:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbiKJUdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 15:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbiKJUc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 15:32:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1396E1D330;
        Thu, 10 Nov 2022 12:32:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6E7061E38;
        Thu, 10 Nov 2022 20:32:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A02C433D6;
        Thu, 10 Nov 2022 20:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668112371;
        bh=FAwxMVXEMCAcS5uby63ed6orJtZrfmYhYcYpN6PuPrI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iXAbIe8qFQnagQ5siMYMEYtmnyY7pKqQkhT1164Uv1Nxs5YcfFkTzJtE7Pz3hF20o
         Fz/CFvkcfS97k+YvDTASeXPu9d4slw3UM09GEkXxEDnHRUmYlxUkzKDYATtImU8vmz
         vZuKVDaz+L5U+effJeDL5j/KyfvsbKTq3+hVY3rfTCeu/a2bzIkvTOKtn+IndjKy18
         a7klHzIGJ+1p39ZYBgPCS7dypgYE98nUFPIWBylSZulwWi9rfLyp4rdU1ZKuNd+QsV
         CuiS4NsdstMxXQMhU/RqWvTeae1jBz8hIqiuBdfFoha0sIT77vmW8z9G5ENnOFM/Pm
         k6oTzr5iCcrlA==
Date:   Thu, 10 Nov 2022 12:32:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Roger Quadros <rogerq@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ido Schimmel <idosch@idosch.org>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        vigneshr@ti.com, srk@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: ti: cpsw_ale: optimize
 cpsw_ale_restore()
Message-ID: <20221110123249.5f0e19df@kernel.org>
In-Reply-To: <32eacc9d-3866-149a-579a-41f8e405123f@kernel.org>
References: <20221108135643.15094-1-rogerq@kernel.org>
        <20221109191941.6af4f71d@kernel.org>
        <32eacc9d-3866-149a-579a-41f8e405123f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Nov 2022 11:39:47 +0200 Roger Quadros wrote:
> > Maybe my tree is old but I see we clear only if there is a netdev that  
> 
> This patch depends on this series
> https://lore.kernel.org/netdev/20221104132310.31577-3-rogerq@kernel.org/T/

I do have those in my tree.

> > needs to be opened but then always call ale_restore(). Is that okay?  
> 
> If netdev is closed and opened ale_restore() is not called.
> ale_restore() is only called during system suspend/resume path
> since CPSW-ALE might have lost context during suspend and we want to restore
> all valid ALE entries.

Ack, what I'm referring to is the contents of am65_cpsw_nuss_resume().

I'm guessing that ALE_CLEAR is expected to be triggered by
cpsw_ale_start().

Assuming above is true and that ALE_CLEAR comes from cpsw_ale_start(),
the call stack is:

 cpsw_ale_start()
 am65_cpsw_nuss_common_open()
 am65_cpsw_nuss_ndo_slave_open()
 am65_cpsw_nuss_resume()

but resume() only calls ndo_slave_open under certain conditions:

        for (i = 0; i < common->port_num; i++) {                                  
                if (netif_running(ndev)) {                                      
                        rtnl_lock();                                            
                        ret = am65_cpsw_nuss_ndo_slave_open(ndev);    

Is there another path? Or perhaps there's nothing to restore 
if all netdevs are down?

> I have a question here. How should ageable entries be treated in this case?

Ah, no idea :) Let's me add experts to To:
