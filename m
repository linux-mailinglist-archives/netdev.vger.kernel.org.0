Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D43D5F0FF2
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbiI3Q3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbiI3Q3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:29:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC3C169E59
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664555334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hkYXsyLaO8u+WlEcttQfBPcTUPYVxBhXMppi5f9oZDs=;
        b=TBzlPZTBsa00JNuh4v6CXn738dEXkCjxkJdxvysXybGTcHSHXdG5suhNMl8MneahRiY7Si
        3YHvPWB40xUFsfRdCGZxjCgOxCHX15nmdzXMcjQzF7IThF62RUcBIdFCZau17zNLbz4lrk
        8j3B55lpxSJokBt26cyeMuZ9WOqH/dM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-557-TC4UPBPUOo6VmNU-hB-f8A-1; Fri, 30 Sep 2022 12:28:53 -0400
X-MC-Unique: TC4UPBPUOo6VmNU-hB-f8A-1
Received: by mail-wr1-f71.google.com with SMTP id p7-20020adfba87000000b0022cc6f805b1so1769178wrg.21
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:28:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=hkYXsyLaO8u+WlEcttQfBPcTUPYVxBhXMppi5f9oZDs=;
        b=A2yi4NW3AKnJBxbMrFKT0RY2uOpQvQs4cf18JNm5mTy3kxm3aHQ1wofHJTqeLCe4K9
         rpDAUlDGmI7PoPcegJe8bq5SMg3QrEpHDq96jHLDU3H4jof4VmdrbTxA6xgCOmy7zPwk
         ORTIUrw7DbraZ2jVfW2eXJGQLgwN45ljzxmasLfjCNpf1ocQ4uUWht8La8HXX+FveQRp
         rvfM+lg9H7Avc19ZFvrRSxAKYLS0BaayknYQrahTPqgFg3rC1LqNFJs5IJOjGWFD7XoZ
         av4KlnYQbAMZZdMporUWpReTshwWMDWrZE+wd5I4a1NebCnVJmWX4CqTXUL/HpZaF4jV
         +2HQ==
X-Gm-Message-State: ACrzQf3iR43jOufic/wveh6HkiFkO7Ut2ISMaUa4EOo6qJ7NayeDlvih
        OMIoVROMtQvaWlIzJLOnNmElovuFKzmiuNcT4uBcRKNJmhZvO65r9IYvHzt9HIe0Ar3KTODAY9w
        +owuK6s8cG3Z3Va09
X-Received: by 2002:a5d:59a7:0:b0:22a:47e3:a1b with SMTP id p7-20020a5d59a7000000b0022a47e30a1bmr6207999wrr.319.1664555332105;
        Fri, 30 Sep 2022 09:28:52 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM63De6YBsBvE61k4HFJv3Owp9zxvemdOz5hKTzGcVxNIYBzmeTJ3ujJ/L6+mA4tYsu/imRRPA==
X-Received: by 2002:a5d:59a7:0:b0:22a:47e3:a1b with SMTP id p7-20020a5d59a7000000b0022a47e30a1bmr6207989wrr.319.1664555331913;
        Fri, 30 Sep 2022 09:28:51 -0700 (PDT)
Received: from localhost.localdomain ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id j6-20020a05600c190600b003a5f3f5883dsm8218619wmq.17.2022.09.30.09.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 09:28:51 -0700 (PDT)
Date:   Fri, 30 Sep 2022 18:28:49 +0200
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
Subject: Re: [PATCHv5 net-next 1/4] rtnetlink: add new helper
 rtnl_configure_link_notify()
Message-ID: <20220930162849.GE10057@localhost.localdomain>
References: <20220930094506.712538-1-liuhangbin@gmail.com>
 <20220930094506.712538-2-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220930094506.712538-2-liuhangbin@gmail.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -3856,7 +3856,7 @@ int __dev_change_flags(struct net_device *dev, unsigned int flags,
>  int dev_change_flags(struct net_device *dev, unsigned int flags,
>  		     struct netlink_ext_ack *extack);
>  void __dev_notify_flags(struct net_device *, unsigned int old_flags,
> -			unsigned int gchanges);
> +			unsigned int gchanges, u32 pid, struct nlmsghdr *nlh);

In all the modified functions, you could make struct nlmsghdr * a const
pointer. You just need to also update rtnl_notify() to make its nlh
parameter const too.

> +void rtmsg_ifinfo_nlh(int type, struct net_device *dev, unsigned int change,
> +		      gfp_t flags, u32 pid, struct nlmsghdr *nlh)
> +{
> +	rtmsg_ifinfo_event(type, dev, change, rtnl_get_event(0), flags,
> +			   NULL, 0, pid, nlh);
>  }

Can't we just add the extra parameters to rtmsg_ifinfo() and trivially
adapt the few users to the new prototype? Maybe that's a personal
taste, but I find such wrapper unnecessary.

