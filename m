Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC696E2C44
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 00:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjDNWIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 18:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbjDNWIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 18:08:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532D93C3B
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 15:08:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2B3F64A72
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 22:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00227C433D2;
        Fri, 14 Apr 2023 22:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681510079;
        bh=NDcOLKN8jsH4X+wIeQKU3+M48AZK64LvvkqT0JPwYTI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lrWsKHRLrOGPZT7e4YHGy2z/LWKC6ruzt8XSwX/VZAg0YVLxdX8OxDTAUHIpcrJci
         5ty3F9tCwxCZevlyhGnRNt09Y8uSoVYTv5iF8PiJHhQkspf+KpadU+jWiShfa3cIIc
         PJP6BJql+iu8suhLhZVkJFXD8Tyzk+7miatyiMxc4WJhBvmyiQCV9NB1sJhor6pK8Y
         +7RORLj5oDj9W5l8V8ccvvVbDc0KCsFLkVnfLxt8C6FYK3n9NZaPrUvqHh6KQ+evLm
         9yTkkWYtXwU77Sf81S8lpCy48PlJp2StwuYThO9ywdC+yxTN1Gfg55U5l+i22yEK98
         6zb5bsWSIXwlg==
Date:   Fri, 14 Apr 2023 15:07:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Westphal <fw@strlen.de>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, pablo@netfilter.org
Subject: Re: [PATCH net-next 5/5] net: skbuff: hide nf_trace and
 ipvs_property
Message-ID: <20230414150758.4e6e9d81@kernel.org>
In-Reply-To: <20230414210950.GC5927@breakpoint.cc>
References: <20230414160105.172125-1-kuba@kernel.org>
        <20230414160105.172125-6-kuba@kernel.org>
        <20230414210950.GC5927@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Apr 2023 23:09:50 +0200 Florian Westphal wrote:
> > +#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || defined(CONFIG_NF_=
TABLES)
> >  	__u8			nf_trace:1; =20
>=20
> As already pointed out nftables can be a module, other than that

I copied it from:

static inline void nf_reset_trace(struct sk_buff *skb)
{
#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || defined(CONFIG_NF_TABLE=
S)
	skb->nf_trace =3D 0;
#endif
}

I can't quite figure out why this would be intentional.
Do the existing conditions need to be fixed? =F0=9F=A4=94=EF=B8=8F
