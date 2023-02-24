Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E50F6A2367
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 22:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjBXVGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 16:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjBXVGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 16:06:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CF56C538;
        Fri, 24 Feb 2023 13:06:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF823B81D2A;
        Fri, 24 Feb 2023 21:06:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B2EC4339C;
        Fri, 24 Feb 2023 21:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677272786;
        bh=+Jo7tem20kbL9MEuxv2XDKdpiPYIHZld4uEyU5MutBU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BWYlXg79roUMMH22AHU9zsFvjcx9XnACoQFK8qvS/yvWlVdm7agCEufiCkNGFKBws
         2BFcmTpDluG93E/QRUI2cdPC85Vv1zhRGjPjjvarh8NTFjNNlsdMX7pobsBhy6LvxI
         +Dyr3l1LluJn1PaUUcQT8yzkMm8U/HWhVM52AQJuBqC9TP5EhrfmOO/rQhx7Pg7h9D
         lBCZnccevHCFsLHDK8qRfrSDj96j+egdkzYvKsZ4bgvr6PdcCxZSqNlI5nG16EoHgm
         SimuwZQ44CsnQBpC+5wRO3sHI8risRRL3NBYtGoAFoL4Uql8zo8TATB7Vuj3Fhka8I
         uJOCdD/rdTQTw==
Date:   Fri, 24 Feb 2023 13:06:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     Hangyu Hua <hbh25y@gmail.com>, Florian Westphal <fw@strlen.de>,
        borisp@nvidia.com, john.fastabend@gmail.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, davejwatson@fb.com,
        aviadye@mellanox.com, ilyal@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tls: fix possible race condition between
 do_tls_getsockopt_conf() and do_tls_setsockopt_conf()
Message-ID: <20230224130625.6b5261b4@kernel.org>
In-Reply-To: <Y/kck0/+NB+Akpoy@hog>
References: <20230224105811.27467-1-hbh25y@gmail.com>
        <20230224120606.GI26596@breakpoint.cc>
        <20230224105508.4892901f@kernel.org>
        <Y/kck0/+NB+Akpoy@hog>
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

On Fri, 24 Feb 2023 21:22:43 +0100 Sabrina Dubroca wrote:
> > Right, the bug and the fix seem completely bogus.
> > Please make sure the bugs are real and the fixes you sent actually 
> > fix them.  
> 
> I suggested a change of locking in do_tls_getsockopt_conf this
> morning [1]. The issue reported last seemed valid, but this patch is not
> at all what I had in mind.
> [1] https://lore.kernel.org/all/Y/ht6gQL+u6fj3dG@hog/

Ack, I read the messages out of order, sorry.

> do_tls_setsockopt_conf fills crypto_info immediately from what
> userspace gives us (and clears it on exit in case of failure), which
> getsockopt could see since it's not locking the socket when it checks
> TLS_CRYPTO_INFO_READY. So getsockopt would progress up to the point it
> finally locks the socket, but if setsockopt failed, we could have
> cleared TLS_CRYPTO_INFO_READY and freed iv/rec_seq.

Makes sense. We should just take the socket lock around all of
do_tls_getsockopt(), then? 
