Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D456E5F1056
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbiI3Q5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbiI3Q5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:57:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329F41D84AD
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664557039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7vwCSClCyhUyj/zcWPXclWsbUAzjC7QlXAFnVZwEqcc=;
        b=ajqBz9KCQnpueCpK2atDEuAH6qTFMY84RBZvEv+5rOAVui1vaAEwJWmXwPV/raub+IXSiC
        IKzbDWLQAgpGxwpZmOBatPa2O7vwlFyIUkJrAbfflM3+kasIuYmPoZGcNa6So7wvn3qjfg
        LJTHI7IAg1uJXVZgGla/uAoME1PXOP0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-169-w4UinpFCN_u3XhvcubBUbQ-1; Fri, 30 Sep 2022 12:57:18 -0400
X-MC-Unique: w4UinpFCN_u3XhvcubBUbQ-1
Received: by mail-wr1-f70.google.com with SMTP id l12-20020adfa38c000000b0022cceed465dso1792417wrb.10
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:57:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=7vwCSClCyhUyj/zcWPXclWsbUAzjC7QlXAFnVZwEqcc=;
        b=NPI8i4HWIMXavoJWeWiEmNEMpS61PYgRCNp5sgVwSwSiMReep0djTuq2v9LvDGp5t4
         8MZZoBu7q5ZT+5u5Eem5BhW1v2datDFQBQiYRiByEoPtMcWAN3TUamrhz6fQeh02ohCo
         iyNEWNgTwCibKRCGg5RvaBf4rhLLij9PGHbxbEoEXkTPnwxrv/2rYykr+926BC53uGcV
         gNVeX3lZG1S02wP86lYAcdrfCQGZiLFmGB79IzcyYNQJcyX5osy3W377eIjL3a45O8a7
         NmDQu35iRc9rBaI2mSaUW37TvYNdsGKSYZdrq3DAlkBpUHYJdzFFCDRdmjvUdH+tdB4S
         LZxQ==
X-Gm-Message-State: ACrzQf0C6L3do+94zZJjtrWChV62Dsx6SW28JlZZ9vC1hM7nk3i0H8kW
        tQXvLXL0F+mVBjHfxp2npN+aWUiaZJzKEHGblJI8l//+7zYX0VhCiX8bs/kZhewBBC1HwMmuQbU
        UFhZf0lNNxNEdwc6u
X-Received: by 2002:a05:6000:1a8b:b0:22a:cb74:eaea with SMTP id f11-20020a0560001a8b00b0022acb74eaeamr6639597wry.253.1664557036963;
        Fri, 30 Sep 2022 09:57:16 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4w9wYas/+owQH3x+ld3o9JTDpenhAicOraAThaFQann+ZSzH9Lsha7AAmUa1770dI5N7W20w==
X-Received: by 2002:a05:6000:1a8b:b0:22a:cb74:eaea with SMTP id f11-20020a0560001a8b00b0022acb74eaeamr6639581wry.253.1664557036649;
        Fri, 30 Sep 2022 09:57:16 -0700 (PDT)
Received: from localhost.localdomain ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id k17-20020adfe8d1000000b00226dfac0149sm2341824wrn.114.2022.09.30.09.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 09:57:16 -0700 (PDT)
Date:   Fri, 30 Sep 2022 18:57:13 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCHv5 net-next 4/4] rtnetlink: Honour NLM_F_ECHO flag in
 rtnl_delete_link
Message-ID: <20220930165713.GH10057@localhost.localdomain>
References: <20220930094506.712538-1-liuhangbin@gmail.com>
 <20220930094506.712538-5-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220930094506.712538-5-liuhangbin@gmail.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 05:45:06PM +0800, Hangbin Liu wrote:
> This patch use the new helper unregister_netdevice_many_notify() for
> rtnl_delete_link(), so that the kernel could reply unicast when userspace
>  set NLM_F_ECHO flag to request the new created interface info.
> 
> At the same time, the parameters of rtnl_delete_link() need to be updated
> since we need nlmsghdr and pid info.
> 
> Suggested-by: Guillaume Nault <gnault@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  include/net/rtnetlink.h        | 2 +-
>  net/core/rtnetlink.c           | 7 ++++---
>  net/openvswitch/vport-geneve.c | 2 +-
>  net/openvswitch/vport-gre.c    | 2 +-
>  net/openvswitch/vport-netdev.c | 2 +-
>  net/openvswitch/vport-vxlan.c  | 2 +-
>  6 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
> index bf8bb3357825..1a152993caef 100644
> --- a/include/net/rtnetlink.h
> +++ b/include/net/rtnetlink.h
> @@ -186,7 +186,7 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
>  				    const struct rtnl_link_ops *ops,
>  				    struct nlattr *tb[],
>  				    struct netlink_ext_ack *extack);
> -int rtnl_delete_link(struct net_device *dev);
> +int rtnl_delete_link(struct net_device *dev, struct nlmsghdr *nlh, u32 pid);
>  int rtnl_configure_link(struct net_device *dev, const struct ifinfomsg *ifm);

You didn't add a wrapper for rtnl_delete_link() here and modified the
callers instead, which makes me think you could just also have modified
rtnl_configure_link() directly and avoided the creation of
rtnl_configure_link_notify() in patch 1.

