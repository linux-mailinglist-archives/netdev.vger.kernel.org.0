Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1A94FC203
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 18:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344051AbiDKQQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 12:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbiDKQQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 12:16:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93BC2B8;
        Mon, 11 Apr 2022 09:13:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EDA0B81704;
        Mon, 11 Apr 2022 16:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76885C385A3;
        Mon, 11 Apr 2022 16:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649693626;
        bh=S4RgEBNrSyI+ophc0QVA8uNOdYjwnqrns4P7akRNFaI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=u6j2TNukG/Ye5tRQPNUxnV2SOuyDUoYoChUBMIbom+cpoQ0Zn/BEGeeQb3x33QKy6
         iLS44nfmiV0iqUPciH14pEgtnMGByPaiINkJeyDpGpE+rhUC7ge4KRijekqh1TjRGA
         qseaDRToWLTReU/pvUu+81XSxrsu93EoG7ecEWegxNmMpJAo8bZYHuyA0fs3ZClIGW
         QzpjAN1iraiktH0G3WnTmK5oRfuB+thCM6cL9rMJ9OUBvGgu/C7i2Vi8x1wU7eFlw1
         TZJwZzLxneElwllZsXdw3TPhhi3Xwhrvud+o0n4UdYwgYcQteqaYVLZoaENV7abKUm
         IqFJ2fHTiw4MA==
Message-ID: <1d595632-ae6d-39f0-b624-7dfc5bfc1ea7@kernel.org>
Date:   Mon, 11 Apr 2022 10:13:44 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH net-next v2] net/ipv6: Introduce accept_unsolicited_na
 knob to implement router-side changes for RFC9131
Content-Language: en-US
To:     Arun Ajith S <aajith@arista.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, pabeni@redhat.com,
        corbet@lwn.net, prestwoj@gmail.com, gilligan@arista.com,
        noureddine@arista.com, gk@arista.com
References: <20220407074428.1623-1-aajith@arista.com>
 <d7a85a29-0d7f-b5e2-c908-4aa9f89bb476@kernel.org>
 <CAOvjArQcH1KRV3B1V9urYEV+6i3ZL6NbmkYjbu1icFBJZ3JVOQ@mail.gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <CAOvjArQcH1KRV3B1V9urYEV+6i3ZL6NbmkYjbu1icFBJZ3JVOQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/11/22 9:41 AM, Arun Ajith S wrote:
> 
> mausezahn doesn't have good support for ICMPv6.
> I tried using --type icmp6 -t icmp6 "type=136, payload=<HEX-PAYLOAD>"
> to manually craft a NA packet with  the target address and the target
> ll addr option.
> But it still doesn't allow me to set the flags to mark it as an
> unsolicited advertisement.
> 
> How about this alternative for a test:
> 1. Setup a veth tunnel across two namespaces, one end being the host
> and the other the router.
> 2. On the host side, I can configure
> net.ipv6.conf.<interface>.ndisc_notify to send out unsolicited NAs.
> 3. On the router side, I can try out various combinations of
> (accept_unsolicited_na, drop_unsolicted_na and forwarding)
> 

that works too. even simpler.
