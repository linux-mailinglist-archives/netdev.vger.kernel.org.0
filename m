Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEE959082F
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 23:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233973AbiHKVl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 17:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbiHKVl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 17:41:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F9C9F0E9
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 14:41:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 85533CE2107
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 21:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334E3C433D6;
        Thu, 11 Aug 2022 21:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660254112;
        bh=sHLc73KXR0K1Nu0toL5g8k604GueGzA6AHIHEoqrmAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EKcrpUtm5/KyTu5jd3Z8mzgNJjx3rqd4Z//uMXXc5qz1q2JGyTMBo+D9zjdHZVh3B
         ESB+tSIci7F7iVQmHJ5aQo06nMgSqkUMysFiHMIogi3+qXSNTDeCDTL3YE/OblaAis
         oV0BPaOD6wZ9Iumn4AaacvRCxGVL3mLb2RiE1mMOaCyYNgqvjW08blNbmWqhX+54PH
         YlfabiV86h6HiKxWp/uiZWuu+KcmlK+powNLWTagwOZ87FBOOCYvTYfZHC13Er9z+7
         2ISkUSptpXLA0I6+H1VIPGmLNRB3RqB3ECBwnje1lIDXXd8NghBWEWimsYs5o1gVm5
         DQVKKK0kdWriA==
From:   James Hogan <jhogan@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Sasha Neftin <sasha.neftin@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Subject: Re: [WIP v2] igc: fix deadlock caused by taking RTNL in RPM resume path
Date:   Thu, 11 Aug 2022 22:41:48 +0100
Message-ID: <4759452.31r3eYUQgx@saruman>
In-Reply-To: <20220811202524.78323-1-vinicius.gomes@intel.com>
References: <20220811151342.19059-1-vinicius.gomes@intel.com> <20220811202524.78323-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday, 11 August 2022 21:25:24 BST Vinicius Costa Gomes wrote:
> It was reported a RTNL deadlock in the igc driver that was causing
> problems during suspend/resume.
> 
> The solution is similar to commit ac8c58f5b535 ("igb: fix deadlock
> caused by taking RTNL in RPM resume path").
> 
> Reported-by: James Hogan <jhogan@kernel.org>
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---
> Sorry for the noise earlier, my kernel config didn't have runtime PM
> enabled.

Thanks for looking into this.

This is identical to the patch I've been running for the last week. The 
deadlock is avoided, however I now occasionally see an assertion from 
netif_set_real_num_tx_queues due to the lock not being taken in some cases via 
the runtime_resume path, and a suspicious rcu_dereference_protected() warning 
(presumably due to the same issue of the lock not being taken). See here for 
details:
https://lore.kernel.org/netdev/4765029.31r3eYUQgx@saruman/

Cheers
James


