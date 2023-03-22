Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D21486C414B
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 04:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbjCVDu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 23:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbjCVDuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 23:50:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7511B3801D
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 20:50:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24883B81AF7
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 03:50:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901A8C433D2;
        Wed, 22 Mar 2023 03:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679457051;
        bh=qkOsoJaPO7eEDZci9Y2nibWq4AMhrvmo/8A18AQO7xg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VP+uzaSKsY4FJ7eGUw4dBSyHvXlh6H6UpzMKSDvm0NYL6xQs/cBus3VOGGDrmLDra
         T31cgGqWTI+FhmvA29Ba31nxtjHMxQC6TwQTqWQT84ux5HamwJr/omATZAzkuRzW9O
         5LyLVMPCbFpulktzZe99YBR75WAMI5AcCUsqabiVmIwb9xIqIY2972f44sRpUCofwK
         7LGz1u5Wskr4O9q/a7a62BLS9gzTmMXNp68EzZVS2mRLzge9yrcA3lv0eVx9GF+vrJ
         Qdh8fIlqLbiLnYJaa8mtYNj2RkqAYmL8H8yCQkGyveiiA51FrnfffwzUc7XCz/+vNG
         5crDEqcdmZBWw==
Date:   Tue, 21 Mar 2023 20:50:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Eli Cohen <elic@nvidia.com>
Subject: Re: [net-next 02/14] lib: cpu_rmap: Use allocator for rmap entries
Message-ID: <20230321205050.763deee8@kernel.org>
In-Reply-To: <20230321204028.20e5a27e@kernel.org>
References: <20230320175144.153187-1-saeed@kernel.org>
        <20230320175144.153187-3-saeed@kernel.org>
        <20230321204028.20e5a27e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Mar 2023 20:40:28 -0700 Jakub Kicinski wrote:
> > @@ -295,7 +307,11 @@ int irq_cpu_rmap_add(struct cpu_rmap *rmap, int irq)
> >  	glue->notify.release = irq_cpu_rmap_release;
> >  	glue->rmap = rmap;
> >  	cpu_rmap_get(rmap);
> > -	glue->index = cpu_rmap_add(rmap, glue);
> > +	rc = cpu_rmap_add(rmap, glue);
> > +	if (rc == -1)
> > +		return -ENOSPC;  
> 
> which you then have to convert into an errno ?
> 
> Also you leak glue here.

.. and the reference on rmap.
