Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0634613BE8
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 18:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbiJaRKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 13:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbiJaRKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 13:10:04 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8974B12D08;
        Mon, 31 Oct 2022 10:10:02 -0700 (PDT)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 6D5E4E0007;
        Mon, 31 Oct 2022 17:09:59 +0000 (UTC)
Message-ID: <eeb28c10-63ab-ecf6-7938-40257dfd12b2@ovn.org>
Date:   Mon, 31 Oct 2022 18:09:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Cc:     i.maximets@ovn.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Content-Language: en-US
To:     netdev@vger.kernel.org
References: <20221021114921.3705550-1-i.maximets@ovn.org>
From:   Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [RFE net-next] net: tun: 1000x speed up
In-Reply-To: <20221021114921.3705550-1-i.maximets@ovn.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/21/22 13:49, Ilya Maximets wrote:
> The 10Mbps link speed was set in 2004 when the ethtool interface was
> initially added to the tun driver.  It might have been a good
> assumption 18 years ago, but CPUs and network stack came a long way
> since then.
> 
> Other virtual ports typically report much higher speeds.  For example,
> veth reports 10Gbps since its introduction in 2007.
> 
> Some userspace applications rely on the current link speed in
> certain situations.  For example, Open vSwitch is using link speed
> as an upper bound for QoS configuration if user didn't specify the
> maximum rate.  Advertised 10Mbps doesn't match reality in a modern
> world, so users have to always manually override the value with
> something more sensible to avoid configuration issues, e.g. limiting
> the traffic too much.  This also creates additional confusion among
> users.
> 
> Bump the advertised speed to at least match the veth.  10Gbps also
> seems like a more or less fair assumption these days, even though
> CPUs can do more.  Alternative might be to explicitly report UNKNOWN
> and let the application/user decide on a right value for them.
> 
> Link: https://mail.openvswitch.org/pipermail/ovs-discuss/2022-July/051958.html
> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
> ---
> 
> Sorry for the clickbait subject line.  Can change it to something more
> sensible while posting non-RFE patch.  Something like:
> 
>   'net: tun: bump the link speed from 10Mbps to 10Gbps'
> 
> This patch is RFE just to start a conversation.

OK.  There seems to be no more discussions around the topic, so
I'll make a conclusion.

General understanding is that reporting UNKNOWN will cause problems
with bonding (not sure why anyone will add tap into bonding outside
of just for testing reasons, but that's a different topic) and will
potentially cause problems with userpsace applications that do not
handle that case for some reason.  So, this is a risky option at the
moment.

There was no strong opinion against equalizing speeds between veth
and tun/tap.  Sounds like a safe option in general and there are no
known use cases that will be negatively affected.

So, I think, I'll go ahead and post the non-RFC version of the
proposed change.

Thanks!

Best regards, Ilya Maximets.
