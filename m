Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB48D6E8026
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 19:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbjDSRMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 13:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjDSRMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 13:12:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7655B3580;
        Wed, 19 Apr 2023 10:12:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E3356409A;
        Wed, 19 Apr 2023 17:12:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE377C433EF;
        Wed, 19 Apr 2023 17:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681924364;
        bh=1Oa2QE6ih7rB23hE5gjm+d/eHjyLoOs35oR0Oh4fIZM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u9z+Z36cl6kVNymoTyEYj73e/3f4rW9yObh42jTy22wR+IRsaRQpGx9uGmbSLqOMY
         xf18YOVeI52Wtoldfss0Z8Lokibkq/8a2PQX6wh9+9obtniMimvB2yPM/NbMMYym6i
         CGRtNpTTmAhiW976hvVUCuTfSNZkM6u79dhQEyxOvYwrMHgU57xvkjmWS0PZjzOv45
         BIsj+41ckWp3tAN798JKrgtN0bZ13gNynQzJ+zg4sUpxqnhUfiMTRZb3fuV4nlpm/m
         WiJesMoV2AIYMPwHuRxnO1wmflF1ep1DjM5TleLutGPkcDG1upAd5wFzISlwpdn4Kr
         WeAnv4WX+yHsQ==
Date:   Wed, 19 Apr 2023 10:12:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, brouer@redhat.com,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        hawk@kernel.org, ilias.apalodimas@linaro.org, davem@davemloft.net,
        pabeni@redhat.com, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, nbd@nbd.name,
        Toke Hoiland Jorgensen <toke@redhat.com>
Subject: Re: issue with inflight pages from page_pool
Message-ID: <20230419101242.44f2d143@kernel.org>
In-Reply-To: <e8df2654-6a5b-3c92-489d-2fe5e444135f@redhat.com>
References: <ZD2NSSYFzNeN68NO@lore-desk>
        <20230417112346.546dbe57@kernel.org>
        <ZD2TH4PsmSNayhfs@lore-desk>
        <20230417120837.6f1e0ef6@kernel.org>
        <ZD26lb2qdsdX16qa@lore-desk>
        <20230417163210.2433ae40@kernel.org>
        <ZD5IcgN5s9lCqIgl@lore-desk>
        <3449df3e-1133-3971-06bb-62dd0357de40@redhat.com>
        <CANn89iKAVERmJjTyscwjRTjTeWBUgA9COz+8HVH09Q0ehHL9Gw@mail.gmail.com>
        <ea762132-a6ff-379a-2cc2-6057754425f7@redhat.com>
        <ZD/4/npAIvS1Co6e@lore-desk>
        <e8df2654-6a5b-3c92-489d-2fe5e444135f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Apr 2023 17:36:20 +0200 Jesper Dangaard Brouer wrote:
> This reminds me that Jakub's recent defer patches returning pages
> 'directly' to the page_pool alloc-cache, will actually result in this
> kind of bug.  This is because page_pool_destroy() assumes that pages
> cannot be returned to alloc-cache, as driver will have "disconnected" RX
> side.  We need to address this bug separately. 

Mm, I think you're right. The NAPI can get restarted with a different
page pool and the old page pool will still think it's in use.
