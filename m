Return-Path: <netdev+bounces-6207-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 69B2E7152F7
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 03:25:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2B65280E37
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 01:25:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3326A41;
	Tue, 30 May 2023 01:25:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A84FA3C
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 01:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1A7C433EF;
	Tue, 30 May 2023 01:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685409912;
	bh=9UerJLLnxNhRATA1s0uD9tcq5ez+PTurFIgg5hQqOY4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YOLgHZUS7m4UicUONy29UjASg5Z2PRQUwVgJjr5JaUPToN454+WhV6GOWt2sZzcgB
	 XV2+aTb5mUxPlqdpgbm/I9qF8eCZ6UDpzd4b0JXwTI9yKMMMseseN6xVZo/3SiVnVQ
	 vGNqAmvMWl0YbXw8isJw/xA7TgINXknqJWu5hlyGS9izIj76TmRl2K2xMF/0jOxTqW
	 3hUK+lUHWjrQ6KI1sEFOdPCLNE8RblRM39TlWtmaSMbVMvfzBleImOSNEtpZln+Jw+
	 ArF27dEECrm/lECb9YDDqj66lXzpNrRrCcv2wYrwbGhuN/bEBki24cUku7odED9cTw
	 VT7inL45ggY8g==
Date: Mon, 29 May 2023 18:25:11 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, davem@davemloft.net, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Thomas Graf
 <tgraf@infradead.org>, Alexander Duyck <alexanderduyck@fb.com>
Subject: Re: [PATCH net 1/3] rtnetlink: move validate_linkmsg into
 rtnl_create_link
Message-ID: <20230529182511.0b138482@kernel.org>
In-Reply-To: <CADvbK_eoJUrDFrW_Kons7RnU5qivdA9ezULcMacB-H+QcNNNCQ@mail.gmail.com>
References: <cover.1685051273.git.lucien.xin@gmail.com>
	<7fde1eac7583cc93bc5b1cb3b386c522b32a94c9.1685051273.git.lucien.xin@gmail.com>
	<20230526204956.4cc0ddf3@kernel.org>
	<CADvbK_eoJUrDFrW_Kons7RnU5qivdA9ezULcMacB-H+QcNNNCQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 27 May 2023 16:36:15 -0400 Xin Long wrote:
> Other than avoiding calling validation twice, adding validate_linkmsg() in
> rtnl_create_link() also fixes the missing validation for newly created links,
> it includes tb[IFLA_ADDRESS/IFLA_BROADCAST] checks in validate_linkmsg():

Ah, I see. Since this is a fix I'd err on the side of keeping the
change small and obvious and limit it to adding the call in
validate_linkmsg() without worrying about validating multiple times.
Then follow up with the refactoring to net-next. 
I guess it could be acceptable to take the whole thing into net, if
you prefer but at least the commit message would need clarification.

> As for the calling twice thing, validating before any changes happen
> makes sense.
> Based on the change in this patch, I will pull the validation out of
> do_setlink()
> to these 3 places:
> 
> @@ -3600,7 +3605,9 @@ static int __rtnl_newlink(struct sk_buff *skb,
> struct nlmsghdr *nlh,
>                         return -EEXIST;
>                 if (nlh->nlmsg_flags & NLM_F_REPLACE)
>                         return -EOPNOTSUPP;
> -
> +               err = validate_linkmsg(dev, tb, extack);
> +               if (err < 0)
> +                       return err;
> 
> @@ -3377,6 +3383,9 @@ static int rtnl_group_changelink(const struct
> sk_buff *skb,
> 
>         for_each_netdev_safe(net, dev, aux) {
>                 if (dev->group == group) {
> +                       err = validate_linkmsg(dev, tb, extack);
> +                       if (err < 0)
> +                               return err;
>                         err = do_setlink(skb, dev, ifm, extack, tb, 0);
> 
> @@ -3140,6 +3136,10 @@ static int rtnl_setlink(struct sk_buff *skb,
> struct nlmsghdr *nlh,
>                 goto errout;
>         }
> 
> +       err = validate_linkmsg(dev, tb, extack);
> +       if (err < 0)
> +               goto errout;
> +
>         err = do_setlink(skb, dev, ifm, extack, tb, 0);
> 
> 
> and yes, one more place calls validate_linkmsg (comparing to the old code
> with the one in rtnl_create_link), unless someone thinks it's not worth it.

Yup, LGTM. Renaming do_setlink() to __do_setlink() and adding a wrapper
called do_setlink() which does the validation and calls __do_setlink() -
seems like another option to explore. Whatever you reckon ends up
looking neatest. As long as the validation ends up moving towards 
the entry point not deeper in - any approach is fine.

