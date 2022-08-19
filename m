Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B6159A5FF
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 21:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351147AbiHSTQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 15:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349775AbiHSTQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 15:16:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153AE10F6AD;
        Fri, 19 Aug 2022 12:16:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93355B827CD;
        Fri, 19 Aug 2022 19:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92F2C433C1;
        Fri, 19 Aug 2022 19:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660936602;
        bh=FHAFzImkf8+uTj2n5t3tQRz+fZFhVhlLsz8IOt07VqA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kygcJmVOWSyWoKEyNGL2b4xGkEcPe+ucAlQEL0HvNbb3VUtcLLx535VqZc5OrEkLn
         a7Et1t/m79LYlpRbT4Z6G4mN2cNE+yadEIK3lSsN8zWlL/BKX0BGAWXu/OhU9aHvA+
         mf90S/K2Jl7zgWFRcSoSfUirI2PHuznkn1YOV4dkJLH9Yvmfj9AZjVS3evYQB1i8q2
         GN5LEvkuVlo1EVrrsEkqeXTdf+O2vl4oM9l9Khxn1AuAT7gswSF4OHJlK+pT2y1XEF
         nphx0QEGVjuD4lnGb6Un96Psa7PMCM7oWIR06tLFrQ0hAXJ8wClSZ60Qf8fdoMKJv8
         4C6AHM/09tF+g==
Date:   Fri, 19 Aug 2022 12:16:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, corbet@lwn.net,
        stephen@networkplumber.org, sdf@google.com, ecree.xilinx@gmail.com,
        benjamin.poirier@gmail.com, idosch@idosch.org,
        f.fainelli@gmail.com, jiri@resnulli.us, dsahern@kernel.org,
        fw@strlen.de, linux-doc@vger.kernel.org, jhs@mojatatu.com,
        tgraf@suug.ch, jacob.e.keller@intel.com, svinota.saveliev@gmail.com
Subject: Re: [PATCH net-next 2/2] docs: netlink: basic introduction to
 Netlink
Message-ID: <20220819121640.11e7e2f7@kernel.org>
In-Reply-To: <20220819105451.1de66044@kernel.org>
References: <20220818023504.105565-1-kuba@kernel.org>
        <20220818023504.105565-2-kuba@kernel.org>
        <6350516756628945f9cc1ee0248e92473521ed0b.camel@sipsolutions.net>
        <20220819092029.10316adb@kernel.org>
        <959012cfd753586b81ff60b37301247849eb274c.camel@sipsolutions.net>
        <20220819105451.1de66044@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Aug 2022 10:54:51 -0700 Jakub Kicinski wrote:
> > Ugh, I repressed all those memories ... I don't remember now, I guess
> > I'd have to try it. Also it doesn't just apply to normal stuff but also
> > multicast, and that can be even trickier.  
> 
> No worries, let me try myself. Annoyingly I have this doc on a different
> branch than my netlink code, that's why I was being lazy :)

Buffer sizing
-------------

Netlink sockets are datagram sockets rather than stream sockets,
meaning that each message must be received in its entirety by a single
recv()/recvmsg() system call. If the buffer provided by the user is too
short, the message will be truncated and the ``MSG_TRUNC`` flag set
in struct msghdr (struct msghdr is the second argument
of the recvmsg() system call, *not* a Netlink header).

Upon truncation the remaining part of the message is discarded.

Netlink expects that the user buffer will be at least 8kB or a page
size of the CPU architecture, whichever is bigger. Particular Netlink
families may, however, require a larger buffer. 32kB buffer is recommended
for most efficient handling of dumps (larger buffer fits more dumped
objects and therefore fewer recvmsg() calls are needed).
