Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E7125285F
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 09:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgHZHUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 03:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgHZHUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 03:20:41 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2747BC061574;
        Wed, 26 Aug 2020 00:20:41 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kApj6-00AuC9-Q7; Wed, 26 Aug 2020 09:20:08 +0200
Message-ID: <f579efc1375e46d9c2ff999ada1bcfed40ec2a8f.camel@sipsolutions.net>
Subject: Re: [PATCH v2 3/6] netlink/compat: Append NLMSG_DONE/extack to
 frag_list
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        netdev@vger.kernel.org
Date:   Wed, 26 Aug 2020 09:19:51 +0200
In-Reply-To: <20200826014949.644441-4-dima@arista.com> (sfid-20200826_034955_677016_9C53E113)
References: <20200826014949.644441-1-dima@arista.com>
         <20200826014949.644441-4-dima@arista.com>
         (sfid-20200826_034955_677016_9C53E113)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-08-26 at 02:49 +0100, Dmitry Safonov wrote:
> Modules those use netlink may supply a 2nd skb, (via frag_list)
> that contains an alternative data set meant for applications
> using 32bit compatibility mode.

Do note, however, that until this day the facility here was only used by
(and originally intended for) wireless extensions, where it exclusively
applies to *event* messages. Hence, we really didn't worry about dump or
any other kind of netlink usage.

That said, it's really just a historic note explaining why it didn't
work for you out of the box :)

> In such a case, netlink_recvmsg will use this 2nd skb instead of the
> original one.
> 
> Without this patch, such compat applications will retrieve
> all netlink dump data, but will then get an unexpected EOF.
> 
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Dmitry Safonov <dima@arista.com>
> ---
>  net/netlink/af_netlink.c | 48 ++++++++++++++++++++++++++++------------
>  1 file changed, 34 insertions(+), 14 deletions(-)
> 
> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index b5f30d7d30d0..b096f2b4a50d 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -2186,13 +2186,36 @@ EXPORT_SYMBOL(__nlmsg_put);
>   * It would be better to create kernel thread.
>   */
>  
> +static int netlink_dump_done(struct netlink_sock *nlk, struct sk_buff *skb,
> +			     struct netlink_callback *cb,
> +			     struct netlink_ext_ack *extack)
> +{
> +	struct nlmsghdr *nlh;
> +
> +	nlh = nlmsg_put_answer(skb, cb, NLMSG_DONE, sizeof(nlk->dump_done_errno),
> +			       NLM_F_MULTI | cb->answer_flags);
> +	if (WARN_ON(!nlh))
> +		return -ENOBUFS;
> +
> +	nl_dump_check_consistent(cb, nlh);
> +	memcpy(nlmsg_data(nlh), &nlk->dump_done_errno,
> +			sizeof(nlk->dump_done_errno));

nit: indentation here looks odd.

Other than that, looks reasonable to me.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes

