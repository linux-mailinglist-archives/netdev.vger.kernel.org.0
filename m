Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57E0D6E9FD3
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 01:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232984AbjDTXYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 19:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232975AbjDTXYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 19:24:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCE43AB5
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 16:24:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3917C64C99
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 23:24:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62AB5C4339B;
        Thu, 20 Apr 2023 23:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682033076;
        bh=CFiDeTt+iHSDWy+RQkVB9K0n0F+/xTRzGJdXpgVq1ys=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aMVH6UnC/eernB5/N2nwUfCGISclKH3gO9iJB8QaYBa7/UyKTWfkWaZuSnx8xI7PU
         Kd3iPTIOKku5B4TiURiqHGyq4aD7DiOhJ0VsbqfB9o9XWzaUGxce16eV+FGKeJx51/
         Jel6jsd6A8O1JLIefYVzzxjrm3xfCxS4CHM9g7kw7uleBPEuLaiWvwl7U1Q+gM4PY+
         nkbvU6vdHyPcnu2uNzVz5eKw/MbXrzi6S4Y+4k7KkVNLY/YByLyoKW7bg5N66YaMG4
         BhhroQfalgtvfIv6QzBoqAAGvKFJomjPwVifbjy2vwNcsqk9DX3QqgvyJ+3vdyWfWo
         2K8OUcUtlCU7Q==
Date:   Thu, 20 Apr 2023 16:24:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     Davide Caratti <dcaratti@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] net/sched: sch_fq: fix integer overflow of
 "credit"
Message-ID: <20230420162435.1d5a79df@kernel.org>
In-Reply-To: <4e8324cf-e6de-acff-5e30-373d015a3cb4@mojatatu.com>
References: <7b3a3c7e36d03068707a021760a194a8eb5ad41a.1682002300.git.dcaratti@redhat.com>
        <4e8324cf-e6de-acff-5e30-373d015a3cb4@mojatatu.com>
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

On Thu, 20 Apr 2023 13:25:33 -0300 Pedro Tammela wrote:
> >           "id": "9398",
> >           "name": "Create FQ with maxrate setting",  
> 
> You probably don't want to backport the test as well? If so I would 
> break this patch into two.

IIRC the preference of stable folks is to backport more not fewer
selftests. Practicality of that aside, I think the patch is good as is.
