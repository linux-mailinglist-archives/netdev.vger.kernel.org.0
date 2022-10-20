Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B12606850
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 20:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiJTSkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 14:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbiJTSkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 14:40:16 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E48441988;
        Thu, 20 Oct 2022 11:40:13 -0700 (PDT)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 7290820004;
        Thu, 20 Oct 2022 18:40:08 +0000 (UTC)
Message-ID: <b0495014-0673-1ac3-5c9f-b12f947d9cb2@ovn.org>
Date:   Thu, 20 Oct 2022 20:40:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Cc:     i.maximets@ovn.org, Pravin B Shelar <pshelar@ovn.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>,
        Kevin Sprague <ksprague0711@gmail.com>, dev@openvswitch.org,
        Eelco Chaudron <echaudro@redhat.com>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Content-Language: en-US
To:     Aaron Conole <aconole@redhat.com>, netdev@vger.kernel.org
References: <20221019183054.105815-1-aconole@redhat.com>
 <20221019183054.105815-2-aconole@redhat.com>
From:   Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [PATCH net 1/2] openvswitch: switch from WARN to pr_warn
In-Reply-To: <20221019183054.105815-2-aconole@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NEUTRAL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/19/22 20:30, Aaron Conole wrote:
> As noted by Paolo Abeni, pr_warn doesn't generate any splat and can still
> preserve the warning to the user that feature downgrade occurred.  We
> likely cannot introduce other kinds of checks / enforcement here because
> syzbot can generate different genl versions to the datapath.
> 
> Reported-by: syzbot+31cde0bef4bbf8ba2d86@syzkaller.appspotmail.com
> Fixes: 44da5ae5fbea ("openvswitch: Drop user features if old user space attempted to create datapath")
> Cc: Thomas Graf <tgraf@suug.ch>
> Signed-off-by: Aaron Conole <aconole@redhat.com>
> ---
>  net/openvswitch/datapath.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index c8a9075ddd0a..155263e73512 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -1616,7 +1616,8 @@ static void ovs_dp_reset_user_features(struct sk_buff *skb,
>  	if (IS_ERR(dp))
>  		return;
>  
> -	WARN(dp->user_features, "Dropping previously announced user features\n");
> +	pr_warn("%s: Dropping previously announced user features\n",
> +		ovs_dp_name(dp));
>  	dp->user_features = 0;
>  }
>  

Works fine.  Thanks!

Acked-by: Ilya Maximets <i.maximets@ovn.org>
