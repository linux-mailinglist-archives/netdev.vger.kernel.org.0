Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 601F067BC9C
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 21:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235840AbjAYUdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 15:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235400AbjAYUdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 15:33:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA1654219
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 12:33:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2403D61610
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 20:33:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D883C4339B;
        Wed, 25 Jan 2023 20:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674678827;
        bh=4Pz9oqJnsXyX3bXmJJaE28NO6FQwa1m7Pnb9b59nUKU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qiJVzKBvfPqEsm9ASoVY+Fqiw6e1iVoA9W3NJHJNsYq9zcG8w0bzUp3KuY/QeLE+t
         Tjek5re6aNbar+mGE5v8mrI04x+7+/uxyVNjQY9Qp2rLEp80d0BZxgebaPR1nWYt7R
         fYnggZ2nyRrYuaYCOiMbYfKdBx+/KVkEgol1wUpefQoKuIZvhuEvOtRphZYnoZnfDN
         rOjyh1g04hsFo1ygVrit+cKmdZX2ndkUl2erKbOdrrPf5upvChtNBXdVIm7bCD2iwk
         IVnXrEWwEmPsbCgwuZbf/llVFy7cNPuIUcM9IK/SykFztr74mtUqjqxgMPcZZaOvlL
         hToLx1tj5WmcQ==
Date:   Wed, 25 Jan 2023 12:33:46 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Gal Pressman <gal@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net 1/2] mlx5: fix possible ptp queue fifo overflow
Message-ID: <Y9GSKrk95A4/Xo68@x130>
References: <20230122161602.1958577-1-vadfed@meta.com>
 <20230122161602.1958577-2-vadfed@meta.com>
 <c73fe66a-2d9a-d675-79bc-09d7f63caa53@meta.com>
 <46b57864-5a1a-7707-442c-b53e14d3a6b8@nvidia.com>
 <45d08ca1-e156-c482-777d-df2bc48dffed@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <45d08ca1-e156-c482-777d-df2bc48dffed@meta.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25 Jan 14:42, Vadim Fedorenko wrote:
>On 24/01/2023 14:39, Gal Pressman wrote:
>> Anyway, I'd like to zoom out for a second, the whole fifo was designed
>> under the assumption that completions are in-order (this is a guarantee
>> for all SQs, not just ptp ones!), this fix seems more of a bandage that
>> potentially hides a more severe issue.
>>
>>>
>>> It really shows that CQE are coming OOO sometimes.
>>
>> Can we reproduce it somehow?
>> Can you please try to update your firmware version? I'm quite confident
>> that this issue is fixed already.
>>

Hi Vadim, 

As Gal pointed out above,
we shouldn't be seeing OOO on TX data path, otherwise, what's the point
of the fifo ? Also you can't have a proper reseliency since it seems when
this OOO happen the skb_cc, which is derived from the we_counter seems to
fall out of range which makes me think it can be a completely random
value, so we can't really be protected from all OOO scenarios.

This is clearly a FW bug and we will get to the bottom of
this internally, Can you please create a bug request ?

For the SKB leak, I will take the 2nd patch as is and improve it as
necessary if that's ok with you.

Thanks,
Saeed.


