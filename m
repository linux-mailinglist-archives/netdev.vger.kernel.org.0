Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 514166142E2
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 02:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiKABt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 21:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbiKABtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 21:49:25 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2968217073;
        Mon, 31 Oct 2022 18:49:24 -0700 (PDT)
Date:   Tue, 1 Nov 2022 09:49:17 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667267362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fRVVxpWdboI3BCK5/upfkjgcKdbyv36akL/n18YwLFA=;
        b=TSIHK7qeBypUjvQibb1WLgZ9Yk4uCfZYIxuKDvJOiK+9htliugor0n81pzJMEjZtZPhMvf
        u1/nTa3ohrfBL4L+IiyQ6eRxV10P2QxJrYM+XvLlmRi+A2164NOGAbCfP60xwtyTM31lpS
        /zCDU/EXOHUXccFEm9EN1NgnPt1GxtI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Cai Huoqing <cai.huoqing@linux.dev>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        Bin Chen <bin.chen@corigine.com>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Peter Chen <peter.chen@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: hinic: Add control command support for VF PMD
 driver in DPDK
Message-ID: <20221101014917.GA6739@chq-T47>
References: <20221026125922.34080-1-cai.huoqing@linux.dev>
 <20221026125922.34080-2-cai.huoqing@linux.dev>
 <20221027110312.7391f69f@kernel.org>
 <20221028045655.GB3164@chq-T47>
 <20221028085651.78408e2c@kernel.org>
 <20221029075335.GA9148@chq-T47>
 <20221031165255.6a754aad@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221031165255.6a754aad@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31 10月 22 16:52:55, Jakub Kicinski wrote:
> On Sat, 29 Oct 2022 15:53:35 +0800 Cai Huoqing wrote:
> > On 28 10月 22 08:56:51, Jakub Kicinski wrote:
> > > > if the cmd is not added to 'nic_cmd_support_vf',
> > > > the PF will return false, and the error messsage "PF Receive VFx
> > > > unsupported cmd x" in the function 'hinic_mbox_check_cmd_valid',
> > > > then, the configuration will not be set to hardware.  
> > > 
> > > You're describing the behavior before the patch?
> > > 
> > > After the patch the command is ignored silently, like I said, right?
> > > Because there is no handler added to nic_vf_cmd_msg_handler[].
> > > Why is that okay? Or is there handler somewhere else?  
> > 
> > No need to add handlers to nic_vf_cmd_msg_handler[].
> > It will run the path,
> > if (i == ARRAY_SIZE(nic_vf_cmd_msg_handler))
> > 	err = hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt, HINIC_MOD_L2NIC,
> > 				cmd, buf_in, in_size, buf_out,
> > 				out_size, HINIC_MGMT_MSG_SYNC);
> 
> Meaning it just forwards it to the firmware?
Yes, host driver just forwards it to the firmware.
Actually the firmware works on a coprocessor MGMT_CPU(inside the NIC)
which will recv and deal with these commands.

Thanks,
Cai
> 
> > right? or if not please show the related code.
> 
> I don't know, I don't know this random driver. I'm just asking you
> questions because as the author of the patch _you_ are supposed to know.
