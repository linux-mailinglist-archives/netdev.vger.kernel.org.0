Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0C1686BA6
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 17:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjBAQ2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 11:28:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjBAQ2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 11:28:37 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5B2485AC;
        Wed,  1 Feb 2023 08:28:16 -0800 (PST)
Received: from [192.168.0.114] (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id C4CFF44C1025;
        Wed,  1 Feb 2023 16:28:09 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru C4CFF44C1025
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1675268889;
        bh=FK0lXauUGtjIwdmiDlZV7U/nfmHSC2l1ofgQ3Hw9Rsw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Xg7t+Z6jGkOcJiHSaKn/1h3ph05IK6cyO/4C9AtLALvLr/MgY7qldHo1YYIehUfOh
         xg+4lI6ZC40VpNxCjTyflP2QUQibVF5FpVkzKWrqxR5nuOOuALrF3xJDo73T8QrYPp
         6noMLVdk0qVgWxr/aPh1ohKdl/rhZNEPrdxNKMAA=
Subject: Re: [PATCH] net: openvswitch: fix flow memory leak in
 ovs_flow_cmd_new
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
References: <20230131191939.901288-1-pchelkin@ispras.ru>
 <Y9qI/vBRPlDFwkAh@corigine.com>
From:   Fedor Pchelkin <pchelkin@ispras.ru>
Message-ID: <a0be13d0-22d5-b92b-9fed-4faeed30fdce@ispras.ru>
Date:   Wed, 1 Feb 2023 19:28:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <Y9qI/vBRPlDFwkAh@corigine.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/1/23 6:45 PM, Simon Horman wrote:
> I see this would work by virtue of kfree(key) doing nothing
> of key is NULL, the error case in question. And that otherwise key is
> non-NULL if this path is hit.
> 
> However, the idiomatic approach to error handling is for the error path
> to unwind resource allocations in the reverse order that they were made.
> And for goto labels to control how far to unwind.
> 

You are right, thanks. Have to keep 'goto' structured, otherwise there
would be a 'goto' mess.

> So I think the following would be more in keeping with the intention of the
> code. Even if it is a somewhat more verbose change.
> 
> *compile tested only!*

I'll test this on error paths and resend the patch.
