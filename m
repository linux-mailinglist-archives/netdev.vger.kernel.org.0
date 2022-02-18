Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 858D94BBBC1
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 16:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234018AbiBRPE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 10:04:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234762AbiBRPE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 10:04:58 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7505F2B2FF0
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 07:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645196682; x=1676732682;
  h=message-id:date:mime-version:subject:from:to:references:
   in-reply-to:content-transfer-encoding;
  bh=2DcN7x0BPgSl3r+cgXiLhCj/kJLli9+8b6jhF33qW38=;
  b=C5xVAK6Q7hq+cPSxSPWT7CTnpMIYUqB7QgMOZk5FTZsYIQgQQKlDHRHz
   VFwshGRc+1F9699KzyvbnSS6AOmCETJpkFcPLUXj2VDk9ZkT2R77HbdnN
   TCXSnlKbooRmlqvPDghp13ndFaMySdktVQZyhfCxWLh5VmBgT6Ps5s2IN
   euO4hkSEfAwrBDL/WtCcpENStgDsdvIsiV2HAUSVVkVE1I1G6z9Hwnx9H
   LY+W1E5Vfh6bt+WSGfY5r3S9L9QTlGKGHjMjE5cDZVMIg+Ln4rtHP8kCd
   dBlglkv2UNYjXf0+GqxCU5NqV9J2kJ99E0B5wGz2iijrW4rcEsjkWUaN2
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10261"; a="249973499"
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="249973499"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 07:04:42 -0800
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="546310215"
Received: from mszycik-mobl.ger.corp.intel.com (HELO [10.249.143.161]) ([10.249.143.161])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 07:04:36 -0800
Message-ID: <33b0a469-7ab4-658c-57e6-7bf6241ea299@linux.intel.com>
Date:   Fri, 18 Feb 2022 16:04:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH net-next v6 1/7] gtp: Allow to create GTP device without
 FDs
Content-Language: en-US
From:   Marcin Szycik <marcin.szycik@linux.intel.com>
To:     netdev@vger.kernel.org
References: <20220218145130.6858-1-marcin.szycik@linux.intel.com>
In-Reply-To: <20220218145130.6858-1-marcin.szycik@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please ignore, sent a duplicate by mistake.

