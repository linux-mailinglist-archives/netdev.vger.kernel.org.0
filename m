Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7655EF80A
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 16:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235756AbiI2Oxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 10:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235596AbiI2Oxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 10:53:39 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D612A131F6C
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:53:37 -0700 (PDT)
Date:   Thu, 29 Sep 2022 16:53:34 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Johannes Berg <johannes@sipsolutions.net>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Guillaume Nault <gnault@redhat.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Florian Westphal <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: [PATCH net-next RESEND] genetlink: reject use of nlmsg_flags for
 new commands
Message-ID: <YzWxbrXkvsjnl50R@salvia>
References: <20220929142809.1167546-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220929142809.1167546-1-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 07:28:09AM -0700, Jakub Kicinski wrote:
> Commit 9c5d03d36251 ("genetlink: start to validate reserved header bytes")
> introduced extra validation for genetlink headers. We had to gate it
> to only apply to new commands, to maintain bug-wards compatibility.
> Use this opportunity (before the new checks make it to Linus's tree)
> to add more conditions.
> 
> Validate that Generic Netlink families do not use nlmsg_flags outside
> of the well-understood set.
> 
> Link: https://lore.kernel.org/all/20220928073709.1b93b74a@kernel.org/
> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
> Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
> Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> Reviewed-by: Guillaume Nault <gnault@redhat.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> --
> RESEND with the right tree in the subject
> 
> CC: Florent Fourcot <florent.fourcot@wifirst.fr>
> CC: Pablo Neira Ayuso <pablo@netfilter.org>
> CC: Florian Westphal <fw@strlen.de>
> CC: Jamal Hadi Salim <jhs@mojatatu.com>
> CC: Jacob Keller <jacob.e.keller@intel.com>
> CC: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  net/netlink/genetlink.c | 32 +++++++++++++++++++++++++++++++-
>  1 file changed, 31 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
> index 7c136de117eb..39b7c00e4cef 100644
> --- a/net/netlink/genetlink.c
> +++ b/net/netlink/genetlink.c
> @@ -739,6 +739,36 @@ static int genl_family_rcv_msg_doit(const struct genl_family *family,
>  	return err;
>  }
>  
> +static int genl_header_check(const struct genl_family *family,
> +			     struct nlmsghdr *nlh, struct genlmsghdr *hdr,
> +			     struct netlink_ext_ack *extack)
> +{
> +	u16 flags;
> +
> +	/* Only for commands added after we started validating */
> +	if (hdr->cmd < family->resv_start_op)
> +		return 0;
> +
> +	if (hdr->reserved) {
> +		NL_SET_ERR_MSG(extack, "genlmsghdr.reserved field is not 0");
> +		return -EINVAL;
> +	}
> +
> +	/* Old netlink flags have pretty loose semantics, allow only the flags
> +	 * consumed by the core where we can enforce the meaning.
> +	 */
> +	flags = nlh->nlmsg_flags;
> +	if ((flags & NLM_F_DUMP) == NLM_F_DUMP) /* DUMP is 2 bits */
> +		flags &= ~NLM_F_DUMP;

no bail out for incorrectly set NLM_F_DUMP flag?

> +	if (flags & ~(NLM_F_REQUEST | NLM_F_ACK | NLM_F_ECHO)) {
> +		NL_SET_ERR_MSG(extack,
> +			       "ambiguous or reserved bits set in nlmsg_flags");
> +		return -EINVAL;

While adding new netlink flags is a very rare event, this is going to
make it harder to add new flags to be added in the future, else
userspace has to probe for supported flags first.

Regarding error reporting - even if error reporting in netlink is also
not consistent accross subsystems - I think EINVAL should be used for
malformed netlink messages, eg. a message that is missing a mandatory
attribute.

EOPNOTSUPP might be a better pick?
