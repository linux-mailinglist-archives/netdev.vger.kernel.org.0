Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8ECD53DB77
	for <lists+netdev@lfdr.de>; Sun,  5 Jun 2022 14:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343783AbiFEMzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 08:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233439AbiFEMzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 08:55:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D07920F48;
        Sun,  5 Jun 2022 05:55:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2E80B80D9C;
        Sun,  5 Jun 2022 12:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF95C385A5;
        Sun,  5 Jun 2022 12:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654433703;
        bh=RY+KJGqku2DSKAEwvB551GtkNFXRcjEMorSuy+j0LMQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DTW2s72V7pdYt4dfLxn1ZlX2bSgelARzJ620dmMxmO/D/PNBv8R7Q3l0QgLYrbV4U
         BRdmfLtbXeqNl3rkR6eh0TZBQvyUdVNRsNEOp31gNAF7QA4ZrDnFWdjwst9z0dcuge
         raAQCPChmJgBF6P8h0yge1JKdnYna8Vu2iza0oGV3D94/TXyxlKTrYaHCoNvYv3jhN
         C4/uNfkfvzBJOSUKHPCL6Y9JwvdVXGDR9PYwOH4hgoAdJI8tvnnA/lPYio2x0pCWjO
         OhukAOoZOEKSEqYNfty1BVNC21+IKWtCoVvP6zroZlWCxGYlhJCmEcb+4AgxYiyieQ
         GWJ0TnDbfxMvw==
Date:   Sun, 5 Jun 2022 08:55:02 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>,
        idosch@nvidia.com, petrm@nvidia.com, bigeasy@linutronix.de,
        imagedong@tencent.com, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.18 040/159] net: sched: use queue_mapping to
 pick tx queue
Message-ID: <YpynpqduOAQCun0/@sashalap>
References: <20220530132425.1929512-1-sashal@kernel.org>
 <20220530132425.1929512-40-sashal@kernel.org>
 <20220530111048.6120db70@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220530111048.6120db70@kernel.org>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 30, 2022 at 11:10:48AM -0700, Jakub Kicinski wrote:
>On Mon, 30 May 2022 09:22:25 -0400 Sasha Levin wrote:
>> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>>
>> [ Upstream commit 2f1e85b1aee459b7d0fd981839042c6a38ffaf0c ]
>
>This is prep for a subsequent patch which was adding a feature.

Dropping, thanks

-- 
Thanks,
Sasha
