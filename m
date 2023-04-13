Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53F9D6E1310
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 19:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbjDMRCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 13:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjDMRCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 13:02:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEE1AF33;
        Thu, 13 Apr 2023 10:02:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02A3E64054;
        Thu, 13 Apr 2023 17:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464F6C433D2;
        Thu, 13 Apr 2023 17:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681405321;
        bh=h3WMjK4zl6JofyMg5vsqpodV2pRvhxWvgIjrDOjPmzI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CyveBJUAuDYUQqq8O9sYdhz5DO3ddDFO57gXRAwDFmUCu/iojQb0HOpxO2KsYLvgb
         ttY5s/8G1bt1AYx+DLZyvXluZdyhONVlHTvGL3lEysljNyGV09O3vhqY0oPJgP7Fd1
         F1rERwcl+cn4TO1P4ThYS7If1UfwsdX+ZItN7V508YGmAjtJE/8ZIXppXb+QaLBOCc
         Do/xh9/zasqJbu6WBaFaUdYcqs54HM4N3MEDPnm9u/SEx7zAmfdI4hPxwmLZ+7H/Nx
         Rmj1kQZUj6stsl3c3vhal4inRxWNHUuhPPCZXLOxLmcpQBJ0zuoUaQE1xOe3aHgLPS
         NNPAs/GJo8e9A==
Date:   Thu, 13 Apr 2023 10:01:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Long Li <longli@microsoft.com>,
        "ssengar@linux.microsoft.com" <ssengar@linux.microsoft.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3,net-next, 2/4] net: mana: Refactor RX buffer
 allocation code to prepare for various MTU
Message-ID: <20230413100159.078bdf18@kernel.org>
In-Reply-To: <20230413165929.GU17993@unreal>
References: <1681334163-31084-1-git-send-email-haiyangz@microsoft.com>
        <1681334163-31084-3-git-send-email-haiyangz@microsoft.com>
        <20230413130428.GO17993@unreal>
        <PH7PR21MB3116194E8F7D56EB434B56A6CA989@PH7PR21MB3116.namprd21.prod.outlook.com>
        <20230413163059.GS17993@unreal>
        <20230413094003.3fa4cd8c@kernel.org>
        <20230413165929.GU17993@unreal>
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

On Thu, 13 Apr 2023 19:59:29 +0300 Leon Romanovsky wrote:
>> Maybe we should update the doc.  
> 
> The last sentence is always true :)

Yeah, I felt bad when writing it :)
