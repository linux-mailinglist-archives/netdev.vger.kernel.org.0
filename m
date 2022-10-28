Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 343DA610963
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 06:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiJ1E5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 00:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiJ1E5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 00:57:01 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAEE0197FA5;
        Thu, 27 Oct 2022 21:56:59 -0700 (PDT)
Date:   Fri, 28 Oct 2022 12:56:55 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666933018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iENfr5ZPUTr7bus8FV8bzCGok8UT4CZsu/mTj2KyRuM=;
        b=Bgd+6+bqzAmI65Tij20r2PW15cevOr7v3mZ3OYrcp4mqvN4mXdvbenM6QqSFLEkGZd/FZy
        uSYOKF65yMSt6NYzVLv9cPFCBvWRZwcjdywokM+Tw2fPhaEi6FUDG07XLFFnRs6v6VZroD
        8QWRiP+qP0ubUf1NMe6O1MN2Kj65mSk=
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
Message-ID: <20221028045655.GB3164@chq-T47>
References: <20221026125922.34080-1-cai.huoqing@linux.dev>
 <20221026125922.34080-2-cai.huoqing@linux.dev>
 <20221027110312.7391f69f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221027110312.7391f69f@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27 10月 22 11:03:12, Jakub Kicinski wrote:
> On Wed, 26 Oct 2022 20:59:11 +0800 Cai Huoqing wrote:
> > The control command only can be set to register in PF,
> > so add support in PF driver for VF PMD driver control
> > command when VF PMD driver work with linux PF driver.
> 
> For what definition of "work"?
Hi Jakub,
  The work means that when the VF NIC driver in guest OS do some
  configuration (VF L2NIC config),
  firstly, VF send cmd to PF viamailbox,
  then, PF deside what cmd is valid as a command filter.
 
  see these,
  ./hinic_sriov.c:1031:static int nic_pf_mbox_handler(..
  ./hinic_sriov.c:1045:   if (!hinic_mbox_check_cmd_valid(hwdev, nic_cmd_support_vf, vf_id, cmd,
> 
> The commands are actually supported or you're just ignoring them
> silently?
No, if the cmd is not added to 'nic_cmd_support_vf',
the PF will return false, and the error messsage "PF Receive VFx
unsupported cmd x" in the function 'hinic_mbox_check_cmd_valid',
then, the configuration will not be set to hardware.

./hinic_hw_mbox.c:1238:bool hinic_mbox_check_cmd_valid(struct hinic_hwdev *hwdev,

Thanks,
Cai
