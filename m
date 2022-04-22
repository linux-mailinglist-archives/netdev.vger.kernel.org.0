Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C27BC50C007
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 20:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiDVS7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 14:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231673AbiDVS6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 14:58:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456651F040D
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 11:48:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2ABFAB8321C
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 18:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACAEC385A4;
        Fri, 22 Apr 2022 18:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650652624;
        bh=mfy0/nIY3uSrXgPd/GSoGgYzgDkfynbQTkywpeFjUL8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LPpnyA05mHWBeWQojmYTvZVPbYePSaDuvRsmHGbwAOrOL9LGftzGHv0sKfD4nA7P2
         xjTBfiJ0zlE5l8mqq+7A48Yxbp0n/5MED1XpH5RZ16riUZTUFjBfp4BzfAg765oS/6
         uSIkrn/00Zwubi5qqcpgiOGd7BhM9k9A1OmMxJ3PT+X2vxDsegeuuvm343V8V1yD2A
         50+047pMAfUME8opTeVDQOhtxjbkyF9NdsswQ+vcym65xmyNJUKSzyL48fQzwXjE0b
         FUW/7IOo8LJNhDxRoNbKMj/NKjxVGg7egeRpjzn+/DYpkYbiYSCX4EFGk0STCOodRV
         uqoCVsZzlKN1Q==
Date:   Fri, 22 Apr 2022 12:37:01 -0600
From:   David Ahern <dsahern@kernel.org>
To:     Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
Cc:     netdev@vger.kernel.org, outreachy@lists.linux.dev,
        roopa@nvidia.com, roopa.prabhu@gmail.com, jdenham@redhat.com,
        sbrivio@redhat.com
Subject: Re: [PATCH net-next 2/2] net: vxlan: vxlan_core.c: Add extack
 support to vxlan_fdb_delet
Message-ID: <20220422183701.GA27661@u2004-local>
References: <cover.1650377624.git.eng.alaamohamedsoliman.am@gmail.com>
 <c6765ff1f66cf74ba6f25ba9b1c91dfe410abcfd.1650377624.git.eng.alaamohamedsoliman.am@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6765ff1f66cf74ba6f25ba9b1c91dfe410abcfd.1650377624.git.eng.alaamohamedsoliman.am@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 04:37:18PM +0200, Alaa Mohamed wrote:
> diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
> index cf2f60037340..4ecbb5878fe2 100644
> --- a/drivers/net/vxlan/vxlan_core.c
> +++ b/drivers/net/vxlan/vxlan_core.c
> @@ -1129,18 +1129,20 @@ static void vxlan_fdb_dst_destroy(struct vxlan_dev *vxlan, struct vxlan_fdb *f,
> 
>  static int vxlan_fdb_parse(struct nlattr *tb[], struct vxlan_dev *vxlan,
>  			   union vxlan_addr *ip, __be16 *port, __be32 *src_vni,
> -			   __be32 *vni, u32 *ifindex, u32 *nhid)
> +			   __be32 *vni, u32 *ifindex, u32 *nhid, struct netlink_ext_ack *extack)
>  {
>  	struct net *net = dev_net(vxlan->dev);
>  	int err;
> 
>  	if (tb[NDA_NH_ID] && (tb[NDA_DST] || tb[NDA_VNI] || tb[NDA_IFINDEX] ||
>  	    tb[NDA_PORT]))
> +		NL_SET_ERR_MSG(extack, "Missing required arguments");

That's a misleading error message; I think it should be something like:
		NL_SET_ERR_MSG(extack, "DST, VNI, ifindex and port are mutually exclusive with NH_ID");

>  		return -EINVAL;
> 
>  	if (tb[NDA_DST]) {
>  		err = vxlan_nla_get_addr(ip, tb[NDA_DST]);
>  		if (err)
> +			NL_SET_ERR_MSG(extack, "Unsupported address family");
>  			return err;
>  	} else {
>  		union vxlan_addr *remote = &vxlan->default_dst.remote_ip;
