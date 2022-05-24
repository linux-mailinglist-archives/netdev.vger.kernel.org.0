Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5311B533011
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 20:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238907AbiEXSHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 14:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231981AbiEXSHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 14:07:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9F96B02B
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 11:07:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2ECFBB817F2
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 18:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83789C34100;
        Tue, 24 May 2022 18:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653415670;
        bh=YdEjgNVDgYBoOZuP0zIDynaz5o0ZUYs3rTziBLSWR2Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NOXdqloorY2eZKXwEYRDR/8Nzg3YeNNar6+Ajblqwbx8/VSgqH8qkSz93pPcqyKi2
         AAV/aeyM/6LEBeGujXkmOCkJV1yNuy+X4dpPCnAAdAqlocL5hh3Cl6mFSUMgptZSBV
         LPpeSAfCww/vr+pSdjmKYx84q516HkDDt0bBqWu8hMghJJD6PlvgP4i6Yr9Sie7+Li
         bWktnpQKpb6tBUDPJoOGMOR7W/8vzIFI2nstjuXaJDoou6UvFJpfrRs4jajDiHB5O/
         vynAZ9D2bPrt1da+4YIGQVXKhL3N3ky9k8Pnj4TcX9CxSRUQx3ViDBim5IMxkhoUSK
         IN4BXVf5mjqjw==
Date:   Tue, 24 May 2022 11:07:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Yuwei Wang <wangyuweihx@gmail.com>, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>, roopa@nvidia.com,
        dsahern@kernel.org, =?UTF-8?B?56em6L+q?= <qindi@staff.weibo.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] net, neigh: introduce interval_probe_time
 for periodic probe
Message-ID: <20220524110749.6c29464b@kernel.org>
In-Reply-To: <797c3c53-ce1b-9f60-e253-cda615788f4a@iogearbox.net>
References: <20220522031739.87399-1-wangyuweihx@gmail.com>
        <b5cf7fac361752d925f663d9a9b0b8415084f7d3.camel@redhat.com>
        <CANmJ_FP0CxSVksjvNsNjpQO8w+S3_10byQSCpt1ifQ6HeURUmA@mail.gmail.com>
        <cf3188eba7e529e4f112f6a752158f38e22f4851.camel@redhat.com>
        <797c3c53-ce1b-9f60-e253-cda615788f4a@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 May 2022 17:32:57 +0200 Daniel Borkmann wrote:
> Right, maybe we could just split this into two: 1) prevent misconfig (see
> below), and 2) make the timeout configurable as what Yuwei has. Wdyt?
> 
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 47b6c1f0fdbb..54625287ee5b 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -1579,7 +1579,7 @@ static void neigh_managed_work(struct work_struct *work)
>          list_for_each_entry(neigh, &tbl->managed_list, managed_list)
>                  neigh_event_send_probe(neigh, NULL, false);
>          queue_delayed_work(system_power_efficient_wq, &tbl->managed_work,
> -                          NEIGH_VAR(&tbl->parms, DELAY_PROBE_TIME));
> +                          max(NEIGH_VAR(&tbl->parms, DELAY_PROBE_TIME), HZ));
>          write_unlock_bh(&tbl->lock);
>   }

FWIW that was my reaction as well. Let's do that unless someone
disagrees.
