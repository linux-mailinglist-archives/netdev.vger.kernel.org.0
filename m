Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5E469F278
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 11:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbjBVKHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 05:07:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbjBVKHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 05:07:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2E226CE1;
        Wed, 22 Feb 2023 02:07:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E927161312;
        Wed, 22 Feb 2023 10:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39269C433EF;
        Wed, 22 Feb 2023 10:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677060453;
        bh=UQvctXk/GLWwF1i1WLEHlMRX57m9FXDXBJWODixJVXM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=LStlCqseFqHzo7ep3cx14uhZ6oJcIRoj9O15AUv5oqgnmERcIb7n+QtI0tloQntU/
         PVyUhvJXT3mJ9sOOV5ZeS467VW020RjWHspw/PzksWb5fft749RM06t6FOiNll27Ww
         mioIw5BVSh3ZdFimuVgJ6xNp/trBja+olvIEVz42kYOeezDBZ1t68D/NMJColEpJPM
         wtS5149nGSybPRxbvkfRxUNCy/mF3C04BVp2a9iWkPOfFHN7oABGjxtoLKspHZgY4l
         7KSmF4gieBCBTqRj1yVfYb1lZqYhE9at+aKzczj2T8mKRsUVFkKMUnBrTts/5Wnbcr
         wNZ4X/2zRdpzA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH] wifi: ath11k: fix SAC bug on peer addition with sta band migration
References: <20230209222622.1751-1-ansuelsmth@gmail.com>
        <167688346963.21606.5485334408823363188.kvalo@kernel.org>
        <63f3c697.5d0a0220.8f9f5.c859@mx.google.com>
Date:   Wed, 22 Feb 2023 12:07:29 +0200
In-Reply-To: <63f3c697.5d0a0220.8f9f5.c859@mx.google.com> (Christian Marangi's
        message of "Mon, 20 Feb 2023 14:51:05 +0100")
Message-ID: <874jret3mm.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Marangi <ansuelsmth@gmail.com> writes:

> On Mon, Feb 20, 2023 at 08:57:51AM +0000, Kalle Valo wrote:
>> Christian Marangi <ansuelsmth@gmail.com> wrote:
>> 
>> > Fix sleep in atomic context warning detected by Smatch static checker
>> > analyzer.
>> > 
>> > Following the locking pattern for peer_rhash_add lock tbl_mtx_lock mutex
>> > always even if sta is not transitioning to another band.
>> > This is peer_add function and a more secure locking should not cause
>> > performance regression.
>> > 
>> > Fixes: d673cb6fe6c0 ("wifi: ath11k: fix peer addition/deletion
>> > error on sta band migration")
>> > Reported-by: Dan Carpenter <error27@gmail.com>
>> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
>> > Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
>> 
>> I assume you only compile tested this and I'll add that to the commit log. It's
>> always good to know how the patch was tested.
>> 
>
> Hi, I just got time to test this and works correctly on my Xiaomi
> AX3600.
>
> Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.5.0.1-01208-QCAHKSWPL_SILICONZ-1

Thanks, I'll add this to the commit log.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
