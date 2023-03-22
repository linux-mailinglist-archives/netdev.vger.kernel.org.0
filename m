Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE016C551B
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 20:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjCVTnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 15:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbjCVTnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 15:43:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF8B6A60;
        Wed, 22 Mar 2023 12:43:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07EB4622AC;
        Wed, 22 Mar 2023 19:43:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA44C433EF;
        Wed, 22 Mar 2023 19:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679514197;
        bh=0eJ2wDPpolg0zMqmBJUTxiE/iCB4f1LEy3GHs5WagXA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XTA7LVqUnLiV1V0ZjkTJHyeM0+HmxziRcvpmW294zoiErgPkcFpbwAmMwEmSEc+6Y
         +yUoLdBiZUOiCJwr5qzT4lSwL+HEPYS9XbZjhHaORsfpouXEWfKloUz6q0xO1Xx9Qp
         dh5o54W9Dy3Slm50HKKtHaZRGHt0hK2am+bnFssu0EpM4cdmNqQVVwv/6A8ajkTpE8
         FXq6pQgsIN6Pnxrl3QaAQrpmS5vRmKFcDT7mGj13A6MI3H1El9AJ8BZ1AhcvqORS0m
         HpsjvxBN4q8oKQDpTBwGmW3MxHmkorTG0fjAA+Vztu+7Y8YWK/p7nWY0sIDZeQDSCd
         ZX5D9aD3dFImg==
Date:   Wed, 22 Mar 2023 12:43:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vfedorenko@novek.ru>,
        Frantisek Krenzelok <fkrenzel@redhat.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Apoorv Kothari <apoorvko@amazon.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Gal Pressman <gal@nvidia.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH net-next v2 0/5] tls: implement key updates for TLS1.3
Message-ID: <20230322124316.7a174e3d@kernel.org>
In-Reply-To: <ZBsocdkUBlEuAU+I@hog>
References: <Y+0Wjrc9shLkH+Gg@hog>
        <20230215111020.0c843384@kernel.org>
        <Y+1pX/vL8t2nU00c@hog>
        <20230215195748.23a6da87@kernel.org>
        <Y+5Yd/8tjCQNOF31@hog>
        <20230221191944.4d162ec7@kernel.org>
        <Y/eT/M+b6jUtTdng@hog>
        <20230223092945.435b10ea@kernel.org>
        <ZA9EMJgoNsxfOhwV@hog>
        <20230313113510.02c107b3@kernel.org>
        <ZBsocdkUBlEuAU+I@hog>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Mar 2023 17:10:25 +0100 Sabrina Dubroca wrote:
> > Theoretically a rekey op is nicer and cleaner. Practically the quality
> > of the driver implementations will vary wildly*, and it's a significant
> > time investment to review all of them. So for non-technical reasons my
> > intuition is that we'd deliver a better overall user experience if we
> > handled the rekey entirely in the core.
> > 
> > Wait for old key to no longer be needed, _del + _add, start using the
> > offload again.
> > 
> > * One vendor submitted a driver claiming support for TLS 1.3, when 
> >   TLS 1.3 offload was rejected by the core. So this is the level of
> >   testing and diligence we're working with :(  
> 
> :(
> 
> Ok, _del + _add then.
> 
> 
> I went over the thread to summarize what we've come up with so far:
> 
> RX
>  - The existing SW path will handle all records between the KeyUpdate
>    message signaling the change of key and the new key becoming known
>    to the kernel -- those will be queued encrypted, and decrypted in
>    SW as they are read by userspace (once the key is provided, ie same
>    as this patchset)
>  - Call ->tls_dev_del + ->tls_dev_add immediately during
>    setsockopt(TLS_RX)
> 
> TX
>  - After setsockopt(TLS_TX), switch to the existing SW path (not the
>    current device_fallback) until we're able to re-enable HW offload
>    - tls_device_{sendmsg,sendpage} will call into
>      tls_sw_{sendmsg,sendpage} under lock_sock to avoid changing
>      socket ops during the rekey while another thread might be waiting
>      on the lock
>  - We only re-enable HW offload (call ->tls_dev_add to install the new
>    key in HW) once all records sent with the old key have been
>    ACKed. At this point, all unacked records are SW-encrypted with the
>    new key, and the old key is unused by both HW and retransmissions.
>    - If there are no unacked records when userspace does
>      setsockopt(TLS_TX), we can (try to) install the new key in HW
>      immediately.
>    - If yet another key has been provided via setsockopt(TLS_TX), we
>      don't install intermediate keys, only the latest.
>    - TCP notifies ktls of ACKs via the icsk_clean_acked callback. In
>      case of a rekey, tls_icsk_clean_acked will record when all data
>      sent with the most recent past key has been sent. The next call
>      to sendmsg/sendpage will install the new key in HW.
>    - We close and push the current SW record before reenabling
>      offload.
> 
> If ->tls_dev_add fails to install the new key in HW, we stay in SW
> mode. We can add a counter to keep track of this.

SG!

> In addition:
> 
> Because we can't change socket ops during a rekey, we'll also have to
> modify do_tls_setsockopt_conf to check ctx->tx_conf and only call
> either tls_set_device_offload or tls_set_sw_offload. RX already uses
> the same ops for both TLS_HW and TLS_SW, so we could switch between HW
> and SW mode on rekey.
> 
> An alternative would be to have a common sendmsg/sendpage which locks
> the socket and then calls the correct implementation. We'll need that
> anyway for the offload under rekey case, so that would only add a test
> to the SW path's ops (compared to the current code). That should allow
> us to make build_protos a lot simpler.

No preference assuming perf is the same.
