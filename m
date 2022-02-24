Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA9B4C2300
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 05:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiBXEZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 23:25:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiBXEZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 23:25:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75A7252923
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 20:25:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61BBC61764
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 04:25:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72AFCC340E9;
        Thu, 24 Feb 2022 04:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645676710;
        bh=NgDc7vnSCQ4QRGN3aB4C4KhquurYo8j0AYt76pAJcRE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rRGLOS8gzBpWmPFwtC+4A1OkkUDClC3cD3Sq3wp3n6WkZV1qQBbTLDwNE0X+1HUEg
         Ik3rP7uDq3nO7zA0sCnyfFD1UvGyULYsbgth4D9iXsF0zU2Bo8v5AIPUF/4C+2NoQH
         66B20yZKOZpwEmAm+ih3MOybVDoS2HmpeKrlMLmOL/b+EDqpKzKZsNvAF1BSqP2wvI
         rcwuAyXop3GP/LaDJJecnQeWzLKHcTJ3tPkGHdedztNOPgXShiPa+txVTDA05gdcuN
         ZTN8P11SLvKUlAA1vrkXioRdnT7s3Nh1SSBUvLdx1Tdb1mPWSuGqF5vMHRq5/dYzPu
         518Zyksmf1A4Q==
Date:   Wed, 23 Feb 2022 20:25:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Roopa Prabhu <roopa@nvidia.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <stephen@networkplumber.org>, <nikolay@cumulusnetworks.com>,
        <idosch@nvidia.com>, <dsahern@gmail.com>, <bpoirier@nvidia.com>
Subject: Re: [PATCH net-next v2 09/12] vxlan: vni filtering support on
 collect metadata device
Message-ID: <20220223202509.439b9c6b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220222025230.2119189-10-roopa@nvidia.com>
References: <20220222025230.2119189-1-roopa@nvidia.com>
        <20220222025230.2119189-10-roopa@nvidia.com>
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

On Tue, 22 Feb 2022 02:52:27 +0000 Roopa Prabhu wrote:
> +static int vxlan_vni_add(struct vxlan_dev *vxlan,
> +			 struct vxlan_vni_group *vg,
> +			 u32 vni, union vxlan_addr *group,
> +			 struct netlink_ext_ack *extack)
> +{
> +	struct vxlan_vni_node *vninode;
> +	__be32 v = cpu_to_be32(vni);
> +	bool changed = false;
> +	int err = 0;
> +
> +	if (vxlan_vnifilter_lookup(vxlan, v))
> +		return vxlan_vni_update(vxlan, vg, v, group, &changed, extack);
> +
> +	err = vxlan_vni_in_use(vxlan->net, vxlan, &vxlan->cfg, v);
> +	if (err) {
> +		NL_SET_ERR_MSG(extack, "VNI in use");
> +		return err;
> +	}
> +
> +	vninode = vxlan_vni_alloc(vxlan, v);
> +	if (!vninode)
> +		return -ENOMEM;
> +
> +	err = rhashtable_lookup_insert_fast(&vg->vni_hash,
> +					    &vninode->vnode,
> +					    vxlan_vni_rht_params);
> +	if (err)

leak ?

> +		return err;
> +
> +	__vxlan_vni_add_list(vg, vninode);
> +
> +	if (vxlan->dev->flags & IFF_UP)
> +		vxlan_vs_add_del_vninode(vxlan, vninode, false);
> +
> +	err = vxlan_vni_update_group(vxlan, vninode, group, true, &changed,
> +				     extack);
> +
> +	if (changed)
> +		vxlan_vnifilter_notify(vxlan, vninode, RTM_NEWTUNNEL);
> +
> +	return err;
> +}
> +
> +static void vxlan_vni_node_rcu_free(struct rcu_head *rcu)
> +{
> +	struct vxlan_vni_node *v;
> +
> +	v = container_of(rcu, struct vxlan_vni_node, rcu);
> +	kfree(v);
> +}

kfree_rcu()?

