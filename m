Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD93B6637DE
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 04:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjAJDhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 22:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233142AbjAJDhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 22:37:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724AF3FCAA
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 19:37:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AB62614C1
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 03:37:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8F3C433D2;
        Tue, 10 Jan 2023 03:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673321843;
        bh=Wap8nJ3jU4HxaHnOzobAnnF7+6aFxOCrwWnQTBSRVuA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QWkB0Pi9o+tJcv8McChWEQHQ/Ri68q+FV9/PO/MmUiYEKUWlG1wfXlxhHgL8DnBnI
         ATPqtzvqXOiUvIJN7Na8uPHO3zNAusUJNDjTHVHVVxElGTiqY9nS79hp8qqgQkpOW6
         FaJMMdnCox5cKZELp7TSV/z30qnX8Ev4iouVASl6q6se9oDqWS5CPdRDVkonNmQfYA
         eQhzRlZNwk2Rp/Gy1EYZKR8jO9ColHwIuHmYodr+TuKUpZd+rah5gQq5izswcOZ8fu
         h/v+zyn1E0+V9wCwEHwbVh5Ji4m7xvY4qQU7FBKS0OgJguPs5Et3TFJXwlV+AVKPUf
         nGMEFCczr9aOQ==
Date:   Mon, 9 Jan 2023 19:37:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Alexander H Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        sujuan.chen@mediatek.com, daniel@makrotopia.org
Subject: Re: [PATCH net-next] net: ethernet: mtk_wed: get rid of queue lock
 for rx queue
Message-ID: <20230109193721.7d05d24b@kernel.org>
In-Reply-To: <be4814483f1b320eaaa49ba8d59d81b2a51f932b.camel@gmail.com>
References: <bff65ff7f9a269b8a066cae0095b798ad5b37065.1673102426.git.lorenzo@kernel.org>
        <be4814483f1b320eaaa49ba8d59d81b2a51f932b.camel@gmail.com>
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

On Mon, 09 Jan 2023 16:50:55 -0800 Alexander H Duyck wrote:
> On Sat, 2023-01-07 at 15:41 +0100, Lorenzo Bianconi wrote:
> > mtk_wed_wo_queue_rx_clean and mtk_wed_wo_queue_refill routines can't run
> > concurrently so get rid of spinlock for rx queues.

You say "for rx queues" but mtk_wed_wo_queue_refill() is also called
for tx queues.

> My understanding is that mtk_wed_wo_queue_refill will only be called
> during init and by the tasklet. The mtk_wed_wo_queue_rx_clean function
> is only called during deinit and only after the tasklet has been
> disabled. That is the reason they cannot run at the same time correct?
> 
> It would be nice if you explained why they couldn't run concurrently
> rather than just stating it is so in the patch description. It makes it
> easier to verify assumptions that way. Otherwise the patch itself looks
> good to me.

Agreed, please respin with a better commit message.
