Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6EC35E649D
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 16:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbiIVODm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 10:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiIVODk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 10:03:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD13F52464;
        Thu, 22 Sep 2022 07:03:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58207634A7;
        Thu, 22 Sep 2022 14:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503FAC433D6;
        Thu, 22 Sep 2022 14:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663855417;
        bh=IaXnE90Dw+lix3qQa6wNniUCh50gJ4TzNAPq4uuhwfs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h44e5MJQs/hxUyq55HYJZ/tZ12V+PbbG4N3hlbJ5IcXTqChHMYcCHWPBfLL0Sbii/
         P+4uyvV+TmFmqbr+2+Hzm3YNdxNED0hJ4WGyo2D8qcCPiDxd6I+lxJzAKBMkfrdypM
         5g+ANA+IVr4Gno9Zh8bcpeVGCZ8FsAv8Igue6qdPAMvCZrb+FhyLpDWxMyVfhF8kiq
         sAMSnuieLRi6KcTD2v0OrGwyb++lC9CydNd8WfnXt/YHUxOy5/FjE0q7oDuelm3wly
         /wiJMenbzpKKVTaaTa0Irvy7S/fAhs/oCAFwtvi20vilIpBqEi/bbW5TcXYhOs0byc
         vmjcuGhxjGvwA==
Date:   Thu, 22 Sep 2022 07:03:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael =?UTF-8?B?V2Vpw58=?= <michael.weiss@aisec.fraunhofer.de>
Cc:     Paolo Abeni <pabeni@redhat.com>, Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org,
        Joe Stringer <joe@cilium.io>
Subject: Re: [PATCH v2 net 2/2] net: openvswitch: allow conntrack in
 non-initial user namespace
Message-ID: <20220922070336.623d4150@kernel.org>
In-Reply-To: <20220921011946.250228-3-michael.weiss@aisec.fraunhofer.de>
References: <20220921011946.250228-1-michael.weiss@aisec.fraunhofer.de>
        <20220921011946.250228-3-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Sep 2022 03:19:46 +0200 Michael Wei=C3=9F wrote:
> Similar to the previous commit, the Netlink interface of the OVS
> conntrack module was restricted to global CAP_NET_ADMIN by using
> GENL_ADMIN_PERM. This is changed to GENL_UNS_ADMIN_PERM to support
> unprivileged containers in non-initial user namespace.

Should we bump=20

  ct_limit =3D kmalloc(sizeof(*ct_limit), GFP_KERNEL);

to also being accounted?

Otherwise LGTM, please repost with [PATCH net-next v3] in the subject.
net is for fixes only, and we're quite late in the -rc process.

Please try to CC the original authors as well, for Joe the address
will be Joe Stringer <joe@cilium.io>.

> diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
> index 4e70df91d0f2..9142ba322991 100644
> --- a/net/openvswitch/conntrack.c
> +++ b/net/openvswitch/conntrack.c
> @@ -2252,14 +2252,16 @@ static int ovs_ct_limit_cmd_get(struct sk_buff *s=
kb, struct genl_info *info)
>  static const struct genl_small_ops ct_limit_genl_ops[] =3D {
>  	{ .cmd =3D OVS_CT_LIMIT_CMD_SET,
>  		.validate =3D GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
> -		.flags =3D GENL_ADMIN_PERM, /* Requires CAP_NET_ADMIN
> -					   * privilege. */
> +		.flags =3D GENL_UNS_ADMIN_PERM, /* Requires CAP_NET_ADMIN
> +					       * privilege.
> +					       */
>  		.doit =3D ovs_ct_limit_cmd_set,
>  	},
>  	{ .cmd =3D OVS_CT_LIMIT_CMD_DEL,
>  		.validate =3D GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
> -		.flags =3D GENL_ADMIN_PERM, /* Requires CAP_NET_ADMIN
> -					   * privilege. */
> +		.flags =3D GENL_UNS_ADMIN_PERM, /* Requires CAP_NET_ADMIN
> +					       * privilege.
> +					       */
>  		.doit =3D ovs_ct_limit_cmd_del,
>  	},
>  	{ .cmd =3D OVS_CT_LIMIT_CMD_GET,

