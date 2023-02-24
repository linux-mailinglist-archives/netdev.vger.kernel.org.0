Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE766A1524
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 04:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbjBXDCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 22:02:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjBXDCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 22:02:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4601C5943D;
        Thu, 23 Feb 2023 19:02:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2022B81B2F;
        Fri, 24 Feb 2023 03:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24872C433D2;
        Fri, 24 Feb 2023 03:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677207760;
        bh=SLACJiADnJA60C4afvJCIsYCAdCHLyLjDB26A1FkA0E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dysVAZ8e+s4uJnmbTuvP4VsiWCPH+fSTceJgsKdAMF9neQcKOjUp4cCZ7DsPJ8Qhv
         rQ759XyBfsfLsO2gfr3f5uaBGqEzoTmYBggafQZKnZ8SxFUbPov0YScNSrymJdWES3
         6ps93wqHQDS2TiZ89fakN1q91H3ncrUkKBUTQNXywLjDF+IeIHnGWlpLQyIKMa5alU
         cDQacj1WfftkkA+f22glgYhgekxTxgj9lTefHRt3A4zNZCYqtvEKsh3Cq0oEtaazrp
         B7wBdh6vsMVtYzykXOJLb8DzWraJajRovGYUDqEgan6g1g5JrEna1NvOPhF24CbL7c
         Yshk5hauWB1TA==
Date:   Thu, 23 Feb 2023 19:02:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>
Subject: Re: [PATCHv2 net] sctp: add a refcnt in sctp_stream_priorities to
 avoid a nested loop
Message-ID: <20230223190239.34932117@kernel.org>
In-Reply-To: <825eb0c905cb864991eba335f4a2b780e543f06b.1677085641.git.lucien.xin@gmail.com>
References: <825eb0c905cb864991eba335f4a2b780e543f06b.1677085641.git.lucien.xin@gmail.com>
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

On Wed, 22 Feb 2023 12:07:21 -0500 Xin Long wrote:
> With this refcnt added in sctp_stream_priorities, we don't need to
> traverse all streams to check if the prio is used by other streams
> when freeing one stream's prio in sctp_sched_prio_free_sid(). This
> can avoid a nested loop (up to 65535 * 65535), which may cause a
> stuck as Ying reported:
> 
>     watchdog: BUG: soft lockup - CPU#23 stuck for 26s! [ksoftirqd/23:136]
>     Call Trace:
>      <TASK>
>      sctp_sched_prio_free_sid+0xab/0x100 [sctp]
>      sctp_stream_free_ext+0x64/0xa0 [sctp]
>      sctp_stream_free+0x31/0x50 [sctp]
>      sctp_association_free+0xa5/0x200 [sctp]
> 
> Note that it doesn't need to use refcount_t type for this counter,
> as its accessing is always protected under the sock lock.
> 
> v1->v2:
>  - add a check in sctp_sched_prio_set to avoid the possible prio_head
>    refcnt overflow.
> 
> Fixes: 9ed7bfc79542 ("sctp: fix memory leak in sctp_stream_outq_migrate()")
> Reported-by: Ying Xu <yinxu@redhat.com>
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks!