On 18-Feb-22 15:51, Marcin Szycik wrote:
> From: Wojciech Drewek <wojciech.drewek@intel.com>
> 
> Currently, when the user wants to create GTP device, he has to
> provide file handles to the sockets created in userspace (IFLA_GTP_FD0,
> IFLA_GTP_FD1). This behaviour is not ideal, considering the option of
> adding support for GTP device creation through ip link. Ip link
> application is not a good place to create such sockets.
> 
> This patch allows to create GTP device without providing
> IFLA_GTP_FD0 and IFLA_GTP_FD1 arguments. If the user sets
> IFLA_GTP_CREATE_SOCKETS attribute, then GTP module takes care
> of creating UDP sockets by itself. Sockets are created with the
> commonly known UDP ports used for GTP protocol (GTP0_PORT and
> GTP1U_PORT). In this case we don't have to provide encap_destroy
> because no extra deinitialization is needed, everything is covered
> by udp_tunnel_sock_release.
> 
> Note: GTP instance created with only this change applied, does
> not handle GTP Echo Requests. This is implemented in the following
> patch.
> 
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> ---
> v4: use ntohs when creating UDP socket
> v5: IFLA_GTP_CREATE_SOCKETS introduced, gtp_newlink refactor
> v6: reordering refactor removed
> ---
>  drivers/net/gtp.c            | 101 +++++++++++++++++++++++++++++------
>  include/uapi/linux/if_link.h |   1 +
>  2 files changed, 85 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
> index bf087171bcf0..25d8521897b3 100644
> --- a/drivers/net/gtp.c
> +++ b/drivers/net/gtp.c
> @@ -66,8 +66,10 @@ struct gtp_dev {
>  
>  	struct sock		*sk0;
>  	struct sock		*sk1u;
> +	u8			sk_created;
>  
>  	struct net_device	*dev;
> +	struct net		*net;
>  
>  	unsigned int		role;
>  	unsigned int		hash_size;
> @@ -320,8 +322,16 @@ static void gtp_encap_disable_sock(struct sock *sk)
>  
>  static void gtp_encap_disable(struct gtp_dev *gtp)
>  {
> -	gtp_encap_disable_sock(gtp->sk0);
> -	gtp_encap_disable_sock(gtp->sk1u);
> +	if (gtp->sk_created) {
> +		udp_tunnel_sock_release(gtp->sk0->sk_socket);
> +		udp_tunnel_sock_release(gtp->sk1u->sk_socket);
> +		gtp->sk_created = false;
> +		gtp->sk0 = NULL;
> +		gtp->sk1u = NULL;
> +	} else {
> +		gtp_encap_disable_sock(gtp->sk0);
> +		gtp_encap_disable_sock(gtp->sk1u);
> +	}
>  }
>  
>  /* UDP encapsulation receive handler. See net/ipv4/udp.c.
> @@ -656,17 +666,69 @@ static void gtp_destructor(struct net_device *dev)
>  	kfree(gtp->tid_hash);
>  }
>  
> +static struct sock *gtp_create_sock(int type, struct gtp_dev *gtp)
> +{
> +	struct udp_tunnel_sock_cfg tuncfg = {};
> +	struct udp_port_cfg udp_conf = {
> +		.local_ip.s_addr	= htonl(INADDR_ANY),
> +		.family			= AF_INET,
> +	};
> +	struct net *net = gtp->net;
> +	struct socket *sock;
> +	int err;
> +
> +	if (type == UDP_ENCAP_GTP0)
> +		udp_conf.local_udp_port = htons(GTP0_PORT);
> +	else if (type == UDP_ENCAP_GTP1U)
> +		udp_conf.local_udp_port = htons(GTP1U_PORT);
> +	else
> +		return ERR_PTR(-EINVAL);
> +
> +	err = udp_sock_create(net, &udp_conf, &sock);
> +	if (err)
> +		return ERR_PTR(err);
> +
> +	tuncfg.sk_user_data = gtp;
> +	tuncfg.encap_type = type;
> +	tuncfg.encap_rcv = gtp_encap_recv;
> +	tuncfg.encap_destroy = NULL;
> +
> +	setup_udp_tunnel_sock(net, sock, &tuncfg);
> +
> +	return sock->sk;
> +}
> +
> +static int gtp_create_sockets(struct gtp_dev *gtp, struct nlattr *data[])
> +{
> +	struct sock *sk1u = NULL;
> +	struct sock *sk0 = NULL;
> +
> +	sk0 = gtp_create_sock(UDP_ENCAP_GTP0, gtp);
> +	if (IS_ERR(sk0))
> +		return PTR_ERR(sk0);
> +
> +	sk1u = gtp_create_sock(UDP_ENCAP_GTP1U, gtp);
> +	if (IS_ERR(sk1u)) {
> +		udp_tunnel_sock_release(sk0->sk_socket);
> +		return PTR_ERR(sk1u);
> +	}
> +
> +	gtp->sk_created = true;
> +	gtp->sk0 = sk0;
> +	gtp->sk1u = sk1u;
> +
> +	return 0;
> +}
> +
>  static int gtp_newlink(struct net *src_net, struct net_device *dev,
>  		       struct nlattr *tb[], struct nlattr *data[],
>  		       struct netlink_ext_ack *extack)
>  {
> +	unsigned int role = GTP_ROLE_GGSN;
>  	struct gtp_dev *gtp;
>  	struct gtp_net *gn;
>  	int hashsize, err;
>  
> -	if (!data[IFLA_GTP_FD0] && !data[IFLA_GTP_FD1])
> -		return -EINVAL;
> -
>  	gtp = netdev_priv(dev);
>  
>  	if (!data[IFLA_GTP_PDP_HASHSIZE]) {
> @@ -677,11 +739,23 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
>  			hashsize = 1024;
>  	}
>  
> +	if (data[IFLA_GTP_ROLE]) {
> +		role = nla_get_u32(data[IFLA_GTP_ROLE]);
> +		if (role > GTP_ROLE_SGSN)
> +			return -EINVAL;
> +	}
> +	gtp->role = role;
> +
> +	gtp->net = src_net;
> +
>  	err = gtp_hashtable_new(gtp, hashsize);
>  	if (err < 0)
>  		return err;
>  
> -	err = gtp_encap_enable(gtp, data);
> +	if (data[IFLA_GTP_CREATE_SOCKETS])
> +		err = gtp_create_sockets(gtp, data);
> +	else
> +		err = gtp_encap_enable(gtp, data);
>  	if (err < 0)
>  		goto out_hashtable;
>  
> @@ -726,6 +800,7 @@ static const struct nla_policy gtp_policy[IFLA_GTP_MAX + 1] = {
>  	[IFLA_GTP_FD1]			= { .type = NLA_U32 },
>  	[IFLA_GTP_PDP_HASHSIZE]		= { .type = NLA_U32 },
>  	[IFLA_GTP_ROLE]			= { .type = NLA_U32 },
> +	[IFLA_GTP_CREATE_SOCKETS]	= { .type = NLA_U8 },
>  };
>  
>  static int gtp_validate(struct nlattr *tb[], struct nlattr *data[],
> @@ -848,7 +923,9 @@ static int gtp_encap_enable(struct gtp_dev *gtp, struct nlattr *data[])
>  {
>  	struct sock *sk1u = NULL;
>  	struct sock *sk0 = NULL;
> -	unsigned int role = GTP_ROLE_GGSN;
> +
> +	if (!data[IFLA_GTP_FD0] && !data[IFLA_GTP_FD1])
> +		return -EINVAL;
>  
>  	if (data[IFLA_GTP_FD0]) {
>  		u32 fd0 = nla_get_u32(data[IFLA_GTP_FD0]);
> @@ -868,18 +945,8 @@ static int gtp_encap_enable(struct gtp_dev *gtp, struct nlattr *data[])
>  		}
>  	}
>  
> -	if (data[IFLA_GTP_ROLE]) {
> -		role = nla_get_u32(data[IFLA_GTP_ROLE]);
> -		if (role > GTP_ROLE_SGSN) {
> -			gtp_encap_disable_sock(sk0);
> -			gtp_encap_disable_sock(sk1u);
> -			return -EINVAL;
> -		}
> -	}
> -
>  	gtp->sk0 = sk0;
>  	gtp->sk1u = sk1u;
> -	gtp->role = role;
>  
>  	return 0;
>  }
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 6218f93f5c1a..42f3fb097271 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -822,6 +822,7 @@ enum {
>  	IFLA_GTP_FD1,
>  	IFLA_GTP_PDP_HASHSIZE,
>  	IFLA_GTP_ROLE,
> +	IFLA_GTP_CREATE_SOCKETS,
>  	__IFLA_GTP_MAX,
>  };
>  #define IFLA_GTP_MAX (__IFLA_GTP_MAX - 1)