> +static int vxlan_vni_del(struct vxlan_dev *vxlan,
> +			 struct vxlan_vni_group *vg,
> +			 u32 vni, struct netlink_ext_ack *extack)
> +{
> +	struct vxlan_vni_node *vninode;
> +	__be32 v = cpu_to_be32(vni);
> +	int err = 0;
> +
> +	vg = rtnl_dereference(vxlan->vnigrp);
> +
> +	vninode = rhashtable_lookup_fast(&vg->vni_hash, &v,
> +					 vxlan_vni_rht_params);
> +	if (!vninode) {
> +		err = -ENOENT;
> +		goto out;
> +	}
> +
> +	vxlan_vni_delete_group(vxlan, vninode);
> +
> +	err = rhashtable_remove_fast(&vg->vni_hash,
> +				     &vninode->vnode,
> +				     vxlan_vni_rht_params);
> +	if (err)
> +		goto out;
> +
> +	__vxlan_vni_del_list(vg, vninode);
> +
> +	vxlan_vnifilter_notify(vxlan, vninode, RTM_DELTUNNEL);
> +
> +	if (vxlan->dev->flags & IFF_UP)
> +		vxlan_vs_add_del_vninode(vxlan, vninode, true);
> +
> +	call_rcu(&vninode->rcu, vxlan_vni_node_rcu_free);
> +
> +	return 0;
> +out:
> +	return err;
> +}
> +
> +static int vxlan_vni_add_del(struct vxlan_dev *vxlan, __u32 start_vni,
> +			     __u32 end_vni, union vxlan_addr *group,
> +			     int cmd, struct netlink_ext_ack *extack)
> +{
> +	struct vxlan_vni_group *vg;
> +	int v, err = 0;
> +
> +	vg = rtnl_dereference(vxlan->vnigrp);
> +
> +	for (v = start_vni; v <= end_vni; v++) {
> +		switch (cmd) {
> +		case RTM_NEWTUNNEL:
> +			err = vxlan_vni_add(vxlan, vg, v, group, extack);
> +			break;
> +		case RTM_DELTUNNEL:
> +			err = vxlan_vni_del(vxlan, vg, v, extack);
> +			break;
> +		default:
> +			err = -EOPNOTSUPP;
> +			break;
> +		}
> +		if (err)
> +			goto out;
> +	}
> +
> +	return 0;
> +out:
> +	return err;
> +}
> +
> +static int vxlan_process_vni_filter(struct vxlan_dev *vxlan,
> +				    struct nlattr *nlvnifilter,
> +				    int cmd, struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *vattrs[VXLAN_VNIFILTER_ENTRY_MAX + 1];
> +	u32 vni_start = 0, vni_end = 0;
> +	union vxlan_addr group;
> +	int err = 0;

unnecessary init

> +	err = nla_parse_nested(vattrs,
> +			       VXLAN_VNIFILTER_ENTRY_MAX,
> +			       nlvnifilter, vni_filter_entry_policy,
> +			       extack);
> +	if (err)
> +		return err;
> +
> +	if (vattrs[VXLAN_VNIFILTER_ENTRY_START]) {
> +		vni_start = nla_get_u32(vattrs[VXLAN_VNIFILTER_ENTRY_START]);
> +		vni_end = vni_start;
> +	}
> +
> +	if (vattrs[VXLAN_VNIFILTER_ENTRY_END])
> +		vni_end = nla_get_u32(vattrs[VXLAN_VNIFILTER_ENTRY_END]);
> +
> +	if (!vni_start && !vni_end) {
> +		NL_SET_ERR_MSG_ATTR(extack, nlvnifilter,
> +				    "vni start nor end found in vni entry");
> +		return -EINVAL;
> +	}
> +
> +	if (vattrs[VXLAN_VNIFILTER_ENTRY_GROUP]) {
> +		group.sin.sin_addr.s_addr =
> +			nla_get_in_addr(vattrs[VXLAN_VNIFILTER_ENTRY_GROUP]);
> +		group.sa.sa_family = AF_INET;
> +	} else if (vattrs[VXLAN_VNIFILTER_ENTRY_GROUP6]) {
> +		group.sin6.sin6_addr =
> +			nla_get_in6_addr(vattrs[VXLAN_VNIFILTER_ENTRY_GROUP6]);
> +		group.sa.sa_family = AF_INET6;
> +	} else {
> +		memset(&group, 0, sizeof(group));
> +	}
> +
> +	err = vxlan_vni_add_del(vxlan, vni_start, vni_end, &group, cmd,
> +				extack);
> +	if (err)
> +		return err;
> +
> +	return 0;
> +}
> +
> +void vxlan_vnigroup_uninit(struct vxlan_dev *vxlan)
> +{
> +	struct vxlan_vni_node *v, *tmp;
> +	struct vxlan_vni_group *vg;
> +
> +	vg = rtnl_dereference(vxlan->vnigrp);
> +	list_for_each_entry_safe(v, tmp, &vg->vni_list, vlist) {
> +		rhashtable_remove_fast(&vg->vni_hash, &v->vnode,
> +				       vxlan_vni_rht_params);
> +		hlist_del_init_rcu(&v->hlist4.hlist);
> +#if IS_ENABLED(CONFIG_IPV6)
> +		hlist_del_init_rcu(&v->hlist6.hlist);
> +#endif

no need to generate the notifications here?

> +		__vxlan_vni_del_list(vg, v);
> +		call_rcu(&v->rcu, vxlan_vni_node_rcu_free);
> +	}
> +	rhashtable_destroy(&vg->vni_hash);
> +	kfree(vg);
> +}
> +
> +int vxlan_vnigroup_init(struct vxlan_dev *vxlan)
> +{
> +	struct vxlan_vni_group *vg;
> +	int ret = -ENOMEM;
> +
> +	vg = kzalloc(sizeof(*vg), GFP_KERNEL);
> +	if (!vg)
> +		goto out;

return -ENOMEM; 
the jumping dance is really not worth it here

> +	ret = rhashtable_init(&vg->vni_hash, &vxlan_vni_rht_params);
> +	if (ret)
> +		goto err_rhtbl;
> +	INIT_LIST_HEAD(&vg->vni_list);
> +	rcu_assign_pointer(vxlan->vnigrp, vg);
> +
> +	return 0;
> +
> +out:
> +	return ret;
> +
> +err_rhtbl:
> +	kfree(vg);
> +
> +	goto out;
> +}
> +
> +static int vxlan_vnifilter_process(struct sk_buff *skb, struct nlmsghdr *nlh,
> +				   struct netlink_ext_ack *extack)
> +{
> +	struct net *net = sock_net(skb->sk);
> +	struct tunnel_msg *tmsg;
> +	struct vxlan_dev *vxlan;
> +	struct net_device *dev;
> +	struct nlattr *attr;
> +	int err, vnis = 0;
> +	int rem;
> +
> +	/* this should validate the header and check for remaining bytes */
> +	err = nlmsg_parse(nlh, sizeof(*tmsg), NULL, VXLAN_VNIFILTER_MAX, NULL,
> +			  extack);

Could be useful to provide a policy here, even if it only points to
single type (entry which is nested). Otherwise we will not reject
UNSPEC, and validate if ENTRY has NLA_F_NESTED set, no?

> +	if (err < 0)
> +		return err;
> +
> +	tmsg = nlmsg_data(nlh);
> +	dev = __dev_get_by_index(net, tmsg->ifindex);
> +	if (!dev)
> +		return -ENODEV;
> +
> +	if (!netif_is_vxlan(dev)) {
> +		NL_SET_ERR_MSG_MOD(extack, "The device is not a vxlan device");
> +		return -EINVAL;
> +	}
> +
> +	vxlan = netdev_priv(dev);
> +
> +	if (!(vxlan->cfg.flags & VXLAN_F_VNIFILTER))
> +		return -EOPNOTSUPP;
> +
> +	nlmsg_for_each_attr(attr, nlh, sizeof(*tmsg), rem) {
> +		switch (nla_type(attr)) {
> +		case VXLAN_VNIFILTER_ENTRY:
> +			err = vxlan_process_vni_filter(vxlan, attr,
> +						       nlh->nlmsg_type, extack);
> +			break;
> +		default:
> +			continue;
> +		}
> +		vnis++;
> +		if (err)
> +			break;
> +	}
> +
> +	if (!vnis) {
> +		NL_SET_ERR_MSG_MOD(extack, "No vnis found to process");
> +		err = -EINVAL;
> +	}
> +
> +	return err;
> +}
