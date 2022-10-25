Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1E660CD5D
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 15:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbiJYNZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 09:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232348AbiJYNZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 09:25:27 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8275AC57;
        Tue, 25 Oct 2022 06:25:24 -0700 (PDT)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 53C0760011;
        Tue, 25 Oct 2022 13:25:18 +0000 (UTC)
Message-ID: <580ec147-d295-eab4-baeb-35551f27746e@ovn.org>
Date:   Tue, 25 Oct 2022 15:25:18 +0200
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
Subject: Re: [PATCH v2 net 1/2] openvswitch: switch from WARN to pr_warn
Content-Language: en-US
To:     Aaron Conole <aconole@redhat.com>, netdev@vger.kernel.org
References: <20221025105018.466157-1-aconole@redhat.com>
 <20221025105018.466157-2-aconole@redhat.com>
From:   Ilya Maximets <i.maximets@ovn.org>
In-Reply-To: <20221025105018.466157-2-aconole@redhat.com>
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

On 10/25/22 12:50, Aaron Conole wrote:
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

Nothing changed here since v1, so

Acked-by: Ilya Maximets <i.maximets@ovn.org>
