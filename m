Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7D746DAFCB
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 17:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbjDGPks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 11:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDGPkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 11:40:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F188A42
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 08:40:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8339A64C2F
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 15:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04CBC433D2;
        Fri,  7 Apr 2023 15:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680882044;
        bh=pDVQ+DRlcY6qkdN7R1psfAUudI8xkJ3mM66OwQ9S+2I=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=O9h+8q5QbjR0Frck9LOikiFqxPJ8eZlMD0cnX9G+0xjAMSjbym7ODG0omjYj8y+Cx
         uX4Vp9V8Qlv1bXfpBHsV8Fnh3ldkD7f0WanNPgdqKBCvONBHhkaiCWD7EZGuFR24uj
         I/xVks/+8bSSk0u6MFAgxiLuRULIBJpCm4/dj/WDvKUoMRBZMWpM8j62XwG+HARR3U
         sEel7+eNxnhWPrL3NnIu7GoVMColPOH3AOrIPXKr4BBnkn5Md1ByiRRXEWfQWUJJ+M
         HFdMqs9GK0ZYxyFHZUxjZeIC+ay9KqwdY4oURcJIg/dSojchWuEjlJT37q+w9E7VT9
         tJwj6JsaeQfFw==
Message-ID: <cc73004c-9aa8-9cd3-b46e-443c0727c34d@kernel.org>
Date:   Fri, 7 Apr 2023 09:40:43 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH iproute2-next] tc: m_tunnel_key: support code for "nofrag"
 tunnels
Content-Language: en-US
To:     Davide Caratti <dcaratti@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ilya Maximets <i.maximets@ovn.org>
Cc:     netdev@vger.kernel.org, Pedro Tammela <pctammela@mojatatu.com>
References: <c43213bed30edfa0d6fa1b084e4d48c26417edc9.1680281221.git.dcaratti@redhat.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <c43213bed30edfa0d6fa1b084e4d48c26417edc9.1680281221.git.dcaratti@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/31/23 10:49 AM, Davide Caratti wrote:
> add control plane for setting TCA_TUNNEL_KEY_NO_FRAG flag on
> act_tunnel_key actions.
> 
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>  include/uapi/linux/tc_act/tc_tunnel_key.h |  1 +
>  man/man8/tc-tunnel_key.8                  |  3 ++
>  tc/m_tunnel_key.c                         | 48 +++++++++++++++++------
>  3 files changed, 41 insertions(+), 11 deletions(-)
> 
> diff --git a/include/uapi/linux/tc_act/tc_tunnel_key.h b/include/uapi/linux/tc_act/tc_tunnel_key.h
> index 49ad4033951b..37c6f612f161 100644
> --- a/include/uapi/linux/tc_act/tc_tunnel_key.h
> +++ b/include/uapi/linux/tc_act/tc_tunnel_key.h
> @@ -34,6 +34,7 @@ enum {
>  					 */
>  	TCA_TUNNEL_KEY_ENC_TOS,		/* u8 */
>  	TCA_TUNNEL_KEY_ENC_TTL,		/* u8 */
> +	TCA_TUNNEL_KEY_NO_FRAG,		/* flag */
>  	__TCA_TUNNEL_KEY_MAX,
>  };
>  

applied to iproute2-next.

In the future, please make uapi changes a separate patch. UAPI headers
are synched by scripts. Inclusion in a PR is a convenience for others;
they are always dropped before applying. A separate patch makes that
process easier.

