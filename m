Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1613C6ED4FA
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 21:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbjDXTBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 15:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbjDXTBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 15:01:31 -0400
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C235F30ED;
        Mon, 24 Apr 2023 12:01:29 -0700 (PDT)
Received: from [192.168.0.2] (ip5f5aebe8.dynamic.kabel-deutschland.de [95.90.235.232])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 2F59661E4052B;
        Mon, 24 Apr 2023 21:01:28 +0200 (CEST)
Message-ID: <b6a13b7f-b140-114b-781f-16299ec3379c@molgen.mpg.de>
Date:   Mon, 24 Apr 2023 21:01:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [Intel-wired-lan] [PATCH v1 1/1] igc: enable multiple TXSTMP
 registers reporting TX timestamp.
Content-Language: en-US
To:     xiaoyan.gong@intel.com
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, inux-kernel@vger.kernel.org
References: <20230423075312.544244-1-xiaoyan.gong@intel.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230423075312.544244-1-xiaoyan.gong@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear  Xiao Yan,


Am 23.04.23 um 09:53 schrieb gongxiao-intel:

Your name is incorrectly configured. Please do (please correct the 
spelling):

     $ git config --global user.name "Xiao Yan Gong"
     $ git commit --amend -s --author="Xiao Yan Gong 
<xiaoyan.gong@intel.com>"

Also, please remove the dot/period from the end of the commit message 
summary.

> The HW TX timestamps created by the NIC via socket options can be
> requested using the current network timestamps generation capability of
> SOF_TIMESTAMPING_TX_HARDWARE. The most common users of this socket flag
> is PTP, however other packet applications that require tx timestamps might
> also ask for it.
> 
> The problem is that, when there is a lot of traffic, there is a high chance
> that the timestamps for a PTP packet will be lost if both PTP and Non-PTP

non-PTP

> packets use the same SOF_TIMESTAMPING_TX_HARDWARE causing the tx timeout.

Is Linux logging this? If so, please paste such a message.

> The root cause of this problem is that igc only use one TXSTMP register to

use*s*

> report TX timestamp. Such implementation intensify the race of TX timestamp

intensif*ies*

> query from multiple sockets.
> 
> However, Intel i225/i226 controller has 4 TXSTMP registers. This patch fully
> utilizes 4 TXSTMP registers to reduce the race of TX timestamp query.
> 
> This patch dedicates TXSTMP register 0 to all PTP packets. In most case, only
> one PTP sync process will run on a network port. So, one TXSTMP register is
> enough for PTP stream.
> 
> For TXSTMP register 1 - 3, they are allocated to sockets round robin. And each

register*s*

> socket can only occupy one register at a time. So, at least 3 sockets can requiest

request

> TX timestamp simultaneously.

Please add Signed-off-by line.

How did you test your patch?

> ---
>   drivers/net/ethernet/intel/igc/igc.h         | 24 +++--
>   drivers/net/ethernet/intel/igc/igc_base.h    |  2 +-
>   drivers/net/ethernet/intel/igc/igc_defines.h |  2 +-
>   drivers/net/ethernet/intel/igc/igc_main.c    | 55 +++++++++--
>   drivers/net/ethernet/intel/igc/igc_ptp.c     | 97 +++++++++++++-------
>   drivers/net/ethernet/intel/igc/igc_regs.h    |  4 +-
>   6 files changed, 129 insertions(+), 55 deletions(-)

[…]


Kind regards,

Paul
