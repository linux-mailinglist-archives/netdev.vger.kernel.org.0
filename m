Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02BB66A62D9
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 23:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjB1Wvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 17:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjB1Wvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 17:51:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B49FB367E4;
        Tue, 28 Feb 2023 14:51:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24B50B80EBF;
        Tue, 28 Feb 2023 22:51:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2E9C433EF;
        Tue, 28 Feb 2023 22:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677624693;
        bh=Xzz4r0PQ/hM3RDGj9gnYQd2OmfFnt1L/ZVhwnGD50Fk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BYdKkkdTf1HGxTZGj89HCgzupY0c1U5cLYF+W2rnQ6RBbNWUqJYd7wWu4TbcX8kxe
         q0XSn1fAAbf3T5j2RIk7txi7LRWROASL0kGF6iYoTLtWvKY/ndD0bMGBUuxk/b17+Z
         YCF4RjJo8XXjsCujVznbquVGEV+EHmSngP8+guszOhdBm/02tlmvgGCoa26ViWQvIF
         3DWuGyEnMOzsVMX5dFP69HD1VKOOj9s5Gx3shiUng2Jecg6UMjduK1kC607O1/NQn7
         cZj0Ja4jabYdgBYUKcTp+vVn2hUlemIYqEI5w9eMqqApCUzde025mkc3k9KNI7t+u7
         ql0ePuiRCsn/w==
Date:   Tue, 28 Feb 2023 14:51:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     syzbot <syzbot+9c0268252b8ef967c62e@syzkaller.appspotmail.com>,
        borisp@nvidia.com, bpf@vger.kernel.org, davem@davemloft.net,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [net?] INFO: task hung in tls_sw_sendpage (3)
Message-ID: <20230228145132.6d09453f@kernel.org>
In-Reply-To: <CANn89i+ooMT_G9aL8keZ-WOcAKqpC44OLQNGvfUtjA6PW-yxcA@mail.gmail.com>
References: <000000000000e412e905f5b46201@google.com>
        <CANn89iJ_kLaF0tVVUfzKQwVkQ0VtCca1dL8eF+RrXCVDTK6h2Q@mail.gmail.com>
        <20230227155352.3399bb10@kernel.org>
        <CANn89i+ooMT_G9aL8keZ-WOcAKqpC44OLQNGvfUtjA6PW-yxcA@mail.gmail.com>
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

On Tue, 28 Feb 2023 12:23:46 +0100 Eric Dumazet wrote:
> This report mentions sendpage, but sendmsg() would have the same issue.
> 
> A thread might be blocked in sk_stream_wait_memory() with the mutex
> held, for an arbitrary amount of time,
> say if the remote peer stays in RWIN 0 for hours.
> 
> This prevents tx_work from making progress, and
> tls_sw_cancel_work_tx() would be stuck forever.
> 
> The consensus is that the kernel shouts a warning if a thread has been
> waiting on a mutex
> more than 120 seconds (check_hung_uninterruptible_tasks())

Thanks for explaining, let's see if I can hack a fix together..
