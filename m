Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D976A14B9
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 02:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjBXB5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 20:57:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjBXB5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 20:57:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663915DCF4
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 17:57:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D12DB81BC6
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 01:57:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D51C433EF;
        Fri, 24 Feb 2023 01:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677203829;
        bh=81zFsgXT74DD4tyYNhDMy2HnrdW1LaR6ap4ARFRZ9zc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=APUQTgwnhFgL0C3VHD2B/3oyok5sqb6iZmOIuimNwnWp/EAbBsrd7na9eH4hzutWx
         mJf/ku4sWue4hhlr4OqVWEhAymFieeym3My2nO8zXW6lwDQTfLaXxuCjz3bfbkGNVz
         BmUqQ4GfA1Rk0ts9E/pR6KMH5g12Rcym/wcdwY/mo074n45oPs5KzytoGCls5rUedb
         O1gXdXCceWP7SN/LGJ5+1JCWZXI46H5bWHdKKJRFCDTuFV3ftZkggS4gCz7ZKOlyGT
         i4WAqnpaDQZvwXp0FZoTDZiNLproqiUawyaRw2/7BefvT2Gq//QMKCMpGmqkzCryD2
         mfmaKYp2KWEwA==
Date:   Thu, 23 Feb 2023 17:57:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     stephen@networkplumber.org
Cc:     dsahern@gmail.com, jhs@mojatatu.com, netdev@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH iproute2] genl: print caps for all families
Message-ID: <20230223175708.51e593f0@kernel.org>
In-Reply-To: <20230224015234.1626025-1-kuba@kernel.org>
References: <20230224015234.1626025-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Feb 2023 17:52:34 -0800 Jakub Kicinski wrote:
> Back in 2006 kernel commit 334c29a64507 ("[GENETLINK]: Move
> command capabilities to flags.") removed some attributes and
> moved the capabilities to flags. Corresponding iproute2
> commit 26328fc3933f ("Add controller support for new features
> exposed") added the ability to print those caps.
> 
> Printing is gated on version of the family, but we're checking
> the version of each individual family rather than the control
> family. The format of attributes in the control family
> is dictated by the version of the control family alone.
> 
> Families can't use flags for random things, anyway,
> because kernel core has a fixed interpretation.
> 
> Thanks to this change caps will be shown for all families
> (assuming kernel newer than 2.6.19), not just those which
> by coincidence have their local version >= 2.
> 
> For instance devlink, before:
> 
>   $ genl ctrl get name devlink
>   Name: devlink
> 	ID: 0x15  Version: 0x1  header size: 0  max attribs: 179
> 	commands supported:
> 		#1:  ID-0x1
> 		#2:  ID-0x5
> 		#3:  ID-0x6
> 		...
> 
> after:
> 
>   $ genl ctrl get name devlink
>   Name: devlink
> 	ID: 0x15  Version: 0x1  header size: 0  max attribs: 179
> 	commands supported:
> 		#1:  ID-0x1
> 		Capabilities (0xe):
>  		  can doit; can dumpit; has policy
> 
> 		#2:  ID-0x5
> 		Capabilities (0xe):
>  		  can doit; can dumpit; has policy
> 
> 		#3:  ID-0x6
> 		Capabilities (0xb):
>  		  requires admin permission; can doit; has policy
> 
> Leave ctrl_v as 0 if we fail to read the version. Old code used 1
> as the default, but 0 or 1 - does not matter, checks are for >= 2.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> Not really sure if this is a fix or not..

Adding Johannes, that's probably everyone who ever used this 
command on CC? ;)

> diff --git a/genl/ctrl.c b/genl/ctrl.c
> index a2d87af0ad07..1fcb3848f137 100644
> --- a/genl/ctrl.c
> +++ b/genl/ctrl.c
> @@ -21,6 +21,8 @@
>  #define GENL_MAX_FAM_OPS	256
>  #define GENL_MAX_FAM_GRPS	256
>  
> +static unsigned int ctrl_v;
> +
>  static int usage(void)
>  {
>  	fprintf(stderr,"Usage: ctrl <CMD>\n" \
> @@ -109,7 +111,6 @@ static int print_ctrl(struct rtnl_ctrl_data *ctrl,
>  	int len = n->nlmsg_len;
>  	struct rtattr *attrs;
>  	FILE *fp = (FILE *) arg;
> -	__u32 ctrl_v = 0x1;
>  
>  	if (n->nlmsg_type !=  GENL_ID_CTRL) {
>  		fprintf(stderr, "Not a controller message, nlmsg_len=%d "
> @@ -148,7 +149,6 @@ static int print_ctrl(struct rtnl_ctrl_data *ctrl,
>  	if (tb[CTRL_ATTR_VERSION]) {
>  		__u32 *v = RTA_DATA(tb[CTRL_ATTR_VERSION]);
>  		fprintf(fp, " Version: 0x%x ",*v);
> -		ctrl_v = *v;
>  	}
>  	if (tb[CTRL_ATTR_HDRSIZE]) {
>  		__u32 *h = RTA_DATA(tb[CTRL_ATTR_HDRSIZE]);
> @@ -241,6 +241,55 @@ static int print_ctrl2(struct nlmsghdr *n, void *arg)
>  	return print_ctrl(NULL, n, arg);
>  }
>  
> +static void ctrl_load_ctrl_version(struct rtnl_handle *rth)
> +{
> +	struct rtattr *tb[CTRL_ATTR_MAX + 1];
> +	struct genlmsghdr *ghdr;
> +	struct rtattr *attrs;
> +	struct {
> +		struct nlmsghdr         n;
> +		struct genlmsghdr	g;
> +		char                    buf[128];
> +	} req = {
> +		.n.nlmsg_len = NLMSG_LENGTH(GENL_HDRLEN),
> +		.n.nlmsg_flags = NLM_F_REQUEST,
> +		.n.nlmsg_type = GENL_ID_CTRL,
> +		.g.cmd = CTRL_CMD_GETFAMILY,
> +	};
> +	struct nlmsghdr *nlh = &req.n;
> +	struct nlmsghdr *answer = NULL;
> +	__u16 id = GENL_ID_CTRL;
> +	int len;
> +
> +	addattr_l(nlh, 128, CTRL_ATTR_FAMILY_ID, &id, 2);
> +
> +	if (rtnl_talk(rth, nlh, &answer) < 0) {
> +		fprintf(stderr, "Error talking to the kernel\n");
> +		return;
> +	}
> +
> +	ghdr = NLMSG_DATA(answer);
> +	if (answer->nlmsg_type != GENL_ID_CTRL ||
> +	    ghdr->cmd != CTRL_CMD_NEWFAMILY) {
> +		fprintf(stderr, "Unexpected reply nlmsg_type=%u cmd=%u\n",
> +			answer->nlmsg_type, ghdr->cmd);
> +		return;
> +	}
> +
> +	len = answer->nlmsg_len;
> +	len -= NLMSG_LENGTH(GENL_HDRLEN);
> +	if (len < 0) {
> +		fprintf(stderr, "wrong controller message len %d\n", len);
> +		return;
> +	}
> +
> +	attrs = (struct rtattr *) ((char *) ghdr + GENL_HDRLEN);
> +	parse_rtattr_flags(tb, CTRL_ATTR_MAX, attrs, len, NLA_F_NESTED);
> +
> +	if (tb[CTRL_ATTR_VERSION])
> +		ctrl_v = rta_getattr_u16(tb[CTRL_ATTR_VERSION]);
> +}
> +
>  static int ctrl_list(int cmd, int argc, char **argv)
>  {
>  	struct rtnl_handle rth;
> @@ -264,6 +313,9 @@ static int ctrl_list(int cmd, int argc, char **argv)
>  		exit(1);
>  	}
>  
> +	if (!ctrl_v)
> +		ctrl_load_ctrl_version(&rth);
> +
>  	if (cmd == CTRL_CMD_GETFAMILY || cmd == CTRL_CMD_GETPOLICY) {
>  		req.g.cmd = cmd;
>  

