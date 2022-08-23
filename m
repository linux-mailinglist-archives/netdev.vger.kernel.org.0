Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF9859CDF5
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 03:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239335AbiHWBhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 21:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236822AbiHWBhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 21:37:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B88E45A2F1
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 18:37:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5552F611DC
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 01:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246C1C433C1;
        Tue, 23 Aug 2022 01:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661218636;
        bh=51U3aFMh9NcPVmtJvVz24FNflfqcfqiLJkBVvVl93gE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EvfALHdj7jnkiQH+OetcC+/1GMyPmhKxXpGrBhHu3MskzpLjkeLcSBxf+yP5pP4Yp
         mGjo7hSgN3oaxwRmphHlcE/XInvDiwNMRxMbxKVL/TmBvjS2zCmqiouMGjzcGAegqj
         +7P0dHlwY/pKB+t1S6tJwiq0JYUOvif1/qMxcgKmcCRCSse8fLwk0qVrjm4XouZkHg
         PnavbFr9lEnG4HgzOdhaOnvXOPEtTwNoOIWgJ9LRBXQa3BQvK+TtsahJQo75GC3Wv0
         cEdL8MnMwo7/6tZw2GlzgJ+ODdy6WwWDJMUooRW5MUpBO7lMFMhe2zZbaEwx9SXVik
         AysP6YZ7K5BtQ==
Date:   Mon, 22 Aug 2022 18:37:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, pshelar@ovn.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        ptikhomirov@virtuozzo.com, alexander.mikhalitsyn@virtuozzo.com,
        avagin@google.com, brauner@kernel.org, mark.d.gray@redhat.com,
        i.maximets@ovn.org, aconole@redhat.com
Subject: Re: [PATCH net-next v2 1/3] openvswitch: allow specifying ifindex
 of new interfaces
Message-ID: <20220822183715.0bf77c40@kernel.org>
In-Reply-To: <20220819153044.423233-2-andrey.zhadchenko@virtuozzo.com>
References: <20220819153044.423233-1-andrey.zhadchenko@virtuozzo.com>
        <20220819153044.423233-2-andrey.zhadchenko@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Aug 2022 18:30:42 +0300 Andrey Zhadchenko wrote:
> CRIU is preserving ifindexes of net devices after restoration. However,
> current Open vSwitch API does not allow to target ifindex, so we cannot
> correctly restore OVS configuration.
> 
> Use ovs_header->dp_ifindex during OVS_DP_CMD_NEW as desired ifindex.
> Use OVS_VPORT_ATTR_IFINDEX during OVS_VPORT_CMD_NEW to specify new netdev
> ifindex.

> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -1739,6 +1739,7 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
>  	struct vport *vport;
>  	struct ovs_net *ovs_net;
>  	int err;
> +	struct ovs_header *ovs_header = info->userhdr;
>  
>  	err = -EINVAL;
>  	if (!a[OVS_DP_ATTR_NAME] || !a[OVS_DP_ATTR_UPCALL_PID])
> @@ -1779,6 +1780,7 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
>  	parms.dp = dp;
>  	parms.port_no = OVSP_LOCAL;
>  	parms.upcall_portids = a[OVS_DP_ATTR_UPCALL_PID];
> +	parms.desired_ifindex = ovs_header->dp_ifindex;

Are you 100% sure that all user space making this call initializes
dp_ifindex to 0? There is no validation in the kernel today that 
the field is not garbage as far as I can tell.

If you are sure, please add the appropriate analysis to the commit msg.

>  	/* So far only local changes have been made, now need the lock. */
>  	ovs_lock();
> @@ -2199,7 +2201,10 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
>  	if (!a[OVS_VPORT_ATTR_NAME] || !a[OVS_VPORT_ATTR_TYPE] ||
>  	    !a[OVS_VPORT_ATTR_UPCALL_PID])
>  		return -EINVAL;
> -	if (a[OVS_VPORT_ATTR_IFINDEX])
> +
> +	parms.type = nla_get_u32(a[OVS_VPORT_ATTR_TYPE]);
> +
> +	if (a[OVS_VPORT_ATTR_IFINDEX] && parms.type != OVS_VPORT_TYPE_INTERNAL)
>  		return -EOPNOTSUPP;
>  
>  	port_no = a[OVS_VPORT_ATTR_PORT_NO]
> @@ -2236,12 +2241,19 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
>  	}
>  
>  	parms.name = nla_data(a[OVS_VPORT_ATTR_NAME]);
> -	parms.type = nla_get_u32(a[OVS_VPORT_ATTR_TYPE]);
>  	parms.options = a[OVS_VPORT_ATTR_OPTIONS];
>  	parms.dp = dp;
>  	parms.port_no = port_no;
>  	parms.upcall_portids = a[OVS_VPORT_ATTR_UPCALL_PID];
>  
> +	if (parms.type == OVS_VPORT_TYPE_INTERNAL) {
> +		if (a[OVS_VPORT_ATTR_IFINDEX])

You already validated that type must be internal for ifindex 
to be specified, so the outer if is unnecessary.

It's pretty common in netlink handling code to validate first
then act assuming validation has passed.

> +			parms.desired_ifindex =
> +				nla_get_u32(a[OVS_VPORT_ATTR_IFINDEX]);
> +		else
> +			parms.desired_ifindex = 0;
> +	}
> +
>  	vport = new_vport(&parms);
>  	err = PTR_ERR(vport);
>  	if (IS_ERR(vport)) {

> diff --git a/net/openvswitch/vport.h b/net/openvswitch/vport.h
> index 9de5030d9801..24e1cba2f1ac 100644
> --- a/net/openvswitch/vport.h
> +++ b/net/openvswitch/vport.h
> @@ -98,6 +98,8 @@ struct vport_parms {
>  	enum ovs_vport_type type;
>  	struct nlattr *options;
>  
> +	int desired_ifindex;

Any chance this field would make sense somewhere else? you're adding 
a 4B field between two pointers it will result in a padding.

Also you're missing kdoc for this field.

>  	/* For ovs_vport_alloc(). */
>  	struct datapath *dp;
>  	u16 port_no;

