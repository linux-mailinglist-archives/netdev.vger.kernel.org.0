Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEBD16E0113
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 23:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjDLVjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 17:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjDLVjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 17:39:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0A43AA6
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 14:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681335535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hY7LMx62SAz1QEOhOU6PyJ7fWfcLCZRJmU8XBV1nFNA=;
        b=FYY2bwM+ga5rLdH1mrPr79Nv7q+7BMqNPGxA+GBRip9o+4q1S58tMSYOs29fuJwsnUhyNa
        Wm26TYIp4U2NlJNdCfBb5wkcWsNClApX3dVfX2TYufUh7BIaPJT0AxQ+JO6+IB82332C3V
        vBgWNx/3P4QRgd4visPJttKtU4NM738=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-463-cfmoTliHOjGoaorCLwE-Uw-1; Wed, 12 Apr 2023 17:38:54 -0400
X-MC-Unique: cfmoTliHOjGoaorCLwE-Uw-1
Received: by mail-qt1-f199.google.com with SMTP id v13-20020a05622a144d00b003e22c6de617so9830058qtx.13
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 14:38:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681335534; x=1683927534;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hY7LMx62SAz1QEOhOU6PyJ7fWfcLCZRJmU8XBV1nFNA=;
        b=Zfd/kEpFFbmfxITzoqOp09GIGQdthGUqsHkI9u5K1Pxcz2DkvKjbHCxo0/iHTMIiYL
         H4xlTzs3H8yf8uLXXAMieZdycIsdBBWu7Es1aLEfLvcG7v593dZIEsXD6BHK6XFH+8Qo
         ymYk5G+ij9st1yx1Ef0G4itLapaXQSvI93xdLLptTgmvQ0JKrSUxN9KIMUR7jB8kprMN
         6JuW6SIUEhh0h1BNZ/mCsHuD8eR39X31LDueXAcbB4YJmvLzXPqYLZsd/SjXWIgXn4au
         z4djLRg8hb8OsZKPIMRm958S0mrMQd3IeCgTtFQFrW3/4GNt7UqHP/mgIcRC6oFgAz2g
         abAQ==
X-Gm-Message-State: AAQBX9cC4AKem0TNO+1nWR4AovfQ9qC6zlUrHwYytq/2bg53UVRdq3cB
        DxRZ+zQJqgaLp6swlTImHV72DxXiRoiqd8ai9KTxmnG/iq7xKKtZaNdzp9SfRHaw6DdINb4I7og
        kLPzm6nSKO2kVg8S2VAno3EKP
X-Received: by 2002:a05:622a:1cd:b0:3e9:94d5:529 with SMTP id t13-20020a05622a01cd00b003e994d50529mr20039qtw.17.1681335533930;
        Wed, 12 Apr 2023 14:38:53 -0700 (PDT)
X-Google-Smtp-Source: AKy350bS0NylTv9Dj7mQq2mwYwzRMbrX/s9L2NwrFL+JktG1ORJKR5CqIgOTej92roIYH1211y+XqQ==
X-Received: by 2002:a05:622a:1cd:b0:3e9:94d5:529 with SMTP id t13-20020a05622a01cd00b003e994d50529mr20025qtw.17.1681335533678;
        Wed, 12 Apr 2023 14:38:53 -0700 (PDT)
Received: from debian ([2001:4649:fcb8:0:eefe:db50:3cfa:deab])
        by smtp.gmail.com with ESMTPSA id f17-20020a05622a1a1100b003dffd3d3df5sm23852qtb.2.2023.04.12.14.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 14:38:53 -0700 (PDT)
Date:   Wed, 12 Apr 2023 23:38:49 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Martin Willi <martin@strongswan.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] rtnetlink: Restore RTM_NEW/DELLINK notification
 behavior
Message-ID: <ZDck6WWZMx1ayYWP@debian>
References: <20230411074319.24133-1-martin@strongswan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411074319.24133-1-martin@strongswan.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 09:43:19AM +0200, Martin Willi wrote:
> The commits referenced below allows userspace to use the NLM_F_ECHO flag
> for RTM_NEW/DELLINK operations to receive unicast notifications for the
> affected link. Prior to these changes, applications may have relied on
> multicast notifications to learn the same information without specifying
> the NLM_F_ECHO flag.
> 
> For such applications, the mentioned commits changed the behavior for
> requests not using NLM_F_ECHO. Multicast notifications are still received,
> but now use the portid of the requester and the sequence number of the
> request instead of zero values used previously. For the application, this
> message may be unexpected and likely handled as a response to the
> NLM_F_ACKed request, especially if it uses the same socket to handle
> requests and notifications.
> 
> To fix existing applications relying on the old notification behavior,
> set the portid and sequence number in the notification only if the
> request included the NLM_F_ECHO flag. This restores the old behavior
> for applications not using it, but allows unicasted notifications for
> others.
> 
> Fixes: f3a63cce1b4f ("rtnetlink: Honour NLM_F_ECHO flag in rtnl_delete_link")
> Fixes: d88e136cab37 ("rtnetlink: Honour NLM_F_ECHO flag in rtnl_newlink_create")
> Signed-off-by: Martin Willi <martin@strongswan.org>
> ---
>  include/linux/rtnetlink.h |  3 ++-
>  net/core/dev.c            |  2 +-
>  net/core/rtnetlink.c      | 11 +++++++++--
>  3 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 5d8eb57867a9..6e44e92ebdf5 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -3972,16 +3972,23 @@ static int rtnl_dump_all(struct sk_buff *skb, struct netlink_callback *cb)
>  struct sk_buff *rtmsg_ifinfo_build_skb(int type, struct net_device *dev,
>  				       unsigned int change,
>  				       u32 event, gfp_t flags, int *new_nsid,
> -				       int new_ifindex, u32 portid, u32 seq)
> +				       int new_ifindex, u32 portid,
> +				       const struct nlmsghdr *nlh)
>  {
>  	struct net *net = dev_net(dev);
>  	struct sk_buff *skb;
>  	int err = -ENOBUFS;
> +	u32 seq = 0;
>  
>  	skb = nlmsg_new(if_nlmsg_size(dev, 0), flags);
>  	if (skb == NULL)
>  		goto errout;
>  
> +	if (nlmsg_report(nlh))
> +		seq = nlmsg_seq(nlh);
> +	else
> +		portid = 0;
> +
>  	err = rtnl_fill_ifinfo(skb, dev, dev_net(dev),
>  			       type, portid, seq, change, 0, 0, event,
>  			       new_nsid, new_ifindex, -1, flags);

This special case makes rtnetlink a bit more confusing (I don't think
other netlink handlers do that, but I haven't looked very far).

I mean, ideally, broadcast netlink messages would never have portid and
seq, so we wouldn't need this special case at all.

But for that, we'd need a way for nlmsg_notify() to use a different
nlmsghdr for the unicast and broadcast messages (or let it rewrite it).

Also the value of seq and portid on broadcast notifications seems to
have always been inconsistent. Some rtnetlink commands seem to have
always set seq and portid on broadcast notifications (like RTM_NEWROUTE
and RTM_NEWADDR) while other commands didn't (RTM_NEWLINK). With
the commits cited in the Fixes tags, RTM_NEWLINK also started to set
portid and seq, and this patch now sets them only if the original
command had NLM_F_ECHO. I guess it's too late make broadcast
notifications consistent anyway :/.

For lack of a better idea,

Acked-by: Guillaume Nault <gnault@redhat.com>

